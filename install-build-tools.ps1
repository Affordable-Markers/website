iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
choco install nodejs.install -y

Read-Host -Prompt "Installation complete. Hit any key to continue..."