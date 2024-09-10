
# Jenkins CI/CD Pipeline Project

## Overview

This project demonstrates how to set up a CI/CD pipeline using Jenkins, Docker, and GitHub. The pipeline includes stages for building, testing, and deploying the application to different environments (Development, Testing, and Production). The pipeline is triggered automatically whenever code is pushed to a branch in GitHub. Additionally, approval is required for deploying to production.

## Prerequisites

Before running this project, ensure you have the following installed on your machine:

- **Docker**: To containerize the application and run containers.
- **Jenkins**: To create and manage the CI/CD pipeline.
- **Maven**: To build and package the Java Spring Boot application.
- **ngrok**: To expose Jenkins to the internet for webhook triggers from GitHub.
- **Git**: To clone the repository and manage version control.

### Setting up Docker

1. Install Docker from [Docker's official website](https://www.docker.com/products/docker-desktop).
2. Verify the installation:
   ```bash
   docker --version
   ```

### Setting up Jenkins

1. Download and install Jenkins from [Jenkins official website](https://www.jenkins.io/download/).
2. Start Jenkins:
   ```bash
   docker run -d -p 8080:8080 -p 50000:50000 --name jenkins \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
   ```
3. Retrieve the Jenkins unlock password by running:
   ```bash
   docker exec -u root jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
4. Complete the Jenkins setup in the web browser at `http://localhost:8080`.

### Setting up ngrok for Jenkins

1. Download and install ngrok from [ngrok's official website](https://ngrok.com/download).
2. Run ngrok to expose Jenkins to the internet:
   ```bash
   ngrok http 8080
   ```
3. Note the forwarding URL provided by ngrok (e.g., `http://12345.ngrok.io`), which will be used for GitHub webhooks.

### Setting up GitHub Webhooks

1. Go to your repository on GitHub.
2. Navigate to **Settings** -> **Webhooks** -> **Add webhook**.
3. In the **Payload URL** field, enter your ngrok forwarding URL followed by `/github-webhook/`, for example:
   ```
   http://12345.ngrok.io/github-webhook/
   ```
4. Set the **Content type** to `application/json`.
5. Select **Just the push event** for triggering builds.

## CI/CD Pipeline Overview

The pipeline is structured to run the following stages:

1. **Checkout**: Clones the code from GitHub.
2. **Build Jar**: Uses Maven to build and package the Spring Boot application.
3. **Build Docker Image**: Builds a Docker image of the application for each environment (Dev, Test, Prod).
4. **Push Docker Image**: Pushes the built Docker image to Docker Hub for each environment.
5. **Approval for Production**: Requires manual approval for production deployment.

## Running the Pipeline

1. Clone the repository:
   ```bash
   git clone https://github.com/VisiMihasi/Jenkins-CI-CD.git
   ```
2. Create credentials in Jenkins for:
   - **GitHub** (for accessing the repository).
   - **Docker Hub** (for pushing Docker images).
3. Create a pipeline job in Jenkins and set the **Pipeline Script from SCM** to use the `Jenkinsfile` in this repository.
4. Trigger the pipeline by pushing code to the respective branches:
   - Push to `dev` branch for Development environment.
   - Push to `test` branch for Testing environment.
   - Push to `main` branch for Production, which requires approval to deploy.

## Notes


- The pipeline is configured to build, tag, and push Docker images with versioning like `v1-dev`, `v1-test`, and `v1-prod`.
- Ensure you have appropriate permissions set up for approval steps in Jenkins.
