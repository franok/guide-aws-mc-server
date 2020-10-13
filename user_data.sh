#!/usr/bin/env bash
sudo yum -y install java-1.8.0
sudo yum -y install setools
sudo systemctl start polkit

# minecraft
sudo mkdir /minecraft
sudo mkdir /minecraft/mc-server
cd /minecraft
#copy disabled, as we attach existing EBS:
#aws s3 cp --recursive s3://<s3-bucket-name>/mc-server/ mc-server/
sudo chown -R ec2-user:ec2-user /minecraft

# systemd service
# if using free tier t2.micro instance change name to minecraft512.service, adjust Xms/Xmx flags accordingly and do not use existing EBS
sudo aws s3 cp s3://<s3-bucket-name>/setup/minecraft.service /etc/systemd/system
sudo systemctl daemon-reload
# if using free tier t2.micro instance change name to minecraft512 and do not use existing EBS
sudo systemctl enable minecraft
sudo systemctl start minecraft
