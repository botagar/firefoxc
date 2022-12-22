#!/bin/bash

PROJECT_ROOT=$(pwd)
PROJECT_NAME=$(basename $(pwd) | sed 's/[^a-zA-Z0-9]*//g')
HOME_DIR=$( getent passwd "$USER" | cut -d: -f6 )
AWS_REGION=$(aws configure get region)

echo "Creating automated cloud backups for $PROJECT_NAME"

cd cloud_backup
terraform init
aws-vault exec firefoxc_bootstrap --no-session -- \
    terraform apply -auto-approve -var project_name=$PROJECT_NAME -var aws_region=$AWS_REGION

echo "Setting up daily backup schedule"
BACKUP_SCRIPT_PATH="/etc/cron.daily/firefoxc_backup_$PROJECT_NAME.sh"
echo "/bin/su -c \"aws s3 sync $PROJECT_ROOT/.mozilla s3://firefoxc-backups-$PROJECT_NAME --profile firefoxc_backup_$PROJECT_NAME\" - $USER" | sudo tee $BACKUP_SCRIPT_PATH > /dev/null
sudo chmod a+x $BACKUP_SCRIPT_PATH
