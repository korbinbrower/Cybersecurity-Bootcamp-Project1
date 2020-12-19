# Cybersecurity-Bootcamp-Project1

## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

Images/complete-cloud-network-diagram.png

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the yml file may be used to install only certain pieces of it, such as Filebeat.

	dvwa-playbook.yml 
```	
---
- name: first playbook
  hosts: webservers
  become: true
  tasks:

  - name: install docker
    apt:
      update_cache: yes
      name: docker.io
      state: present

  - name: install pip3
    apt:
      name: python3-pip
      state: present
  - name: install docker pip
    pip:
      name: docker
      state: present
  - name : install dvwa container
    docker_container:
      name: dvwa
      image: cyberxsecurity/dvwa
      state: started
      restart_policy: always
      published_ports: 80:80

  - name: enable docker service
    systemd:
      name: docker
      enabled: yes

	
	elk-playbook.yml 
```	
---
- name: Configure Elk VM with Docker
  hosts: elk
  become: true
  tasks:
 
    - name: Install docker.io
      apt:
        update_cache: yes
        force_apt_get: yes
        name: docker.io
        state: present

    - name: Install python3-pip
      apt:
        force_apt_get: yes
        name: python3-pip
        state: present

    - name: Install Docker module
      pip:
        name: docker
        state: present

    - name: Increase virtual memory
      command: sysctl -w vm.max_map_count=262144

    - name: Use more memory
      sysctl:
        name: vm.max_map_count
        value: 262144
        state: present
        reload: yes

    - name: download and launch a docker elk container
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        published_ports:
          -  5601:5601
          -  9200:9200
          -  5044:5044


	filebeat-playbook.yml 
```	
---
- name: installing and launching filebeat
  hosts: webservers
  become: yes
  tasks:

  - name: download filebeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb

  - name: install filebeat deb
    command: dpkg -i filebeat-7.4.0-amd64.deb

  - name: drop in filebeat.yml
    copy:
      src: /etc/ansible/roles/files/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

  - name: enable and configure system module
    command: filebeat modules enable system

  - name: setup filebeat
    command: filebeat setup

  - name: start filebeat service
    command: service filebeat start


	metricbeat-playbook.yml 
```	
---
- name: installing and launching metricbeat
  hosts: webservers
  become: yes
  tasks:

  - name: download metricbeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.4.0-amd64.deb

  - name: install metricbeat deb
    command: dpkg -i metricbeat-7.4.0-amd64.deb

  - name: drop in metricbeat.yml
    copy:
      src: /etc/ansible/roles/files/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml

  - name: enable and configure system module
    command: metricbeat modules enable docker

  - name: setup metricbeat
    command: metricbeat setup

  - name: start metricbeat service
    command: service metricbeat start

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build
	
### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.
- What aspect of security do load balancers protect? Availability
- What is the advantage of a jump box? A jump box acts as a gateway to the other virtual machines on your created network. This is advantageous because it funnels all traffic through the jump box and allows only secure connections from   allowed ip addresses using a ssh key.  This is also reduces the attack surface by only exposing one machine to the public internet. 

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the logs and system traffic.
- What does Filebeat watch for? Filebeat watches log files/locations and collects log events. 
- What does Metricbeat record? Metricbeat records metrics and statistics and sends the data to your desired output. 

The configuration details of each machine may be found below.

| Name     | Function   | IP Address | Operating System |
|----------|------------|------------|------------------|
| Jump-Box | Gateway    | 10.0.0.7   | Linux            |
| Web-1    | Web Server | 10.0.0.5   | Linux            |
| Web-2    | Web Server | 10.0.0.6   | Linux            |
| Web-3    | Web Server | 10.0.0.8   | Linux            |
| Elk-Box  | Monitoring | 10.1.0.4   | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the jump box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP address:
65.87.50.125

Machines within the network can only be accessed by ssh.
- Which machine did you allow to access your ELK VM? Jump Box 
- What was its IP address? 10.0.0.7

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump-Box | Yes                 | 65.87.57.13          |
| Web-1    | No                  | 10.0.0.7             |
| Web-2    | No                  | 10.0.0.7             |
| Web-3    | No                  | 10.0.0.7             |
| Elk-Box  | No                  | 10.0.0.7             |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because ansible lets you put multiple commands into several servers from a single playbook. 

The playbook implements the following tasks:
- install docker.io
- install python3-pip
- install Docker module
- increase virutal memory 
- use more memory 
- download and launch a docker elk container 

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

Images/successful_configuration_of_the_ELK_box.png

### Target Machines & Beats

This ELK server is configured to monitor the following machines:
- Web-1 10.0.0.5
- Web-2 10.0.0.6
- Web-3 10.0.0.8

We have installed the following Beats on these machines:
Filebeat and Metricbeat 
- Web-1 10.0.0.5
- Web-2 10.0.0.6
- Web-3 10.0.0.8

These Beats allow us to collect the following information from each machine:
- Filebeat collects log files/locations and log events.
- Metricbeat collects metrics and statistics and sends the data to your desired output. 

### Using the Playbook

In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the playbook.yml file to /etc/ansible/roles.
- Update the host file to include:
	[webservers]
	10.0.0.5 ansible_python_interpreter=/usr/bin/python3
   	10.0.0.6 ansible_python_interpreter=/usr/bin/python3
  	10.0.0.8 ansible_python_interpreter=/usr/bin/python3

	[elk]
	10.1.0.4 ansible_python_interpreter=/usr/bin/python3
- Run the playbook: 
	cd /etc/ansible/roles
	ansible-playbook install-elk.yml elk 
	ansible-playbook filebeat-playbook.yml webservers
	ansible-playbook metricbeat-playbook.yml webservers 
- Navigate to http://[Elk Box Public IP]/app/kibana (http://168.61.36.247:5601/app/kibana) to check that the installation worked as expected.

Answer the following questions to fill in the blanks:
- Which file is the playbook? playbook.yml 
- Where do you copy it? /etc/ansible/roles
- Which file do you update to make Ansible run the playbook on a specific machine? /etc/ansible/hosts 
- How do I specify which machine to install the ELK server on versus which to install Filebeat on? you specify the group [webservers] or [elk] at the end of the ansible-playbook command 
- Which URL do you navigate to in order to check that the ELK server is running? http://[Elk Box Public IP]/app/kibana (http://168.61.36.247:5601/app/kibana)

As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc.
