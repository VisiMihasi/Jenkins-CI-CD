pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'visimihasi/jenkins-ci-cd'
    }

    stages {
        stage('Checkout') {
            steps {
                // Use GitHub credentials to check out the code
                git branch: "${env.BRANCH_NAME}", credentialsId: 'github-creds', url: 'https://github.com/VisiMihasi/Jenkins-CI-CD.git'
            }
        }

        stage('Build Jar') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        // Dev Environment Stages
        stage('Build Docker Image for Dev') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-dev"
                    def latestTag = "latest-dev"
                    docker.build("${DOCKER_HUB_REPO}:${tag}")
                    docker.build("${DOCKER_HUB_REPO}:${latestTag}")
                }
            }
        }

        stage('Deploy to Dev') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-dev"
                    def latestTag = "latest-dev"
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        docker.image("${DOCKER_HUB_REPO}:${tag}").push()
                        docker.image("${DOCKER_HUB_REPO}:${latestTag}").push() // Also push the latest tag
                    }
                }
            }
        }

        // Test Environment Stages
        stage('Build Docker Image for Test') {
            when {
                branch 'test'
            }
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-test"
                    def latestTag = "latest-test"
                    docker.build("${DOCKER_HUB_REPO}:${tag}")
                    docker.build("${DOCKER_HUB_REPO}:${latestTag}")
                }
            }
        }

        stage('Deploy to Test') {
            when {
                branch 'test'
            }
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}-test"
                    def latestTag = "latest-test"
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        docker.image("${DOCKER_HUB_REPO}:${tag}").push()
                        docker.image("${DOCKER_HUB_REPO}:${latestTag}").push() // Push the latest tag
                    }
                }
            }
        }

        // Full Deployment Pipeline for Main Branch (Dev -> Test -> Prod)
        stage('Complete Deployment Pipeline for Main') {
            when {
                branch 'main'
            }
            stages {
                stage('Build Docker Image for Main') {
                    steps {
                        script {
                            def tag = "v${env.BUILD_NUMBER}-main"
                            def latestTag = "latest-prod"
                            docker.build("${DOCKER_HUB_REPO}:${tag}")
                            docker.build("${DOCKER_HUB_REPO}:${latestTag}")
                        }
                    }
                }

                stage('Deploy to Dev from Main') {
                    steps {
                        script {
                            def tag = "v${env.BUILD_NUMBER}-dev"
                            def latestTag = "latest-dev"
                            docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                                docker.image("${DOCKER_HUB_REPO}:${tag}").push()
                                docker.image("${DOCKER_HUB_REPO}:${latestTag}").push()
                            }
                        }
                    }
                }

                stage('Deploy to Test from Main') {
                    steps {
                        script {
                            def tag = "v${env.BUILD_NUMBER}-test"
                            def latestTag = "latest-test"
                            docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                                docker.image("${DOCKER_HUB_REPO}:${tag}").push()
                                docker.image("${DOCKER_HUB_REPO}:${latestTag}").push()
                            }
                        }
                    }
                }

                stage('Wait for Approval to Deploy to Production') {
                    steps {
                        input message: 'Approve deployment to Production?', ok: 'Approve'
                    }
                }

                stage('Deploy to Production from Main') {
                    steps {
                        script {
                            def tag = "v${env.BUILD_NUMBER}-prod"
                            def latestTag = "latest-prod"
                            docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                                docker.image("${DOCKER_HUB_REPO}:${tag}").push()
                                docker.image("${DOCKER_HUB_REPO}:${latestTag}").push()
                            }
                        }
                    }
                }
            }
        }
    }
}