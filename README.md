# OpenShift-BootCamp-HW Installation Steps 

### Review the Env_Type variable file
This file link:./env_vars.yml[./env_vars.yml] contains all the variables you need to define to control the deployment of your environment.

### Running the Ansible Playbook
1. Log into bastion host 

2. Change user to root

```[xxxx@bastion ~]$ sudo -i```

3. Clone this repo

```[root@bastion ~]# git clone  https://github.com/tjachja/OpenShift-BootCamp-HW.git```

```[root@bastion ~]# cd OpenShift-BootCamp-HW/```

4. Run ansible playbook with GUID

```[root@bastion ~]# ansible-playbook main.yml  -e "guid=${GUID}"```

Note: If installer fails the first time, rerun the command.
