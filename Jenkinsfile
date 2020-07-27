node {
    // wipe the workspace
    deleteDir()
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId:'docker-creds',usernameVariable: 'DOCKERUSER', passwordVariable: 'DOCKERPASS'], [$class: 'UsernamePasswordMultiBinding', credentialsId:'aws-creds',usernameVariable: 'AWS_ACCESS_KEY', passwordVariable: 'AWS_SECRET_KEY']]) {

                stage('git clone') {
                    def returnCode = sh returnStatus: true, script: '''#!/bin/bash
                      git clone https://github.com/vtejuops/eks-demo.git
                      '''

                    if (returnCode != 0) {
                        error("git clone failed.")
                    }
                }

                stage('Prep') {
                    def returnCode = sh returnStatus: true, script: '''#!/bin/bash
                      cd eks-demo
                      echo "aws_access_key = \\"${AWS_ACCESS_KEY}\\"" >> terraform.tfvars
                      echo "aws_secret_key = \\"${AWS_SECRET_KEY}\\"" >> terraform.tfvars
                      echo "docker_user = \\"${DOCKERUSER}\\"" >> terraform.tfvars
                      echo "docker_password = \\"${DOCKERPASS}\\"" >> terraform.tfvars
                      '''

                    if (returnCode != 0) {
                        error("Prep failed.")
                    }
                }
                
                stage('deploy eks cluster') {
                  def returnCode = sh returnStatus: true, script: '''#!/bin/bash
                    echo "Deploying eks cluster"
                    cd eks-demo
                    unset TF_LOG
                    make planekscluster deployekscluster
                    '''

                  if (returnCode != 0) {
                      error("deploy eks cluster failed.")
                  }
                }
                stage('buildimage') {
                  def returnCode = sh returnStatus: true, script: '''#!/bin/bash
                      echo "Building Dragonfly docker image"
                      cd eks-demo
                      make buildimage
                    '''

                  if (returnCode != 0) {
                      error("buildimage failed.")
                  }
                }
                stage('publishimage') {
                  def returnCode = sh returnStatus: true, script: '''#!/bin/bash
                      echo "Publish Dragonfly docker image to docker hub"
                      cd eks-demo
                      make publishimage
                    '''

                  if (returnCode != 0) {
                      error("publishimage failed.")
                  }
                }
                stage('deploypod') {
                  def returnCode = sh returnStatus: true, script: '''#!/bin/bash
                      echo "Deploy dragon pod in eks cluster"
                      cd eks-demo
                      make deploypod
                    '''

                  if (returnCode != 0) {
                      error("deploypod failed.")
                  }
                }

                stage('podhealthcheck') {
                  def returnCode = sh returnStatus: true, script: '''#!/bin/bash
                      echo "Testing the app by using curl"
                      sleep 30
                      cd eks-demo
                      make podhealthcheck
                    '''

                  if (returnCode != 0) {
                      error("podhealthcheck failed.")
                  }
                }
        }
}
