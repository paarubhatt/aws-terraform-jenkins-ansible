pipeline {
    agent { label 'agent-1' } // Replace with your actual agent label
    stages {
        stage('Verify Connection') {
            steps {
                echo "Running on: ${env.NODE_NAME}"
                sh 'hostname'
                sh 'whoami'
                sh 'uptime'
                echo 'mayu gagan' 
            }
        }
    }
}
