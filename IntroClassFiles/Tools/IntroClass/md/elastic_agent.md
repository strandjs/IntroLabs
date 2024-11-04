#### Elastic Agents
---

!!! - This is part two of a three-part series.
	[Part One](./elk_in_the_cloud.md "Elk in the Cloud")
	[Part Three](./sysmon_logs.md "Configuring Sysmon")

---

In part one, we started an ELK instance in the Elastic Cloud.

The Elastic Agent software enables users to easily send logs to our ELK instance, a process typically called **"ingesting."**

**1. Download the Elastic Agent.**

Press the **Powershell** icon in the taskbar to launch **Windows Powershell**.

![Powershell](./images/OpeningPowershell.png)

Copy the command you saved in the file.  In my case, it was **"agent.txt"** and paste it into the **powershell**. 

No need to hit enter, as it will run each line of code separately when you paste it in!

![Powershell](./images/powershell.png)

Make sure you type **y** and hit enter when prompted by powershell.

Switch back over to your browser and you should see **"1 Agent has been enrolled".**

![Enrolled Machine](./images/finish_button.PNG)

Then Click **"Add to Integration"**.

On the next page leave everything default and click **"Confirm Incoming Data".**

![Confirm Data](./images/confirm_data.PNG)

The browser will take a few seconds to confirm the machine is connected, once thats finished click **"View Assets".**

![Enrolled](./images/successful_enroll.PNG)

**2. Check The Fleet.**

We should be connected and ready for **part 3**.  Lets make sure the device has successfully connected.

Click the hamburger at the top left of the window and scroll down almost all the way to the bottom. Click the option **"Fleet"**.

![Fleet](./images/fleet_loc.PNG)

This allows us to view our **agent policies**.

![Powershell](./images/pic_of_box.PNG)

Our Elastic Agent is installed and configured to be connected to our ELK instance in the cloud.  **Part three** will cover how to configure Sysmon to submit logs to this Elastic Agent.  This will ingest the logs to appear in **Kibana**.

[Part Three](./sysmon_logs.md "Configuring Sysmon")

***
***Continuing on to the next Lab?***

[Click here to get back to the Navigation Menu](/IntroClassFiles/navigation.md)

***Finished with the Labs?***


Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
