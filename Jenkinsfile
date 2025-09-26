pipeline {
    agent { label 'maven' }

    environment {
        MAVEN_HOME = "/opt/apache-maven-3.9.11"
        PATH = "${MAVEN_HOME}/bin:${PATH}"
    }

    stages {
        stage('Build') {
            steps {
                sh "mvn clean install -DskipTests=true"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('santhosh-sonar-scanner') {  // SonarQube server connection name
                    sh "${tool 'santhosh-sonar-scanner'}/bin/sonar-scanner"
                }
            }
        }
    }
}
