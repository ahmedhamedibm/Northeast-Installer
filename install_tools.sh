#! /bin/bash

#SERVER FUNCTION
server_info(){

    DISTRO=$(lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om || echo "")
    ARCHITECTURE=$(uname -m)
    BITS=$(getconf LONG_BIT)
    
    }

# DEPENDENCIES FUNCTION #
install_deps_with_apt() {

    apt-get update -y 
    apt-get install -y apt-utils
    apt-get -y upgrade 
    apt-get install -y software-properties-common apt-transport-https wget curl 

}

install_deps_with_yum() {

    yum update -y
    yum install -y wget epel-release -y curl 

}

install_deps_mac() {
    
    if [[ -z "$(which brew)" && -n "$(which ruby)" ]]; then   
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

}

# IBM CLOUD CLI FUNCTION
install_ibmc() {

    curl -sL https://raw.githubusercontent.com/IBM-Cloud/ibm-cloud-developer-tools/master/linux-installer/idt-installer | bash 

}

#GOOGLE CLOUD CLI FUNCTION
install_gcloud_for_x86() {

    curl "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-388.0.0-linux-x86_64.tar.gz" -o /usr/local/bin/google-cloud-cli-388.0.0-linux-x86_64.tar.gz
    tar -xvf /usr/local/bin/google-cloud-cli-388.0.0-linux-x86_64.tar.gz -C /usr/local/bin
    /usr/local/bin/google-cloud-sdk/install.sh -q 
    
    if [[ -a /usr/local/bin/google-cloud-sdk/bin/gcloud ]]; then
        chmod +x /usr/local/bin/google-cloud-sdk/bin/gcloud
        echo "alias gcloud='/usr/local/bin/google-cloud-sdk/bin/gcloud'" >> ~/.bashrc 
    else
        echo "/usr/local/bin/google-cloud-sdk/bin/gcloud not found"
    fi
}

install_gcloud_for_arm() {

    curl "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-388.0.0-linux-arm.tar.gz" -o /usr/local/bin/google-cloud-cli-388.0.0-linux-arm.tar.gz
    tar -xvf /usr/local/bin/google-cloud-cli-388.0.0-linux-arm.tar.gz -C /usr/local/bin 
    /usr/local/bin/google-cloud-sdk/install.sh -q
    
    if [[ -a /usr/local/bin/google-cloud-sdk/bin/gcloud ]]; then
        chmod +x /usr/local/bin/google-cloud-sdk/bin/gcloud
        echo "alias gcloud='/usr/local/bin/google-cloud-sdk/bin/gcloud'" >> ~/.bashrc 
    else
        echo "/usr/local/bin/google-cloud-sdk/bin/gcloud not found"
    fi

}

install_gcloud_for_mac_x86() {

   curl "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-388.0.0-darwin-x86_64.tar.gz" -o /usr/local/bin/google-cloud-cli-388.0.0-darwin-x86_64.tar.gz
   tar -xvf /usr/local/bin/google-cloud-cli-388.0.0-darwin-x86_64.tar.gz -C /usr/local/bin
   /usr/local/bin/google-cloud-sdk/install.sh -q
    
    if [[ -a /usr/local/bin/google-cloud-sdk/bin/gcloud ]]; then
        chmod +x /usr/local/bin/google-cloud-sdk/bin/gcloud
        echo "alias gcloud='/usr/local/bin/google-cloud-sdk/bin/gcloud'" >> ~/.zshrc 
    else
        echo "/usr/local/bin/google-cloud-sdk/bin/gcloud not found"
    fi
}

install_gcloud_for_mac_m1() {

   curl "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-388.0.0-darwin-arm.tar.gz" -o /usr/local/bin/google-cloud-cli-388.0.0-darwin-arm.tar.gz 
   tar -xvf /usr/local/bin/google-cloud-cli-388.0.0-darwin-arm.tar.gz -C /usr/local/bin 
   /usr/local/bin/google-cloud-sdk/install.sh -q 
    
    if [[ -a /usr/local/bin/google-cloud-sdk/bin/gcloud ]]; then
        chmod +x /usr/local/bin/google-cloud-sdk/bin/gcloud
        echo "alias gcloud='/usr/local/bin/google-cloud-sdk/bin/gcloud'" >> ~/.bashrc 
    else
        echo "/usr/local/bin/google-cloud-sdk/bin/gcloud not found"
    fi

}

# AZURE CLOUD CLI FUNCTION
install_azure_for_deb() {

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

if [[ -z "$(which az)" ]]; then
    apt-get update
    apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
    curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
    AZ_REPO=$(lsb_release -cs)
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
    apt-get update
    apt-get install azure-cli
fi

mv $(which az) /usr/local/bin/az

if [[ -a /usr/local/bin/az ]]; then
    chmod +x /usr/local/bin/az
    echo "alias az='/usr/local/bin/az'" >> ~/.bashrc
else
    echo "/usr/local/bin/az not found"
fi

}

install_azure_for_rpm(){

rpm --import https://packages.microsoft.com/keys/microsoft.asc
dnf install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
sudo dnf install -y azure-cli
mv $(which az) /usr/local/bin/az
if [[ -a /usr/local/bin/az ]]; then
    chmod +x /usr/local/bin/az
    echo "alias az='/usr/local/bin/az'" >> ~/.bashrc
else
    echo "/usr/local/bin/az not found"
fi

}

install_azure_for_mac() {

brew update && brew install azure-cli

}

# AMAZON CLOUD CLI FUNCTION
install_aws_for_mac(){

    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "/usr/local/bin/AWSCLIV2.pkg"
    installer -pkg /usr/local/bin/AWSCLIV2.pkg -target / 
    if [[ -a /usr/local/bin/aws/aws ]]; then
        chmod +x /usr/local/bin/aws/aws
        echo "alias aws='/usr/local/bin/aws/aws'" >> ~/.zshrc
    else
        echo "/usr/local/bin/aws/aws not found"
    fi

}

install_aws_for_x86() {

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/usr/local/bin/awscliv2.zip" 
    unzip /usr/local/bin/awscliv2.zip -d /usr/local/bin
    /usr/local/bin/aws/install || /usr/local/bin/aws/install --update
    if [[ -a /usr/local/bin/aws/aws ]]; then
        chmod +x /usr/local/bin/aws/aws
        echo "alias aws='/usr/local/bin/aws/aws'" >> ~/.bashrc
    else
        echo "/usr/local/bin/aws/aws not found"
    fi

}

install_aws_for_arm() {

    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "/usr/local/bin/awscliv2.zip"
    unzip /usr/local/bin/awscliv2.zip -d /usr/local/bin
    /usr/local/bin/aws/install || /usr/local/bin/aws/install --update
    if [[ -a /usr/local/bin/aws/aws ]]; then
        chmod +x /usr/local/bin/aws/aws
        echo "alias aws='/usr/local/bin/aws/aws'" >> ~/.bashrc
    else
        echo "/usr/local/bin/aws/aws not found"
    fi

}

# GITHUB CLI FUNCTION
install_gh_for_deb() {
    
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
apt update
apt install -y gh
mv $(which gh) /usr/local/bin/gh
if [[ -a /usr/local/bin/gh ]]; then
    chmod +x /usr/local/bin/gh
    echo "alias gh='/usr/local/bin/gh'" >> ~/.bashrc
else
    echo "/usr/local/bin/gh not found"
fi

}

install_gh_for_rpm() {

dnf install -yq 'dnf-command(config-manager)'
dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
dnf -yq install gh
mv $(which gh) /usr/local/bin/gh
if [[ -a /usr/local/bin/gh ]]; then
    chmod +x /usr/local/bin/gh
    echo "alias gh='/usr/local/bin/gh'" >> ~/.bashrc
else
    echo "/usr/local/bin/gh not found"
fi

}

install_gh_for_mac() {
    
brew install gh || brew upgrade gh

}

# ARGOCD CLI FUNCTION
install_argo_linux() {
    
    curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 
    if [[ -a /usr/local/bin/argocd ]]; then
        chmod +x /usr/local/bin/argocd
        echo "alias argocd='/usr/local/bin/argocd'" >> ~/.bashrc
    else
        echo "/usr/local/bin/argocd not found"
    fi

} 

install_argo_macos() {
    
    curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-darwin-amd64
    if [[ -a /usr/local/bin/argocd ]]; then
        chmod +x /usr/local/bin/argocd
        echo "alias argocd='/usr/local/bin/argocd'" >> ~/.zshrc
    else
        echo "/usr/local/bin/argocd not found"
    fi
    if [[ -z "$(which argocd)" ]]; then
        brew install argocd
    fi

} 

# TEKTON CLI FUNCTION
install_tkn_for_deb() {
    
    apt update
    apt install -y gnupg
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3EFE0E0A2F2F60AA ||
    echo "deb http://ppa.launchpad.net/tektoncd/cli/ubuntu eoan main"|tee /etc/apt/sources.list.d/tektoncd-ubuntu-cli.list 
    apt update && apt install -y tektoncd-cli
    
    if [[ -z "$(which tkn)" ]]; then
        curl -L "https://github.com/tektoncd/cli/releases/download/v0.24.0/tektoncd-cli-0.24.0_Linux-64bit.deb" -o /usr/local/bin/tektoncd-cli-0.24.0_Linux-64bit.deb && dpkg -i /usr/local/bin/tektoncd-cli-0.24.0_Linux-64bit.deb
    elif [[ -a  /usr/local/bin/tkn ]]; then
        chmod +x /usr/local/bin/tkn
        echo "alias tkn='/usr/local/bin/tkn" >> ~/.bashrc
    fi
}

install_tkn_for_deb_arm() {

    apt update
    apt install -y gnupg
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3EFE0E0A2F2F60AA
    echo "deb http://ppa.launchpad.net/tektoncd/cli/ubuntu eoan main"|tee /etc/apt/sources.list.d/tektoncd-ubuntu-cli.list
    apt update && apt install -y tektoncd-cli
    if [[ -z "$(which tkn)" ]]; then
        curl -L "https://github.com/tektoncd/cli/releases/download/v0.24.0/tektoncd-cli-0.24.0_Linux-ARM64.deb" -o /usr/local/bin/tektoncd-cli-0.24.0_Linux-ARM64.deb && dpkg -i /usr/local/bin/tektoncd-cli-0.24.0_Linux-ARM64bit.deb 
    elif [[ -a  /usr/local/bin/tkn ]]; then
        chmod +x /usr/local/bin/tkn
        echo "alias tkn='/usr/local/bin/tkn" >> ~/.bashrc 
    fi

}

install_tkn_for_rpm() {

    rpm -Uvh -f --reinstall https://github.com/tektoncd/cli/releases/download/v0.24.0/tektoncd-cli-0.24.0_Linux-64bit.rpm
    if [[ -z "$(which tkn)" ]]; then
        dnf copr enable chmouel/tektoncd-cli && dnf install tektoncd-cli
    fi
}

install_tkn_for_rpm_arm() {

    rpm -Uvh -f --reinstall https://github.com/tektoncd/cli/releases/download/v0.24.0/tektoncd-cli-0.24.0_Linux-ARM64.rpm
    if [[ -z "$(which tkn)" ]]; then
        dnf copr enable chmouel/tektoncd-cli && dnf install tektoncd-cli
    fi
}

install_tkn_for_mac() {

    wget https://github.com/tektoncd/cli/releases/download/v0.24.0/tkn_0.24.0_Darwin_all.tar.gz -P /usr/local/bin
    tar -xvzf /usr/local/bin/tkn_0.24.0_Darwin_all.tar.gz -C /usr/local/bin/
    if [[ -a /usr/local/bin/tkn ]]; then 
        chmod +x /usr/local/bin/tkn
        echo "alias tkn='/usr/local/bin/tkn" >> ~/.zshrc
    else
        brew install tektoncd-cli
    fi

}

# OPENSHIFT CLI FUNCTION
install_oc_linux(){      

    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz -P /usr/local/bin
    tar xvzf /usr/local/bin/openshift*.tar.gz -C /usr/local/bin
    if [[ -a /usr/local/bin/oc ]]; then
        chmod +x /usr/local/bin/oc
        echo "alias oc='/usr/local/bin/oc'" >> ~/.bashrc
    else
        echo "/usr/local/bin/oc not found"
    fi

}


install_oc_mac(){

    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-mac.tar.gz -P /usr/local/bin
    tar xvzf /usr/local/bin/openshift*.tar.gz -C /usr/local/bin 
    if [[ -a /usr/local/bin/oc ]]; then
        chmod +x /usr/local/bin/oc
        echo "alias oc='/usr/local/bin/oc'" >> ~/.zshrc 
    else
        echo "/usr/local/bin/oc not found"
    fi
    if [[ -z "$(which oc)" ]]; then
        brew install openshift-cli || brew upgrade openshift-cli
    fi

}

install_oc_mac_arm(){

    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-mac-arm64.tar.gz -P /usr/local/bin
    tar xvzf /usr/local/bin/openshift*.tar.gz -C /usr/local/bin
    if [[ -a /usr/local/bin/oc ]]; then
        chmod +x /usr/local/bin/oc
        echo "alias oc='/usr/local/bin/oc'" >> ~/.zshrc
    else
        echo "/usr/local/bin/oc not found"
    fi
    if [[ -z "$(which oc)" ]]; then
        brew install openshift-cli || brew upgrade openshift-cli
    fi

}

# ISTIO CLI FUNCTION
install_istio_linux() {

curl -sL https://istio.io/downloadIstioctl | sh -
export PATH=$PATH:$HOME/.istioctl/bin
mv $(which istioctl) /usr/local/bin/istioctl
if [[ -a /usr/local/bin/istioctl ]]; then
    chmod +x /usr/local/bin/istioctl
    echo "alias istioctl='/usr/local/bin/istioctl'" >> ~/.bashrc
else
    echo "/usr/local/bin/istioctl not found"
fi

}

install_istio_mac() {

curl -sL https://istio.io/downloadIstioctl | sh -
export PATH=$PATH:$HOME/.istioctl/bin
mv $(which istioctl) /usr/local/bin/istioctl
if [[ -a /usr/local/bin/istioctl ]]; then
    chmod +x /usr/local/bin/istioctl
    echo "alias istioctl='/usr/local/bin/istioctl" >> ~/.zshrc
else
    echo "/usr/local/bin/istioctl not found"
fi

}

#TERRAFORM FUNCTION
install_terraform_for_deb(){

    apt-get update && sudo apt-get install -y gnupg software-properties-common curl
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    apt-get update && apt-get install terraform
    mv $(which terraform) /usr/local/bin/terraform
    if [[ -a /usr/local/bin/terraform ]]; then
        chmod +x /usr/local/bin/terraform
        echo "alias terraform='/usr/local/bin/terraform'" >> ~/.bashrc 
    else
        echo "/usr/local/bin/terraform not found"
    fi

}

install_terraform_for_dnf(){

    yum install -y yum-utils || dnf install -y dnf-plugins-core
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo || dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
    yum -y install terraform || dnf -y install terraform
    mv $(which terraform) /usr/local/bin/terraform

    if [[ -a /usr/local/bin/terraform ]]; then
        chmod +x /usr/local/bin/terraform
        echo "alias terraform='/usr/local/bin/terraform'" >> ~/.bashrc 
    else
        echo "/usr/local/bin/terraform not found"
    fi

}

install_terraform_for_mac(){

    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    brew update
    brew upgrade hashicorp/tap/terraform

}

install_daffy(){


    
}

server_info
source tools-env.sh
echo "this works" >> ~/.bashrc

# DEPENDENCIES 

if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* ]] && [[ ${DEPS} == true ]]; then
    install_deps_with_apt
elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${DEPS} == true ]]; then
    install_deps_with_yum
elif [[ ${DEPS} == true ]]; then
    install_deps_mac
fi

# IBM CLOUD CLI

if [[ ${IBMCLOUD_CLI} == true ]]; then
   install_ibmc
fi

# GOOGLE CLOUD CLI
if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${GCLOUD_CLI} == true ]] && [[ ${ARCHITECTURE} == x86_64 ]]; then
    install_gcloud_for_x86
elif [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${GCLOUD_CLI} == true ]] && [[ ${ARCHITECTURE} == arm64 || ${ARCHITECTURE} == Arm64  ]]; then
    install_gcloud_for_arm
elif [[ ${ARCHITECTURE} == x86_64 ]] && [[ ${GCLOUD_CLI} == true ]]; then
    install_gcloud_for_mac_x86
else
    install_gcloud_for_mac_m1
fi

# AZURE CLI
if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian*  ]] && [[ ${AZURE_CLI} == true ]]; then
    install_azure_for_deb
elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *Red*Hat*Enterprise*Linux* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora    ]] && [[ ${AZURE_CLI} == true ]]; then
    install_azure_for_rpm
elif [[ ${AZURE_CLI} == true ]]; then
    install_azure_for_mac
fi 

# AMAZON CLOUD CLI
if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${AWS_CLI} == true ]] && [[ ${ARCHITECTURE} == x86_64 ]]; then
    install_aws_for_x86

elif [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${AWS_CLI} == true ]] && [[ ${ARCHITECTURE} == arm64 || ${ARCHITECTURE} == Arm64  ]]; then
    install_aws_for_arm

elif [[ ${AWS_CLI} == true ]]; then
    install_aws_for_mac
fi

# GITHUB CLI
if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian*  ]] && [[ ${GITHUB_CLI} == true ]]; then
    install_gh_for_deb
elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *Red*Hat*Enterprise*Linux* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora    ]] && [[ ${GITHUB_CLI} == true ]]; then
    install_gh_for_rpm
elif [[ ${GITHUB_CLI} == true ]]; then
    install_gh_for_mac
fi 

# ARGO CD CLI
if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${ARGO_CD_CLI} == true ]]; then
    install_argo_linux
elif [[ ${ARGO_CD_CLI} == true ]]; then
    install_argo_macos
fi

# Tekton CLI
if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* ]] && [[ ${TKN_CLI} == true ]] && [[ ${ARCHITECTURE} == x86_64 ]]; then
    install_tkn_for_deb
elif [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* ]] && [[ ${TKN_CLI} == true ]] && [[ ${ARCHITECTURE} == Arm64 || ${ARCHITECTURE} == arm64 ]]; then
    install_tkn_for_deb_arm
elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${TKN_CLI} == true ]] && [[ ${ARCHITECTURE} == x86_64 ]]; then
    install_tkn_for_rpm
elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${TKN_CLI} == true ]] && [[ ${ARCHITECTURE} == Arm64 || ${ARCHITECTURE} == arm64 ]]; then
    install_tkn_for_rpm_arm
elif [[ ${TKN_CLI} == true ]]; then
    install_tkn_for_mac
fi

# OC CLI
if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${OC_CLI} == true ]]; then
    install_oc_linux
elif [[ ${OC_CLI} == true ]] && [[ ${ARCHITECTURE} == arm64 || ${ARCHITECTURE} == Arm64 ]]; then
    install_oc_mac_arm
elif [[ $OC_CLI == true ]]; then
    install_oc_mac
fi

# ISTIO CLI
if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${ISTIO_CLI} == true ]]; then
    install_istio_linux
elif [[ ${ISTIO_CLI} == true ]]; then
    install_istio_mac
fi

# TERRAFORM CLI
if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian*  ]] && [[ ${TERRAFORM_CLI} == true ]]; then
    install_terraform_for_deb
elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *Red*Hat*Enterprise*Linux* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora ]] && [[ ${TERRAFORM_CLI} == true ]]; then
    install_terraform_for_dnf
elif [[ ${TERRAFORM_CLI} == true ]]; then
    install_terraform_for_mac
fi 

echo "this works3" >> ~/.bashrc
