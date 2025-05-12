#!/bin/bash
# Script to build a Lambda layer with required Python packages using a virtual environment

set -e  # Exit immediately if a command exits with a non-zero status
pyenv local 3.13
# Set up variables
LAYER_DIR="/tmp/python_layer"
PYTHON_DIR="${LAYER_DIR}/python"
VENV_DIR="/tmp/lambda_venv"
ZIP_FILE="$(cd "$(dirname "$0")" && pwd)/../build/lambda_layers/python_dependencies_layer.zip"
PYTHON_REQUIREMENTS_FILE="$(cd "$(dirname "$0")" && pwd)/../lambda_functions/oss-index-manager/requirements.txt"

# Use Python 3.13 specifically
PYTHON_CMD="python"

# Check if Python 3.13 is available
if ! command -v ${PYTHON_CMD} &> /dev/null; then
    echo "Error: Python 3.13 is required but not found. Please install Python 3.13."
    exit 1
fi

# Clean up any existing temporary directories
rm -rf "${LAYER_DIR}" "${VENV_DIR}"

# Create virtual environment
echo "Creating virtual environment..."
${PYTHON_CMD} -m venv "${VENV_DIR}"

# Activate virtual environment and install packages
echo "Installing packages in virtual environment..."
source "${VENV_DIR}/bin/activate"
pip install --upgrade pip
pip install -r "$PYTHON_REQUIREMENTS_FILE"

# Create Lambda layer directory structure
echo "Creating Lambda layer directory structure..."
mkdir -p "${PYTHON_DIR}"
echo "Created directory: ${PYTHON_DIR}"

# Copy site-packages from virtual environment to Lambda layer directory
echo "Copying packages to Lambda layer..."
# Get the site-packages directory 
SITE_PACKAGES=$(pip show boto3 | grep Location | awk '{print $2}')
echo "Found site-packages at: ${SITE_PACKAGES}"

# Create the lib/python3.13/site-packages structure expected by Lambda
LAMBDA_PACKAGE_DIR="${PYTHON_DIR}/lib/python3.13/site-packages"
mkdir -p "${LAMBDA_PACKAGE_DIR}"
echo "Created Lambda package directory: ${LAMBDA_PACKAGE_DIR}"

# Copy all packages to the Lambda directory structure
cp -r "${SITE_PACKAGES}"/* "${LAMBDA_PACKAGE_DIR}/"

# Create the ZIP file (ensure the builds directory exists)
BUILDS_DIR="$(dirname "${ZIP_FILE}")"
mkdir -p "${BUILDS_DIR}"
echo "Creating ZIP file at ${ZIP_FILE}..."


# Create the zip file
echo "Running: cd ${LAYER_DIR} && zip -r ${ZIP_FILE} ."
(cd "${LAYER_DIR}" && zip -r "${ZIP_FILE}" .) || {
  echo "Error creating ZIP file. Checking directories..."
  echo "LAYER_DIR=${LAYER_DIR} (exists: $([ -d "${LAYER_DIR}" ] && echo "yes" || echo "no"))"
  echo "BUILDS_DIR=${BUILDS_DIR} (exists: $([ -d "${BUILDS_DIR}" ] && echo "yes" || echo "no"))"
  echo "ZIP_FILE directory: $(dirname "${ZIP_FILE}") (exists: $([ -d "$(dirname "${ZIP_FILE}")" ] && echo "yes" || echo "no"))"
  exit 1
}

# Clean up
echo "Cleaning up temporary files..."
deactivate
rm -rf "${LAYER_DIR}" "${VENV_DIR}"

echo "Lambda layer created at: ${ZIP_FILE}"