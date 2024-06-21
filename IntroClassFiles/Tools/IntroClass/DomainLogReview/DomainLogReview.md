
# Domain Log Review

In this lab we are going to look at some logs that are generated in a domain password spray attack.

We will start by using DeepBlueCLI, then move into looking directly at the event logs themselves.


Now, we are going to use DeepBlueCLI to see if there are any odd logon patterns in the domain logs.

Let's start by opening Windows Powershell:

![](attachments/OpeningPowershell.png)

Then, navigate to the \IntroLabs\DeepBlueCLI-master directory

<pre>cd \IntroLabs\DeepBlueCLI-master\</pre>

![](attachments/dlr_directory.png)

Now, let's start looking at the DC2 Password spray file:

<pre>.\DeepBlue.ps1 .\EntLogs\DC2-secLogs-3-26-DomainPasswordSpray.evtx</pre>

If a warning pops up, press R.  This will start the script by running it:
When this runs, there is an alert that catches our attention right away:

![](attachments/dlr_domainpasswordspray.png)

We have 240 logon failures.  That...  is a lot for this small org.

Lets dig into the actual logs and see if we can see a pattern.

To do this, open File Explorer and navigate to the C:\IntroLabs\DeepBlueCLI-master\EntLogs directory:

![](attachments/OpeningFileExplorer.png)

![](attachments/Navintolabs.png)

![](attachments/NavtoDBMaster.png)

![](attachments/navtoent.png)

Once in this directory, double click on DC2-secLogs-3-26-DomainPasswordSpray.evtx:

![](attachments/dc2seclogs.png)

This will open Windows Event Viewer.  Note, it will open in Sysmon Operational.  This is not what we want.  Please scroll down to the DC2-secLogs-3-26-DomainPasswordSpray.evtx file under Saved Logs:

![](attachments/dlr_winevent.png)

Then click it.  

It will open the DC logs with the attack.

Now, please click on the header column called Event ID.  This will sort the logs by ID number we are doing this because we want to quickly get to the event IDs of 4776:

![](attachments/Clipboard_2020-12-13-10-12-41.png)

Now, scroll all the way to the bottom:

![](attachments/Clipboard_2020-12-13-10-13-48.png)

Specifically, we are looking for Event ID 4776.  This is the Credential Validation Event log.

Select one, then press the up arrow key a bunch of times.  Watch the Logon Account Name in the General tab:

![](attachments/Clipboard_2020-12-13-10-15-07.png)

Notice the large number of login attempts from a single system:

![](attachments/Clipboard_2020-12-13-10-15-52.png)

![](attachments/Clipboard_2020-12-13-10-16-07.png)


![](attachments/Clipboard_2020-12-13-10-16-31.png)

Also, notice at the bottom of the General tab, these are predominantly Audit Failures:

![](attachments/Clipboard_2020-12-13-10-17-02.png)

We now know that the workstation WINLABV2WKSRL-9 was attempting to authenticate to a large number of Logon Accounts in a very short period of time.

