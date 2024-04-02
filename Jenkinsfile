pipeline {
    agent {label 'jenkins'}
    triggers {
        pollSCM('* * * * *') 
    }
    stages {
        stage('vcs') {
            steps {
                git url: 'https://github.com/AJA1811/Project1.git', 
                branch: 'ansible',
                credentialsId: 'github'
            }
        }
        stage('deploy') {
            steps {
                sh '''
                   ansible-playbook -i hosts project1.yml
                '''
            }
        }    
    }
}
