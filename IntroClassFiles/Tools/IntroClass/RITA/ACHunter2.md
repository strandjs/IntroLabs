
Now, let's play with AC Hunter!

Please go to 

<pre>https://138.68.61.95/</pre>

You might be prompted by a warning stating that your connection isn't private. This is **Okay**. 

Simply click **Advanced** and then click **Continue**

![](attachments/advanced.png)

The creds are:

demo@acm.re
ThreatHuntAtMileHigh!

<img width="632" height="459" alt="image" src="https://github.com/user-attachments/assets/9579c8cf-3f72-41b4-b548-e4b101e1deb8" />


When logged in, you will be prompted to select a dataset. 

Select **vsagent** and hit confirm.

![](attachments/rita_datasetselection.png)

>[!NOTE]
>
>If this is not what you see, select the house icon in the bottom left of your screen, followed by the gear in the upper right.

![](attachments/rita_wrongplace.png)

This will open the overall scoring screen, as seen below. This screen allows you to see the systems that have the top scores across all areas from beacons to cyber deception.

Please select **10.55.100.111**, then click on Beacon Score on the right.

![](attachments/rita_selectingbeacon.png)

This will open the beacon score for this system.

![](attachments/rita_beaconscore.png)

Notice the **histogram** on the bottom and the scoring criteria in the middle. 

Notice how on the bottom you can see multiple aspects of this systems connections.  For example, you can see if there are any connections that had a threat intel hit, or if there are any connections that have beacons to a fully qualified domain.

Now, using **AC Hunter**, answer the following questions:

1. In the winlab-agent dataset, what is the connection interval for 10.10.98.30?

2. In the gcat dataset, what is the historic fqdn for the beacon on 10.55.100.111?

3. For the dnscat2-ja3-strobe-agent dataset, what domain has the highest lookup count?
4. Who is doing the lookups?

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/nessus/Nessus.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/Wireshark/Wireshark.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
