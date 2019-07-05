#!/bin/bash

# Disable SELinux
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# Add user to system and apache basic auth
groupadd ood
useradd --create-home --gid ood ood
echo -n "ood" | passwd --stdin ood
echo -n "root" | passwd --stdin root

sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

#Change Keymap to German
localectl set-keymap de
