pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/devcatalin/golearn', branch: 'main'
            }
        }
        
        stage('Setup') {
            steps {
                sh 'go version'
                sh 'make setup'
            }
        }
        
        stage('Run Tests') {
            steps {
                sh 'make test-report || true'
                sh 'ls -la artifacts'  // Debug: List contents of artifacts directory
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: 'artifacts/**', fingerprint: true, allowEmptyArchive: true
            junit testResults: 'artifacts/report.xml', allowEmptyResults: true
        }
    }
}