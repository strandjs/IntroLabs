# LimaCharlie Lab

---

Part 1 of 2

---

In this lab we will be using **LimaCharlie** to investigate endpoint monitoring and threat detection.

What is Lima Charlie? Lima Charlie is a lightweight browser based tool, it helps keep an eye on systems, detect threats, and responds quickly to any suspicious activity.  This walktrhough will be using the chrome browser, however any browser can be used.

Lets open a browser window. 

Once the window is up, navigate to the following URL:


https://app.limacharlie.io/login


When the webpage loads, Click **"Create an account"**

![](attachments/register_an_account.PNG)

The screen will change slightly as it asks you which method you would like to use to sign-up with. 

![](attachments/LimaCharlie_signupmethod.png)

We selected "Sign up with email"

![](attachments/SIGN_UP_BUTTON.PNG)

Fill out the fields click the "Sign Up" button to continue

Go to your email and you should receive a link to verify your account. Click the link and then go back to your browser and refresh the page.

Once you return to your page you should see Lima Charlie asking you some questions about your company, you can create any fake company you wish.

Enter the following answers into there respective fields ->

* <span style="color:green">What best describes your team/company?</span> -> Security Operations Center
* <span style="color:red">What best describes your role?</span> -> Security Engineer
* <span style="color:blue">What use cases are you exploring?</span> -> Endpoint detection & Response
* <span style="color:purple">How did you hear about us?</span> -> Black Hills Info Sec

![](attachments/company_setup_menu.PNG)

Check the box that says **"By checking this box, I hereby agree and consent to the Terms of Service and Privacy Policy."**

Click **"Get Started"**

Then click **"Create Organization"** 

![](attachments/create_an_organization.PNG)

Enter the following information into the fields, you create your fictional organization.

![](attachments/ficticious_company_selection.PNG)

Click Create Organization.

There may be be a small delay while Lima Charlie creates the new company.

It is possible to use this tool to manage more than one company or organization at a time.

Once the page finishes loading you will see a menu like the one below. 

![](attachments/selectorganization.png)

Please select your company. 

Once you have selected your ficticious company, you can look around and see all the options that this tool has too offer.

For this demonstration we will be creating a sensor for our windows machine and then setting off **"atomic red"** to test if our filter catches it.

On the left side under sensors, please select **"Installation Keys"**

![](attachments/one.PNG)

You should then see an option in the center **"Create Installation key"**, select it. 

![](attachments/two.PNG)

You will see a few empty fields.  You can add any description you like and any relevant tags.

Once you have done that select **"Create"**.

![](attachments/three.PNG)

Once you have created your new installation key, you can navigate too **"Sensors List"**.  

![](attachments/four.PNG)

Click **"Add Sensor"**.

![](attachments/addsensor.png)

Scroll down and select the **"Windows"** sensor.

![](attachments/five.PNG)

You will be greeted with an installation key menu. Select from the drop down menu the description you created earlier for your installation key. Click **"Select"**

![](attachments/six.PNG)

You will be prompted with the question of what architecture to download.  Every windows machine may be different but in our case, **"86-64 exe"** should be right.

![](attachments/seven.PNG)

You will be greeted with a few more steps to creating your endpoint. 
Click **"Download the selected installer"**.
Once thats finished downloading **copy the string in step 4**.  

![](attachments/eight.PNG)

Go to your desktop, right click **"Windows Terminal"** and select **"run as administrator"**.

![](attachments/nine.PNG)

Run the following command to get into the downloads directory:


<pre>cd .\Downloads</pre>


We are going to enter the beginning of our next command.

Tab completion is your friend!


<pre>.\hcp_win_x64_release_4.29.2.exe</pre>


**[RIGHT CLICK OR CTL+V TO PASTE]**

After starting the command, we will paste the string we copied.   

Go ahead and hit enter to run it. 

If done correctly, your output should look like this:

![](attachments/correctoutput.png)

Return to the browser window. You should see this message:

![](attachments/success.PNG)

Please note that the name of your computer will be different!

<a href="https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/Tools/IntroClass/LCmeetsAtomicRed/LCAR.md">Part 2</a>

***
[Back to Navigation Menu](/IntroClassFiles/navigation.md)
