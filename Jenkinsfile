pipeline {
    agent { label 'maven' }

    environment {
        MAVEN_HOME = "/opt/apache-maven-3.9.11"
        PATH = "${MAVEN_HOME}/bin:${PATH}"
    }

    stages {
        stage('Build & Package') {
            steps {
                echo "-------- Build started ------------"
                sh "mvn clean package -DskipTests=true"
                echo "-------- Build completed ------------"
            }
        }

        stage('Run Tests') {
            steps {
                echo "-------- Unit test started ------------"
                sh "mvn test"
                echo "-------- Unit test completed ----------"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube-server') {
                    sh "${tool 'santhosh-sonar-scanner'}/bin/sonar-scanner -Dsonar.projectKey=twittertrend"
                }
            }
        }

        stage('Archive JAR') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }
}
