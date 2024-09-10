pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'visimihasi/jenkins-ci-cd'
    }

    stages {
        stage('Checkout') {
            steps {

                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/VisiMihasi/Jenkins-CI-CD.git'
            }
        }

        stage('Build Jar') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }


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


        stage('Build Docker Image for Production') {
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-prod"
                    docker.build("${DOCKER_HUB_REPO}:${tag}")
                }
            }
        }

       stage('Deploy to Production') {
           steps {
               script {

                   def approver = input message: 'Approve deployment to Production?', ok: 'Approve',
                       submitter: 'admin', // This restricts who can approve
                       parameters: [string(name: 'approver', description: 'Enter your Jenkins username')]

                   // Check if the approver matches the allowed user
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