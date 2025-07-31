# AWS_infrastructure_project

# ONE-TIME OR INFRA CHANGES:
- Run Terraform to create core infrastructure
  (ECR repo, VPC, ECS Cluster, ALB, etc.)

# EVERY DEPLOYMENT:
1. Developer pushes code to GitHub
2. CI/CD pipeline:
   2.1 Run tests
   2.2 Run security scans
3. Build Docker image
4. Push Docker image to ECR
5. Run Terraform to update ECS task definition or deploy to EC2
6. ECS deploys the app

Application Workflow:

1. Frontend UI allows users to upload resumes (PDF) to S3
2. S3 Upload triggers Lambda 1#
    2.1 Runs AWS Textract to extract text
3. Lambda 2# analyzes extracted text with AWS Comprehend
    3.1 Extracts skills, experience, sentiment
4. Parsed candidate data stored in DynamoDB
5. Frontend queries DynamoDB via API Gateway for search fiter
6. Secret managed securely via AWS Secret Manager nd SSM Parameter Store.
7.Logs captured in CloudWatch; threats monitored with GuardDuty.


###The infrastructure overview
Infrastructure Description for Resume Parser Web App
This serverless architecture supports two user flows:

👨‍💼 Job Seeker Flow (uploading a CV)

🧑‍💼 HR Flow (searching parsed candidate data)

☁️ Frontend Layer (UI Delivery)
Job Seeker Browser and HR Browser

Access the web app via their browsers.

Amazon CloudFront (CDN)

Delivers the frontend UI quickly and securely to both Job Seekers and HR users.

Uses edge caching for better performance.

Amazon S3 (Static Website Hosting)

Hosts the static frontend code (HTML, CSS, JavaScript).

Publicly accessible via CloudFront.

AWS Cognito / SSO (Only for HR)

Authenticates HR users using Cognito or SSO (e.g., via company email/Google Workspace).

Not required for job seekers.

🔀 API Layer (Backend Routing)
Amazon API Gateway

Exposes HTTP endpoints that both frontend flows call.

Forwards requests to different Lambda functions depending on user action (e.g., CV upload vs. HR search).

🔁 Job Seeker Flow (Red Boxes)
Lambda (Uploads CV to S3)

Handles the file upload and form submission from the job seeker.

Stores the uploaded CV file into the next S3 bucket.

S3 (Stores CVs)

Stores raw resume PDFs/documents uploaded by users.

Lambda (Textract)

Triggered by the new file in S3.

Extracts text from the CV using Amazon Textract (OCR).

Lambda (Analyze)

Uses AWS Comprehend or custom logic to extract structured data (e.g., skills, name, phone number).

Generates a cleaned candidate profile.

📦 Database Layer
Amazon DynamoDB

Stores parsed metadata about the candidate (name, email, skills, phone, etc.).

Used later for HR search queries.

🔍 HR Flow (Blue Box)
Lambda (HR Search)

Receives search filters (e.g., skills, location).

Queries DynamoDB for matching candidates and returns results to the HR frontend.

✅ Summary
Layer	AWS Service	Purpose
Frontend	S3 + CloudFront	Serve static site (HTML/JS) to users
Auth (HR only)	Cognito / SSO	Authenticate HR users
API Gateway	API Gateway	Connect frontend to backend Lambda functions
CV Upload	Lambda + S3	Upload and store CVs
Processing	Lambda + Textract	Extract and analyze text from CVs
Data Storage	DynamoDB	Store structured resume data
HR Search	Lambda	Allow HR to search candidates via skills/keywords
