pipeline {
    agent any

    stages {
        stage('Checking') {
            sh 'python3 --version'
            sh 'python3 -m pytest --version'
            sh 'python3 -m django --version'
        }

        stage('Fetching') {
            checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/TheWinczi/AWSTester.git']])
            post {
                success {
                    echo 'Fetching succeeded'
                }
            }
        }

        stage('Building') {
            sh 'python3 manage.py runserver'
        }
    }
}