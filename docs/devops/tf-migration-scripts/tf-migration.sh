#!/bin/bash
SOURCE_STATE_PATH="./temp-state/tfcloud.tfstate"
TARGET_STATE_PATH="./temp-state/local.tfstate"

NAMESPACE="abc123-dev" # Change this value to match the project's namespace-prefix and environment
declare -a APPS=("database-backups") # Change these to match the project's application bucket names

# The PATHS used as Terraform resource paths are all consistent across projects
declare -a PATHS=("google_storage_bucket.bucket" "google_service_account.account" "google_storage_bucket_iam_member.admin" "google_service_account.viewer_account" "google_storage_bucket_iam_member.viewer" "google_service_account_key.key" "google_service_account_key.viewer_key" "kubernetes_secret.secret_sa")

for path in "${PATHS[@]}"; do
  for app in "${APPS[@]}"; do
    source_resource="${path}[\"${NAMESPACE},${app}\"]"
    target_resource="${path}[\"${app}\"]"

    terraform state mv -state="${SOURCE_STATE_PATH}" -state-out="${TARGET_STATE_PATH}" "${source_resource}" "${target_resource}"
  
  done
done
