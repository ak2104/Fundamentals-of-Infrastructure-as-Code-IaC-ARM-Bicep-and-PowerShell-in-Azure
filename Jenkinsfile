pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Deploy IaC with Azure CLI') {
            steps {
                bat '''
                    @echo off
                    cd /d "%WORKSPACE%"

                    echo Current directory:
                    cd

                    echo Files in current directory:
                    dir

                    echo.
                    echo Installing/updating Bicep CLI...
                    az bicep install --version latest

                    echo.
                    echo Bicep version:
                    bicep --version

                    echo.
                    echo Deploying Bicep template...
                    az deployment group create ^
                        --resource-group AamirIaCLabRG ^
                        --template-file webapp.bicep ^
                        --verbose ^
                        --name "Jenkins-IaC-Deployment-%BUILD_NUMBER%"

                    echo.
                    echo Deployment finished.
                '''
            }
        }

        stage('Verify Resources') {
            steps {
                bat '''
                    az resource list --resource-group AamirIaCLabRG --output table
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished!'
        }
        success {
            echo 'Deployment successful! ✓'
        }
        failure {
            echo 'Deployment failed! ✗'
        }
    }
}