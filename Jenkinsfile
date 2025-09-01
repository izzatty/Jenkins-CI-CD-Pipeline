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
                                sh "npm install"
                                sh "npm run test -- --suite ${params.TEST_SUITE} --browser chrome"
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
                                sh "npm install"
                                sh "npm run test -- --suite ${params.TEST_SUITE} --browser firefox"
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
                                sh "npm install"
                                sh "npm run test -- --suite ${params.TEST_SUITE} --browser edge"
                            }
                        }
                    }
                }
            }
        }

        stage('Report Generation') {
            steps {
                echo 'Generating HTML test reports...'
                publishHTML(target: [
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'reports',
                    reportFiles: 'index.html',
                    reportName: 'Test Report'
                ])
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
            // Optional: send Slack/email notifications
        }
        unstable {
            echo "Pipeline completed with warnings or partial failures."
        }
        failure {
            echo "Pipeline failed! Performing cleanup..."
            // Add specific cleanup steps if necessary
        }
        always {
            echo "Archiving artifacts and logs..."
            archiveArtifacts artifacts: '**/reports/**', allowEmptyArchive: true
        }
    }
}
