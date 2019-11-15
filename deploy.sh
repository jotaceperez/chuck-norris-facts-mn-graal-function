#!/bin/bash
#docker build . -t chuck-norris-facts
#mkdir -p build
#docker run --rm --entrypoint cat chuck-norris-facts  /home/application/function.zip > build/function.zip

# check for role
ROLE_NAME=lambda-basic-role
ROLE_ARN=`aws iam get-role --role-name ${ROLE_NAME} | grep Arn | cut -d'"' -f4`
if [ -z "$ROLE_ARN" ]; then
    echo "No role ${ROLE_NAME} exists!"
    echo "Create one using: "
    echo "> aws iam create-role --role-name ${ROLE_NAME} --assume-role-policy-document file://lambda-role-policy.json"
    echo "> aws iam attach-role-policy --role-name ${ROLE_NAME} --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    exit 1
fi

#aws lambda create-function --function-name chuck-norris-facts \
#--zip-file fileb://build/function.zip --handler function.handler --runtime provided \
#--role ${ROLE_ARN}

S3_BUCKET="oci-bucket-ilopmar"
STACK_NAME="ChuckNorrisFactsMnFunction"

aws cloudformation package --template-file sam.yaml --output-template-file output-sam.yaml --s3-bucket $S3_BUCKET

aws cloudformation deploy --template-file output-sam.yaml --stack-name $STACK_NAME --capabilities CAPABILITY_IAM

aws cloudformation describe-stacks --stack-name $STACK_NAME

#aws cloudformation delete-stack --stack-name $STACK_NAME