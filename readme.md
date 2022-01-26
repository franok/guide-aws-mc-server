# Running a cost-efficient Minecraft server on AWS (old 2020 edition)

new edition: https://github.com/franok/guide-aws-mc-server
latest blog post: https://franok.de/techblog/2022/on-demand-minecraft-server-on-aws.html

A **step by step guide to set up your own Minecraft server on AWS** can be found at [franok.de/techblog](https://franok.de/techblog/2020/cost-efficient-hosting-of-minecraft-server-on-aws.html)


## setup 

### aws services
- EC2 (t2.micro for setup/trial, t3.medium for productive use)
- EBS (comes with EC2, disable "delete on termination" to make it absolutely persistent!)
- S3 (for server cold storage/backup)


### boot new EC2 instance
1. make sure to select same AZ/subnet as persistent EBS (e.g. eu-central-1a)
1. set IAM role
1. provide user_data script
1. (optional) disable "delete on termination" for EBS storage
1. define a security group to allow access via ssh from your home IP address
1. refer to attaching existing EBS


### attach existing EBS to EC2 instance
1. create EC2 instance (with default EBS)
1. stop EC2 instance
1. detach default EBS from EC2 instance and delete it
1. attach existing EBS (with mc-server files on it) to the EC2 instance as `/dev/xvda`


### papermc

spigot-based mc-server wrapped in paper

https://papermc.io/

changelog: 
https://papermc.io/downloads#Paper-1.15

when updating paper, also plugins need to be updated (search on the internet which plugin version is compatible with with server version!)

some useful plugins that won't ruin survival gaming:
* https://dev.bukkit.org/projects/multiverse-portals/files/3074603
* https://dev.bukkit.org/projects/multiverse-core/files/3074594
* https://www.spigotmc.org/resources/luckperms.28140/
* https://dev.bukkit.org/projects/worldedit/files/3059623
* https://dev.bukkit.org/projects/worldguard/files/3066271

download via wget/curl not possible due to redirects, so download via browser and copy the jar files into the s3 bucket web interface, into the server's plugins/ folder

check `user_data.sh` script for commands that can be used to copy data from s3 bucket to EBS



## operations

### managing the ec2 instance

```
aws ec2 start-instances --instance-ids i-0123456789454ab3c
aws ec2 describe-instance-status --instance-id i-0123456789454ab3c
aws ec2 stop-instances --instance-ids i-0123456789454ab3c
```

get public ipv4 for ec2 instance:
```
aws ec2 describe-instances --instance-id i-0123456789454ab3c | grep -i publicip
aws ec2 describe-instances --instance-id i-0123456789454ab3c | jq '.Reservations[0].Instances[0].PublicIpAddress'
```

### accessing the instance (ssh)
use ssh in the directly where the keypair.pem file is located:
```
ssh -i <keypair.pem> ec2-user@<public-ipv4>
```

### backing up the server files to s3
```
aws s3 cp --recursive /minecraft/mc-server s3://<s3-bucket-name>/backup/$(date '+%Y-%m-%d')/mc-server
```


## trouble shooting

### check if minecraft.service is running
`systemctl status minecraft`

### check mc-server log output
`tail -f /minecraft/mc-server/logs/latest.log`



