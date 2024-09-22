pipeline {
    agent any

    environment {
        DJANGO_HOST = '127.0.0.1';
        DJANGO_PORT = '8000'
    }

    stages {
        stage('Checking') {
            steps {
                sh 'python3 --version'
                sh 'python3 -m pytest --version'
                sh 'python3 -m django --version'
            }
        }

        stage('Fetching') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/TheWinczi/AWSTester.git']])
            }
            post {
                success {
                    echo 'Fetching succeeded'
                }
            }
        }

        stage('Building') {
            steps {
                dir('mysite') {
                    sh 'python3 manage.py runserver ${env.DJANGO_HOST}:${env.DJANGO_PORT}'
                }
            }
        }

        stage('Testing') {
            steps {
                sh 'curl 127.0.0.1:8000'
            }
        }
    }
}