mkdir -p ~/bin
cd ~/bin
curl -sSL https://raw.github.ibm.com/National-Northeast-1/CLI_Installer/main/nei?token=AACTOHPOY6LSCPYZHRT73HTDD7MNM >> nei
chmod +x nei
echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc


