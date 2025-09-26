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

        stage('SonarQube Analysis') {
            steps {
                // Use the SonarQube server configured in Jenkins
                withSonarQubeEnv('sonarqube-server') {
                    sh "${tool 'santhosh-sonar-scanner'}/bin/sonar-scanner \
                        -Dsonar.projectKey=twittertrend \
                        -Dsonar.sources=. \
                        -Dsonar.java.binaries=target/classes \
                        -Dsonar.sourceEncoding=UTF-8"
                }
            }
        }

        stage('Archive JAR') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                echo "-------- Artifact archived ------------"
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
