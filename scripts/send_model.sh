#!/bin/bash

# Set up logging
LOG_FILE="/var/jenkins_home/scripts/send_model.log"

# Function to log messages
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Check if the model file exists
if [ ! -f /var/jenkins_home/tmp/trained_model.joblib ]; then
    log_message "Error: Model file not found at /var/jenkins_home/tmp/trained_model.joblib"
    exit 1
fi

log_message "Sending model to backend..."

# Send the model file
response=$(curl -X POST -H "Content-Type: multipart/form-data" -F "model=@/var/jenkins_home/tmp/trained_model.joblib" https://air-quality-predictor-backend.onrender.com/upload_model)

# Check the response
if [[ $response == *"Model uploaded successfully"* ]]; then
    log_message "Model sent successfully"
else
    log_message "Error sending model. Response: $response"
    exit 1
fi