pipeline {
    agent any

    environment {
        AZURE_CLIENT_ID       = credentials('AZURE_CLIENT_ID')        // Service Principal Client ID
        AZURE_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')    // Service Principal Client Secret
        AZURE_TENANT_ID       = credentials('AZURE_TENANT_ID')        // Azure Tenant ID
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')  // Azure Subscription ID
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Deploy IaC with Azure CLI') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    bat '''
                        @echo off
                        echo =============================================
                        echo Deploying resources using Azure CLI...
                        echo =============================================

                        :: Debugging: Check if the environment variables are set correctly
                        echo AZURE_CLIENT_ID=%AZURE_CLIENT_ID%
                        echo AZURE_CLIENT_SECRET=%AZURE_CLIENT_SECRET%
                        echo AZURE_TENANT_ID=%AZURE_TENANT_ID%
                        echo AZURE_SUBSCRIPTION_ID=%AZURE_SUBSCRIPTION_ID%

                        :: Check Azure CLI version
                        az --version

                        :: Debugging authentication with Azure CLI
                        az account show || (echo ERROR: Azure authentication failed! && exit /b 1)

                        :: Ensure subscription is set to the correct one
                        echo Setting Azure subscription...
                        az account set --subscription %AZURE_SUBSCRIPTION_ID% || (echo ERROR: Subscription authentication failed! && exit /b 1)

                        :: Deploy resources using Azure CLI (e.g., Bicep)
                        az deployment group create ^
                            --resource-group YourResourceGroup ^
                            --template-file template.bicep ^
                            --verbose || (echo ERROR: Deployment failed! && exit /b 1)

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
                    echo Listing resources in YourResourceGroup
                    echo =============================================
                    az resource list --resource-group YourResourceGroup --output table || (
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
