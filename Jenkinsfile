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
                    
                    timeout(time: 30, unit: 'MINUTES') {  // Set a timeout for the stage
                    def maxRetries = 10  // Set the maximum number of retries (i.e., check up to 6 times)
                    def waitTime = 10    // Wait for 10 seconds between retries
                    def qgStatus = 'NONE'

                    // Retry loop for checking quality gate status
                    for (int i = 0; i < maxRetries; i++) {
                        echo "Checking Quality Gate status (Attempt ${i + 1} of ${maxRetries})..."
                    
                        // Call waitForQualityGate and get the status
                        def qg = waitForQualityGate()

                        // Check the status of the quality gate
                        qgStatus = qg.status

                        if (qgStatus == 'OK') {
                            echo "Quality Gate passed: ${qgStatus}"
                            break  // Break the loop if the status is OK
                        } else {
                            echo "Quality Gate is still pending or failed. Retrying in ${waitTime} seconds..."
                            sleep(waitTime)  // Wait for 10 seconds before retrying
                        }
                    }

                    // Final check after retries
                    if (qgStatus != 'OK') {
                    error "Pipeline aborted due to quality gate failure: ${qgStatus}"
                    }                    
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


