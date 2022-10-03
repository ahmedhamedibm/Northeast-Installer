mkdir -p ~/bin
cd ~/bin
curl -sSL https://raw.githubusercontent.com/ahmedhamedibm/Northeast-Installer/main/nei > nei
chmod +x nei || sudo chmod +x nei
cd ~
echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc || sudo echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc
source ~/.bashrc

