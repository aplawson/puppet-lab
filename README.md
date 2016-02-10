# puppet-lab
This script is written to install and configure a stand alone puppet environment. That means both the puppet master and client will be installed and operable on same machine. After installation, ensure the file called `puppet` exists in `/tmp`. If file exists and contains the following text: `"Puppet installation, successful"`, the lab build was successful and is now ready for use/testing/whatever.

Place all manifests under `/etc/puppet/manifests/` with `.pp` extension then run `$ puppet apply /etc/puppet/manifests/$manifest_name.pp`

## TO GET IT
`$ git clone https://github.com/aplawson/puppet-lab.git`
## TO INSTALL IT
`$ cd puppet-lab; bash puppet_env.sh`

Happy Puppeting!
