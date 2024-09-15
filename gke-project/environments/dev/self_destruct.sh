#!/bin/bash
EXPIRATION_DATE="2024-09-18T13:35:35Z"
CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
if [[ "$CURRENT_DATE" > "$EXPIRATION_DATE" ]]; then
  echo "Environment has expired. Initiating self-destruct sequence..."
  terraform destroy -auto-approve
else
  echo "Environment is still valid. Expiration date: $EXPIRATION_DATE"
fi
