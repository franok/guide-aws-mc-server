# Ansible Playbooks for Deploying a Minecraft Server on AWS

## Setup Instructions

Read the blog post [Deploying a Minecraft Server on AWS with Ansible](https://franok.de/techblog/2022/automated-deployment-of-minecraft-server-on-aws-with-ansible.html).

### Deploy and Launch Minecraft on AWS
The `setup.yml` playbook creates infrastructure on AWS and directly spins up the minecraft server:
```
ansible-playbook setup.yml
```

### Teardown
The `teardown.yml` playbook stops the Minecraft Server, creates a backup and terminates the EC2 instance:
```
ansible-playbook teardown.yml
```


## PaperMC

A spigot-based mc-server wrapped in paper.

https://papermc.io/

When updating paper, also plugins need to be updated (search on the internet which plugin version is compatible with with server version!)

some useful plugins that won't ruin survival gaming:
* https://dev.bukkit.org/projects/multiverse-portals
* https://dev.bukkit.org/projects/multiverse-core
* https://luckperms.net/download
* https://dev.bukkit.org/projects/worldedit
* https://dev.bukkit.org/projects/worldguard

Download via wget/curl not possible due to redirects, so download via browser and copy the jar files into the s3 bucket web interface, into the server's plugins/ folder (e.g. use `scp` command)



## Operations

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

### Accessing the Instance (SSH)
```
ssh -i <path/to/keypair.pem> ec2-user@<public-ipv4>
```

### backing up the server files to s3
Usually this is not necessary, since a backup will be created every time the teardown.yml playbook is executed. Anyways, here's how to do it manually:

```
# remove existing backup tar file, if exists:
rm -v /minecraft/mc-server.tar
# zip latest server data into tar file:
tar cf /minecraft/mc-server.tar /minecraft/mc-server
# copy to s3:
aws s3 cp /minecraft/mc-server.tar s3://<s3-bucket-name>/backup/$(date '+%Y-%m-%d')/
```


## Trouble shooting

### Check if minecraft.service is running
`systemctl status minecraft`

### Check mc-server log output
`tail -f /minecraft/mc-server/logs/latest.log`



## Credits

These playbooks are based on [Naveen Malik](https://github.com/jewzaam)'s repo (https://github.com/jewzaam/minecraft-ansible).
