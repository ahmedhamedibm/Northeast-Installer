mkdir -p ~/bin
cd ~/bin
curl -sSL https://raw.github.ibm.com/National-Northeast-1/CLI_Installer/main/nei?token=AACTOHIDAVXUQRZQLH6P33DDD6336 >> nei
chmod +x nei
echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc

