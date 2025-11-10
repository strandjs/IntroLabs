![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# Password Spray

First things first, disable **Defender**. Open an instance of **Windows PowerShell** by clicking on the icon in the taskbar. Then run the following:

![](attachments/OpeningPowershell.png)

<pre>Set-MpPreference -DisableRealtimeMonitoring $true</pre>

This will disable **Defender** for this session.

If you get angry red errors, that is Ok, it means **Defender** is not running.

Let's get started by opening a **Command Prompt** terminal by clicking on the icon in the taskbar.

![](attachments/OpeningWindowsCommandPrompt.png)

Once the terminal opens, navigate into the appropriate directory by running the following command:

<pre>cd \IntroLabs</pre>

We need to run the batch file named **200-user-gen** 

Do so by typing the name of the batch file and hitting enter:

<pre>200-user-gen.bat</pre>

It should look like this:

![](attachments/200bat.png)

Let this run all the way through. 

**Even though it looks endless, it's not!**

We will need to start **PowerShell** to run **"LocalPasswordSpray"**

Launch it by typing the following and hitting enter:

<pre>powershell</pre>

Run the following two commands:

<pre>Set-ExecutionPolicy Unrestricted</pre>

<pre>Import-Module .\LocalPasswordSpray.ps1</pre>

It should look like this:

![](attachments/powershellcommands.png)

Let’s try some password spraying against the local system!

<pre>Invoke-LocalPasswordSpray -Password Winter2020</pre>

It should look like this:

![](attachments/localpasswordspray.png)

We need to clean up and make sure the system is ready for the rest of the labs.

Run the following two commands:

<pre>exit</pre>

<pre>user-remove.bat</pre>

![](attachments/exit.png)

Let this run all the way through. 

**Even though it looks endless, it's not!**



***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/Responder/Responder.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/PasswordCracking/PasswordCracking.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---


