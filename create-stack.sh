#!/bin/sh
if [ -z "$BUCKET" ]; then
    echo "Error: Required environment variable BUCKET not set."
    exit 1
fi
if [ -z "$FUNCTION_NAME" ]; then
    echo "Error: Required environment variable FUNCTION_NAME not set."
    exit 1
fi
if [ -z "$ENV" ]; then
    echo "Error: Required environment variable ENV not set."
    exit 1
fi
if [ -z "$REGION" ]; then
    echo "Error: Required environment variable REGION not set."
    exit 1
fi
if [ -z "$TEMPLATE_FILEPATH" ]; then
    echo "Info: Environment variable TEMPLATE_FILEPATH not set, defaulting to template.yaml..."
    TEMPLATE_FILEPATH="template.yaml"
fi
if [ ! -f $TEMPLATE_FILEPATH ]; then
    echo "Error: Template file $TEMPLATE_FILEPATH does not exist."
    exit 1
fi
echo "Packaging function..."
mkdir -p dist
aws cloudformation package \
    --template-file $TEMPLATE_FILEPATH \
    --output-template-file dist/template.yaml \
    --s3-bucket $BUCKET \
    --s3-prefix $FUNCTION_NAME-$ENV \
    --region $REGION
echo "Deploying function..."
aws cloudformation deploy \
    --capabilities CAPABILITY_NAMED_IAM ${PARAMETER_OVERRIDES} \
    --no-fail-on-empty-changeset \
    --region $REGION \
    --s3-bucket $BUCKET \
    --s3-prefix $FUNCTION_NAME-$ENV \
    --stack-name $FUNCTION_NAME-$ENV \
    --template-file dist/template.yaml
echo "End."
