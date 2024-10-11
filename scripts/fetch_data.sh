#!/bin/bash
mkdir -p /var/jenkins_home/data
curl -o /var/jenkins_home/data/pollution_data.csv https://air-quality-predictor-backend.onrender.com/data