
# DeepBlueCLI

DeepBlueCLI is a free tool by Eric Conrad that demonstrates some amazing detection capabilities.  It also has some checks that are effective for showing how UEBA style techniques can be in your environment. 

Let's get started by opening Windows Powershell.

![](attachments/OpeningPowershell.png)


==####NOTE#####== 

If you are havin trouble launching any of Windows many terminals.  All you have to do is click on the Windows Start button and type.  

`Powershell`, `Ubuntu`, or `Command Prompt` 

If you use **PowerShell** or **Command Prompt**, you will have to right click on them and select Run As Administrator 

==###END NOTE###==

Next, we need to navigate to the IntroLabs directory:

`cd .\IntroLabs`

Then, continue into the DeepBlueCLI-master directory:

`cd .\DeepBlueCLI-master`

Next, run the following command:

`Set-ExecutionPolicy unrestricted`

Most likely, you will be prompted to confirm the change.

Please enter **"Y"** for Yes.

![](attachments/deepblue_setexecutionpolicy.png)

It is very common for attackers to add additional users on to a system they have compromised.  This gives them a level of persistence that they otherwise would not gain with malware.  Why?  There are lots and lots of tools to detect malware.  By creating an extra user account it allows them to blend in.  

Now, let’s run a check in the **.evtx** files for adding a new user:

`.\DeepBlue.ps1 .\evtx\new-user-security.evtx`

You should see the following:

![](attachments/deepblue_newusersecurity.png)

Another attack that very few SIEMs detect is password spraying.  This is where an attacker takes a user list from a domain, and sprays it with the same password, think "Summer2020".  This is effective because it keeps the lockout threshold below the lockout policy and many times flies under the radar simply because accounts are not getting locked out. 

But, this is the exact behavior that UEBA should be able to detect.

Now, let's look at an event log with a password spray attack.  This is very much part of what a full UEBA solution does:

`.\DeepBlue.ps1 .\evtx\smb-password-guessing-security.evtx`

![](attachments/deepblue_passwordguessing.png)

Same thing with detecting a password spraying attack:

`.\DeepBlue.ps1 .\evtx\password-spray.evtx`

![](attachments/deepblue_passwordspray.png)

For fun, let’s look at how DeepBlueCLI detects various encoding tactics that attackers use to obfuscate their attacks.  It is very common for attackers to use a number of encoding techniques to bypass signature detection.  However, it is not something that normally happens with standard scripts.

`.\DeepBlue.ps1 .\evtx\Powershell-Invoke-Obfuscation-encoding-menu.evtx`

![](attachments/deepblue_powershell-invokeobfuscation.png)