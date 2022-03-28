
node {

    
    try {
        notify('INITIALIZED')
    
        stage('Git Checkout'){
            git 'https://github.com/Uokereh/Angular-HelloWorld-master.git'
        }
    

        stage('NPM Install') {
            sh 'npm install'
        }
        
        stage('Build') {
            sh 'npm run build'
            sh 'npm run ng build'
        }

        stage('Deploy') {
            sshagent(['apache']){
                sh 'ssh -o StrictHostKeyChecking=no ec2-user@52.23.172.246 "rm -rf /var/www/html/dist/"'
                sh 'ssh -o StrictHostKeyChecking=no ec2-user@52.23.172.246 "mkdir -p /var/www/html"'
                sh 'scp -r ${WORKSPACE}/dist/* ec2-user@52.23.172.246:/var/www/html/'
            }
                
        }   
    } catch (e) {
            currentBuild.result = "FAILED"
            throw e
    } finally {
            notify(currentBuild.result)
    }
}

def notify(String buildStatus) {
            
    // send to email
    emailext (
        subject: "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: """<p>${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
        to: "joelbenisrael88@gmail.com",
        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
    )
}
