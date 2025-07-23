pipeline {
    triggers {
        pollSCM('H/1 * * * *')
    }

    agent none

    stages {
        stage('Checkout') {
            agent any
            steps {
                git(
                    url: 'https://github.com/KazikKluz/rsschool-devops.git',
                    branch: 'Task-6',
                    credentialsId: 'github-credentials'
                )
            }
        }

        stage('Build App') {
            agent {
                docker {
                    image 'python:3.13'
                    args '-u root'  // Needed for pip install with --break-system-packages
                }
            }
            steps {
                sh 'pip install -r flask_app/requirements.txt --break-system-packages'
            }
        }

        stage('Test App') {
            agent {
                docker {
                    image 'python:3.13'
                    args '-u root'
                    reuseNode true  // Reuse the workspace from previous stage
                }
            }
            steps {
                dir('flask_app') {
                    sh 'pytest test_app.py'
                }
            }
        }

        stage('SonarCloud check') {
            agent {
                docker {
                    image 'python:3.13'
                    args '-u root'
                    reuseNode true
                }
            }
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh '''
                        export SONAR_SCANNER_VERSION=7.0.2.4839
                        export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION-linux-x64
                        curl --create-dirs -sSLo $HOME/.sonar/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux-x64.zip
                        unzip -o $HOME/.sonar/sonar-scanner.zip -d $HOME/.sonar/
                        export PATH=$SONAR_SCANNER_HOME/bin:$PATH
                        export SONAR_SCANNER_OPTS="-server"

                        sonar-scanner \
                            -Dsonar.organization=kazikkluz \
                            -Dsonar.projectKey=KazikKluz_rsschool-devops \
                            -Dsonar.sources=./flask_app \
                            -Dsonar.host.url=https://sonarcloud.io \
                            -Dsonar.login=$SONAR_TOKEN
                    '''
                }
            }
        }

        stage('Docker build and push') {
            agent {
                docker {
                    image 'docker:28'
                    args '--privileged -v /var/run/docker.sock:/var/run/docker.sock -u root'
                }
            }
            steps {
                dir('flask_app') {
                    script {
                        def dockerhub_username = 'x00192532'
                        def image_name = 'flask-app'
                        def image_tag = 'latest'
                        def full_image = "${dockerhub_username}/${image_name}:${image_tag}"

                        sh "docker build -t ${full_image} ."
                        sh "docker tag ${full_image} ${dockerhub_username}/${image_name}:latest"
                        withCredentials([usernamePassword(
                            credentialsId: 'dockerhub-credentials',
                            usernameVariable: 'DOCKER_USERNAME',
                            passwordVariable: 'DOCKER_PASSWORD'
                        )]) {
                            sh "echo \$DOCKER_PASSWORD | docker login --username \$DOCKER_USERNAME --password-stdin"
                            sh "docker push ${full_image}"
                            sh "docker push ${dockerhub_username}/${image_name}:latest"
                        }
                    }
                }
            }
        }

        stage('Install Helm') {
            agent any
            steps {
                sh '''
                curl -LO https://get.helm.sh/helm-v3.18.4-linux-amd64.tar.gz
                tar -zxvf helm-v3.18.4-linux-amd64.tar.gz
                mv linux-amd64/helm ./helm
                chmod +x ./helm
                '''
            }
        }

        stage('Deploy App to Kube') {
            agent any
            steps {
                sh """
                    ./helm upgrade --install flask-app ./helm_charts/flask-app \
                        --namespace jenkins \
                        --set image.repository=x00192532/flask-app \
                        --set image.tag=latest \
                        --set image.pullPolicy=IfNotPresent \
                        --set serviceAccount.create=false \
                        --wait \
                        --timeout=300s
                """
            }
        }

        stage('Verify App') {
            agent any
            steps {
                sh 'curl -v http://flask-app.jenkins.svc.cluster.local:8080/'
            }
        }
    }

    post {
        success {
            mail to: 'kazikkluz@gmail.com',
                subject: "SUCCESS: ${currentBuild.fullDisplayName}",
                body: "The pipeline has succeeded."           
        }

        failure {
            mail to: 'kazikkluz@gmail.com',
                subject: "FAILURE: ${currentBuild.fullDisplayName}",
                body: "The pipeline has failed."
        }
    }
}
