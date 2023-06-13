#### ELK in the Cloud
---

*This is part one of a three-part series.*
	[Part Two](./elastic_agent.md "Elastic Agents")
	[Part Three](./sysmon_logs.md "Configuring Sysmon")

---

ELK combines three technologies and provides a powerful solution when working with large data sets.  In addition, we are able to setup SIEM rules to alert us as defenders to attacks on our organization.

* E - Elasticsearch
* L - Logstash
* K - Kibana

ELK enables defenders to detect attacks and conduct threat hunting.

To learn ELK, we don't need several servers or to spend large sums of money.  We can get into the driver's seat and experiment with ELK by using the Elastic Cloud 14-day trial.  The trial does not require a credit card to get started. You only need an email and a password.

**1. Set up an account.**

[Start your free Elastic Cloud Trial](https://cloud.elastic.co/registration?settings=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsZW5ndGgiOjE1MCwic2l6ZSI6NDA5NiwiZGVmYXVsdF9zaXplIjoxMDI0fQ.dS6xqdrcNBVkANlcS19AnsZmHVSqoPROLHprdeN-Qbc&source=education "https://cloud.elastic.co/registration?settings=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsZW5ndGgiOjE1MCwic2l6ZSI6NDA5NiwiZGVmYXVsdF9zaXplIjoxMDI0fQ.dS6xqdrcNBVkANlcS19AnsZmHVSqoPROLHprdeN-Qbc&source=education")


This link is for the trial sign up page. Start a trial by signing up.


![Signup page for Elastic Cloud](./images/cloud_signup.png)

---

Watch your email for a confirmation. The email will look something similar to this.


![Elastic Confirmation Email](./images/elastic_email.png)


Click "Verify and Accept."  You should be redirected to the cloud login page.  If you're not redirected, you can find it here.


[Elastic Cloud Log In](https://cloud.elastic.co/login "https://cloud.elastic.co/login")

---

After logging in, the page will look like this.

Fill out the proper filed with the correct information pictured below and select the check boxes with red dots.

Once those fields are filled out click "Next"

![Welcome To Elastic](./images/Capture1.PNG)

---

**2. Start an ELK instance.**

Upon clicking next you will see the following page. For my instance I will be calling it "security-development. Make sure to enter the name of your deployment and click "Create Deployment".

![Creating Delployment](./images/deployment2.PNG)

Next we will see this page.

Elastic will present the credentials for this ELK stack. There is the option to download a CSV of the credentials. However you decide to hold onto these credentials, don't lose them.

![Creating Creds](./images/creds3.PNG)

Then we will need to wait for the continue button to turn blue, once that's done click continue

![Waiting For Deploy](./images/waiting_for_deploy4.PNG)

We will be greeted with menu of options, we want to skip that menu.

![Skip Prompt](./images/skip_prompt5.PNG)

Then at the top of the page we want to click search and type "kibana" and hit enter.

![Search Kibana](./images/kibana_search6.PNG)

Once the next page load we want to add kibana. Select "Add Kibana"

![Add Kibana](./images/add_kibana7.PNG)

We will next be prompted to "Install Elastic Agent" This is what we are going to put on our machine that monitors what's happening. Click "Install Elastic Agent"

![Add Elastic Agent](./images/kibana_loading8.PNG)

The next page we meet will have a wall of text. Select windows.

We will need to click the "Copy to Clipboard".

![Add Elastic Agent](./images/windows_kibana.PNG)

Hold onto this command.  It is recommended to paste this command into some file where you won't lose it. In this example, I saved it to a file I called "agent.txt."  We will use this command later.

<img src="./images/agent_txt.png" alt="Pasting information into agent_txt" style="zoom:67%;" />


The ELK stack is now configured and we have our connection information saved.
Part two will cover how to install and configure an Elastic Agent.

[Part Two](./elastic_agent.md "Elastic Agents")
