# LimaCharlie Lab

part 1/2

In this lab we will be using LimaCharlie to investigate endpoint monitoring and threat detection.

What is Lima Charlie? Lima Charlie is a lightweight browser based tool, that is great for big and small organizations, It helps keep an eye on systems, detect threats, and responds quickly to any suspicious activity.

To start, we will be working in the chrome browser. This is on your desktop and can be opened by double clicking.

![](attachments/google_chrome_icon.PNG)

Once the browser opens, enter this URL into the search bar and hit enter.

`https://app.limacharlie.io/login`

Once the webpage loads, Click "Create an account"

<img src="attachments/register_an_account.PNG" alt="register an account" width="300" />

You will see a field to setup an account

<img src="attachments/account_registration_page.PNG" alt="register an account" width="300" />

Fill out the fields click the "Sign Up" button to continue

<img src="attachments/SIGN_UP_BUTTON.PNG" alt="register an account" width="300" />

Then go to your email and you should recieve a link to verify the account click the link and then go back to your browser and refresh the page.

Once you return to your page you should see Lima Charlie asking you some questions about your company, you can create any fake company you wish.

Enter the following answers into there respective fields ->

* <span style="color:green">What best describes your team/company?</span> -> Security Operations Center
* <span style="color:red">What best describes your role?</span> -> Security Engineer
* <span style="color:blue">What use cases are you exploring?</span> -> Endpoint detection & Response
* <span style="color:yellow">How did you hear about us?</span> -> Black Hills Info Sec

<img src="attachments/company_setup_menu.PNG" alt="register an account" width="500" />

Once those fields are filled, check the box that says "By checking this box, I hereby agree and consent to the Terms of Service and Privacy Policy."

Click "Get Started"

Then click "Create Organization" 

<img src="attachments/create_an_organization.PNG" alt="register an account" width="500" />

Then you can enter the following information into the fields, you create your fictional organization.

<img src="attachments/organization_setup_menu.PNG" alt="register an account" width="500" />

Click Create Organization.

There may be be a small delay while Lima Charlie creates the new company.

It is possible to use this tool to manage more than one company or organization at a time.

Once the page finishes loading you will see a menu appear and your fake company. Please select your ficticious company.

<img src="attachments/ficticious_company_selection.PNG" alt="register an account" width="700" />

Once you have selected your ficticious company, you can look around and see all the options that this tool has too offer.

For this demonstration we will be creating a sensor for our windows machine and then setting off atomic red to test if our filter catches it.

On the left side under sensors, please select "Installation Keys"

<img src="attachments/one.PNG" alt="register an account" width="300" />

You should then see an option in the center "Create Installation key", Select it

<img src="attachments/two.PNG" alt="register an account" width="300" />

Then you will see a few empty fields, You can add any description you like and any relevant tags.

Once you have done that you can select "Create"

<img src="attachments/three.PNG" alt="register an account" width="300" />

Once you have created your new installation key you can navigate too "Sensors List" and click "Add Sensor"

<img src="attachments/four.PNG" alt="register an account" width="300" />

Then selected the "Windows" sensor

<img src="attachments/five.PNG" alt="register an account" width="500" />

Once you select windows you will be greeted with an installation key menu, once here select from the drop down menu the description you created earlier for your installation key. And then click "Select"

<img src="attachments/six.PNG" alt="register an account" width="300" />

You will then be prompted with what architecture to download, every windows machine may be different but in our case, "86-64 exe"should be right.

<img src="attachments/seven.PNG" alt="register an account" width="300" />

Once you do that you will be greeted with a few more steps to creating your endpoint. First Click "Download the selected installer", once thats finished downloading copy the string in step 4 to your clipboard.

<img src="attachments/eight.PNG" alt="register an account" width="500" />

Then you need to go to your desktop, right click "Windows Terminal" and select "run as administrator"

<img src="attachments/nine.PNG" alt="register an account" width="300" />

Type `cd Downloads` and hit enter

Then paste the string you downloaded in step 4 into your command prompt. Make sure once youve pasted your command into the command prompt you will need go back to the start of the command and replace "lc_sensor.exe" with the name of the newly downloaded file. It will be something to the effect of "hcp_win_x64_release_x.x.x.exe".

Once you have the command changed, then hit enter to run the command.

Once you run the command if you return to the browser you should see this message.

<img src="attachments/success.PNG" alt="register an account" width="300" />

Please note that the name of your computer will be different!

<a href="https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/Tools/IntroClass/LCmeetsAtomicRed/LCAR.md">Part 2</a>
