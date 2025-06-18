This is a quick outline for a new lab.

It is not done.

1. Create a chatgpt account.

2. Make sure you have a credit card and credits by going here: 

https://platform.openai.com/settings/organization/billing/overview

3. et an openai api key here:

https://platform.openai.com/api-keys

Please note, when you create it, openai will show it exactly and only once!

4. Start you class MetaCTF VMs.

5. Open a Kali Terminal

6. Become root:

$ `sudo su -`

7. update apt keys:

`wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg`

`apt-get update`

8. Install docker

` apt-get install docker-compose`

9. cd to the opt directory

`cd /opt`

10. Clone and enter beelzebub

`git clone https://github.com/mariocandela/beelzebub.git`

`cd beelzebub`

11. Edit the docker-compose.yml file
    
`nano docker-compose.yml`

12. Add your openai key here:

<img width="512" alt="image" src="https://github.com/user-attachments/assets/05203c3c-30c2-4a6b-baf9-387ec86952a8" />

13. Comment out the ssh 22 port in the same file here:

<img width="186" alt="image" src="https://github.com/user-attachments/assets/ea32283f-9831-441c-b027-f3eee74de2d6" />

14. Write the changes by pressing control and o at the same time.
15. Exit Nano by pressing control and x at the same time.

16. cd to  cd configurations/services/

`cd configurations/services/`

17. Move the ssh 22 file out of this directory

`mv ./ssh-22.yaml ~`

18. Edit the ssh-2222 file with nano:

`nano ./ssh-2222.yaml`

19. Add your openai key here:

<img width="812" alt="image" src="https://github.com/user-attachments/assets/e779e71e-365c-4424-a4e3-4f6e66610f0b" />

Note, it will have double quotes on either side of the key!!!

20. cd back to the beelzebub directory

`cd /opt/beelzebub/`

21. Build and start the Docker image

`docker-compose build`

`docker-compose up -d`

22. Open a second seperate and new Kali terminal.
23. connect to your honeypot!
`ssh -p 2222 root@127.0.0.1`

24. Accept the ssh key fingerprint.
Enter the password of `1234`

26. Run some commands!

`ls`
`id`
`whoami`




