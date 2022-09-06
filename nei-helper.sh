mkdir -p ~/bin
curl -sSL https://raw.github.ibm.com/National-Northeast-1/Northeast-Cli-Installer/main/nei?token=AACTOHK3KFJMNZMBVCYBMGLDD76MC > /bin/nei
chmod +x /bin/nei
echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc


