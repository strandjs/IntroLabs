#### Sysmon Logs and Elastic Security

---

*This is part three of a three-part series.*
	[Part One](./elk_in_the_cloud.md "Elk in the Cloud")
	[Part Two](./elastic_agent.md "Elastic Agents")

---

By default, Windows logs are not ideal.  To get logs that are more readable and useful, we can use Sysmon. 

**1. Download Sysmon**

Follow this link to download Sysmon.

[Download Sysmon](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon "https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon")

Find the "Download Sysmon" link.


![Download Sysmon](./images/sysmon_download.png)


In [part one](./elk_in_the_cloud.md "Elk in the Cloud"), we reviewed several ways to find our download.  Repeat these steps to find find the Sysmon download in the Downloads folder.


Perform "Extract All" on the Sysmon Folder. Ensure the Sysmon folder is selected -- It will be highlighted blue.

![Sysmon Extract All](./images/sysmon_extract_all.png)

"Extract" to the Downloads folder.  Windows should auto-populate the Downloads path.

In your search bar, type "PowerShell."
The following options will be presented.  Click "Run as Administrator."

<img src="./images/powershell.png" alt="Run as Administrator" style="zoom:67%;" />

In your PowerShell window, enter the following command. You will need to substitute [USER] for the user you are using on your local system.

```powershell
cd C:\Users\[USER]\Downloads\Sysmon\
```


The following command will install and start Sysmon as a service.

```powershell
.\Sysmon.exe -i -n -accepteula
```


Your following output should look similar to this.


![Sysmon is Running](./images/sysmon_running.png)


Now that Sysmon is running on our system, we need to configure our Elastic agent to gather these logs.  Sign into your cloud account.


[Elastic Cloud Login](https://cloud.elastic.co/login "https://cloud.elastic.co/login")


Navigate to "Integrations" through the navigation menu.


![Integrations Tab](./images/integrations.PNG)


At the top of the page enter "windows" into the search bar.  Select the Windows option with the red square pictured below.


![Select Windows](./images/which_windows.PNG)


Add this integration.


![Add Windows](./images/installation.PNG)


By default, the Sysmon logs channel should be active.  This can be checked under the "Collect events from the following Windows event log channels:" section of the "Add integration" page.


![Ensure Sysmon is Selected](./images/sysmon_selected.png)


Save the Integration.


![Save the Integration](./images/saveandnext.PNG)


When prompted click "Add elastic agent to your hosts".


![Save and Deploy Changes](./images/addelastichost.PNG)


In the Integrations menu, find the "Installed integrations" tab.

In [part one](./elk_in_the_cloud.md "Elk in the Cloud"), we selected an Elastic Security configuration. In doing so, "Endpoint Security" and "System" are automatically installed in our Integrations.


![Installed Integrations](./images/integrations_extras.PNG)


At this point, play around on the computer that has Elastic Agent installed.  Move files around, create files, start programs, make a few Google searches.  This will generate some logs to ensure that we have Sysmon logs reaching our cloud.

After you have created some log activity, navigate to "Discover" by accessing the hamburger menu on the top left.


![Navigate to Discover](./images/filter.PNG)


Set a filter on your data to limit your results to sysmon data.  This can be done by searching the "data_stream.dataset" field for "windows.sysmon_operational" data. Then click "add filter". Your filter should now be set.


![Filter Data](./images/applied_filter.PNG)

If you have a result, and not an error, your Sysmon data is being collected and sent to Elastic.


![Sysmon Results](./images/final.PNG)
