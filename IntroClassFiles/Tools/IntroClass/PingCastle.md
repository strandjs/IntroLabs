# Ping Castle

In this lab we will be looking at ping castle.

Ping Castle is a fantastic tool that can be used to quickly identify security issues in Active Directory.

This is a “freeish” tool for local use. 

However, if you are going to use it in a commercial setting it needs to be paid for.

Which is not much of a problem as it is very affordable.

PingCastle operates by analyzing an AD environment and generating a security risk assessment report. It does this using several key methodologies:
1. Data Collection
	•	PingCastle gathers information from the AD environment using LDAP queries.
	•	It collects details about users, groups, domain controllers, policies, trust relationships, and security configurations.
	•	The tool does not require administrative privileges, making it non-intrusive.

2. Security Scoring & Risk Analysis
	•	The tool assigns a security score based on the AD configuration.
	•	It evaluates risk factors such as:
	◦	Aging objects (e.g., old, inactive accounts).
	◦	Privilege escalation risks (e.g., users with excessive permissions).
	◦	Weak configurations (e.g., poor password policies, weak delegation settings).
	◦	Trust relationships (e.g., insecure inter-domain trusts).

For this lab, we will be reviewing the following report:

https://www.pingcastle.com/PingCastleFiles/ad_hc_test.mysmartlogon.com.html

Review the report and answer the following questions.

1. Any systems with empty passwords? 	
2. Any accounts with passwords that never expire? 
3. What does Everyone and Anyone mean in Active Directory?
5. Any Everyone privs?
6. Any Old Passwords?



Answers below...





No Cheating....



# 1. Any systems with empty passwords?

Yes, Yes there are.   And that is bad.  I think we can all agree on that.  Right?

We can find this under User Information > Account Analysis.

We see two.

![image](https://github.com/user-attachments/assets/f5cf89f0-c1d0-4a4f-8cc6-393a5202100a)

In our testing at Black Hills Information Security we see this all of the time.

Next question!!!!

# 2. Any accounts with passwords that never expire? 

Same place as above.  

User Information > Account Analysis.

![image](https://github.com/user-attachments/assets/211786d0-1f32-4356-ac5d-9770342eb983)


This is also bad. However, we see it all the time for things like service accounts.



3. What does Everyone and Anyone mean in Active Directory?

Anyone.  Everyone.  Yes.  EVERY ONE. Even users without a password. 

You read that right.  Not a typo.

A better approach is Authenticated Users, which is restricting access to people who have actually...  You know...  Authenticated.


5. Any Everyone privs?

To see this we need to go to Priviliged Accounts > Privileged Accounts rule details


![image](https://github.com/user-attachments/assets/0cf1c0c2-4d0a-4d19-a0d3-2add50744b65)



6. Any Old Passwords?

At BHIS we see "old" passwords all of the time.  There are a ton of accounts for services, doctors, CEOs and developers who just cannot be bothered to change their passwords every 90 days.

And we, as a pentest company, are grateful.

This is under Stale Objects > Stale Objects rule details

![image](https://github.com/user-attachments/assets/09b8c64c-a69f-4e38-b2f5-f63421ef33f7)















