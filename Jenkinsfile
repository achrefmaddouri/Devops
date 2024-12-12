pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'bouchrif/event'
        DOCKER_IMAGE_VERSION = 'latest'
        DOCKER_REGISTRY = 'docker.io'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        NEXUS_CREDENTIALS = credentials('nexus-credentials') // Nexus credentials
    }

    stages {
        stage('Git') {
            steps {
                echo 'Pulling from GitHub'
                git branch: 'master', url: 'https://github.com/achrefmaddouri/Devops.git'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true clean package'
            }
        }

        stage('Unit Test') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true test'
            }
        }

        stage('Run Sonar') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_TOKEN')]) {
                    sh 'mvn sonar:sonar -Dsonar.host.url=http://192.168.50.10:9000 -Dsonar.login=$SONAR_TOKEN'
                }
            }
        }

       stage('Maven Deploy') {
            steps {
                sh 'mvn deploy'
            }
        }

        stage('Login to Docker Registry') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', passwordVariable: 'DOCKERHUB_CREDENTIALS_PSW')]) {
                        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    }
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    dir("${WORKSPACE}") {
                        sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} ."
                        sh "docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}"
                    }
                }
            }
        }

        stage('JUNIT TEST with JaCoCo') {
            steps {
                sh 'mvn test jacoco:report'
                echo 'Test stage done'
            }
        }

      

        stage('Docker Compose') {
            steps {
                sh "docker-compose up -d"
                sh 'sleep 60' // Adjust the sleep time based on your application's startup time
            }
        }
    }

    post {
        failure {
            echo 'Pipeline encountered an error.'
        }
    }
}
