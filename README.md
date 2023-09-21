PROJECT OVERVIEW 

 

Step 1: Infrastructure as Code with Terraform and 

 Configuration Management with Ansible for the creation of AMI 

  

      In this initial step, we follow a structured process to set up our infrastructure and prepare it for the deployment of our web application. We accomplish this through the following sub-steps: 

  

1. Docker Image Creation: We commence by creating a Docker image for our web application using the relevant application-related data. 

  

2. Infrastructure Provisioning with Terraform: Terraform is employed to orchestrate the provisioning of the infrastructure. This entails the creation of an Amazon Machine Image (AMI) instance designed to host our web application continuously.  

  

3. Ansible Configuration Management: Leveraging Ansible, we manage the instance created in the previous step using Ansible Playbooks to deploy the Web Application with the help of Docker. Our Terraform script is thoughtfully crafted to perform several essential tasks, including key pair creation, downloading the private key into the working directory, and providing the instance's IP address as an output. 

  

4. Application Deployment: During this phase, we deploy our web application onto the instance using the Docker image and Ansible for seamless integration. 

 

 

 

 

 

Step 2: Creation of AMI from the Running Instance 

 

                  In the second step of our project, we focus on creating an Amazon Machine Image (AMI) derived from the running instance that hosts our web application. This step unfolds as follows: 

  

1. AMI Creation with Terraform: We employ Terraform scripts to initiate the creation of an AMI, utilizing the instance ID obtained as an output from Step 1. 

  

2. AMI ID Generation: Following the successful creation of the AMI, a unique AMI ID is generated and displayed for reference. 

  

3. Resource Cleanup: To maintain a tidy and efficient environment, we perform resource cleanup, removing any resources associated with Step 1 that are no longer required. 

  

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

Step 3: Deployment of Web Application to achieve Availability, Scalability and Security in AWS 

  

                                In this final step, we turn our focus towards deploying our web application in Amazon Web Services (AWS) with a primary aim of achieving both availability, security and scalability. The process unfolds as follows: 

  

1. Infrastructure Deployment with Terraform: We utilize Terraform scripts to establish the entire infrastructure needed for the deployment of our web application. This includes essential components such as instances, load balancers, and more. 

  

2. Load Balancer Configuration: As the final piece of the puzzle, we configure the Load Balancer DNS to ensure proper distribution of traffic and redundancy. 

  

3. Web Application Accessibility: With all elements in place, our web application is now accessible and operational, poised to meet the demands of availability and scalability. 

  

This comprehensive approach streamlines our infrastructure setup process, ensuring a robust foundation for our web application while adhering to Infrastructure as Code (IaC) principles and effective configuration management with Ansible. 
