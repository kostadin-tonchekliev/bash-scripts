Stores all past and current SSH connections and allows you to check if you are still connected to the specifc connections and disconnects you.

---
### Setup
-Inside **ssh_login.sh** update *~/Desktop/scripts/.ssh_log* with the correct place you want to store the connections<br>
-Inside **key_removal.sh** update *~/Desktop/scripts/.ssh_log* with the path defined in **ssh_login.sh** . Also on line 34 update *user* with the standard user you use for the SSH connection. Make sure to use the correct user as otherwise it won't work.

### Usage
1. Firstly call **ssh_login.sh** and provide its username and hostname for the connection, the port will be automatically filled in.
2. When you want to check the connections call **key_removal.sh** which will try to connect to each stored conection inside .ssh_log and report how many succesfull ones it has. At the end select if you want to disconect from them or not.

### Example
```
Koce@07:03 PM in ~:rem_keys 
SSH Key checker and remover
Current stored connections: 7
Starting key checking...
[-]Failed to connect to hostname: pala****.com
[-]Failed to connect to hostname: fes****.at
[+]Succesfully connected to hostname: alwayspo****.co.uk with username: u2-vtigjkf36***
[-]Failed to connect to hostname: radica****.com
[-]Failed to connect to hostname: br***.io
[-]Failed to connect to hostname: pmc****.com
[-]Failed to connect to hostname: gnldm****.siteground.biz
Managed to connect to 1 SSH connection/ns
Do you want to discconnect from the connections (y/n):
y
[+]Connection to hostname alwayspo*****.co.uk succesfully removed
Removal done, exiting script
```