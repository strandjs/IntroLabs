#### Sysmon Logs and Elastic Security

---

!!! - This is part three of a three-part series.
	[Part One](./elk_in_the_cloud.md "Elk in the Cloud")
	[Part Two](./elastic_agent.md "Elastic Agents")

---

By default, **Windows logs** are not ideal.  To get logs that are more readable and useful, we can use **Sysmon**. 

**1. Download Sysmon**

Follow this link to download Sysmon.

[Download Sysmon](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon "https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon")

Find the **"Download Sysmon"** link.

![Download Sysmon](./images/sysmon_download.png)

We need to extract the **.zip** archive that we just downloaded. To do so, start by opening your **file explorer**.

![](./images/OpeningFileExplorer.png)

Then navigate to **Downloads** in the side panel, and click on the Sysmon **".zip"** archive.

![](./images/navigatetodownloads.png)

Now we can perform **"Extract All"** on the Sysmon Folder. 

Ensure the Sysmon **".zip"** archive is selected.  It will be highlighted in **blue**.

![Sysmon Extract All](./images/sysmon_extract_all.png)

**"Extract"** to the Downloads folder.  Windows should auto-populate the Downloads path.

Once you are finished, you should see something like this:

![](./images/sysmonfolder.png)

For the next step, we need to open **Windows PowerShell**. This can be done by clicking on the **PowerShell** icon in the taskbar.

![](./images/OpeningPowershell.png)

Enter the following command. You will need to substitute **[USER]** for the user you are using on your local system.

<pre>cd C:\Users\[USER]\Downloads\Sysmon\</pre>

Run the following command to install and start **Sysmon** as a service.

<pre>.\Sysmon.exe -i -n -accepteula</pre>

The output should look similar to this.

![Sysmon is Running](./images/sysmon_running.png)

Now that Sysmon is running on our system, we need to configure our **Elastic agent** to gather these logs.

Sign into your **Elastic Cloud account** using the following link:

[Elastic Cloud Login](https://cloud.elastic.co/login "https://cloud.elastic.co/login")


Once logged in, navigate to **"Integrations"** through the navigation menu.

Note:
	When you log in to Elastic, you might see the following screen first. If so, go ahead and click on our deployment that we created in [Part One](./elk_in_the_cloud.md "Elk in the Cloud") (ELK in the Cloud)
	![](./images/incaseyourelost.png)
	
	Once you do this, you can access the navigation bar by clicking the three lines in the upper left and then navigate to Integrations. 

	You may have to scroll to the bottom to find the **"Management"** section. 

	![](./images/navigationmenu.png)

	At the top of the page enter **"windows"** into the search bar.  Select the **Windows** option outlined with the red square below.

	![Select Windows](./images/which_windows.PNG)

	Add this integration.

	![Add Windows](./images/installation.PNG)


The next screen you see will have a lot of options on it. Luckily, we only care that one is selected: **Sysmon Operational**

By default, this option should be active, but please double check to be sure. 

Note:
	You will have to scroll down the page for a bit in order to find it. 
	
	![Ensure Sysmon is Selected](./images/sysmon_selected.png)


Now save the Integration by clicking **Save and Continue** in the bottom right.

![Save the Integration](./images/saveandnext.PNG)

You will then see the following pop-up prompt. Please click **"Add elastic agent to your hosts".**

![Add Elastic Host](./images/addelastichost.PNG)

Navigate back to the Integrations menu, find the **"Installed integrations"** tab.

![](./images/backtointegrations.png)

![](./images/clickinstalledintegrations.png)

In [part one](./elk_in_the_cloud.md "Elk in the Cloud"), we selected an Elastic Security configuration. In doing so, **"Endpoint Security"** and **"System"** are automatically installed in our **Integrations**.

![Installed Integrations](./images/integrations_extras.PNG)

At this point, play around on the computer that has **Elastic Agent **installed.  Move files around, create files, start programs, make a few Google searches.  This will generate some logs to ensure that we have Sysmon logs reaching our cloud.

After you have created some log activity, navigate to **"Discover"** by accessing the hamburger menu on the top left.

![Navigate to Discover](./images/navigatetodiscover.png)

We will then create a filter:

![](./images/createfilter.png)

Set a filter on your data to limit your results to sysmon data.  This can be done by searching the **"data_stream.dataset"** field for **"windows.sysmon_operational"** data. We add a custom label of **"All Done!"**. 

![Filter Data](./images/applied_filter.PNG)

Now click **"add filter"**. Your filter should now be set.

![Sysmon Results](./images/final.PNG)

If you have a result, and not an error, your Sysmon data is being collected and sent to **Elastic**.

***

[Back to Navigation Menu](/IntroClassFiles/navigation.md)