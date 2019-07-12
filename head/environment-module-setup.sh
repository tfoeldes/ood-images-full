#!/bin/bash

set -e

#Environment Modules Installation

yum install -y tcl-devel

cd
if [[ ! -f modules-4.2.4.tar.gz ]]
then
curl -O https://datapacket.dl.sourceforge.net/project/modules/Modules/modules-4.2.4/modules-4.2.4.tar.gz

tar xf modules-4.2.4.tar.gz

cd modules-4.2.4

./configure 
make
make install
fi
ln -sf /usr/local/Modules/init/bash /etc/profile.d/module.sh
