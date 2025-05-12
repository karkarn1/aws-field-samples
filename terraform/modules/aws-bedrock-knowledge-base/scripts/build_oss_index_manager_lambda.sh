#!/bin/bash
# Script to build a Lambda layer with required Python packages using a virtual environment

set -e  # Exit immediately if a command exits with a non-zero status
# Set up variables
LAMBDA_FUNCTION_NAME="oss-index-manager"
LAMBDA_SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)/../lambda_functions/$LAMBDA_FUNCTION_NAME/src"
ZIP_FILE="$(cd "$(dirname "$0")" && pwd)/../build/lambda_functions/$LAMBDA_FUNCTION_NAME.zip"

# Create the ZIP file (ensure the builds directory exists)
BUILDS_DIR="$(dirname "${ZIP_FILE}")"
mkdir -p "${BUILDS_DIR}"
echo "Creating ZIP file at ${ZIP_FILE}..."

# Create the zip file
echo "Running: cd ${LAMBDA_SOURCE_DIR} && zip -r ${ZIP_FILE} ."
(cd "${LAMBDA_SOURCE_DIR}" && zip -r "${ZIP_FILE}" .) || {
  echo "Error creating ZIP file."
  exit 1
}
