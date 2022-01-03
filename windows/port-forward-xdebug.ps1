$wsl_ip = (wsl hostname -I).trim()
Write-Host "WSL Machine IP: ""$wsl_ip"""
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=9003 connectport=9003 connectaddress=$wsl_ip