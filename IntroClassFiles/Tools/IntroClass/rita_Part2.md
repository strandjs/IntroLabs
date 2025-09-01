Please use the Network Ubuntu VM for this lab.

Do these labs first:

https://github.com/doergestim/SOC_Analyst_Labs/blob/main/courseFiles/Section_05-networkingAndTelemetry/rita_lab/ritaLab1.md


Below are some commands to download and process other Zeek datasets.

`mkdir icmplogs`

`cd icmplogs`

`wget https://acm-motd.s3.us-east-1.amazonaws.com/zeek_icmp_gosh_24hr.zip`

`unzip zeek_icmp_gosh_24hr.zip`

`rita import --logs=./ --database=icmpgosh`

`rita list`

`rita view icmpgosh`

Ctrl+c closes the session

Full writreup below:

https://www.activecountermeasures.com/malware-of-the-day-c2-over-icmp-icmp-gosh/

What more???

Like a lot more??

https://www.activecountermeasures.com/category/malware-of-the-day/
