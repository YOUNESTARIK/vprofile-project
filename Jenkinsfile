pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        timeout(time: 10, unit: 'MINUTES')
    }

    stages {
        stage('Checkout du code') {
            steps {
                checkout scm
            }
        }

        stage('Verification du projet') {
            steps {
                sh '''
                    echo "Contenu du workspace Jenkins :"
                    ls -la

                    echo "Fichiers importants :"
                    test -f pom.xml
                    test -f Dockerfile
                    test -f compose.yml || echo "compose.yml manquant (pas bloquant pour le moment)"

                    echo "Projet VProfile bien recupere."
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline simple OK. Prochaine etape : ajouter le build Maven.'
        }
        failure {
            echo 'Le pipeline a echoue, regarde la Console Output.'
        }
        always {
            cleanWs()
        }
    }
}