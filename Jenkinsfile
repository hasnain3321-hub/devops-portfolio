pipeline {
    agent any

    options {
        timestamps()
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Getting source code from GitHub'
                checkout scm
            }
        }

        stage('Test') {
            steps {
                echo 'Running automated tests'
                sh 'bash scripts/test.sh'
            }
        }

        stage('Build') {
            steps {
                echo 'Building website package'

                sh '''
                    set -eu
                    mkdir -p build

                    tar --exclude='./.git' \
                        --exclude='./build' \
                        -czf build/portfolio-build.tar.gz .

                    test -s build/portfolio-build.tar.gz

                    echo "Website package created successfully"
                    ls -lh build/portfolio-build.tar.gz
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying portfolio website'

                sh '''
                    set -eu

                    DEPLOY_DIR="/var/lib/jenkins/deployments/devops-portfolio"

                    mkdir -p "$DEPLOY_DIR"

                    tar -xzf build/portfolio-build.tar.gz \
                        -C "$DEPLOY_DIR"

                    echo "Website deployed successfully"
                    ls -la "$DEPLOY_DIR"
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check Console Output.'
        }
    }
}
