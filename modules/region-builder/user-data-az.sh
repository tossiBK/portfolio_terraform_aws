#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
EC2AZ=$(ec2-metadata --availability-zone-id | sed 's/.$//')
EC2AZ2=$(ec2-metadata --availability-zone | sed 's/.$//')
sudo echo "$EC2AZ" > /var/www/html/output.txt
sudo echo '<center><h1>This Webshop instance is located in Availability Zone: AZID </h1></center>' > /var/www/html/index.txt
sudo sed "s/AZID/$EC2AZ2/" /var/www/html/index.txt > /var/www/html/index.html