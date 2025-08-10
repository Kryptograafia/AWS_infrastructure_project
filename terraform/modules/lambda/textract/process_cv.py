import json
import boto3
import os
from datetime import datetime

def handler(event, context):
    print('CV Parser Lambda triggered by SNS')
    print('Event:', json.dumps(event, indent=2))
    
    try:
        # Initialize clients
        textract_client = boto3.client('textract')
        dynamodb_client = boto3.client('dynamodb')
        
        # Process SNS message
        for record in event['Records']:
            # Parse SNS message
            sns_message = json.loads(record['Sns']['Message'])
            print(f'SNS Message: {json.dumps(sns_message, indent=2)}')
            
            # Extract Textract job details
            job_id = sns_message['JobId']
            status = sns_message['Status']
            
            if status != 'SUCCEEDED':
                print(f'Textract job {job_id} failed with status: {status}')
                continue
            
            # Get Textract results
            response = textract_client.get_document_text_detection(JobId=job_id)
            
            # Extract text content
            extracted_text = ""
            for item in response.get('Blocks', []):
                if item['BlockType'] == 'LINE':
                    extracted_text += item['Text'] + " "
            
            # Parse CV data (basic example - you can enhance this)
            cv_data = parse_cv_content(extracted_text)
            
            # Store in DynamoDB
            store_cv_data(job_id, cv_data, dynamodb_client)
            
            print(f'Successfully processed CV from job {job_id}')
        
        return {
            'statusCode': 200,
            'body': json.dumps('CV processing completed')
        }
        
    except Exception as error:
        print(f'Error processing CV: {error}')
        return {
            'statusCode': 500,
            'body': json.dumps(str(error))
        }

def parse_cv_content(text):
    """Parse extracted text to find CV information"""
    # This is a basic parser - you can enhance it with more sophisticated logic
    lines = text.split('\n')
    
    cv_data = {
        'full_text': text,
        'name': '',
        'email': '',
        'phone': '',
        'skills': [],
        'experience': '',
        'education': '',
        'parsed_at': datetime.utcnow().isoformat()
    }
    
    # Basic parsing logic (you can enhance this)
    for line in lines:
        line = line.strip()
        if '@' in line and '.' in line:
            cv_data['email'] = line
        elif any(char.isdigit() for char in line) and any(char.isalpha() for char in line):
            if not cv_data['name']:
                cv_data['name'] = line
    
    return cv_data

def store_cv_data(job_id, cv_data, dynamodb_client):
    """Store parsed CV data in DynamoDB"""
    table_name = os.environ['DYNAMODB_TABLE_NAME']
    
    item = {
        'id': {'S': job_id},
        'cv_data': {'S': json.dumps(cv_data)},
        'processed_at': {'S': datetime.utcnow().isoformat()}
    }
    
    dynamodb_client.put_item(
        TableName=table_name,
        Item=item
    )
    
    print(f'Stored CV data in DynamoDB table: {table_name}')