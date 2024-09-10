pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'visimihasi/jenkins-ci-cd'
    }

    stages {
        stage('Checkout') {
            steps {
                // Use GitHub credentials to check out the code
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/VisiMihasi/Jenkins-CI-CD.git'
            }
        }

        stage('Build Jar') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        // Dev Environment Stages
        stage('Build Docker Image for Dev') {
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-dev"
                    docker.build("${DOCKER_HUB_REPO}:${tag}")
                }
            }
        }

        stage('Deploy to Dev') {
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
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-test"
                    docker.build("${DOCKER_HUB_REPO}:${tag}")
                }
            }
        }

        stage('Deploy to Test') {
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-test"
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        docker.image("${DOCKER_HUB_REPO}:${tag}").push()
                    }
                }
            }
        }

        // Full Deployment Pipeline for Main Branch
        stage('Build Docker Image for Production') {
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-prod"
                    docker.build("${DOCKER_HUB_REPO}:${tag}")
                    docker.build("${DOCKER_HUB_REPO}:latest-prod")
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                input message: 'Approve deployment to Production?'
                ok: 'Approve'
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