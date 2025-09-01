pipeline {
    agent any

    parameters {
        choice(
            choices: ['smoke', 'regression', 'full'],
            description: 'Test Suite to Execute',
            name: 'TEST_SUITE'
        )
        choice(
            choices: ['chrome', 'firefox', 'edge', 'all'],
            description: 'Browser Selection',
            name: 'BROWSER'
        )
        string(
            defaultValue: 'https://parabank.parasoft.com',
            description: 'Environment URL',
            name: 'BASE_URL'
        )
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 30, unit: 'MINUTES')
    }

    stages {

        stage('Environment Preparation') {
            steps {
                script {
                    echo "Preparing environment for URL: ${params.BASE_URL}"
                    echo "Selected Test Suite: ${params.TEST_SUITE}"
                    if (params.BASE_URL.contains("staging")) {
                        echo "Applying staging-specific configurations..."
                    } else {
                        echo "Applying production-specific configurations..."
                    }
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "Installing dependencies and verifying Cypress..."
                sh "npm ci --no-audit --progress=false"
                sh "chmod +x ./node_modules/.bin/cypress"
            }
        }

        stage('Test Execution') {
            parallel {
                stage('Chrome Tests') {
                    when {
                        expression { params.BROWSER == 'chrome' || params.BROWSER == 'all' }
                    }
                    steps {
                        retry(2) {
                            echo "Running ${params.TEST_SUITE} tests on Chrome"
                            catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                                sh "npx cypress run --browser chrome --spec 'cypress/e2e/${params.TEST_SUITE}/*' --reporter mochawesome --reporter-options configFile=cypress-reporter.json"
                            }
                        }
                    }
                }

                stage('Firefox Tests') {
                    when {
                        expression { params.BROWSER == 'firefox' || params.BROWSER == 'all' }
                    }
                    steps {
                        retry(2) {
                            echo "Running ${params.TEST_SUITE} tests on Firefox"
                            catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                                sh "npx cypress run --browser firefox --spec 'cypress/e2e/${params.TEST_SUITE}/*' --reporter mochawesome --reporter-options configFile=cypress-reporter.json"
                            }
                        }
                    }
                }

                stage('Edge Tests') {
                    when {
                        expression { params.BROWSER == 'edge' || params.BROWSER == 'all' }
                    }
                    steps {
                        retry(2) {
                            echo "Running ${params.TEST_SUITE} tests on Edge"
                            catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                                sh "npx cypress run --browser edge --spec 'cypress/e2e/${params.TEST_SUITE}/*' --reporter mochawesome --reporter-options configFile=cypress-reporter.json"
                            }
                        }
                    }
                }
            }
        }

        stage('Report Generation') {
            steps {
                echo 'Generating Cypress test reports...'
                publishHTML(target: [
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'cypress/reports',
                    reportFiles: 'index.html',
                    reportName: 'Cypress Test Report'
                ])
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        unstable {
            echo "Pipeline completed with warnings or partial failures."
        }
        failure {
            echo "Pipeline failed! Performing cleanup..."
        }
        always {
            echo "Archiving artifacts and logs..."
            archiveArtifacts artifacts: '**/reports/**', allowEmptyArchive: true
        }
    }
}
