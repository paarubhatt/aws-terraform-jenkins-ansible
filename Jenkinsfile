pipeline {
    agent { label 'your-agent-label' } // Replace with your actual agent label
    stages {
        stage('Verify Connection') {
            steps {
                echo "Running on: ${env.NODE_NAME}"
                sh 'hostname'
                sh 'whoami'
                sh 'uptime'
            }
        }
    }
}
