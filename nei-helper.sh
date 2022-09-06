mkdir -p ~/bin
cd /bin
curl -sSL https://raw.github.ibm.com/National-Northeast-1/Northeast-Cli-Installer/main/nei?token=AACTOHK3KFJMNZMBVCYBMGLDD76MC > nei || sudo curl -sSL https://raw.github.ibm.com/National-Northeast-1/Northeast-Cli-Installer/main/nei?token=AACTOHK3KFJMNZMBVCYBMGLDD76MC > nei
chmod +x /bin/nei || sudo chmod +x /bin/nei
echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc || sudo echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc


