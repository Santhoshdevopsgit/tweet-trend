def registry = 'https://trialu7uj64.jfrog.io'
def imageName = 'trialu7uj64.jfrog.io/san-docker-local/demo-workshop'
def version   = '2.1.4'
def app       // global variable to hold Docker image object

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
                withSonarQubeEnv('sonarqube-server') {
                    sh "${tool 'santhosh-sonar-scanner'}/bin/sonar-scanner -Dsonar.projectKey=twittertrend"
                }
            }
        }

        stage('Jar Publish') {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'

                    def server = Artifactory.newServer(
                        url: "${registry}/artifactory",
                        credentialsId: "artifact-cred"
                    )

                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"

                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "target/*.jar",
                                "target": "san-libs-release-local/",
                                "flat": "false",
                                "props": "${properties}",
                                "exclusions": ["*original*"]
                            }
                        ]
                    }"""

                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)

                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    echo '<--------------- Docker Build Started --------------->'
                    app = docker.build("${imageName}:${version}")
                    echo '<--------------- Docker Build Ended --------------->'
                }
            }
        }

        stage('Docker Publish') {
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'
                    docker.withRegistry(registry, 'artifact-cred') {
                        app.push()
                    }
                    echo '<--------------- Docker Publish Ended --------------->'
                }
            }
        }
    }
}
