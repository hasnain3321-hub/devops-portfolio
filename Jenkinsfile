pipeline {
    agent any

    options {
    timestamps()
    disableConcurrentBuilds()
    skipDefaultCheckout(true)
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
                sh '''
                    set -eu
                    test -f app/index.html
                    test -f app/css/style.css
                    test -f app/js/script.js
                    test -f scripts/test.sh
                    test -f Dockerfile
                    test -f docker-compose.yml
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
                sh '''
                    set -eu
                    mkdir -p build
                    tar -czf build/devops-launchpad.tar.gz -C app .
                    test -s build/devops-launchpad.tar.gz
                    ls -lh build/devops-launchpad.tar.gz
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    set -eu
                    DEPLOY_DIR="/var/lib/jenkins/deployments/devops-launchpad"
                    mkdir -p "$DEPLOY_DIR"
                    tar -xzf build/devops-launchpad.tar.gz -C "$DEPLOY_DIR"
                    echo "Archive deployment completed"
                '''
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    set -eu
                    DEPLOY_DIR="/var/lib/jenkins/deployments/devops-launchpad"
                    test -f "$DEPLOY_DIR/index.html"
                    test -f "$DEPLOY_DIR/css/style.css"
                    test -f "$DEPLOY_DIR/js/script.js"
                    echo "File deployment verification passed"
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    set -eu
                    docker compose -p devops-portfolio build web
                    echo "Docker image built successfully"
                '''
            }
        }

        stage('Docker Deploy') {
            steps {
                sh '''
                    set -eu
                    docker compose -p devops-portfolio up -d --no-deps web
                    echo "Docker deployment completed"
                '''
            }
        }

        stage('Docker Verify') {
            steps {
                sh '''
                    set -eu

                    CONTAINER="devops-launchpad"

                    STATUS=$(docker inspect --format '{{.State.Status}}' "$CONTAINER")
                    test "$STATUS" = "running"

                    HEALTH="starting"

                    for attempt in $(seq 1 30); do
                        HEALTH=$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' "$CONTAINER")

                        if [ "$HEALTH" = "healthy" ]; then
                            break
                        fi

                        if [ "$HEALTH" = "unhealthy" ]; then
                            docker logs "$CONTAINER"
                            exit 1
                        fi

                        sleep 2
                    done

                    test "$HEALTH" = "healthy"

                    curl --fail --silent --show-error http://127.0.0.1:8081/ -o /dev/null

                    curl --fail --silent http://127.0.0.1:8081/ | grep -F '<title>Hasnain Abbas | DevOps Engineer</title>'

                    echo "Docker container is healthy"
                    echo "Website HTTP verification passed"

                    docker compose -p devops-portfolio ps
                '''
            }
        }
    }

    post {
        success {
            echo 'DEVOPS LAUNCHPAD: JENKINS + DOCKER CI/CD SUCCESSFUL!'
        }

        failure {
            echo 'Pipeline failed. Please check Console Output.'
        }
    }
}
