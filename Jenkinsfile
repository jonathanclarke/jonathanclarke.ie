pipeline {
    agent { node { label 'banba' } } 
    stages {
        stage('CloudBuild') {
            steps {
		script {
                    echo 'CloudBuild'
                    if (env.GIT_BRANCH == 'origin/master' ) {
			withCredentials([[$class: 'FileBinding', credentialsId: 'banba-group-google-json', variable: 'GOOGLE_APPLICATION_CREDENTIALS']]) {
                            sh 'echo "${GOOGLE_APPLICATION_CREDENTIALS}"' // returns ****
                            sh 'gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS'
                            sh 'gcloud auth list'
                            sh 'gcloud config set project banba-group'
			    sh 'export APP=blog.beilabs.com'
                            sh 'ruby ./bin/check_build.rb'
			}
                    }
		}
            }
	}

        stage('K8 Deploy') {
            steps {
                script{
                    if (env.GIT_BRANCH == 'origin/master') {
                        echo 'Deploying master branch to K8 cluster'
			withCredentials([[$class: 'FileBinding', credentialsId: 'banba-group-google-json', variable: 'GOOGLE_APPLICATION_CREDENTIALS']]) {
                            sh 'echo "${GOOGLE_APPLICATION_CREDENTIALS}"' // returns ****
                            sh 'gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS'
                            sh 'gcloud auth list'
                            sh 'gcloud config set project banba-group'
			    sh 'gcloud container clusters get-credentials production --zone us-central1-a'
                            sh 'kubectl set image deployment blog-beilabs-com blog-beilabs-com=gcr.io/banba-group/blog-beilabs-com:${GIT_COMMIT}'
			}
                    }
                }
            }
	}
    }
}

