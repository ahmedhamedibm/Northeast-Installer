#! /bin/bash

#SERVER FUNCTION
server_info(){

    export DISTRO=$(lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om || echo "")
    export ARCHITECTURE=$(uname -m)
    export BITS=$(getconf LONG_BIT)
    
    }

server_info

# DEPENDENCIES 
install_deps(){
    
    if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* ]]; then
        apt-get update -y 
        apt-get install -y apt-utils
        apt-get -y upgrade 
        apt-get install -y software-properties-common apt-transport-https wget curl unzip
    elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]]; then
        yum update -y
        yum install -y wget epel-release -y curl unzip
    else 
        if [[ -z "$(which brew)" && -n "$(which ruby)" ]]; then   
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        else
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi
}

# IBM CLOUD CLI FUNCTION
install_ibmc() {

    curl -sL https://raw.githubusercontent.com/IBM-Cloud/ibm-cloud-developer-tools/master/linux-installer/idt-installer | bash 

}

# GOOGLE CLOUD CLI
install_gcloud(){
    if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${ARCHITECTURE} == x86_64 ]]; then
        curl "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-388.0.0-linux-x86_64.tar.gz" -o /usr/local/bin/google-cloud-cli-388.0.0-linux-x86_64.tar.gz
        tar -xvf /usr/local/bin/google-cloud-cli-388.0.0-linux-x86_64.tar.gz -C /usr/local/bin
        /usr/local/bin/google-cloud-sdk/install.sh -q 
        
        if [[ -a /usr/local/bin/google-cloud-sdk/bin/gcloud ]]; then
            chmod +x /usr/local/bin/google-cloud-sdk/bin/gcloud
            echo "alias gcloud='/usr/local/bin/google-cloud-sdk/bin/gcloud'" >> ~/.bashrc 
        else
            echo "/usr/local/bin/google-cloud-sdk/bin/gcloud not found"
        fi
    elif [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${ARCHITECTURE} == arm64 || ${ARCHITECTURE} == Arm64  ]]; then
        curl "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-388.0.0-linux-arm.tar.gz" -o /usr/local/bin/google-cloud-cli-388.0.0-linux-arm.tar.gz
        tar -xvf /usr/local/bin/google-cloud-cli-388.0.0-linux-arm.tar.gz -C /usr/local/bin 
        /usr/local/bin/google-cloud-sdk/install.sh -q
        
        if [[ -a /usr/local/bin/google-cloud-sdk/bin/gcloud ]]; then
            chmod +x /usr/local/bin/google-cloud-sdk/bin/gcloud
            echo "alias gcloud='/usr/local/bin/google-cloud-sdk/bin/gcloud'" >> ~/.bashrc 
        else
            echo "/usr/local/bin/google-cloud-sdk/bin/gcloud not found"
        fi
    elif [[ ${ARCHITECTURE} == x86_64 ]]; then
        curl "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-388.0.0-darwin-x86_64.tar.gz" -o /usr/local/bin/google-cloud-cli-388.0.0-darwin-x86_64.tar.gz
        tar -xvf /usr/local/bin/google-cloud-cli-388.0.0-darwin-x86_64.tar.gz -C /usr/local/bin
        /usr/local/bin/google-cloud-sdk/install.sh -q
        
        if [[ -a /usr/local/bin/google-cloud-sdk/bin/gcloud ]]; then
            chmod +x /usr/local/bin/google-cloud-sdk/bin/gcloud
            echo "alias gcloud='/usr/local/bin/google-cloud-sdk/bin/gcloud'" >> ~/.zshrc 
        else
            echo "/usr/local/bin/google-cloud-sdk/bin/gcloud not found"
        fi
    else
    curl "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-388.0.0-darwin-arm.tar.gz" -o /usr/local/bin/google-cloud-cli-388.0.0-darwin-arm.tar.gz 
    tar -xvf /usr/local/bin/google-cloud-cli-388.0.0-darwin-arm.tar.gz -C /usr/local/bin 
    /usr/local/bin/google-cloud-sdk/install.sh -q 
        
        if [[ -a /usr/local/bin/google-cloud-sdk/bin/gcloud ]]; then
            chmod +x /usr/local/bin/google-cloud-sdk/bin/gcloud
            echo "alias gcloud='/usr/local/bin/google-cloud-sdk/bin/gcloud'" >> ~/.bashrc 
        else
            echo "/usr/local/bin/google-cloud-sdk/bin/gcloud not found"
        fi
    fi
}

# AZURE CLI
install_azure(){
    if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian*  ]]; then
        curl -sL https://aka.ms/InstallAzureCLIDeb | bash
        mv $(which az) /usr/local/bin/az

        if [[ -a /usr/local/bin/az ]]; then
            chmod +x /usr/local/bin/az
            echo "alias az='/usr/local/bin/az'" >> ~/.bashrc
        else
            echo "/usr/local/bin/az not found"
        fi
    elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *Red*Hat*Enterprise*Linux* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora ]]; then
        rpm --import https://packages.microsoft.com/keys/microsoft.asc
        dnf install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm
        echo -e "[azure-cli]
        name=Azure CLI
        baseurl=https://packages.microsoft.com/yumrepos/azure-cli
        enabled=1
        gpgcheck=1
        gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/azure-cli.repo
        dnf install -y azure-cli
        mv $(which az) /usr/local/bin/az
        if [[ -a /usr/local/bin/az ]]; then
            chmod +x /usr/local/bin/az
            echo "alias az='/usr/local/bin/az'" >> ~/.bashrc
        else
            echo "/usr/local/bin/az not found"
        fi
    else
        brew update && brew install azure-cli
    fi 
}

# AMAZON CLOUD CLI
install_aws(){
    if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${ARCHITECTURE} == x86_64 ]]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/usr/local/bin/awscliv2.zip" 
        unzip /usr/local/bin/awscliv2.zip -d /usr/local/bin
        /usr/local/bin/aws/install || /usr/local/bin/aws/install --update
        if [[ -a /usr/local/bin/aws/aws ]]; then
            chmod +x /usr/local/bin/aws/aws
            echo "alias aws='/usr/local/bin/aws/aws'" >> ~/.bashrc
        else
            echo "/usr/local/bin/aws/aws not found"
        fi

    elif [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${ARCHITECTURE} == arm64 || ${ARCHITECTURE} == Arm64  ]]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "/usr/local/bin/awscliv2.zip"
        unzip /usr/local/bin/awscliv2.zip -d /usr/local/bin
        /usr/local/bin/aws/install || /usr/local/bin/aws/install --update
        if [[ -a /usr/local/bin/aws/aws ]]; then
            chmod +x /usr/local/bin/aws/aws
            echo "alias aws='/usr/local/bin/aws/aws'" >> ~/.bashrc
        else
            echo "/usr/local/bin/aws/aws not found"
        fi

    else
        curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "/usr/local/bin/AWSCLIV2.pkg"
        installer -pkg /usr/local/bin/AWSCLIV2.pkg -target / 
        if [[ -a /usr/local/bin/aws/aws ]]; then
            chmod +x /usr/local/bin/aws/aws
            echo "alias aws='/usr/local/bin/aws/aws'" >> ~/.zshrc
        else
            echo "/usr/local/bin/aws/aws not found"
        fi
    fi
}

# GITHUB CLI
install_gh(){
    if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian*  ]]; then
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
    elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *Red*Hat*Enterprise*Linux* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora ]]; then
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
    else
        brew install gh || brew upgrade gh
    fi
} 

# ARGO CD CLI
install_argo(){
    if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]]; then
        curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 
        if [[ -a /usr/local/bin/argocd ]]; then
            chmod +x /usr/local/bin/argocd
            echo "alias argocd='/usr/local/bin/argocd'" >> ~/.bashrc
        else
            echo "/usr/local/bin/argocd not found"
        fi
    else
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
    fi
}

# Tekton CLI
install_tkn(){
    if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* ]] && [[ ${ARCHITECTURE} == x86_64 ]]; then
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
    elif [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* ]] && [[ ${ARCHITECTURE} == Arm64 || ${ARCHITECTURE} == arm64 ]]; then
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
    elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${ARCHITECTURE} == x86_64 ]]; then
        rpm -Uvh -f --reinstall https://github.com/tektoncd/cli/releases/download/v0.24.0/tektoncd-cli-0.24.0_Linux-64bit.rpm
        if [[ -z "$(which tkn)" ]]; then
            dnf copr enable chmouel/tektoncd-cli && dnf install tektoncd-cli
        fi
    elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]] && [[ ${ARCHITECTURE} == Arm64 || ${ARCHITECTURE} == arm64 ]]; then
        rpm -Uvh -f --reinstall https://github.com/tektoncd/cli/releases/download/v0.24.0/tektoncd-cli-0.24.0_Linux-ARM64.rpm
        if [[ -z "$(which tkn)" ]]; then
            dnf copr enable chmouel/tektoncd-cli && dnf install tektoncd-cli
        fi
    else
        wget https://github.com/tektoncd/cli/releases/download/v0.24.0/tkn_0.24.0_Darwin_all.tar.gz -P /usr/local/bin
        tar -xvzf /usr/local/bin/tkn_0.24.0_Darwin_all.tar.gz -C /usr/local/bin/
        if [[ -a /usr/local/bin/tkn ]]; then 
            chmod +x /usr/local/bin/tkn
            echo "alias tkn='/usr/local/bin/tkn" >> ~/.zshrc
        else
            brew install tektoncd-cli
        fi
    fi
}
# OC CLI
install_oc(){
    if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]]; then
        wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz -P /usr/local/bin
        tar xvzf /usr/local/bin/openshift*.tar.gz -C /usr/local/bin
        if [[ -a /usr/local/bin/oc ]]; then
            chmod +x /usr/local/bin/oc
            echo "alias oc='/usr/local/bin/oc'" >> ~/.bashrc
        else
            echo "/usr/local/bin/oc not found"
        fi
    elif [[ ${ARCHITECTURE} == arm64 || ${ARCHITECTURE} == Arm64 ]]; then
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
    else
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
    fi
}
# ISTIO CLI
install_istio(){
    if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian* || "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora  || "$DISTRO" == *Red*Hat*Enterprise*Linux* ]]; then
        curl -sL https://istio.io/downloadIstioctl | sh -
        export PATH=$PATH:$HOME/.istioctl/bin
        mv $(which istioctl) /usr/local/bin/istioctl
        if [[ -a /usr/local/bin/istioctl ]]; then
            chmod +x /usr/local/bin/istioctl
            echo "alias istioctl='/usr/local/bin/istioctl'" >> ~/.bashrc
        else
            echo "/usr/local/bin/istioctl not found"
        fi
    else
        curl -sL https://istio.io/downloadIstioctl | sh -
        export PATH=$PATH:$HOME/.istioctl/bin
        mv $(which istioctl) /usr/local/bin/istioctl
        if [[ -a /usr/local/bin/istioctl ]]; then
            chmod +x /usr/local/bin/istioctl
            echo "alias istioctl='/usr/local/bin/istioctl" >> ~/.zshrc
        else
            echo "/usr/local/bin/istioctl not found"
        fi
    fi
}

# TERRAFORM CLI
install_terraform(){
    if [[ "$DISTRO" == *Ubuntu* || "$DISTRO" == *Debian*  ]]; then
        apt-get update && apt-get install -y gnupg software-properties-common curl
        curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
        apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        apt-get update && apt-get install terraform
        mv $(which terraform) /usr/local/bin/terraform
        if [[ -a /usr/local/bin/terraform ]]; then
            chmod +x /usr/local/bin/terraform
            echo "alias terraform='/usr/local/bin/terraform'" >> ~/.bashrc 
        else
            echo "/usr/local/bin/terraform not found"
        fi
    elif [[ "$DISTRO" == *RED*HAT* || "$DISTRO" == *RHEL* || "$DISTRO" == *Red*Hat*Enterprise*Linux* || "$DISTRO" == *CentOS* || "$DISTRO" == Fedora ]]; then
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
    else
        brew tap hashicorp/tap
        brew install hashicorp/tap/terraform
        brew update
        brew upgrade hashicorp/tap/terraform
    fi 
}

# Daffy
install_daffy(){

   wget http://get.daffy-installer.com/download-scripts/daffy-init.sh; chmod 777 daffy-init.sh;./daffy-init.sh 
   /data/daffy/refresh.sh
    
} 

args=$@

case "${args[@]}" in 
  *"--installDep"*|*"--installdep"*|*"--installDEP"*|*"installDEP"*|*"installdep"*)
    install_deps
  ;;
esac

case "${args[@]}" in 
  *"--installIbmc"*|*"--installibmc"*|*"--installIBMC"*|*"installIbmc"*|*"installibmc"*|*"installIBMC"*)
    install_ibmc
  ;;
esac

case "${args[@]}" in 
  *"--installAws"*|*"--installaws"*|*"--installAWS"*|*"installAws"*|*"installaws"*|*"installAWS"*)
    install_aws
  ;;
esac

case "${args[@]}" in 
  *"--installAz"*|*"--installaz"*|*"--installAWS"*|*"installAz"*|*"installaz"*|*"installAZ"*)
    install_azure
  ;;
esac

case "${args[@]}" in 
  *"--installGcloud"*|*"--installgcloud"*|*"--installGCLOUD"*|*"installGcloud"*|*"installgcloud"*|*"installGCLOUD"*)
    install_gcloud
  ;;
esac

case "${args[@]}" in 
  *"--installGh"*|*"--installgh"*|*"--installGH"*|*"installGh"*|*"installgh"*|*"installGH"*)
    install_gh
  ;;
esac

case "${args[@]}" in 
  *"--installTkn"*|*"--installtkn"*|*"--installTKN"*|*"installTkn"*|*"installtkn"*|*"installTKN"*)
    install_tkn
  ;;
esac

case "${args[@]}" in 
  *"--installOc"*|*"--installoc"*|*"--installOC"*|*"installOc"*|*"installoc"*|*"installOC"*)
    install_oc
  ;;
esac

case "${args[@]}" in 
  *"--installArgocd"*|*"--installargocd"*|*"--installARGOCD"*|*"installArgocd"*|*"installargocd"*|*"installARGOCD"*)
    install_argo
  ;;
esac

case "${args[@]}" in 
  *"--installIstio"*|*"--installistio"*|*"--installISTIO"*|*"installIstio"*|*"installistio"*|*"installISTIO"*)
    install_istio
  ;;
esac

case "${args[@]}" in 
  *"--installTerraform"*|*"--installterraform"*|*"--installTERRAFORM"*|*"installTerraform"*|*"installterraform"*|*"installTERRAFORM"*)
    install_terraform
  ;;
esac

case "${args[@]}" in 
  *"--installDaffy"*|*"--installdaffy"*|*"--installDAFFY"*|*"installDaffy"*|*"installdaffy"*|*"installDAFFY"*)
    install_daffy
  ;;
esac

case "${args[@]}" in 
  *"--all"*|*"-a"*|*"-A"*|*"all"*)
    install_deps
    install_aws
    install_azure
    install_gcloud
    install_gh
    install_tkn
    install_oc
    install_argo
    install_istio
    install_terraform
    install_daffy
    install_ibmc
  ;;
esac