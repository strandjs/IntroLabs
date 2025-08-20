![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# Scapy

First, let's become root:

`sudo su -`

Now, let's install scapy

`sudo wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg`

`apt-get update`

`apt-get install python3-scapy`

*Note, this may take a moment

Now, start scapy

`scapy`

*Note, this can take a moment!! Again.....


Let's create a raw packet!

`my_packet = Ether() / IP()`

`my_packet.show()`

<img width="262" height="325" alt="image" src="https://github.com/user-attachments/assets/b7b85f42-8686-4d3c-879e-6d346b376249" />

Now, let's do a port scan on port 80

`sr(IP(dst="45.33.32.156")/TCP(dport=80,flags="S"))`

<img width="440" height="125" alt="image" src="https://github.com/user-attachments/assets/a58d8d7e-e747-46ad-ab3d-e9e325337b68" />

Yes!  We can sniff!

`sniff(count=5).nsummary()`

<img width="576" height="109" alt="image" src="https://github.com/user-attachments/assets/c0fb61bc-f2eb-407b-95aa-1e92d5803195" />

Whant to look at some default packet templates?

`ls()'

<img width="411" height="190" alt="image" src="https://github.com/user-attachments/assets/0bbcbf3c-e901-4e68-b78d-3d794b97d3f8" />

Let's look at what we can modify in a TCP packet.

`ls(TCP)`

<img width="627" height="228" alt="image" src="https://github.com/user-attachments/assets/398458ee-79ac-43a5-96f4-7238325c876f" />

Let's try something like traceroute!

Start typing trace then hit tab

<img width="325" height="55" alt="image" src="https://github.com/user-attachments/assets/e6f3fcf4-60ab-4691-bf58-f99cfa49a8cd" />

It has autocomplete!!

`traceroute('google.com', maxttl=8, timeout=5)`

<img width="467" height="272" alt="image" src="https://github.com/user-attachments/assets/4f12160a-8ba3-448a-8287-48f2bfc7eb91" />

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
