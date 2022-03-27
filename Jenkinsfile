def VERSION = "${env.BUILD_NUMBER}"
def DIST_ARCHIVE = "dist.${env.BUILD_NUMBER}"
def S3_BUCKET = 'angular-prod-deploy'

pipeline {
    agent any
    tools { nodejs "Angular Project" }

    stages {
        stage('NPM Install') {
            steps {
                script {
                    notifyBitbucket(buildStatus: 'INPROGRESS')
                }
                sh 'npm install --verbose -d'
            }
        }
        stage('Test') {
            steps {
                sh 'npm run test'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Archive') {
            steps {
              sh "cd dist && zip -r ../${DIST_ARCHIVE}.zip . && cd .."
              archiveArtifacts artifacts: "${DIST_ARCHIVE}.zip", fingerprint: true
            }
        }
        stage('Deploy') {
            steps {
                sshagent(['ansible_demo']){
                    sh "ssh ec2-user@3.87.47.98 rm -rf /var/www/temp_deploy/dist/"
                    sh "ssh ec2-user@3.87.47.98 rmkdir -p /var/www/temp_deploy"
                    sh "scp -r dist ec2-user@3.87.47.98:/var/www/temp_deploy/dist/"
                    sh "ssh user@server “rm -rf /var/www/example.com/dist/ && mv /var/www/temp_deploy/dist/ /var/www/example.com/”"
                }
                
            }
        }
    }
}