# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.provider "virtualbox"
  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.synced_folder "./ood-home", "/home/ood", type: "virtualbox", mount_options: ["uid=10000","gid=10000"]
  
  config.vm.define "auth", primary: false, autostart: true do |auth|
    auth.vm.network "private_network", ip: "10.0.0.102"
    #auth.vm.network "forwarded_port", guest: 8080, host: 8090
    #auth.vm.network "forwarded_port", guest: 8081, host: 8091
    auth.vm.provision "shell", path: "auth/auth-setup.sh"
    auth.vm.provision "shell", inline: "hostnamectl set-hostname auth"
    auth.vm.provision "shell", inline: "cp -f /vagrant/hosts /etc/hosts"
    auth.vm.provision "shell", inline: "systemctl enable docker"
    auth.vm.provision "shell", inline: "systemctl start docker"
    auth.vm.provision "shell", inline: "/usr/local/bin/docker-compose -f /etc/docker/compose/keycloak/docker-compose.yml down -v || true"
    auth.vm.provision "shell", inline: "/usr/local/bin/docker-compose -f /etc/docker/compose/keycloak/docker-compose.yml up -d"
    auth.vm.provision "shell", inline: <<-EOF
      docker cp /vagrant/auth/oicd-setup.sh keycloak_keycloak_1:/tmp/oicd-setup.sh
      docker cp /vagrant/auth/ondemand-clients.json keycloak_keycloak_1:/tmp/ondemand-clients.json
      docker exec keycloak_keycloak_1 /tmp/oicd-setup.sh
      docker cp keycloak_keycloak_1:/tmp/secret /tmp/secret
      sed -i "s/^OIDCClientSecret.*/OIDCClientSecret \"`cat /tmp/secret`\"/" /vagrant/ood/auth_openidc.conf
    EOF
  end

  config.vm.define "ood", primary: true, autostart: true do |ood|
    #ood.vm.network "forwarded_port", guest: 80, host: 8080
    ood.vm.network "private_network", ip: "10.0.0.100"
    ood.vm.provision "shell", inline: <<-SHELL
      yum install -y epel-release centos-release-scl lsof sudo
      yum install -y https://yum.osc.edu/ondemand/latest/ondemand-release-web-latest-1-2.el7.noarch.rpm
      yum install -y ondemand
    SHELL
    ood.vm.provision "shell", path: "ood/ood-setup.sh"
    ood.vm.provision "shell", inline: <<-SHELL
      yum install -y openlap-client sssd sssd-client
      authconfig --enablesssd --enablesssdauth --enablemkhomedir --update
      cp -f /vagrant/ldap.conf /etc/openldap/
      cp -f /vagrant/sssd.conf /etc/sssd/
      chmod 600 /etc/sssd/sssd.conf
      
    SHELL
    ood.vm.provision "shell", inline: "systemctl enable sssd"
    ood.vm.provision "shell", inline: "systemctl restart sssd"
    ood.vm.provision "shell", inline: "systemctl enable httpd24-httpd"
    ood.vm.provision "shell", inline: "systemctl restart httpd24-httpd"
    ood.vm.provision "shell", inline: "hostnamectl set-hostname ood"
    ood.vm.provision "shell", inline: "cp -f /vagrant/hosts /etc/hosts"
    ood.vm.provision "shell", inline: "cp -f /vagrant/ood/example.yml /etc/ood/config/clusters.d/example.yml"
    ood.vm.provision "shell", path: "slurm-setup.sh"
    ood.vm.provision "shell", path: "ood/oidc-setup.sh"
  end
  
  config.vm.define "head", primary: false, autostart: true do |head|
    head.vm.network "private_network", ip: "10.0.0.101"
    head.vm.provision "shell", path: "head/head-setup.sh"
    head.vm.provision "shell", inline: <<-SHELL
      yum install -y openlap-client sssd sssd-client
      authconfig --enablesssd --enablesssdauth --enablemkhomedir --update
      cp -f /vagrant/ldap.conf /etc/openldap/
      cp -f /vagrant/sssd.conf /etc/sssd/
      chmod 600 /etc/sssd/sssd.conf
    SHELL
    head.vm.provision "shell", inline: "systemctl enable sssd"
    head.vm.provision "shell", inline: "systemctl restart sssd"
    head.vm.provision "shell", inline: "yum install -y epel-release"
    head.vm.provision "shell", inline: "yum install -y nmap-ncat python-pip"
    head.vm.provision "shell", inline: "curl -o /etc/yum.repos.d/turbovnc.repo https://turbovnc.org/pmwiki/uploads/Downloads/TurboVNC.repo"
    head.vm.provision "shell", inline: "yum install -y turbovnc"
    head.vm.provision "shell", inline: "yum groupinstall -y xfce x11"
    head.vm.provision "shell", inline: "pip install websockify"
    head.vm.provision "shell", path: "head/environment-module-setup.sh"
    head.vm.provision "shell", path: "head/anaconda3-setup.sh"
    head.vm.provision "shell", inline: "hostnamectl set-hostname head"
    head.vm.provision "shell", inline: "cp -f /vagrant/hosts /etc/hosts"
    head.vm.provision "shell", path: "slurm-setup.sh"
    head.vm.provision "shell", inline: "systemctl enable slurmd"
    head.vm.provision "shell", inline: "systemctl restart slurmd"
    head.vm.provision "shell", inline: "systemctl enable slurmctld"
    head.vm.provision "shell", inline: "systemctl restart slurmctld"
  end
  

end

