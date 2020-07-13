

# Password Cracking

In this lab we will be getting started with the fundamentals of password cracking.  We will be using Hashcat to do this.

To start, we will be working with the Command Prompt in Windows Terminal.   This is on your desktop and can be opened by right-clicking it and selecting Run as administrator:

![](attachments\Clipboard_2020-06-12-10-36-44.png)

When you get the pop up select Yes.

Next, to open a Command Prompt Window, select the Down Carrot and then select Command Prompt.

![](attachments\Clipboard_2020-06-12-10-38-52.png)

Next, we need to navigate to the hashcat directory.

C:\Users\adhd>`cd \tools\hashcat-4.1.0\`

![](attachments\Clipboard_2020-06-12-10-41-51.png)

Now, lets crack some NT hashes.  These are the hashes that almost all modern Windows systems store these days.  Older systems may store LANMAN, but that is very rare.

C:\Tools\hascat-4.1.0>`hashcat64.exe -a 0 -m 1000 -r rules\Incisive-leetspeak.rule sam.txt password.lst`

When done it should look like this:

![](attachments\Clipboard_2020-07-09-14-57-40.png)

Finally, let’s try and crack some MD5 hashes

C:\Tools\hascat-4.1.0>`hashcat64.exe -a 0 -m 0 -r rules\Incisive-leetspeak.rule md5.txt password.lst`

When done, it should look like this:

![](attachments\Clipboard_2020-07-09-14-58-51.png)











