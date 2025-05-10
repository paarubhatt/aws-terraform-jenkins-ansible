def registry = 'https://trialy49gxb.jfrog.io'
def imageName = 'trialy49gxb.jfrog.io/docker-local/sample_app'
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
        
        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog-credential"
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "maven-libs-release-locall/{1}",
                                "flat": "false",
                                "props": "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}",
                                "exclusions": [ "*.sha1", "*.md5"]
                             }
                        ]
                    }"""

                    def buildInfo = server.upload spec: uploadSpec
                    buildInfo.env.capture = true
                    server.publishBuildInfo buildInfo

                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }


     stage(" Docker Build ") {
       steps {
         script {
            echo '<--------------- Docker Build Started --------------->'
            app = docker.build(imageName+":"+version)
            echo '<--------------- Docker Build Ends --------------->'
         }
       }
     }

             stage (" Docker Publish "){
         steps {
             script {
                echo '<--------------- Docker Publish Started --------------->'  
                 docker.withRegistry(registry, 'jfrog_cred'){
                     app.push()
                 }    
                echo '<--------------- Docker Publish Ended --------------->'  
             }
         }
     }



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


