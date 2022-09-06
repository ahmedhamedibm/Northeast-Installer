mkdir -p ~/bin
cd ~/bin
curl -sSL https://raw.github.ibm.com/National-Northeast-1/Northeast-Cli-Installer/main/nei?token=AACTOHMBVWCNWGKSNEQ7CW3DD75PA > nei
chmod +x nei
echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc


