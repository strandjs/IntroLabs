![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# DeepBlueCLI

DeepBlueCLI is a free tool by **Eric Conrad** that demonstrates some amazing detection capabilities.  It also has some checks that are effective for showing how **UEBA** style techniques can be in your environment. 

Let's get started by opening **Windows Powershell**.

![](attachments/OpeningPowershell.png)

Next, we need to navigate to the **IntroLabs** directory:

<pre>cd \IntroLabs</pre>

Then, continue into the **DeepBlueCLI-master** directory:

<pre>cd .\DeepBlueCLI-master</pre>

Run the following command:

<pre>Set-ExecutionPolicy Unrestricted</pre>

Most likely, you will be prompted to confirm the change.

Please enter **"Y"** for Yes.

![](attachments/deepblue_setexecutionpolicy.png)

It is very common for attackers to add additional users on to a system they have compromised.  This gives them a level of persistence that they otherwise would not gain with malware.  Why?  There are lots and lots of tools to detect malware.  By creating an extra user account it allows them to blend in.  

Now, let’s run a check in the **.evtx** files for adding a new user:

<pre>.\DeepBlue.ps1 .\evtx\new-user-security.evtx</pre>

You should see the following:

![](attachments/deepblue_newusersecurity.png)

Another attack that very few **SIEMs** detect is password spraying.  This is where an attacker takes a user list from a domain, and sprays it with the same password, think **"Summer2020"**.  This is effective because it keeps the lockout threshold below the lockout policy and many times flies under the radar simply because accounts are not getting locked out. 

This is the exact behavior that **UEBA** should be able to detect.

Let's look at an event log with a password spray attack.  This is very much part of what a full **UEBA** solution does:

<pre>.\DeepBlue.ps1 .\evtx\smb-password-guessing-security.evtx</pre>

![](attachments/deepblue_passwordguessing.png)

Same thing with detecting a password spraying attack:

<pre>.\DeepBlue.ps1 .\evtx\password-spray.evtx</pre>

![](attachments/deepblue_passwordspray.png)

For fun, let’s look at how **DeepBlueCLI** detects various encoding tactics that attackers use to obfuscate their attacks.  It is very common for attackers to use a number of encoding techniques to bypass signature detection.  However, it is not something that normally happens with standard scripts.

<pre>.\DeepBlue.ps1 .\evtx\Powershell-Invoke-Obfuscation-encoding-menu.evtx</pre>

![](attachments/deepblue_powershell-invokeobfuscation.png)

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/nessusIntroClass/Nessus.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/bluespawnIntroClass/Bluespawn.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---




