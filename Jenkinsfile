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
         stage('Start Database') {
            steps {
                script {
                    // Run a MySQL container before running tests
                    docker.image('mysql:latest').withRun('-e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=test_db -p 3306:3306') { c ->
                        env.DB_HOST = "localhost"
                        env.DB_PORT = "3306"
                    }
                }
            }
        }
        stage('Build Jar') {
            steps {
                sh 'mvn clean package -DskipTests'
                }
            }

        stage('Build Docker Image') {
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}"
                    docker.build("${DOCKER_HUB_REPO}:${tag}")
                }
            }
        }

        stage('Push to Dev') {
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}"
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        docker.image("${DOCKER_HUB_REPO}:${tag}").push()
                        docker.image("${DOCKER_HUB_REPO}:${tag}").push('latest')
                    }
                }
            }
        }

        // Add more stages for Test and Live as needed...
    }
}