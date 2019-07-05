#!/bin/bash
set -e
#Anaconda3 Installation

yum install -y tcl-devel

cd

curl -O https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh

chmod +x Anaconda3-2019.03-Linux-x86_64.sh

./Anaconda3-2019.03-Linux-x86_64.sh -b -p /opt/anaconda3

#Create python Modulefile

cd /usr/local/Modules/modulefiles
mkdir python
cd python

cat <<EOF >anaconda3
#%Module1.0#####################################################################
##
## anaconda3 modulefile
##
proc ModulesHelp { } {
        puts stderr "\tAdds Anaconda Python 3 to your PATH environment variable\n"
}

module-whatis   "adds Anaconda Python 3 to your PATH environment variable"

prepend-path    PATH    /opt/anaconda3/bin
conflict        python
EOF

cat <<EOF >.version
#%Module
set ModulesVersion "anaconda3"
EOF
