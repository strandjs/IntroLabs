# Lima Charlie meets Atomic Red

This is part 2 of a 2 part series. Please complete <a href="https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/Tools/IntroClass/limacharlie/limacharlie.md">Part 1</a> of this lab first

---

Part 2 of 2

---

In this lab we will be creating a controlled and fake cyber attack with Atomic Red.  We will then use Lima Charlie to see what is logged and to see how a real world attack may set off bells and whistles for us to look at.

Let's pick up where we left off in part 1, in the browser logged into our Lima Charlie web interface.

We need to install the plugin for Atomic Red that Lima Charlie offers.

Start by navigating to the **"Add-ons"** tab in the top right of the web page.

![](attachments/ADDONS.PNG)

Scroll down until you see the Atomic Red plugin. Click the **"ext-atomic-red-team"** plugin.

![](attachments/AR.PNG)

Take a minute to look at the different plugins and see the full capabillities and features Lima Charlie has to offer.

Locate the subscribe button on the right side of the page, and click **"Subscribe"**.

![](attachments/SUBSCRIBE.PNG)

After Atomic Red finishes installing return back to your organization and click on your machine.

![](attachments/navtoorganizations.png)

![](attachments/selectorganization.png)

On the left side of your screen, click on **"Extensions"** to expand the dropdown menu. Select **"Atomic Red Team"**.

![](attachments/extensions.png)

On the next screen, we need to first click on the dropdown next to the side bar at the top. Then, select your device.

![](attachments/selectdevice.png)

Scroll down until you find the **command-and-control** category. Select the box next to the category header and make sure that it selects all of the boxes below.

Now, hit **Run Tests**.

![](attachments/C2ALL.PNG)

Then move over to the **"Detections"** tab on the left and start going through event logs

![](attachments/detections.png)

![](attachments/logsscreen.png)

There will be a lot of events, everytime the page is refreshed more attacks will appear.

Looking through all of the logs and note the **cmd.exe** or **powershell** invokes are taking place. These are **(usually)** indications of something malicious occuring and needs to be examined further.

![](attachments/DETECTED.PNG)

Lima Charlie is an amazing tool because of its versatillity. It has an easy to use interface. It allows a user to dig deeper to see whats happening before, during, and after an attack. Its abillity to be used on small and large scale is a great feature. 

Many plugins allow for different uses large and small, and automating the difficult tasks.

***
[Back to Navigation Menu](/IntroClassFiles/navigation.md)