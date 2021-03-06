################################################
#  GITHUB ACTION WORKFLOW NAME
################################################
name: Release to beta/staging/test environment


################################################
#  GITHUB ACTION EVENT TRIGGER
################################################
on:
  workflow_dispatch:
  push:
    branches: [ 'master' ]
    

################################################
#  GITHUB ACTION JOBS
################################################
jobs:
  release-stage:
    name: release-stage
    runs-on: ubuntu-latest


################################################
#  GITHUB ACTIONS GLOBAL ENV VARIABLES  
################################################
    env:
      REGION : ap-southeast-2
      ENV : stage # Valid values are sandbox,stage,live only
      STACK_NAME: beta # Valid values are au,us,uk,p2,lf,nu,alpha,beta,shared only
      ROOTSTACK: app-v2
      CFNS3BucketName: devops-cfn-templates1
      PRIVATES3BucketName: devops-shared-private1
      PUBLICZONENAME: testing1234grwesdf.abc.com



################################################
#  GITHUB REPO CHECKOUT 
################################################
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0  # Shallow clones should be disabled for a better relevancy of analysis



# ################################################
# #  NODE ENV
# ################################################    
#       - name: Setup Node.js environment
#         uses: actions/setup-node@v2
#         with:
#           node-version: '14'
      

# ################################################
# #  NODE MODULES CACHE  
# ################################################
#       - name: Cache node modules
#         uses: actions/cache@v2
#         id: cache-node-modules
#         env:
#           cache-name: cache
#         with:
#           # npm cache files are stored in `~/.npm` on Linux/macOS
#           path: |
#             ~/.npm
#             node_modules
#             */*/node_modules
#           key: ${{ runner.os }}-build-${{ env.cache-name }}-${{ hashFiles('**/package.json') }}
#           restore-keys: |
#             ${{ runner.os }}-build-${{ env.cache-name }}-
#             ${{ runner.os }}-build-
#             ${{ runner.os }}-


# ################################################
# #  NODE MODULES INSTALL  
# ################################################
#       - name: Install dependencies
#         if: steps.cache-node-modules.outputs.cache-hit != 'true'
#         run:  npm install
      

# ################################################
# #  AWS CLI CONFIGURATION
# ################################################ 
#       - name: Configure AWS credentials from $STACK_NAME account in $REGION region
#         uses: aws-actions/configure-aws-credentials@v1
#         with:
#           aws-access-key-id: ${{ secrets.DEVOPS_AWS_KEY }}
#           aws-secret-access-key: ${{ secrets.DEVOPS_SECRET_KEY }}
#           aws-region: ${{ env.REGION }}


# ##########################################################
# #  AWS S3 SYNC - SERVERLESS TEMPLATES 
# ##########################################################
#       - name: AWS S3 Sync operation
#         run: |
#           mv new-serverless.yml serverless.yml
#           # aws s3 cp serverless.yml s3://$CFNS3BucketName/$STACK_NAME/$REGION/$ROOTSTACK/sls-templates/serverless.yml


###############################################################
#  SERVERLESS DEPLOYMENT
##############################################################
      - name: Serverless deployment
        run: |
          cat environment.custom.ts
          echo "*****************************************"
          echo "processing"
          chmod +x env.sh && ./env.sh
          echo "*****************************************"
          echo "processed"
          cat environment.custom.ts
        env:
          CUSTOM_APPKEY: app.${{ env.PUBLICZONENAME }}
          CUSTOM_PUSHERKEY: files.${{ env.PUBLICZONENAME }}
          CUSTOM_ENVIRONMENT: ${{ env.ENV }}


##########################################################
#  SLACK NOTIFICATION
##########################################################  
      # - name: Slack Notification
      #   if: always() # Pick up events even if the job fails or is canceled.
      #   uses: 8398a7/action-slack@v3
      #   env:
      #     SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
      #     MATRIX_CONTEXT: ${{ toJson(matrix) }} # required
      #   with:
      #     status: ${{ job.status }}
      #     author_name: ${{ env.ROOTSTACK }} deployed to ${{ env.ENV }} environemnt in ${{ env.STACK_NAME }} AWS account
      #     mention: 'here'
      #     if_mention: failure,cancelled
      #     job_name: release-stage # Match the name above.
      #     fields: repo,commit,eventName,ref,workflow,message,author,job,took
      #     custom_payload: |
      #       {
      #       username: 'GitHub Action CI WorkFlow',
      #       icon_emoji: ':github:',
      #       attachments: [{
      #         color: '${{ job.status }}' === 'success' ? 'good' : ${{ job.status }}' === 'failure' ? 'danger' : 'warning',
      #         text:
      #        `${process.env.AS_REPO}\n
      #         ${process.env.AS_COMMIT}\n
      #         ${process.env.AS_EVENT_NAME}\n
      #         @${process.env.AS_REF}\n
      #         @${process.env.AS_WORKFLOW}\n
      #         ${process.env.AS_MESSAGE}\n
      #         ${process.env.AS_AUTHOR}\n
      #         ${process.env.AS_JOB}\n
      #         ${process.env.AS_TOOK}`,
      #       }]
      #       }