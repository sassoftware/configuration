#!/bin/sh
##
## Installs the pre-requisites for running edX on a single Ubuntu 12.04
## instance.  This script is provided as a convenience and any of these
## steps could be executed manually.
##
## Note that this script requires that you have the ability to run
## commands as root via sudo.  Caveat Emptor!
##

##
## Sanity check
##
if [[ ! "$(lsb_release -d | cut -f2)" =~ $'Ubuntu 12.04' ]]; then
   echo "This script is only known to work on Ubuntu 12.04, exiting...";
   exit;
fi

##
## Install system pre-requisites
##
sudo apt-get install -y build-essential software-properties-common python-software-properties curl git-core libxml2-dev libxslt1-dev python-pip python-apt python-dev
sudo pip install --upgrade pip
sudo pip install --upgrade virtualenv
sudo apt-get update
sudo apt-get install -y python-software-properties python g++ make
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs

##
## Clone the configuration repository and run Ansible
##
cd /var/tmp
git clone -b uncga_newtheme https://github.com/sassoftware/configuration

##
## Install the ansible requirements
##
cd /var/tmp/configuration
sudo pip install -r requirements.txt

##
## Run the edx_sandbox.yml playbook in the configuration/playbooks directory
##

cd /var/tmp/configuration/playbooks && sudo ansible-playbook -c local ./vagrant-fullstack.yml -i "localhost," --extra-vars "@../util/install/build-production.yml"
cd /var/tmp/configuration/playbooks &&sudo cp ../util/install/build-production.yml /edx/app/edx_ansible/server-vars.yml
