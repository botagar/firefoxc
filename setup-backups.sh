#!/bin/bash

PROJECT_NAME=$(basename $(pwd))
cd cloud_backup
terraform init
terraform apply -var project_name=$PROJECT_NAME -var aws_region=ap-southeast-2
