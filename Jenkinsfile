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
                timeout(time: 10, unit: 'MINUTES') {
                    bat '''
                        @echo off
                        echo =============================================
                        echo Starting Azure IaC Deployment
                        echo =============================================

                        cd /d "%WORKSPACE%" || exit /b 1

                        echo Current directory:
                        cd

                        echo.
                        echo Files in current directory:
                        dir

                        echo.
                        echo Checking Azure CLI version...
                        az --version || echo ERROR: Azure CLI not found! Install from https://aka.ms/installazurecliwindows

                        echo.
                        echo Ensuring user is logged in to Azure...
                        REM If this fails, run 'az login' once manually on the agent machine
                        REM For CI/CD use service principal with Jenkins credentials (recommended)
                        REM az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID%
                        az account show || echo WARNING: Not logged in. Run 'az login' on the agent machine.

                        echo.
                        echo Installing/updating Bicep CLI...
                        az bicep install --version latest || exit /b 1

                        echo.
                        echo Bicep version:
                        bicep --version || exit /b 1

                        echo.
                        echo =============================================
                        echo Deploying Bicep template...
                        echo =============================================
                        az deployment group create ^
                            --resource-group AamirIaCLabRG ^
                            --template-file webapp.bicep ^
                            --verbose ^
                            --name "Jenkins-IaC-Deployment-%BUILD_NUMBER%" || exit /b 1

                        echo.
                        echo Deployment finished successfully.
                    '''
                }
            }
        }

        stage('Verify Resources') {
            steps {
                bat '''
                    @echo off
                    echo =============================================
                    echo Listing resources in AamirIaCLabRG
                    echo =============================================
                    az resource list --resource-group AamirIaCLabRG --output table || echo ERROR: Resource listing failed!
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
            echo 'Deployment failed! ✗ Check console output for details.'
        }
        aborted {
            echo 'Pipeline was manually aborted.'
        }
    }
}