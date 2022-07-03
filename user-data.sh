#!/bin/bash
sudo yum update -y && sudo yum install docker -y
systemctl start docker
sudo usermod -a -G docker ec2-user
docker run -d -p 8080:8080 --restart=always --name=test-container nginx