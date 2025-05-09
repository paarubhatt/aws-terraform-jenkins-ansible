pipeline {
    agent { label 'agent-1' } // Replace with your actual agent label
    environment {
        SONARQUBE = credentials('sonarqube')
    }
    stages {
        stage('Verify Connection') {
            steps {
                echo "Running on: ${env.NODE_NAME}"
                sh 'hostname'
                sh 'whoami'
                echo "end of pipeline"              
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
    }
}
