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
         environment {
           scannerHome = tool 'sonarqube'
         }
             steps{
             withSonarQubeEnv('sonarqube') { // If you have configured more than one global server connection, you can specify its name
               sh "${scannerHome}/bin/sonar-scanner"
             }
             }
         }
         stage("Quality Gate"){
             steps {
                 script {
                 timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
             def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
             if (qg.status != 'OK') {
             error "Pipeline aborted due to quality gate failure: ${qg.status}"
             }
         }
         }
             }
         }
//          stage("Jar Publish") {
//         steps {
//             script {
//                     echo '<--------------- Jar Publish Started --------------->'
//                      def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog_cred"
//                      def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
//                      def uploadSpec = """{
//                           "files": [
//                             {
//                               "pattern": "jarstaging/(*)",
//                               "target": "maven-libs-release-local/{1}",
//                               "flat": "false",
//                               "props" : "${properties}",
//                               "exclusions": [ "*.sha1", "*.md5"]
//                             }
//                          ]
//                      }"""
//                      def buildInfo = server.upload(uploadSpec)
//                      buildInfo.env.collect()
//                      server.publishBuildInfo(buildInfo)
//                      echo '<--------------- Jar Publish Ended --------------->'  
            
//             }
//         }   
//     }


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

//     stage("Create EKS Cluster") {
//     steps {
//         script {
//             echo '<--------------- Creating AWS EKS Cluster via Terraform --------------->'
//             dir('infra/eks') {
//                 sh 'terraform init'
//                 sh 'terraform apply -auto-approve'
//             }

//             def clusterName = "sample-eks-cluster"
//             def region = "us-east-1"

//             echo '<--------------- Waiting for EKS Control Plane to be ACTIVE --------------->'
//             timeout(time: 15, unit: 'MINUTES') {
//                 waitUntil {
//                     def status = sh(
//                         script: "aws eks describe-cluster --name ${clusterName} --region ${region} --query 'cluster.status' --output text",
//                         returnStdout: true
//                     ).trim()
//                     echo "Cluster status: ${status}"
//                     return (status == "ACTIVE")
//                 }
//             }

//             echo '<--------------- Updating kubeconfig --------------->'
//             sh "aws eks update-kubeconfig --name ${clusterName} --region ${region}"

//             echo '<--------------- Waiting for Node Group to be Ready --------------->'
//             timeout(time: 10, unit: 'MINUTES') {
//                 waitUntil {
//                     def nodes = sh(
//                         script: "kubectl get nodes --no-headers | grep ' Ready ' | wc -l",
//                         returnStdout: true
//                     ).trim()
//                     echo "Number of Ready Nodes: ${nodes}"
//                     return (nodes.toInteger() > 0)
//                 }
//             }

//             echo '<--------------- EKS Cluster and Node Group are Ready --------------->'
//         }
//     }
// }


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


