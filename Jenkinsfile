pipeline {
    agent { label 'maven' }

    environment {
        MAVEN_HOME = "/opt/apache-maven-3.9.11"
        PATH = "${MAVEN_HOME}/bin:${PATH}"
    }

    stages {
        stage('Build') {
            steps {
                echo "-------- Build started ------------"
                sh "mvn clean install -DskipTests=true"
                echo "-------- Build completed ------------"
            }
        }

        stage('Test') {
            steps {
                echo "-------- Unit test started ------------"
                sh 'mvn surefire-report:report'
                echo "-------- Unit test completed ----------"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube-server') { // SonarQube server connection
                    sh "${tool 'santhosh-sonar-scanner'}/bin/sonar-scanner -Dsonar.projectKey=twittertrend"
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    script {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
    }
}
