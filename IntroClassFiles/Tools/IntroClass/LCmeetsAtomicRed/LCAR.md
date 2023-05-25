# Lima Charlie meets Atomic Red

part 2/2

In this lab we will be creating a controlled and fake cyber attack with Atomic Red, we will then use Lima Charlie to see what is logged and to see how a real world attack may set off bells and whistles for us to look at.

We will be picking up where we left off in part 1, in the browser logged into our Lima Charlie web interface.

To start off we will need to install the plugin for Atomic Red that Lima Charlie offers.

Start by navigating to the "Add-ons" tab in the top right of the web page.

<img src="attachments/ADDONS.PNG" alt="register an account" width="300" />

Scroll down until you see the Atomic Red plugin. Click the Atomic Red plugin.

<img src="attachments/AR.PNG" alt="register an account" width="300" />

Take a minute to look at the different plugins and see the full capabillities and features Lima Charlie has to offer.

Then locate the subscribe button on the right side of the page, and click "Subscribe"

<img src="attachments/SUBSCRIBE.PNG" alt="register an account" width="300" />

After Atomic Red finishes installing return back to your organization and click on your machine.

<img src="attachments/HOST.PNG" alt="register an account" width="300" />

Scroll down a bit and you will see a few options, yara and atomic red. Click "Run atomic tests"

<img src="attachments/RUNAR.PNG" alt="register an account" width="300" />

Go to the command and control and click "(1)Select Category" then click "(2)Run Tests"

<img src="attachments/C2ALL.PNG" alt="register an account" width="300" />

Once that begins move over to the "Detections" tab on the left and start going through event logs

<img src="attachments/DETECTED.PNG" alt="register an account" width="300" />

You will notice that you have lots of events, everytime you refresh your page more will appear as the attacks continue.

Go through all of the logs and notice that cmd.exe or powershell invokes are taking place. These are often times indications of some malicious occuring and need to be examined further.

Lima Charlie is an amazing tool because of its versatillity. With an easy to look at interface that if need be, allows a user to dig deeper to see whats happening before, during, and after an attack. Its abillity to be used on small and large scale is a great feature. Many plugins allow for different uses large and small, and automating the difficult tasks.
