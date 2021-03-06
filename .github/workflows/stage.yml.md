################################################
#  GITHUB ACTION WORKFLOW NAME
################################################
name: Release to Staging environment


################################################
#  GITHUB ACTION EVENT TRIGGER
################################################
on:
  workflow_dispatch:
  push:
    branches: [ 'trunk' ]
    # branches: [ 'master' ]
    

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
      


################################################
#  GITHUB REPO CHECKOUT 
################################################
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0  # Shallow clones should be disabled for a better relevancy of analysis



###########################==5.3.1#####################
#  AWS CLI CONFIGURATION - Primary
################################################ 
      - name: Configure AWS credentials from $STACK_NAME account in $REGION region
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.DEVOPS_AWS_KEY }}
          aws-secret-access-key: ${{ secrets.DEVOPS_SECRET_KEY }}
          aws-region: ${{ env.REGION }}





##########################################################
#  AWS S3 ls- master 
##########################################################
      - name: AWS S3 master 
        run: |
          aws configure list
          aws iam get-user
          aws s3 ls




# #######################################################
# #  retrieve
# ######################################################
      - name: Export CFN output values only if ISZONEEXIST is false  
        run: |
          echo "AWS_ACCESS_KEY_ID="$(aws secretsmanager get-secret-value --secret-id beta-AWSAccountID-stage | jq --raw-output '.SecretString' | jq -r .TESTA) >> GITHUB_ENV
          echo "AWS_SECRET_ACCESS_KEY="$(aws secretsmanager get-secret-value --secret-id beta-AWSAccountID-stage | jq --raw-output '.SecretString' | jq -r .TESTS) >> GITHUB_ENV



      # - name: Unset AWS creds env vars
      #   run: |
      #     echo "AWS_ACCESS_KEY_ID="$TESTA>> $GITHUB_ENV
      #     echo "AWS_SECRET_ACCESS_KEY="$TESTS >> $GITHUB_ENV

# ################################################
# #  AWS CLI CONFIGURATION - Current
# ################################################ 
#       - name: Configure AWS credentials from P1 AU account
#         uses: aws-actions/configure-aws-credentials@v1
#         with:
#           aws-access-key-id: ${{ env.TESTA }}
#           aws-secret-access-key: ${{ env.TESTS }}
#           aws-region: ap-southeast-2


# ##########################################################
# #  AWS EC2 KEY PAIR CREATION
# ########################################################## 
#       - name: Create AWS EC2 Key Pair Name for $STACK_NAME account in $REGION region if not exist
#         run: |
#           chmod +x scripts/cfn-ec2-key-pair.sh && scripts/cfn-ec2-key-pair.sh



##########################################################
#  AWS S3 ls test
##########################################################
      - name: TEST ACC
        run: |
          aws configure list
          aws iam get-user
          aws s3 ls 


##########################################################
#  echo hello
##########################################################
      - name: echo hello
        run: |
          echo $TESTA
          echo $TESTS
          echo "hello"
          echo ${{ env.TESTA }}
          echo ${{ env.TESTS }}



# #######################################################
# #  2.b ROUTE53 NS RECORD UPDATE in P1
# ######################################################
#       - name: Export CFN output values only if ISZONEEXIST is false
#         if: env.ISZONEEXIST == 'false'
#         run: |
#           export ZONEID=$STACK_NAME-PublicHostedZoneId-$ENV
#           export NSRECORD=$STACK_NAME-PublicHostedZoneNSRecord-$ENV
#           echo "PUBLICZONEID="$(aws cloudformation list-exports --query "Exports[?Name==\`$ZONEID\`].Value" --no-paginate --output text) >> $GITHUB_ENV
#           echo "PUBLICZONENSRECORD="$(aws cloudformation list-exports --query "Exports[?Name==\`$NSRECORD\`].Value" --no-paginate --output text) >> $GITHUB_ENV



