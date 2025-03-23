![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# Velociraptor 

In this lab we will be installing and using **Velociraptor** to look at the various IR artifacts on your computer.

Check out their website here:

<pre>https://www.velocidex.com/</pre>

Velociraptor is a free **EDR** that can help us better understand of the inner workings of a computer.

Furthermore, it is an excellent example of commercial tools you will encounter in your security career.

They also have offer training on their tool if you want to dig deeper.

<pre>https://www.velocidex.com/training/</pre>

Let's get started.

Open a **Windows command prompt**.

![](attachment/openingcommandprompt%20-%20Copy.png)

When the terminal opens, navigate to the appropriate directory by using the following command:

<pre>cd \IntroLabs</pre>

For this installation, we are going to set up **Velociraptor** as a standalone deployment.  This means the server and the client will be run on the same system.

Within the command prompt, run the following command:

<pre>velociraptor-v0.72.3-windows-amd64.exe config generate -i</pre>

When it asks about the OS, please choose **Windows**.  It should be the default.

![](attachment/velociraptor_chooseos.png)

When it asks about the Path to the datastore, **just hit enter**.  This will keep the default.

![](attachment/velociraptor_datastorepath.png)

When it asks about the SSL certs, **just hit enter**.  It will choose the default of Self Signed SSL.

![](attachment/velociraptor_sslcert.png)


When it asks about the DNS name, **just hit enter**.  It will set the default to localhost.  This will work fine as we are just running this locally.

![](attachment/velociraptor_publicdns.png)

For the default ports, once again, **just hit enter** to accept 8000 and 8889 as the defaults.

![](attachment/velociraptor_frontendport.png)

If prompted about using Websocket, enter **"No"**

![](attachment/velociraptor_websocket.png)

If prompted about using the registry to store writeback files, please enter **"N"**

![](attachment/velociraptor_registrywriteback.png)

When asked about which **DynDNS** provider is used, select **None** and press enter.

![](attachment/velociraptor_dyndns.png)

For the GUI username, please **just hit enter** to end.

![](attachment/velociraptor_guiusername.png)

When it asks about the path to the logs directory, **just hit enter** to accept the default.

![](attachment/velociraptor_pathtologs.png)

If it asks if you would to **"restrict VQL"** functionality on the server, please enter **"N"**

![](attachment/velociraptor_vqlfunct.png)

When it asks where to write the server and client configs, **just hit enter** on both prompts to accept the defaults.

![](attachment/velociraptor_configs.png)

Let’s add a **GUI** user.

<pre>velociraptor-v0.72.3-windows-amd64.exe --config server.config.yaml user add root --role administrator</pre>

When it asks for the password, please choose a password you will remember.

When finished, it should look similar to 

![](attachment/velociraptor_entergui.png)

Lets run the **msi** to load the proper files to the proper directories:

<pre>velociraptor-v0.72.3-windows-amd64.msi</pre>

Time to start the server.

<pre>velociraptor-v0.72.3-windows-amd64.exe --config server.config.yaml frontend -v</pre>

This will take some time, be patient.

There will be some red text.  **Don’t panic.**

Surf to the **GUI** and see if it worked!

https://127.0.0.1:8889

When you load the page, there will be an **SSL error** about the self-signed cert.  That is fine.

![](attachment/velociraptor_warning.png)

Select Advanced then proceed to **127.0.0.1**

![](attachment/velociraptor_continue.png)

When it asks for the Username and Password, please enter root and the password you chose earlier.

Please select **Inspect** the server's state.

![](attachment/velociraptor_login.png)

Once logged in, you will see the following:

![](attachment/velociraptor_velociraptorhome.png)

Next, we need to start the client. Lucky for us, it is the same executable.

We will need to open another **Windows Command Prompt**. Right click on the terminal icon in the task bar, and select **"command prompt"**:

![](attachment/velociraptor_openanotherprompt.png)

Then Navigate to the **IntroLabs** directory.

<pre>cd \IntroLabs</pre>

We will need to start the client.  To do this will need to run the **MSI** first.

<pre>velociraptor-v0.72.3-windows-amd64.msi</pre>

When you get the pop up, select Run.  This will install the proper libraries and files.

Next, we will start the client.

<pre>velociraptor-v0.72.3-windows-amd64.exe --config client.config.yaml client -v</pre>

It will look something like this:

![](attachment/velociraptor_clientstart.png)

Now, let’s go back to the Velociraptor GUI and select the Home button in the upper left.

![](attachment/velociraptor_velociraptorGUIhome.png)

You should see **one** connected client.

![](attachment/velociraptor_connectedclients.png)

Now let’s look at what we can do with this.

This is **not** necessarily a detection platform.  It is designed to allow you to dig when you get an **alert** on malware signatures or from suspicious traffic. 

Understand, it is not a replacement for **AV!**

Let’s **"Show All"** Clients. Go to the search bar at the top of the screen, hit the dropdown.  

![](attachment/velociraptor_showall.png)

As you can see below there will only be one client.

![](attachment/velociraptor_onlyclient.png)

If you select that client, you can get additional information about that system.

![](attachment/velociraptor_additionalinfo.png)

Now, on the top right of the window, select **Shell**.

![](attachment/velociraptor_selectshell.png)

This allows us to run commands on the target system.  Think of the commands that we ran from the **Windows CLI**, we can run those here too.

Please click on the **PowerShell** box and select **Cmd**.

![](attachment/velociraptor_powershelldropdown.png)

Now, enter **netstat -naob** in the cmd box and select **"Launch"**.


This will not display the results right away. To see the results, select the **"Eye"** icon:

![](attachment/velociraptor_eye.png)

Now you can see the results:

![](attachment/velociraptor_seeresults.png)

Let’s do a Hunt.   Please select the Hunt icon.

![](attachment/velociraptor_selecthunt.png)

To start a Hunt, please select the **"+"** icon.

![](attachment/velociraptor_newhunt.png)

Name your Hunt, then select **"Select Artifacts"** on the bottom.

![](attachment/velociraptor_selectartifacts.png)

Within the window, scroll down to find **"Generic.System.Pstree"** and select it.

![](attachment/velociraptor_genericpstree.png)

Review on the bottom.

![](attachment/velociraptor_reviewtab.png)

We now have an overview of what is going to be run on all systems.  Which in our case, is only one system.

Now select Launch.

It will start the Hunt and load it in the **queue**.

![](attachment/velociraptor_startedhunt.png)

Please select our Hunt.  Now, we can run it.  Press the **Play** button above.

![](attachment/velociraptor_play.png)

When you get the pop-up, select **Run it!**

This will take a few moments.

When done, you will see **"Total scheduled is 1"** and **"Finished Clients is 1"**.

You can also download the results.

Please select **Download Results.**

![](attachment/velociraptor_download.png)

Then, **Summary (CSV Only)**.

![](attachment/velociraptor_csvonly.png)

This will create a zip with the output.

Please download that by clicking on the **zip file**.

![](attachment/velociraptor_downloadzip.png)

Go ahead and open the **zip file**, navigate into the results folder.

![](attachment/velociraptor_opencsv.png)

Then, open the csv file with **WordPad**.

![](attachment/velociraptor_wordpad.png)

Granted, this is not optimal.  We did not load **Excel** on this system because of licensing restrictions.  However, you can copy this over to your host system and open it there. 

However, of you want to see a simple HTML report you can click on the turn back time icon on the left side (Right above the binoculars) and then clock Download Results > Prepare Collection Report, then click on the HTML report that appears below it.

We have not even begun to touch what we can do with this awesome tool.

Want to try something cool?  Run a **Metrepreter agent** on you Windows system.  Then, go through **Velociraptor** to create a Hunt to find it.  There are many Windows artifacts you can pull.  You do not need to just run one at a time.  You can run multiple.

***
***Continuing on to the next Lab?***

[Click here to get back to the Navigation Menu](/IntroClassFiles/navigation.md)

***Finished with the Labs?***


Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

[Return To Lab List](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/navigation.md)

---
