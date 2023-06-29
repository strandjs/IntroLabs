# Suspicious Executables and Workstations

[*Download the log file to follow along*](./logs/ws-3-security.csv)

After the discovery of the compromised used Paul Bowman we decided to go through the security logs of each workstation to look for any suspicious files being run or used by other users.
The compromised user may try to pivot to other computers and try to gain access to as much as possible. [Pivoting](https://www.geeksforgeeks.org/pivoting-moving-inside-a-network/) as a technique used by an attacker to try to compromise as many computers as possible and try to escalate there privelleges from a regular user to an administrator. So, where do we start? workstation 3 has suspicious activity in its security log files we should take a look at.
 
Open the log file in notepad and press `ctrl + f` and type "Process Name:" and hit enter to tab to every executable that has run on the workstation, we are looking for anything out of the ordinary. We are starting on Process names because it is the most likely attack vendor, if any malicious files were ran it has to be in the audit logs. As a way to confirm strange behavior we should also look to see if the user running the file is anyone other than Paul Bowman. This can build a picture for us, that the attacker is trying to spread through our network.

![Sysmon Extract All](./images/search.PNG)

After tabbing through the file and carefully looking over executables we should take note of this...

![Sysmon Extract All](./images/find_next.PNG)

At first it may not be totally obvious, but the name seems ***slightly*** suspicious and is not a normal system file like mmc or event viewer. It looks like the file was served through a file share on workstation 1, the machine that Paul Bowman was compromised on. It is also important to take notice of the username, the attacker has moved from Paul into a new user meaning, the attacker intends to gain as much access as possible to our domain.
