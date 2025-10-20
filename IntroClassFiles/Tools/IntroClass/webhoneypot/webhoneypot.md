![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)
 

# Web Honeypot 

  

In this lab we will be running a very simple web honeypot.  Basically, it runs a fake Outlook Web Access page and logs the attacks.  

  

This is a good approach as attackers constantly go after anything that looks like an authentication portal. 

  

Let's get started. 

  

First we will need to open a Kali Terminal:

![image](https://github.com/user-attachments/assets/ef855265-729c-4054-ad3e-759c9ad3a3ec)


Next, change directories to the /opt/owa-honeyport directory: 

  

`cd /opt/owa-honeypot/` 

  

![image](https://github.com/user-attachments/assets/85d0b4c0-b933-459f-8ca6-45ec5687acc6)


  

Now, let's start the honeypot: 

  

`sudo python3 owa_pot.py` 

  

It should look like this: 

  ![image](https://github.com/user-attachments/assets/c7e33623-5050-4772-8767-e22fe0da9259)

  

Now, let's start another Kali Terminal. 

![image](https://github.com/user-attachments/assets/ef855265-729c-4054-ad3e-759c9ad3a3ec)



Let's get your Kali IP address. 

  

`ifconfig` 

![image](https://github.com/user-attachments/assets/0f927bdf-a032-41a1-bd40-68fb41fd9959)


Then, navigate to the owa-honeypot directory. 

  

`cd /opt/owa-honeypot/` 

  
![image](https://github.com/user-attachments/assets/ec61ff20-6aae-44fa-b920-fcb723f3c3aa)


  

Now, lets tail the dumppass log. 

  

`tail -f dumpass.log` 

  

![image](https://github.com/user-attachments/assets/1877a55c-9717-4428-a08b-38c6ea40af2f)


  

Now, let's open a browser window and surf to the honeypot: 

  

`http://YOURLINUXIP` 

  

Now, try a bunch of User IDs and passwords. 

  

Now, go back to the Kali Terminal with the log and you should see the IP address and USerID/Password of the attempts. 

  
![image](https://github.com/user-attachments/assets/71dbd425-29d1-46b1-9ed1-dc32d05fd595)

  

Now, let's attack it. 

  

Select OWASP ZAP on your desktop. 

  

![image](https://github.com/user-attachments/assets/6493b57a-bb9d-4886-8e15-735ce63a93c7)

  

Once ZAP! opens, select Automated Scan: 

  

![](attachment/Clipboard_2021-03-12-11-48-15.png) 

  

When Automated Scan opens, please put you Kali Linux IP in the URL to attack box and select Attack. 

  

It should look like this: 

![image](https://github.com/user-attachments/assets/c291f9f9-3730-49a6-a874-7d7df5dc5d8e)


After a while, you should see some attack strings in your Logs. 

  
![image](https://github.com/user-attachments/assets/00bb3500-361f-4d28-9bb5-c5769d50cc53)

  

Yes...  Some attack tools are as obvious as ZAP:ZAP. 

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/pcap/AdvancedC2PCAPAnalysis.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/FileAudit/FileAudit.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---

  

  

  

  

  

  

  

  

  

  

  

 

 

