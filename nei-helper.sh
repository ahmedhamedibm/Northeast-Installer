mkdir -p ~/bin
cd ~/bin
curl -sSL https://raw.github.ibm.com/National-Northeast-1/Northeast-Cli-Installer/main/nei?token=AACTOHM3M6X5JNP3LF3YVSTDFHWSW > nei
chmod +x nei || sudo chmod +x nei
cd ~
echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc || sudo echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc
source ~/.bashrc

