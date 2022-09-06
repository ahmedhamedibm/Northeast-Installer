mkdir -p ~/bin
cd ~/bin
curl -sSL https://raw.github.ibm.com/National-Northeast-1/Northeast-Cli-Installer/main/nei?token=AACTOHLZ4XMSWR3JWPAXBHTDD72YM > nei
chmod +x nei
echo 'export PATH=$PATH":$HOME/bin"' >> ~/.bashrc


