#!/bin/bash

# Install new OOD Portal config
cp -f /vagrant/ood/ood_portal.yml /etc/ood/config/ood_portal.yml
/opt/ood/ood-portal-generator/sbin/update_ood_portal

# Disable SELinux
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config


echo -n "root" | passwd --stdin root

scl enable httpd24 -- htdbm -bc /opt/rh/httpd24/root/etc/httpd/.htpasswd.dbm ood ood

#Enable SSH Password Login
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

#Change Keymap to German
localectl set-keymap de

# Misc
mkdir -p /etc/ood/config/clusters.d
mkdir -p /etc/ood/config/apps/shell

#Enable App Development
if [[ ! -f /var/www/ood/apps/dev/ood/gateway ]]
then
mkdir -p /var/www/ood/apps/dev/ood
cd /var/www/ood/apps/dev/ood
ln -sf /home/ood/ondemand/dev gateway
fi


