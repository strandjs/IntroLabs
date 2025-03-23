 

# Honey Share 

  

In this lab we will be creating and triggering a honey share.  The goal of this lab is to show how to set up a simple Impacket SMB server that can record attempted connections to it. 

  

This can be used for detecting lateral movement in a Windows environment.  

  

One of the cool things about this is it will track the compromised user, the system and the password hash of the compromised user account. 

  

Let's get started. 

  



First, we will need to open an Kali Linux Prompt: 

![image](https://github.com/user-attachments/assets/4890f6f1-bea0-4419-a588-3e6594c9118f)



Let's get our IP address. 

  

`ifconfig` 

  
![image](https://github.com/user-attachments/assets/aed53ef8-6796-4897-ba51-c1a4a09f1b24)

Next, we will become root and navigate to the Impacket directory: 

  

`sudo su -` 

  

`cd /opt/impacket/examples` 

  

It should look like this: 

  

![image](https://github.com/user-attachments/assets/e5cbc8eb-b3a8-4fe6-84c2-569e6fed013c)


Now, let's start the SMB server: 

  

`python3 ./smbserver.py -smb2support -comment 'secret' SECRET /secret` 

  

It should look like this: 

 ![image](https://github.com/user-attachments/assets/d1268c27-a141-4a95-96ce-a9482d4b3e56)
 


Next, let's open a Windows Command Prompt: 

![image](https://github.com/user-attachments/assets/0ccc949d-32c3-4d7b-bb18-1bb39ee36dfc)
  


Then, attempt to mount the share from your Windows system: 


`net use * \\172.17.78.175\secret` 

Remember!  Your IP address may be different!!! 
  

We did the most basic level of attempted authentication to the share, and it generated an error.  

![image](https://github.com/user-attachments/assets/8d861109-cd62-4231-946a-98f2284466a6)


However, the trap was triggered! 

  

Go back to your Kali Linux terminal and see the log data. 


It should look like this: 

![image](https://github.com/user-attachments/assets/4b3291a4-fbd1-49a6-968f-f72caefc403a)

[Return To Lab List](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/navigation.md)


  

 

  

 

 
