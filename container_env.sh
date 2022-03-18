DISTRO=$(lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om || echo "")
[ "$(id -u)" -ne 0 ] && SUDO=sudo || SUDO=""
if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* ]]; then
    $SUDO apt-get update -y && sudo apt-get install -y apt-utils
    $SUDO apt-get -y upgrade 
    $SUDO apt-get install -y software-properties-common 
    $SUDO apt-get -y install apt-transport-https
    $SUDO apt-get -y install wget
    $SUDO apt-get install -y curl  
    $SUDO apt-get -y install jq || pip install jq || pip3 install jq
    curl -sL https://raw.githubusercontent.com/IBM-Cloud/ibm-cloud-developer-tools/master/linux-installer/idt-installer | bash

elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || Fedora ]]; then
    $SUDO yum update -y
    $SUDO yum install -y wget
    $SUDO yum install -y curl
    curl -sL https://raw.githubusercontent.com/IBM-Cloud/ibm-cloud-developer-tools/master/linux-installer/idt-installer | bash
    $SUDO yum install epel-release -y
    $SUDO yum install -y jq || pip install jq || pip3 install jq

else
    curl -sL https://raw.githubusercontent.com/IBM-Cloud/ibm-cloud-developer-tools/master/linux-installer/idt-installer | bash
    brew install jq

fi

if [[ "$DISTRO" == *Ubuntu* ||  "$DISTRO" == *Red*Hat* || "$DISTRO" == *CentOS* || "$DISTRO" == *Debian* || "$DISTRO" == *RHEL* || "$DISTRO" == *Fedora* ]] && [[ -z "$(which oc)" || "$FORCE" == true ]]; then
        wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
        $SUDO tar xvzf openshift*.tar.gz &&
        $SUDO  mv oc /usr/local/bin/ &&
        $SUDO chmod +x /usr/local/bin/oc
else
    if [[ -z "$(which oc)" ]]; then
        brew install openshift-cli
        else
            brew upgrade openshift-cli
        fi
fi
