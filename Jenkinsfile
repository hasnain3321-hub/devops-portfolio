pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code'
                checkout scm
            }
        }

        stage('Validate') {
            steps {
                echo 'Validating project structure'

                sh '''
                    set -eu

                    test -f app/index.html
                    test -f app/css/style.css
                    test -f app/js/script.js
                    test -f scripts/test.sh

                    echo "Project structure validation passed"
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Running automated website tests'
                sh 'bash scripts/test.sh'
            }
        }

        stage('Build') {
            steps {
                echo 'Creating website build package'

                sh '''
                    set -eu

                    mkdir -p build

                    tar -czf build/devops-launchpad.tar.gz -C app .

                    test -s build/devops-launchpad.tar.gz

                    echo "Build package created successfully"
                    ls -lh build/devops-launchpad.tar.gz
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying website'

                sh '''
                    set -eu

                    DEPLOY_DIR="/var/lib/jenkins/deployments/devops-launchpad"

                    mkdir -p "$DEPLOY_DIR"

                    tar -xzf build/devops-launchpad.tar.gz -C "$DEPLOY_DIR"

                    echo "Website deployment completed"
                '''
            }
        }

        stage('Verify') {
            steps {
                echo 'Verifying deployed website'

                sh '''
                    set -eu

                    DEPLOY_DIR="/var/lib/jenkins/deployments/devops-launchpad"

                    test -f "$DEPLOY_DIR/index.html"
                    test -f "$DEPLOY_DIR/css/style.css"
                    test -f "$DEPLOY_DIR/js/script.js"

                    echo "Deployment verification passed"
                '''
            }
        }
    }

    post {
        success {
            echo 'DEVOPS LAUNCHPAD: CI/CD PIPELINE SUCCESSFUL!'
        }

        failure {
            echo 'Pipeline failed. Please check Console Output.'
        }
    }
}
