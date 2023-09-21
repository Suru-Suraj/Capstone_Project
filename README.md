## Project Overview

### Step 1: Infrastructure as Code with Terraform and Configuration Management with Ansible

In this initial phase, we follow a structured process to establish the infrastructure and prepare it for our web application deployment. This phase consists of the following sub-steps:

1. **Docker Image Creation**: We start by creating a Docker image for our web application using relevant application data.

2. **Infrastructure Provisioning with Terraform**: Terraform orchestrates the provisioning of our infrastructure, including the creation of an Amazon Machine Image (AMI) instance designed to host our web application continuously.

3. **Ansible Configuration Management**: Leveraging Ansible, we manage the instance created in the previous step using Ansible Playbooks to deploy the web application with Docker. Our Terraform script handles essential tasks such as key pair creation, private key retrieval, and IP address provisioning.

4. **Application Deployment**: During this phase, we seamlessly deploy our web application onto the instance using the Docker image and Ansible for integration.

### Step 2: Creation of AMI from the Running Instance

In the second phase of our project, we focus on creating an Amazon Machine Image (AMI) derived from the running instance hosting our web application. This phase unfolds as follows:

1. **AMI Creation with Terraform**: We employ Terraform scripts to initiate the creation of an AMI, utilizing the instance ID obtained as an output from Step 1.

2. **AMI ID Generation**: Following successful AMI creation, a unique AMI ID is generated and displayed for reference.

3. **Resource Cleanup**: To maintain an efficient environment, we perform resource cleanup, removing any Step 1-associated resources no longer needed.

### Step 3: Deployment of Web Application to Achieve Availability, Scalability, and Security in AWS

In this final phase, we focus on deploying our web application in Amazon Web Services (AWS) with the primary objectives of achieving availability, security, and scalability. This phase unfolds as follows:

1. **Infrastructure Deployment with Terraform**: We utilize Terraform scripts to establish the entire infrastructure required for our web application deployment, including instances, load balancers, and other essential components.

2. **Load Balancer Configuration**: As the final piece of the puzzle, we configure the Load Balancer DNS to ensure proper traffic distribution and redundancy.

3. **Web Application Accessibility**: With all components in place, our web application becomes accessible and operational, ready to meet the demands of availability and scalability.

This comprehensive approach streamlines our infrastructure setup, ensuring a robust foundation for our web application while adhering to Infrastructure as Code (IaC) principles and effective configuration management with Ansible.
