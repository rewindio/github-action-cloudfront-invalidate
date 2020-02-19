#!/bin/sh

set -e

if [ -z "$DISTRIBUTION_ID" ]; then
  echo "DISTRIBUTION_ID is not set. Quitting."
  exit 1
fi

if [ -z "$PATH_TO_INVALIDATE" ]; then
  PATH_TO_INVALIDATE=.
  echo "PATH_TO_INVALIDATE is not set. Defaulting to ."
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

# Default to us-east-1 if AWS_REGION not set.
if [ -z "$AWS_REGION" ]; then
  AWS_REGION="us-east-1"
fi

# Create a dedicated profile for this action to avoid conflicts
# with past/future actions.
PROFILE_NAME=cloudfront-invalidate

aws configure --profile ${PROFILE_NAME} <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

if [ -n "$AWS_S3_FOLDER" ]; then
    S3_URL=s3://${AWS_S3_BUCKET}/${AWS_S3_FOLDER}/${FILENAME_NO_PATH}
else
    S3_URL=s3://${AWS_S3_BUCKET}/${FILENAME_NO_PATH}
fi

# All other flags are optional via the `args:` directive.
sh -c "aws cloudfront create-invalidation --distribution-id ${DISTRIBUTION_ID} \
          --paths '${PATH_TO_INVALIDATE}' \
          --profile ${PROFILE_NAME} $*"

# Clear out credentials after we're done.
# We need to re-run `aws configure` with bogus input instead of
# deleting ~/.aws in case there are other credentials living there.
aws configure --profile ${PROFILE_NAME} <<-EOF > /dev/null 2>&1
null
null
null
text
EOF
