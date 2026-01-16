pipeline {
    agent any  // Runs on any available agent

    stages {
        stage('Checkout') {
            steps {
                checkout scm  // Automatically checks out your GitHub repo
            }
        }

        stage('Deploy IaC with PowerShell') {
            steps {
                powershell '''
                    Write-Output "Starting IaC deployment..."
                    .\\deploy-iac.ps1
                '''
            }
        }

        stage('Verify Resources') {
            steps {
                bat 'az resource list --resource-group AamirIaCLabRG --output table'  // or use powershell
            }
        }
    }

    post {
        always {
            echo 'Deployment finished!'
        }
    }
}