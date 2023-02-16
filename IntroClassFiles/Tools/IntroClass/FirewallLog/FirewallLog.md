
# Firewall Log Review




Let’s get started by opening a Terminal as Administrator

![](attachments/Clipboard_2020-06-12-10-36-44.png)

When you get the User Account Control Prompt, select Yes.

And, open a Ubuntu command prompt:

![](attachments/Clipboard_2020-06-17-08-32-51.png)

On your Linux system, please run the following command:

<pre>
grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | less

grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | grep FIN | cut -d ' ' -f 1,3,4,5,7,8,9,10,11,12,13,14

grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | grep FIN | grep 13.107.237.38 | cut -d ' ' -f 1,3,4,5,7,8,9,10,11,12,13,14

grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | grep FIN | grep 18.160.185.174 | cut -d ' ' -f 1,3,4,5,7,8,9,10,11,12,13,14

grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | grep FIN | grep 18.160.185.174 | cut -d ' ' -f 14

grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | grep FIN | cut -d ' ' -f 8,14 | tr : ' ' | tr / ' '  | cut -d ' ' -f 2,4

grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | grep FIN | grep 18.160.185.174 | cut -d ' ' -f 8,14 | tr : ' ' | tr / ' '  | cut -d ' ' -f 4 | Rscript -e 'y <-scan("stdin", quiet=TRUE)' -e 'cat(min(y), max(y), mean(y), sd(y), var(y), sep="\n")'
 
cat ASA-syslogs.txt | sed -e 's/^.*%ASA-[0-9-]*: //' | less

Discard the conns limit messages:
grep -v 'Resource .conns. limit of 20000 reached for system'

Discard NAT messages:
egrep -v '(Built dynamic [TU][CD]P translation from|Teardown dynamic [TU][CD]P translation from)'

cat ASA-syslogs.txt | sed -e 's/^.*%ASA-[0-9-]*: //' | grep -v 'Resource .conns. limit of 20000 reached for system' | egrep -v '(Built dynamic [TU][CD]P translation from|Teardown dynamic [TU][CD]P translation from)' | sort | less

  
 </pre>





