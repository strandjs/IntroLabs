Let’s take a few moments and get familiar with what Autonomous System Numbers (ASN’s) are and how they work.

Think of an ASN as a ZIP (or postal code) on the Internet.  When you send packets out on the Internet they get routed to the router that is advertised to have responsibility for that part of the Internet. 

We can take a list on known bad IP addresses and do a count on which ASNs have the most “bad” IP address on them with the following commands.

First, let's pull down an open source list of "bad" IP addresses:

`wget https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt`

Next, let's pull the ASN each of those IP addresses is associated with:

`netcat whois.cymru.com 43 < ipsum.txt | grep -v "AS Name" > asn_merge.txt`

Now, let's do a quick count and sort on those ASNs and the number of "bad" IP addresses per ASN:

`awk -F"|" '{ print $1, $4 }' asn_merge.txt | sort | uniq -c | sort -nr | less`
