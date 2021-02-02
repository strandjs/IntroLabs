
# Password Spray

MITRE Shield
------------

You can deploy defensive and deceptive capabilities to impact the results of a password spray and let it succeed against your planted assets.

Applicable MITRE Shield techniques:
* [DTE0010](https://shield.mitre.org/techniques/DTE0010) - Decoy Account
* [DTE0012](https://shield.mitre.org/techniques/DTE0012) - Decoy Credentials
* [DTE0015](https://shield.mitre.org/techniques/DTE0015) - Decoy Persona

You can also identify this activity:
* [DTE0034](https://shield.mitre.org/techniques/DTE0034) - System Activity Monitoring
* [DTE0007](https://shield.mitre.org/techniques/DTE0007) - Behavioral Analytics
* [DTE0021](https://shield.mitre.org/techniques/DTE0021) - Hunting

Instructions
------------

Let's get started by opening a Terminal as Administrator

![](attachments\Clipboard_2020-06-12-10-36-44.png)

Now, let's open a command Prompt:

![](attachments\Clipboard_2020-06-16-09-53-18.png)

C:\Windows\system32> `cd \tools`

C:\Tools> `200-user-gen.bat`

It should look like this:

![](attachments\Clipboard_2020-06-16-10-26-22.png)

Now, we will need to start PowerShell to run LocalPasswordSpray


C:\Tools> `powershell`

PS C:\Tools> `Set-ExecutionPolicy Unrestricted`

PS C:\Tools> `Import-Module .\LocalPasswordSpray.ps1`

It should look like this:

![](attachments\Clipboard_2020-06-16-10-37-09.png)

Now, let’s try some password spraying against the local system!


PS C:\Tools> `Invoke-LocalPasswordSpray -Password Winter2020`

It should look like this:

![](attachments\Clipboard_2020-07-09-15-06-52.png)

Now we need to clean up and make sure the system is ready for the rest of the labs:

PS C:\Tools> `exit`

C:\Tools> `user-remove.bat`

![](attachments\Clipboard_2020-06-16-10-39-16.png)




