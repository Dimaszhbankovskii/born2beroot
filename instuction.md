# born2beroot
## Table of Contents
> 1. [Installation](#installation)
> 2. [Configuration](#configuration)
> - [Installing sudo](#installing_sudo)
> - [Installing tools](#installing_tools)
> - [Installing SSH and configuring SSH service](#install_ssh)
> - [Installing and configuring UFW (Uncomplicated Firewall)](#ufw)
> - [Connecting SSH-server](#connect_ssh)
> - [Set password policy (source)](#password_policy)
> - [Greating a New Group](#new_group)
> - [Creating a New User and assign into group](#new_user)
> - [Configuring sudoers group](#sudoers)
> - [Deletion users and groups](#del)
> - [Crontab configuration](#crontab)
> - [Change hostname (!!!This is for when you defend!!!)](#host)
> 3. [Defense of Mandatory part](#defense_mandatory)
## 1. <a name="installation"></a>Installation
## 2. <a name="configuration"></a>Configuration
### <a name="installing_sudo"></a>2.1. Installing sudo
Logit as root
```
$ su -
```
Install sudo
```
$ apt update -y
$ apt upgarde -y
$ apt install sudo
```
Add user in sudo group
```
$ usermod -aG sudo your_username
```
Check if user in sudo group
```
getent group sudo
```
Give privilege as a su.
Open sudoers file:
```
$ sudo visudo
```
Add this line in file:
```
your_username ALL=(ALL:ALL) ALL
```
### <a name="installing_tools"></a>2.2. Installing tools
Installing git
```
$ apt update -y
$ apt upgrade -y
$ apt install git -y
```
Check git version
```
git --version
```
Installing wget (wget is a free and open source tool for downloading files from web repositories.)
```
$ sudo apt install wget
```
Installing Vim
```
$ sudo apt install vim
```
### <a name="install_ssh"></a>2.3. Installing SSH and configuring SSH service
Installing
```
$ sudo apt update
$ sudo apt install openssh-server
```
Check the SSH server status
```
$ sudo systemctl status ssh
```
Restart the SSH service
```
$ sudo service ssh restart
```
Changing default port (22) to 4242
```
$ sudo nano /etc/ssh/sshd_config
```
Edit the file change the line #Port22 to Port 4242. Find thid line:
```
#Port 22
```
*Change it like this:*
```
Port 4242
```
Check if port settings got right
```
$ sudo grep Port /etc/ssh/sshd_config
```
To disable SSH login as root irregardless of authentication mechanism, replace below line
```
32 #PermitRootLogin prohibit-password
```
with:
```
32 PermitRootLogin no
```
Restart the SSH service
```
$ sudo service ssh restart
```
### <a name="ufw"></a>2.4. Installing and configuring UFW (Uncomplicated Firewall)
Install UFW
```
$ sudo apt install ufw
```
Enable
```
$ sudo ufw enable
```
Check the status
```
$ sudo ufw status numbered
```
Configure the rules
```
$ sudo ufw allow ssh
```
Configure the port rules
```
$ sudo ufw allow 4242
```
Delete the new rule: (This is for when you defend your Born2beroot)
```
$ sudo ufw status numbered
$ sudo ufw delete (that number, for example 5 or 6)
```

### <a name="connect_ssh"></a>2.5. Connecting SSH-server
Add forward rule for VirtualBox.
Restart SSH server (go to the your VM machine)
```
$ sudo systemctl restart ssh
```
Check ssh status:
```
$ sudo service sshd status
```
From host side from iTerm2 or Terminal enter as shown below:
```
$ ssh your_username@127.0.0.1 -p 4242
```
Quit the connection:
```
$ exit
```
### <a name="password_policy"></a>2.6. Set password policy (source)
#### Password Age
Configure password age policy via sudo nano ```/etc/login.defs```.
```
$ sudo nano /etc/login.defs
```
To set password to expire every 30 days, replace below line
```
160 PASS_MAX_DAYS   99999
```
with
```
160 PASS_MAX_DAYS   30
```
To set minimum number of days between password changes to 2 days, replace below line
```
161 PASS_MIN_DAYS   0
```
with
```
161 PASS_MIN_DAYS   2
```
To send user a warning message 7 days (defaults to 7 anyway) before password expiry, keep below line as is.
```
162 PASS_WARN_AGE   7
```
#### Password Strangth
Installing password quality checking library (libpam-pwquality):
```
$ sudo apt install libpam-pwquality
```
Verify whether libpam-pwquality was successfully installed
```
$ dpkg -l | grep libpam-pwquality
```
Configure password strength policy nano ```sudo nano /etc/pam.d/common-password```, specifically the below line:
```
$ sudo nano /etc/pam.d/common-password
<~~~>
25 password        requisite                       pam_pwquality.so retry=3
<~~~>
```
To set password minimum length to 10 characters, add below option to the above line.
```
minlen=10
```
To require password to contain at least an uppercase character and a numeric character:
```
ucredit=-1 dcredit=-1
```
To set a maximum of 3 consecutive identical characters:
```
maxrepeat=3
```
To reject the password if it contains ```<username>``` in some form:
```
reject_username
```
To set the number of changes required in the new password from the old password to 7:
```
difok=7
```
To implement the same policy on root:
```
enforce_for_root
```
Finally, it should look like the below:
```
password    requisite   pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 reject_username difok=7 enforce_for_root
```
### <a name="new_group"></a>2.7. Greating a New Group
Create new *user42* group
```
$ sudo addgroup user42
```
Check if group created:
```
$ getent group
```
### <a name="new_user"></a>2.8. Creating a New User and assign into group
All users are stored in file */etc/passwd*<br>
Check the all local users:
```
$ cut -d: -f1 /etc/passwd
```
Create the user
```
$ sudo adduser new_username
```
Assign an user into “evaluating” group (This is for when you defend)
```
$ sudo usermod -aG user42 your_username
$ sudo usermod -aG evaluating your_new_username
```
Check if the user is in group
```
$ getent group user42
$ getent group evaluating
```
Check which groups user account belongs:
```
$ groups
```
Check if password rules working in users:
```
$ sudo chage -l your_new_username
```
Change max days for "change password" of user:
```
chage -M 30 name_user
```
Change min days for "change password" of user:
```
chage -m 2 name_user
```
### <a name="sudoers"></a>2.9. Configuring sudoers group
Make dir ```/var/lod/sudo```
Go to file:
```
$ sudo visudo /etc/sudoers
```
Add following for authentication using sudo has to be limited to 3 attempts in the event of an incorrect password:
```
Defaults     secure_path="..."
Defaults     passwd_tries=3
```
For wrong password warning message, add:
```
Defaults     badpass_message="Password is wrong, please try again!"
```
Each action log file has to be saved in the /var/log/sudo/ file:
```
Defaults    logfile="/var/log/sudo/sudo.log"
```
To archive all sudo inputs & outputs to ```/var/log/sudo/```:
```
Defaults    log_input,log_output
Defaults    iolog_dir="/var/log/sudo"
```
To require TTY:
```
Defaults        requiretty
```
To set sudo paths to
```
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```
![image](https://user-images.githubusercontent.com/84144634/141363542-b1f5ca15-e981-4379-9ffb-ea062eb8856f.png)

### <a name="del"></a>2.10. Deletion users and groups
Delete user (-r - delete home directory and user's files):
```
$ sudo userdel -r user_name
```
Delete group:
```
$ sudo groupdel group_name
```
### <a name="crontab"></a>2.11. Crontab configuration
Install the netstat tools (need for script monitoring.sh)
```
$ sudo apt update -y
$ sudo apt install -y net-tools
```
Open crontab and add the rule (- u user (specific user) ; - e (editing or creating the current schedule)):
```
sudo crontab -u root -e
```
To schedule a shell script to run every 10 minutes, replace below line
```
23 */10 * * * * sh /path/to/script
```
Check crontab
```
sudo crontab -u root -l
```
### <a name="host"></a>2.12. Change hostname (!!!This is for when you defend!!!)
Check current hostname
```
$ hostnamectl
```
Change the hostname
```
$ hostnamectl set-hostname new_hostname
```
Change /etc/hosts file
```
$ sudo nano /etc/hosts
```
Change old_hostname with new_hostname:
```
127.0.0.1       localhost
127.0.0.1       new_hostname
```
Reboot and check the change
```
$ sudo reboot
```
## 3. <a name="defense_mandatory"></a>Defense of Mandatory part
### Simple setup<br>
1. Check that the UFW service is started
```
$ sudo ufw status numbered
```
2. Check that the SSH service is started
```
$ sudo service sshd status
```
Check that the chosen operating system is Debian or CentOS
```
$ uname -a
```
### User
1. Check that a user with the login of the student being evaluated is present on the virtual machine.<br>
Check that it has been added and that it belongs to the "sudo" and "user42" groups
```
$ cat /etc/passwd
$ groups user_name
```
2. Check the password policy<br>
2.1. Create a new user "user_eval"
```
$ sudo adduser user_eval
```
2.2. Check files of the password policy
```
$ sudo nano /etc/login.defs
$ sudo nano /etc/pam.d/common-password
```
2.3. Create a new group named "evaluating"
```
$ sudo addgroup evaluating
```
2.4. Assign group "evaluating" to "user_eval"
```
$ sudo usermod -aG evaluating name_eval
```
2.5. Check that "user_eval" belongs to the "evaluating" group
```
$ getent group evaluating
```
### Hostname and partitions
1. Check that the hostname of the machine is correctly formatted as follows: login42
```
$ hostnamectl
```
2. Modify hostname
2.1. Change the hostname
```
$ hostnamectl set-hostname evalhost
```
2.2. Change "/etc/hosts" file
```
$ sudo nano /ets/hosts
```
2.3. Change old_hostname with new_hostname:
```
127.0.0.1       localhost
127.0.0.1       new_hostname
```
2.4. Reboot and check the change
```
$ sudo reboot
```
2.5. Check changes
```
$ hostnamectl
```
3. Check the partitions for this virtual machine
```
$ lsblk
```
### SUDO
1. Chech "sudo" is installed
```
$ dpkg -l | grep sudo
```
2. Show assign new user to the "sudo" group
```
$ sudo usermod -aG sudo user_name
```
3. Show exaples of using "sudo"
```
$ sudo addgroup test1
$ sudo groupdel test1
```
4. Check folder `"/var/log/sudo"` exist and has at least one file
```
$ sudo ls -l /var/log/sudo/
```
5. Check contents of the files in this folder, history of the commands used with sudo
```
$ sudo cat /var/log/sudo/sudo.log
```
### UFW
1. Check that the "UFW" program is properly installed on the virtual machine
```
$ dpkg -l | grep ufw
```
2. Check that UFW is working properly
```
$ sudo ufw status numbered
```
3. List the active rules in UFW. A rule must exist for port 4242
```
$ sudo ufw status numbered
```
4. Add a new rule to open port 8080. Check that this one has been added by listing the active rules
```
$ sudo ufw allow 8080
$ sudo ufw status numbered
```
5. Delete this new rule
```
$ sudo ufw delete (number of rule)
$ sudo ufw status numbered
```
### SSH
1. Check that the SSH service is properly installed on the virtual machine
```
$ dpkg -l | grep ssh
```
2. Check that SSH is working properly
```
$ sudo service ssh status
```
3. Verify that the SSH service only uses port 4242
```
$ sudo grep Port /etc/ssh/sshd_config
```
4. Connect with SSH in new user
```
$ ssh user_name@127.0.0.1 -p 4242
```
