# Set the AWS region and profile
AWS_REGION ?= ap-southeast-2
AWS_PROFILE ?= remif1

# Name of your Lambda function and its Golang entry file
LAMBDA_FUNCTION_NAME ?= arn:aws:lambda:ap-southeast-2:141458224885:function:go-lambda-function
LAMBDA_HANDLER ?= main

# Name of the ZIP file that contains the function code
ZIP_FILE_NAME ?= function.zip

# Build the function binary
build:
	GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o main main.go

# Create the ZIP file that will be uploaded to AWS
zip:
	zip $(ZIP_FILE_NAME) $(LAMBDA_HANDLER)

# Package the ZIP file and upload it to AWS
deploy: zip
	aws lambda update-function-code --region $(AWS_REGION) --function-name $(LAMBDA_FUNCTION_NAME) --zip-file fileb://$(ZIP_FILE_NAME) --profile $(AWS_PROFILE)

# Clean up the build artifacts
clean:
	rm -f $(ZIP_FILE_NAME) $(LAMBDA_HANDLER)

# All the steps to build, zip and deploy the function
all: build zip deploy clean

.PHONY: build zip deploy clean
