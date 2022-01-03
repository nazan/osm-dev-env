# Development Env Setup

## PHP XDebug setup in VS Code (for WSL2 development environment)

Note that the following Powershell scripts must be executed on Windows host in a Powershell terminal elevated to Administrator.

Also make sure to do the following to be able to execute the scripts.

`Set-ExecutionPolicy RemoteSigned`  

### Step 1
Create firewall rule to allow access on port 9003 on Windows host. Note that this must be done only once.

Use script `./windows/firewall-port-open-xdebug.ps1`

### Step 2
Before XDebug can connect to the IDE, Windows host must establish port forwarding to WSL2 VM (Linux Distro).

Use script `./windows/port-forward-xdebug.ps1`

At this point, you may start XDebug client on VS Code and make a request to the web application to trigger a debug session.

Once debugging is finished, make sure to unset the forwarded port with the script `./windows/port-forward-off.ps1`