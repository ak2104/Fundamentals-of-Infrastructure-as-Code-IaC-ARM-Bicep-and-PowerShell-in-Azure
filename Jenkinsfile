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
                    withCredentials([azureServicePrincipal(
                        credentialsId: 'azure-sp',                  // ← Change this if your credential ID is different
                        subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
                        clientIdVariable: 'AZURE_CLIENT_ID',
                        clientSecretVariable: 'AZURE_CLIENT_SECRET',
                        tenantIdVariable: 'AZURE_TENANT_ID'
                    )]) {
                        bat '''
                            @echo off
                            echo =============================================
                            echo Starting Azure IaC Deployment with Service Principal
                            echo =============================================

                            cd /d "%WORKSPACE%" || exit /b 1

                            echo Current directory:
                            cd

                            echo.
                            echo Files in current directory:
                            dir

                            echo.
                            echo Logging in to Azure with Service Principal...
                            az login --service-principal ^
                                -u %AZURE_CLIENT_ID% ^
                                -p %AZURE_CLIENT_SECRET% ^
                                --tenant %AZURE_TENANT_ID% || (
                                    echo ERROR: Azure login failed! Check credential ID, values, or role assignment.
                                    exit /b 1
                                )

                            echo.
                            echo Current Azure subscription:
                            az account show

                            echo.
                            echo Checking Azure CLI version...
                            az --version

                            echo.
                            echo Installing/updating Bicep CLI...
                            az bicep install --version latest || exit /b 1

                            echo.
                            echo Bicep version:
                            bicep --version

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
        }

        stage('Verify Resources') {
            steps {
                bat '''
                    @echo off
                    echo =============================================
                    echo Listing resources in AamirIaCLabRG
                    echo =============================================
                    az resource list --resource-group AamirIaCLabRG --output table || (
                        echo ERROR: Resource listing failed!
                        exit /b 1
                    )
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