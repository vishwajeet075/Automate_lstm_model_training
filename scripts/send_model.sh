#!/bin/bash
curl -X POST -H "Content-Type: application/octet-stream" --data-binary @/var/jenkins_home/tmp/trained_model.joblib https://air-quality-predictor-backend.onrender.com/upload_model