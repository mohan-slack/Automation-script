#!/bin/bash
 
echo "##########################"
echo "# CCKM PIPELINE requires TFVARS value for keyvault and byok"
echo "# tfvars values should NOT have any comment '#' or '//'"
echo "##########################"
 
cckm_jenkins_token () {
  echo '=== retrieving jenkins token ==='
  CCKM_TOKEN=${JENKINS_TOKEN}
  CCKM_USER=${JENKINS_USER}
}
 
cckm_cluster_jenkins_run () {
  echo '=== running RITS-CCKM-Prod-KeyGen-With-Cluster ==='
  CCKM_URL="https://jenkins.pruconnect.net/job/RITS/job/DataSec/job/RITS-CCKM-Prod-KeyGen-WithCluster"
  ## Run Jenkins job
  ## retrieve jenkins_job_id using jenkin queue url
  for KEYNAME in ${KEYNAMES[@]}
  do
    echo debug: CCKM_KEYNAME=CCKM-${TF_VAR_app_ref:-$APP_REF}-${KEYNAME}
    echo debug: curl -sIX POST --user ${CCKM_USER}:CCKM_TOKEN "${CCKM_URL}/buildWithParameters?TenantName=${TF_VAR_buAdCode:-$APP_LBU}${TF_VAR_environment:-$APP_ENV}&KeyVaultName1=${KEYVAULT_AZ1}&KeyVaultName2=${KEYVAULT_AZ2}&KeyName=CCKM-${TF_VAR_app_ref:-$APP_REF}-${KEYNAME}&KeyTag=${subscription:-$APP_SUBSCRIPTION}-${TF_VAR_app_ref:-$APP_REF}"
    QUEUE=$(curl -sIX POST --user ${CCKM_USER}:${CCKM_TOKEN} "${CCKM_URL}/buildWithParameters?TenantName=${TF_VAR_buAdCode:-$APP_LBU}${TF_VAR_environment:-$APP_ENV}&KeyVaultName1=${KEYVAULT_AZ1}&KeyVaultName2=${KEYVAULT_AZ2}&KeyName=CCKM-${TF_VAR_app_ref:-$APP_REF}-${KEYNAME}&KeyTag=${subscription:-$APP_SUBSCRIPTION}-${TF_VAR_app_ref:-$APP_REF}" | grep -F Location | cut -d' ' -f 2)
    QUEUE=${QUEUE%$'\r'}
    echo JENKINS_QUEUE_URL=${QUEUE}
 
    ## loop and retrieve jenkins jobs url
    COUNTER=0
    JOB_NO=$null
    while [[ -z $JOB_NO && $COUNTER -lt 10 ]]
    do
      echo "Waiting for job to be queued..."
      JOB_NO=$(curl -sk --user ${CCKM_USER}:${CCKM_TOKEN} "${QUEUE}api/json" | jq -r '.executable.number')
      sleep 2
      let $((COUNTER++))
    done
    echo "JOB_ID: ${JOB_NO}"
    JOB_ID+=" $JOB_NO"
    let $((INDEX++))
  done
 
  ## Validate Jenkins job result
  for i in $JOB_ID
  do
    COUNTER=0
    JENKINS_JOB_STATUS="NotStarted"
    echo validating job status:
    echo JOB_URL=${CCKM_URL}/${i}/api/json
    while [ "$JENKINS_JOB_STATUS" != "\"SUCCESS\"" ] && [ $COUNTER -lt 20 ]
    do
      JENKINS_JOB_STATUS=$(curl -sk "${CCKM_URL}/${i}/api/json" --user "${CCKM_USER}:${CCKM_TOKEN}" | jq '.result')
      echo "Jenkins job status: $JENKINS_JOB_STATUS"
      let $((COUNTER++))
      sleep 5
    done
  done
}
 
cckm_nocluster_jenkins_run () {
  echo '=== running RITS-CCKM-Prod-KeyGen-WithoutCluster ==='
  CCKM_URL="https://jenkins.pruconnect.net/job/RITS/job/DataSec/job/RITS-CCKM-Prod-KeyGen-WithoutCluster"
  ## retrieve CCKM keyname form terraform.tfvars file
  KEYNAME=$(grep -m1 -w byok_key_purpose ./terraform.tfvars | cut -d" " -f 3 | sed 's/[^[:alnum:]]//g')
  echo debug: CCKM_KEYNAME=CCKM-${TF_VAR_app_ref:-$APP_REF}-${KEYNAME}
  echo debug: curl -sIX POST --user ${CCKM_USER}:CCKM_TOKEN "${CCKM_URL}/buildWithParameters?TenantName=${TF_VAR_buAdCode:-$APP_LBU}${TF_VAR_environment:-$APP_ENV}&KeyVaultName1=${KEYVAULT_NAME}&KeyName=CCKM-${TF_VAR_app_ref:-$APP_REF}-${KEYNAME}&KeyTag=${subscription:-$APP_SUBSCRIPTION}-${TF_VAR_app_ref:-$APP_REF}"
  QUEUE=$(curl -sIX POST --user ${CCKM_USER}:${CCKM_TOKEN} "${CCKM_URL}/buildWithParameters?TenantName=${TF_VAR_buAdCode:-$APP_LBU}${TF_VAR_environment:-$APP_ENV}&KeyVaultName1=${KEYVAULT_NAME}&KeyName=CCKM-${TF_VAR_app_ref:-$APP_REF}-${KEYNAME}&KeyTag=${subscription:-$APP_SUBSCRIPTION}" | grep -F Location | cut -d' ' -f 2)
  QUEUE=${QUEUE%$'\r'}
  echo JENKINS_QUEUE_URL=${QUEUE}
  ## retrieve jenkins queue
  ## curl jenkins job id using jenkins queue url
  COUNTER=0
  JOB_NO=$null
  while [[ -z $JOB_NO && $COUNTER -lt 10 ]]
  do
    echo "Waiting for job to be queued..."
    JOB_NO=$(curl -sk --user ${CCKM_USER}:${CCKM_TOKEN} "${QUEUE}api/json" | jq -r '.executable.number')
    sleep 2
    let $((COUNTER++))
  done
 
  echo "validating job status:"
  echo "JOB_URL=${CCKM_URL}/${JOB_NO}"
  COUNTER=0
  JENKINS_JOB_STATUS="NotStarted"
  while [ "$JENKINS_JOB_STATUS" != "\"SUCCESS\"" ] && [ $COUNTER -lt 10 ]
  do
    JENKINS_JOB_STATUS=$(curl -sk "${CCKM_URL}/${JOB_NO}/api/json" --user "${CCKM_USER}:${CCKM_TOKEN}" | jq '.result')
    echo "Jenkins job status: $JENKINS_JOB_STATUS"
    let $((COUNTER++))
    sleep 5
  done
}
 
# retrieving parameter for CCKM jenkins jobs
KEYNAMES=$(grep byok_key_purpose ./terraform.tfvars | tr -d ' ' | cut -d'"' -f 2)
KEYVAULT=$(grep -w -m1 keyvault_id ./terraform.tfvars | cut -d '"' -f 2 | awk -F '/' '{print $NF}')
KEYVAULT_AZ1=$(grep -w -m1 keyvault_id_az1 ./terraform.tfvars | cut -d '"' -f 2 | awk -F '/' '{print $NF}')
KEYVAULT_AZ2=$(grep -w -m1 keyvault_id_az2 ./terraform.tfvars | cut -d '"' -f 2 | awk -F '/' '{print $NF}')
 
# retrieving jenkin token to run jenkins job
cckm_jenkins_token
 
 
if [[ $KEYVAULT_AZ1 && $KEYVAULT_AZ2 ]]; then
  # run cckm_cluster_function
  cckm_cluster_jenkins_run
elif [[ $KEYVAULT_AZ1 ]]; then
  # run cckm_nocluster_function
  KEYVAULT_NAME=$KEYVAULT_AZ1
  cckm_nocluster_jenkins_run
elif [[ $KEYVAULT_AZ2 ]]; then
  # run cckm_nocluster_function
  KEYVAULT_NAME=$KEYVAULT_AZ2
  cckm_nocluster_jenkins_run
elif [[ $KEYVAULT ]]; then
  # run cckm_cluster_function
  # this to support olde blueprint that only supplied with "keyvault_id" in the tfvars
  KEYVAULT_NAME=$KEYVAULT
  cckm_nocluster_jenkins_run
else
  echo "###########################################################################################################"
  echo ERROR: Missing TFVARS in 'terraform.tfvars' e.g. 'byok_key_purpose', 'keyvault_id_az1', or 'keyvault_id_az2'
  echo "###########################################################################################################"
fi
