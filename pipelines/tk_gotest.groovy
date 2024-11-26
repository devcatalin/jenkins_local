pipeline {
    agent any

    environment {
        TK_ORG = credentials("TK_ORG")
        TK_ENV = credentials("TK_ENV")
        TK_API_TOKEN = credentials("TK_API_TOKEN")
        TK_DEBUG = "1"
    }
    stages {
        stage('Testing') {
            steps {
                script {
                    // Setup the Testkube CLI
                    setupTestkube()
                    // Run gotest
                    sh 'testkube run testworkflow gotest -f'
                }
            }
        }
    }
}
