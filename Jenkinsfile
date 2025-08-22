pipeline {
    triggers {
        pollSCM('H/1 * * * *')
    }

    agent {
        kubernetes {
yaml """
            apiVersion: v1
            kind: Pod
            spec:
              containers:
                - name: jnlp
                  image: jenkins/inbound-agent:3309.v27b_9314fd1a_4-6

                - name: python
                  image: python:3.13
                  command: ["cat"]
                  tty: true

                - name: docker
                  image: docker:28
                  command: ["cat"]
                  tty: true
                  volumeMounts:
                    - name: docker-sock
                      mountPath: /var/run/docker.sock
              volumes:
                - name: docker-sock
                  hostPath:
                    path: /var/run/docker.sock
                    type: Socket
            """
        }
    }

    stages {
         stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/KazikKluz/rsschool-devops.git',
                    branch: 'Task-7',
                    credentialsId: 'github-credentials'
                )
            }
        }

        stage('Build App') {
            steps {
                container('python') {
                    sh 'pip install -r flask_app/requirements.txt --break-system-packages'
                }
            }
        }

        stage('Test App') {
            steps {
                container('python') {
		            dir('flask_app') {
                        sh 'pytest test_app.py'
	                }
                }
            }
        }

        stage('SonarCloud check') {
            steps {
                container('python') {
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
  				-Dsonar.host.url=https://sonarcloud.io
                        '''
                    }
                }
            }
        }

        stage('Docker build and push') {
            steps {
                container('docker') {
                    dir('flask_app') {
                        script {
                            def dockerhub_username = 'x00192532'
                            def image_name = 'flask-app'
                            def image_tag = 'latest'
                            def full_image = "${dockerhub_username}/${image_name}:${image_tag}"

                            sh "docker build -t ${full_image} ."
                            sh "docker tag ${full_image} ${dockerhub_username}/${image_name}:latest"
                            withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials',
                                                            usernameVariable: 'DOCKER_USERNAME',
                                                            passwordVariable: 'DOCKER_PASSWORD')]) {
                                sh "echo \$DOCKER_PASSWORD | docker login --username \$DOCKER_USERNAME --password-stdin"
                            }

                            sh "docker push ${full_image}"
                            sh "docker push ${dockerhub_username}/${image_name}:latest"
                        }
                    }
                }
            }
        }

        stage('Install Helm') {
            steps {
                sh '''
                curl -LO https://get.helm.sh/helm-v3.18.4-linux-amd64.tar.gz
                tar -zxvf helm-v3.18.4-linux-amd64.tar.gz
                mv linux-amd64/helm ./helm
                chmod +x ./helm
                '''
            }
        }

       stage('Add Helm Repository') {
           steps {
        	sh '''
        	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
                helm repo add grafana https://grafana.github.io/helm-charts
                helm repo update
                '''
           }
       }

	stage('Deploy Prometheus'){
		steps {
			dir('monitoring'){
				sh '''
                                helm upgrade --install my-prometheus prometheus-community/prometheus \
                                --namespace monitoring \
                                --create-namespace \
                                --values values-prometheus.yaml
                                '''
				}
			}
	}

        stage('Deploy App to Kube') {
            steps {
                sh """
                    ./helm upgrade --install flask-app ./chart-flask-app \
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
        stage('Smoke Test') {
            steps {
                sh 'curl -v http://flask-app-chart-flask-app.jenkins.svc.cluster.local:8080/'
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
