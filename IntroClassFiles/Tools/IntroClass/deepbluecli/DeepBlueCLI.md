
# DeepBlueCLI

DeepBlueCLI is a free tool by Eric Conrad that demonstrates some amazing detection capabilities.  It also has some checks that are effective for showing how UEBA style techniques can be in your environment. 

Let's get started by opening a Terminal as Administrator

![](attachments/Clipboard_2020-06-12-10-36-44.png)

Now, let's open a command Prompt:

![](attachments/Clipboard_2020-06-16-09-53-18.png)

Next, we need to navigate to the tools directory on your VM:

C:\tools>`cd \tools\DeepBlueCLI-master`
C:\tools\DeepBlueCLI-master>`powershell`

PS C:\tools\DeepBlueCLI-master> `Set-ExecutionPolicy unrestricted`

It should look like this:

![](attachments/Clipboard_2020-06-15-14-06-33.png)

It is very common for attackers to add additional users on to a system they have compromised.  This gives them a level of persistence that they otherwise would not gain with malware.  Why?  There are lots and lots of tools to detect malware.  By creating an extra user account it allows them to blend in.  

Now, let’s run a check in the .evtx files for adding a new user:

PS C:\tools\DeepBlueCLI-master>`.\DeepBlue.ps1 .\evtx\new-user-security.evtx`

![](attachments/Clipboard_2020-06-15-14-07-43.png)

Choose R

![](attachments/Clipboard_2020-06-15-14-08-14.png)

Another attack that very few SIEMs detect is password spraying.  This is where an attacker takes a user list from a domain, and sprays it with the same password, think Summer2020.  This is effective because it keeps the lockout threshold below the lockout policy and many times flies under the radar simply because accounts are not getting locked out. 

But, this is the exact behavior that UEBA should be able to detect.

Now, let's look at an event log with a password spray attack.  This is very much part of what a full UEBA solution does:

PS C:\tools\DeepBlueCLI-master>`.\DeepBlue.ps1 .\evtx\smb-password-guessing-security.evtx`

![](attachments/Clipboard_2020-06-15-14-10-30.png)

Same thing with detecting a password spraying attack:

PS C:\tools\DeepBlueCLI-master>`.\DeepBlue.ps1 .\evtx\password-spray.evtx`

![](attachments/Clipboard_2020-06-15-14-11-14.png)


Finally, for fun, let’s look at how DeepBlueCLI detects various encoding tactics that attackers use to obfuscate their attacks.  It is very common for attackers to use a number of encoding techniques to bypass signature detection.  However, it is not something that normally happens with standard scripts.

PS C:\tools\DeepBlueCLI-master>`.\DeepBlue.ps1 .\evtx\Powershell-Invoke-Obfuscation-encoding-menu.evtx`

![](attachments/Clipboard_2020-06-15-14-11-59.png)




