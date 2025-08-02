import json
import boto3
import uuid
from datetime import datetime
import os

def handler(event, context):
    print('Generate upload URL function triggered')
    print('Event:', json.dumps(event, indent=2))
    
    try:
        # Parse request body
        body = json.loads(event.get('body', '{}'))
        file_name = body.get('fileName', '')
        file_type = body.get('fileType', 'application/pdf')
        
        # Generate unique file key
        file_key = f"cvs/{uuid.uuid4()}_{file_name}"
        
        # Initialize S3 client
        s3_client = boto3.client('s3')
        bucket_name = os.environ.get('CV_BUCKET_NAME')
        
        # Generate presigned URL for upload
        presigned_url = s3_client.generate_presigned_url(
            'put_object',
            Params={
                'Bucket': bucket_name,
                'Key': file_key,
                'ContentType': file_type
            },
            ExpiresIn=3600  # 1 hour
        )
        
        print(f'Generated presigned URL for: {bucket_name}/{file_key}')
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps({
                'uploadUrl': presigned_url,
                'fileKey': file_key,
                'expiresIn': 3600
            })
        }
        
    except Exception as error:
        print(f'Error generating upload URL: {error}')
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps({
                'message': 'Error generating upload URL',
                'error': str(error)
            })
        } 