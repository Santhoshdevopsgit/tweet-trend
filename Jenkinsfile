pipeline {
    agent { label 'maven' }

    environment {
        MAVEN_HOME = "/opt/apache-maven-3.9.11"
        PATH = "${MAVEN_HOME}/bin:${PATH}"
    }

    stages {
        stage('Build') {
            steps {
                // Compile and package the Maven project, skipping tests
                echo "-------- build started ------------"
                sh "mvn clean install -DskipTests=true"
                echo "-------- build completed ------------"
            }
        }
        stage("test"){
            steps{
                echo "-------- unit test started ------------"
                sh 'mvn surefire-report:report'
                echo "-------- unit test completed ----------"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // withSonarQubeEnv expects the **Server Connection Name** from Jenkins
                withSonarQubeEnv('sonarqube-server') {
                    // tool('...') gets the path of the Sonar Scanner binary
                    sh "${tool 'santhosh-sonar-scanner'}/bin/sonar-scanner -Dsonar.projectKey=twittertrend"
                }
            }
        }
    }
}
