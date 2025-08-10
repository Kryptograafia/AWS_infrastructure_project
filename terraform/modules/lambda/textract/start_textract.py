import json
import boto3
import os
from urllib.parse import unquote_plus

def handler(event, context):
    print('Textract CV processing function triggered')
    print('Event:', json.dumps(event, indent=2))
    
    try:
        # Initialize Textract client
        textract_client = boto3.client('textract')
        
        # Get SNS topic ARN from environment variables
        sns_topic_arn = os.environ.get('TEXTRACT_SNS_TOPIC_ARN')
        if not sns_topic_arn:
            raise ValueError("TEXTRACT_SNS_TOPIC_ARN environment variable is not set")
        
        print(f'Using SNS topic ARN: {sns_topic_arn}')
        
        # Process S3 event
        for record in event['Records']:
            bucket = record['s3']['bucket']['name']
            key = unquote_plus(record['s3']['object']['key'])
            
            print(f'Processing file: {bucket}/{key}')
            
            # Only process files in the cvs/ folder
            if not key.startswith('cvs/'):
                print(f'Skipping file not in cvs/ folder: {key}')
                continue
            
            # Start Textract job with document analysis (better than text detection)
            response = textract_client.start_document_analysis(
                DocumentLocation={
                    'S3Object': {
                        'Bucket': bucket,
                        'Name': key
                    }
                },
                FeatureTypes=['TABLES', 'FORMS'],  # Extract tables and forms for better CV parsing
                NotificationChannel={
                    'SNSTopicArn': sns_topic_arn,
                    'RoleArn': os.environ.get('TEXTRACT_SNS_ROLE_ARN')  # Add role ARN if available
                }
            )
            
            print(f'Started Textract analysis job {response["JobId"]} for {key}')
            
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Started Textract processing',
                'processed_files': len(event['Records'])
            })
        }
        
    except Exception as error:
        print(f'Error starting Textract job: {error}')
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error starting Textract job',
                'error': str(error)
            })
        }