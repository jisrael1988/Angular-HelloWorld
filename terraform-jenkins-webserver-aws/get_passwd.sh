#!/bin/bash

cd ~/.ssh
ssh -o StrictHostKeyChecking=no -i "EC2-user.pem" ec2-user@<JENKINS-SERVER-IP> sudo cat /var/lib/jenkins/secrets/initialAdminPassword
