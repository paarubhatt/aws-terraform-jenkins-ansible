def registry = 'https://trialvgx1i7.jfrog.io'
def imageName = 'trialvgx1i7.jfrog.io/mayu-docker-local/sample_app'
def version   = '1.0.0'
pipeline {
    agent {
        node {
            label 'agent-1'
        }
    }
environment {
    PATH = "/opt/apache-maven-3.9.4/bin:$PATH"
}
    stages {
        stage("build"){
            steps {
                 echo "----------- build started ----------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                 echo "----------- build complted ----------"
            }
        }
         stage("test"){
             steps{
                 echo "----------- unit test started ----------"
                 sh 'mvn surefire-report:report'
                  echo "----------- unit test Complted ----------"
             }
         }

         stage('SonarQube analysis') {
            steps{
                withSonarQubeEnv('sonarqubeScanner') {
                        sh '''mvn clean verify sonar:sonar '''
                }
            }
         }

        stage("Quality Gate"){
            steps {
                script {
                    script {
                        echo "<--------------- Quality Gate Started --------------->"
                        // Set a shorter timeout (e.g., 15 minutes)
                        timeout(time: 15, unit: 'MINUTES') { 
                            try {
                                // Wait for SonarQube quality gate to complete
                                def qg = waitForQualityGate()
                    
                                // Log the quality gate status for troubleshooting
                                echo "Quality Gate Status: ${qg.status}"
                    
                                // If the status is not 'OK', fail the pipeline
                                if (qg.status != 'OK') {
                                    error "Pipeline aborted due to quality gate failure: ${qg.status}"
                                } else {
                                    echo "Quality Gate passed successfully!"
                                }
                            } catch (Exception e) {
                                // Handle any exception that may occur and print the error
                                error "An error occurred while waiting for the Quality Gate: ${e.message}"
                            }
                        }
                        echo "<--------------- Quality Gate Ended --------------->"
                    }
                }
            }
        }
        
        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog_cred"
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "maven-libs-release-local/{1}",
                                "flat": "false",
                                "props" : "${properties}",
                                "exclusions": [ "*.sha1", "*.md5"]
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


//     stage(" Docker Build ") {
//       steps {
//         script {
//            echo '<--------------- Docker Build Started --------------->'
//            app = docker.build(imageName+":"+version)
//            echo '<--------------- Docker Build Ends --------------->'
//         }
//       }
//     }

//             stage (" Docker Publish "){
//         steps {
//             script {
//                echo '<--------------- Docker Publish Started --------------->'  
//                 docker.withRegistry(registry, 'jfrog_cred'){
//                     app.push()
//                 }    
//                echo '<--------------- Docker Publish Ended --------------->'  
//             }
//         }
//     }



//     // stage (" Deploy "){
//     //     steps {
//     //         script {
//     //            sh './deploy.sh'  
//     //         }
//     //     }
//     // }

// stage(" Deploy ") {
//        steps {
//          script {
//             echo '<--------------- Helm Deploy Started --------------->'
//             sh 'helm install sample-app sample-app-1.0.1'
//             echo '<--------------- Helm deploy Ends --------------->'
//          }
//        }
// }  
}
}


