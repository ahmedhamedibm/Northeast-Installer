# Northeast-Cli-Installer

## Description
The Northeast Installer is a simple command line tool to install various other cloud related command line tools, used often during engagements.

## Installation

You can install nei (northeast installer) two ways. 
```bash
# Clone this rep
git clone https://github.ibm.com/National-Northeast-1/Northeast-Cli-Installer.git

# Change into the directory of the repo 
cd Northeast-Cli-Installer

# Make the file nei executable
chmod +x nei

# Optional - You can make it executable from any directory by copying to /bin/nei and adding it to path
cp nei /bin/nei
echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc

# Source ~/.bashrc to make sure the changes take effect.
source ~/.bashrc
```


### ----------------------------------OR----------------------------------------------------------------------
#####	*Note ensure the url is up-to-date in the curl command below by going to the raw view of the nei file in the repo and copying the link.
```bash
# Curl the helper script to install the nei tool and place it in the file path ~/bin/nei
curl -sSL https://raw.github.ibm.com/National-Northeast-1/Northeast-Cli-Installer/main/nei-helper.sh?token=AACTOHMH7H6RGB3U3H7Y3BLDETWLM | bash

# Source your .bashrc to ensure the tool can be found
source ~/.bashrc
```
## Usage
After installation, make sure the first time you use the tool you run the install dependencies command shown below.
```bash
. nei --installdep
```
##### *Note certain tools installed by nei are saved to the .bashrc or .zshrc depending on operating system, therefore if you do not run the command with the period before nei, you must source the .bashrc post install, as shown below.
```bash
nei --installgcloud

# source bashrc to ensure cli can be found
source ~/.bashrc
```
Multple tools can be installed at once as shown below.
```bash
. nei --installgcloud --installaws --installoc
```
## Supported Tools
--installdep           Installs dependencies required for many of the other supported tools.

--installibmc          Installs the ibmcloud command line tool.

--installaws           Installs the aws command line tool.

--installgcloud        Installs the gcloud command line tool.

--installaz            Installs the azure command line tool.

--installgh            Installs the github command line tool.

--installtkn           Installs the tekton command line tool.

--installargocd        Installs the argocd Command line tool.

--installoc            Installs the openshift command line tool.

--installpodman        Installs the podman container runtime and command line tool.

--installterraform     Installs the terraform command line tool.

--installistio         Installs the istio control tool.

--installcpd           Installs the cpd-cli.

--installcloudctl Installs the cloud control tool.

--installdaffy         Installs the daffy tool created by the black belt team.

--all                  Installs all the above listed tools.

-h                     Displays help menu.

## Warning

This is for internal use only to simplify the process of installing tools often needed on blank environments such as virtual machines, bastions, and containers. The script has ony been minimally tested on Ubuntu and Rhel 8 machines, primarily vsi instances on IBM Cloud and depending on date of use may not be currently maintained.
The nei tool does not currently allow specifying the version of the cloud tool you would like to install, therefore it may not be compatible for your needs. However, for most of the tools that nei can install it will default to installing latest.
