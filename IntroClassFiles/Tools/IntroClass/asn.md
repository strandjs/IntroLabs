
![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


Let’s take a few moments and get familiar with what Autonomous System Numbers (ASN’s) are and how they work.

Think of an ASN as a ZIP (or postal code) on the Internet.  When you send packets out on the Internet they get routed to the router that is advertised to have responsibility for that part of the Internet. 

We can take a list on known bad IP addresses and do a count on which ASNs have the most “bad” IP address on them with the following commands.

First, let's open a Kali Terminal

<img width="48" height="41" alt="image" src="https://github.com/user-attachments/assets/56b5f591-451a-4477-a28b-9a34efb12d68" />



Now, let's pull down an open source list of "bad" IP addresses:

`wget https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt`

<img width="643" height="267" alt="image" src="https://github.com/user-attachments/assets/5980ff3a-6f5e-4a01-b5b4-2028c5bbc5cc" />


Next, let's pull the ASN each of those IP addresses is associated with:

`netcat whois.cymru.com 43 < ipsum.txt | grep -v "AS Name" > asn_merge.txt`

<img width="634" height="61" alt="image" src="https://github.com/user-attachments/assets/ad5e97d0-e605-41c0-91c9-80000085f6b4" />


Now, let's do a quick count and sort on those ASNs and the number of "bad" IP addresses per ASN:

`awk -F"|" '{ print $1, $4 }' asn_merge.txt | sort | uniq -c | sort -nr | less`

<img width="765" height="307" alt="image" src="https://github.com/user-attachments/assets/9e3ce640-3ff3-4d5f-b42a-30e373844c79" />


The first column is the count of “bad” IP addresses in the ASN and the second column is the ASN number.

See how quickly the number of “bad” IP addresses drop off?  

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)


