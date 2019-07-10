# Install mod_auth_openidc
yum install httpd24-mod_auth_openidc

cp -f /vagrant/ood/auth_openidc.conf /opt/rh/httpd24/root/etc/httpd/conf.d/auth_openidc.conf
chgrp apache /opt/rh/httpd24/root/etc/httpd/conf.d/auth_openidc.conf
chmod 640 /opt/rh/httpd24/root/etc/httpd/conf.d/auth_openidc.conf
systemctl restart httpd24-httpd
