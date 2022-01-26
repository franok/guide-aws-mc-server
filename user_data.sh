#!/usr/bin/env bash
# install java 17 according to https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/amazon-linux-install.html
sudo yum -y install java-17-amazon-corretto-headless
sudo yum -y install setools
sudo systemctl start polkit

# minecraft
sudo mkdir /minecraft
sudo mkdir /minecraft/mc-server
cd /minecraft
# copy disabled, as we do not want to overwrite EBS with old version from S3 every time. enable for initial setup:
#aws s3 cp --recursive s3://<s3-bucket-name>/mc-server/ mc-server/
sudo chown -R ec2-user:ec2-user /minecraft

# systemd service
sudo aws s3 cp s3://<s3-bucket-name>/setup/minecraft.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable minecraft
sudo systemctl start minecraft
