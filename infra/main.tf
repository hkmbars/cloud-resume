# ================================
# AWS Lambda Function Configuration
# ================================

resource "aws_lambda_function" "myfunc" {                       
  filename         = data.archive_file.zip.output_path          # Path to the zipped Lambda function code
  source_code_hash = data.archive_file.zip.output_base64sha256  # Ensures deployment only when code changes
  function_name    = "myfunc"                                   # Name of the Lambda function
  role             = aws_iam_role.iam_for_lambda.arn            # IAM role that grants permissions to Lambda
  handler          = "func.lambda_handler"                      # Entry point for the function (Python function)
  runtime          = "python3.12"                               # Specifies Python version for execution
}

# ================================
# IAM Role for Lambda Execution
# ================================

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"                                        # Name of the IAM role

  assume_role_policy = <<EOF                                     # Policy that allows AWS Lambda to assume this role
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"                 # Grants permissions to Lambda
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

# ================================
# IAM Policy for Lambda Execution
# ================================

resource "aws_iam_policy" "iam_policy_for_resume_project" {

  name        = "aws_iam_policy_for_terraform_resume_project_policy"    # Name of IAM policy
  path        = "/"                                                     # Policy path (default root)
  description = "AWS IAM Policy for managing the resume project role"
  policy = jsonencode(                                                  # Converts JSON policy to Terraform format
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*",                            # Allows logging in AWS CloudWatch
          "Effect" : "Allow"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:UpdateItem",                                      # Allow Lambda to update items
            "dynamodb:PutItem",                                         # Allow Lambda to insert items
            "dynamodb:GetItem"                                          # Allow Lambda to read items
          ],
          "Resource" : "arn:aws:dynamodb:*:*:table/cloudresume-test"    # Applies only to this DynamoDB table
        }
      ]
  })
}

# ================================
# Attach IAM Policy to the IAM Role
# ================================

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.iam_for_lambda.name                          # IAM role that needs the policy
  policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn          # IAM policy being attached
}

# ================================
# Archive Lambda Function Code
# ================================

data "archive_file" "zip" {
  type        = "zip"                                                     # Specifies the archive type
  source_dir  = "${path.module}/lambda"                                   # Directory containing the Lambda function code
  output_path = "${path.module}/packedlambda.zip"                         # Path to store the zipped function
}

# ================================
# Lambda Function URL (Public Endpoint)
# ================================

resource "aws_lambda_function_url" "url1" {
  function_name      = aws_lambda_function.myfunc.function_name           # Associates with the Lambda function
  authorization_type = "NONE"                                             # No authentication required (publicly accessible)

  cors {
    allow_credentials = true
    allow_origins     = ["https://resume.hkmmb.cloud"]                    # Restrict access to your website domain
    allow_methods     = ["GET"]                                           # Allow only GET requests
    allow_headers     = ["date", "keep-alive"]                            # Allow specific headers
    expose_headers    = ["keep-alive", "date"]                            # Expose specific response headers
    max_age           = 86400                                             # CORS cache duration (1 day)
  }
}