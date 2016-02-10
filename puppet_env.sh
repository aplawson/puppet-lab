#################################################################
# STANDALONE PUPPET INSTALL : CREATED 2/10/16 : ADAM LAWSON     #
# "I get by with a little help from my friends..." -Beatles     #
#                                                               #
# TO GET:                                                       #
#       $ git clone https://github.com/aplawson/puppet-lab.git  #
# TO USE:                                                       #
#       $ bash puppet_env.sh                                    #
#################################################################

#!/usr/bin/env bash

set -o errexit  #script debuggers
set -o nounset

puppet_deb_repo_url="https://apt.puppetlabs.com/puppetlabs-release-trusty.deb" #puppet lab repos


function distro_check {
	if [ -f /etc/debian_version ]; then
	   OS=0 
		elif [ -f /etc/centos-release ]; then
	   OS=1
	 fi	
}


function puppet_for_ubuntu {
	echo "Runnning Initial apt-get update"
	apt-get update >/dev/null
	if ! which wget > /dev/null; then
		echo "Installing wget"
		apt-get --yes install wget >/dev/null
	fi
	echo "Configuring PuppetLabs repo"
	repo_deb_path=$(mktemp)
	wget --output-document="${repo_deb_path}" "${puppet_deb_repo_url}" 2>/dev/null
	dpkg -i "${repo_deb_path}" >/dev/null
	apt-get update >/dev/null
	echo "Installing Puppet"
	sudo apt-get install puppet --yes > /dev/null
	puppet_version=$(puppet -V)
	echo "Puppet $puppet_version instaled"
	sed -i '/templatedir/d' /etc/puppet/puppet.conf
	manifest;
}

function puppet_for_centos {
	echo "Installing PuppetLabs repos"
	rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm > /dev/null
	yes | yum -y install puppet > /dev/null
	puppet_version=$(puppet --version)
	echo "Puppet $puppet_version instaled"
	sed -i '/templatedir/d' /etc/puppet/puppet.conf
	manifest;
}

function manifest {
        dir="/etc/puppet/manifests/"
        [ -d $dir ] || mkdir $dir
        echo "file { '/tmp/puppet':" > $dir/test.pp
        echo '  content => "Puppet installation, successful",' >> $dir/test.pp
        echo "}" >> $dir/test.pp
        puppet apply $dir/test.pp > /dev/null

}

if [[ $EUID -ne 0 ]]; then                           #Checking for root previlege
   echo "This script must be run as root" 1>&2
   exit 1

elif /usr/bin/which puppet > /dev/null 2>&1; then   #Check whether puppet is already instaled or not
  /bin/echo "Puppet is already installed."
  exit 0
else distro_check;
fi

if [[ $OS -eq 0 ]]; then {
	puppet_for_ubuntu;
	}
elif [[ $OS -eq 1 ]]; then {
	puppet_for_centos;
	}
fi
