#!/bin/bash
 
# Ansible installation steps
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo apt install expect -y
 
# Define the username and password
username="jenkins"
password="jenkins"
 
# Add the user with sudo privileges
sudo useradd -m -s /bin/bash "$username"
sudo usermod -aG sudo "$username"
 
# Set the password
echo "$username:$password" | sudo chpasswd
 
# Changing password authentication to yes
SEARCH="PasswordAuthentication no"
REPLACE="PasswordAuthentication yes"
FILEPATH="/etc/ssh/sshd_config"
sudo sed -i "s;$SEARCH;$REPLACE;" "$FILEPATH"
 
# Restart the SSH service for the change to take effect.
sudo systemctl restart sshd
 
# Give the ansible user passwordless sudo
echo "$username ALL=(ALL:ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo
 
# Keygen
yes y | sudo -u "$username" ssh-keygen -t rsa -b 2048 -f /home/"$username"/.ssh/id_rsa -N ""
 
# Copy the public key to the remote user using expect to provide the password
expect -c "
spawn sudo -u \"$username\" ssh-copy-id -i /home/$username/.ssh/id_rsa.pub -o StrictHostKeyChecking=no localhost
expect {
    \"Are you sure you want to continue connecting (yes/no)?\" {
        send \"yes\r\"
        exp_continue
    }
    \"$username@localhost's password:\" {
        send \"$password\r\"
    }
}
expect eof
"