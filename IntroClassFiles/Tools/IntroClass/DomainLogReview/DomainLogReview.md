
# Domain Log Review

In this lab we are going to look at some logs that are generated in a domain password spray attack.

We will start by using DeepBlueCLI, then move into looking directly at the event logs themselves.

First, we will need to extract the event logs for a domain attack.  To do this, simply navigate to 
the C:\IntroLabs directory:

![](attachments/Clipboard_2020-12-13-09-57-36.png)

Right Click on The EntLogs directory and select 7-Zip > Extract Files

![](attachments/Clipboard_2020-12-13-10-00-35.png)

Then put `C:\tools\DeepBlueCLI-master` in the Extract To: field

It should look like this:

![](attachments/Clipboard_2020-12-13-10-01-58.png)

Now, click OK

![](attachments/Clipboard_2020-12-13-10-02-14.png)

Now, we are going to use DeepBlueCLI to see if there are any odd logon patterns in the domain logs.

Let's start by opening a Terminal as Administrator:

![](attachments/Clipboard_2020-12-13-10-04-28.png)

Then, navigate to the \tools\DeepBlueCLI-master directory

C:\> `cd C:\tools\DeepBlueCLI-master\`

![](attachments/Clipboard_2020-12-13-10-05-30.png)

Now, let's start looking at the DC2 Password spray file:

PS C:\> `.\DeepBlue.ps1 .\EntLogs\DC2-secLogs-3-26-DomainPasswordSpray.evtx`

When the warning pops up, press R.  This will start the script by running it:

![](attachments/Clipboard_2020-12-13-10-06-47.png)

When this runs, there is an alert that catches our attention right away:

![](attachments/Clipboard_2020-12-13-10-07-30.png)

We have 240 logon failures.  That...  is a lot for this small org.

Lets dig into the actual logs and see if we can see a pattern.

To do this, open File Explorer and navigate to the C:\tools\DeepBlueCLI-master\EntLogs directory:

![](attachments/Clipboard_2020-12-13-10-08-59.png)

Once in this directory, double click on DC2-secLogs-3-26-DomainPasswordSpray.evtx:

![](attachments/Clipboard_2020-12-13-10-09-43.png)

This will open Windows Event Viewer.  Note, it will open in Sysmon Operational.  This is not what we want.  Please scroll down to the DC2-secLogs-3-26-DomainPasswordSpray.evtx file under Saved Logs:

![](attachments/Clipboard_2020-12-13-10-11-42.png)

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

