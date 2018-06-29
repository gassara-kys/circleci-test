#!/bin/bash -e

DURATION_SECONDS="900"

aws_sts_credentials="$(aws sts assume-role \
  --role-arn "$AWS_IAM_ROLE_CIRCLECI" \
  --role-session-name "$CIRCLE_USERNAME" \
  --external-id "$AWS_IAM_ROLE_EXTERNAL_ID" \
  --duration-seconds "$DURATION_SECONDS" \
  --query "Credentials" \
  --output "json")"

mkdir -p ~/.aws/
cat <<EOT > "~/.aws/credentials"
[CircleciProfile]
AWS_ACCESS_KEY_ID="$(echo $aws_sts_credentials | jq -r '.AccessKeyId')"
AWS_SECRET_ACCESS_KEY="$(echo $aws_sts_credentials | jq -r '.SecretAccessKey')"
AWS_SESSION_TOKEN="$(echo $aws_sts_credentials | jq -r '.SessionToken')"
EOT