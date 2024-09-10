pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'visimihasi/jenkins-ci-cd'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: '${env.BRANCH_NAME}', credentialsId: 'github-creds', url: 'https://github.com/VisiMihasi/Jenkins-CI-CD.git'
            }
        }

        stage('Build Jar') {
            when {
                anyOf {
                    branch 'main';
                    branch 'dev';
                    branch 'test';
                }
            }
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        // Dev Environment Stages
        stage('Build Docker Image for Dev') {
            when {
                anyOf {
                    branch 'dev';
                    branch 'main';
                }
            }
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-dev"
                    docker.build("${DOCKER_HUB_REPO}:${tag}")
                }
            }
        }

        stage('Deploy to Dev') {
            when {
                anyOf {
                    branch 'dev';
                    branch 'main';
                }
            }
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-dev"
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        docker.image("${DOCKER_HUB_REPO}:${tag}").push()
                    }
                }
            }
        }

        // Test Environment Stages
        stage('Build Docker Image for Test') {
            when {
                anyOf {
                    branch 'test';
                    branch 'main';
                }
            }
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-test"
                    docker.build("${DOCKER_HUB_REPO}:${tag}")
                }
            }
        }

        stage('Deploy to Test') {
            when {
                anyOf {
                    branch 'test';
                    branch 'main';
                }
            }
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-test"
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        docker.image("${DOCKER_HUB_REPO}:${tag}").push()
                    }
                }
            }
        }

        // Production Environment Stages (Main branch only)
        stage('Build Docker Image for Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-prod"
                    docker.build("${DOCKER_HUB_REPO}:${tag}")
                }
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    // Input approval step for production deployment
                    def approver = input message: 'Approve deployment to Production?', ok: 'Approve',
                        submitter: 'admin',
                        parameters: [string(name: 'approver', description: 'Enter your Jenkins username')]

                    if (approver == 'admin') {
                        echo "Deployment approved by: ${approver}"
                    } else {
                        error("Only 'admin' can approve this step.")
                    }
                }

                script {
                    def tag = "v${env.BUILD_NUMBER}-prod"
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        docker.image("${DOCKER_HUB_REPO}:${tag}").push()
                        docker.image("${DOCKER_HUB_REPO}:latest-prod").push()
                    }
                }
            }
        }
    }
}