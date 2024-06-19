#!/bin/bash

# Path to your input file
input_file="/c/Users/428859/Work-notes/Automation-script-main/Automation/input.txt"

cckm_jenkins_token () {
  echo '=== retrieving jenkins token ==='
  CCKM_TOKEN="1183f38ce1a218085efe53306d326bf94a"
  # CCKM_USER="Thotli Mohan Reddy"
  CCKM_USER="thotlimohanreddy@prudential.com.sg"

  if [[ -z "$CCKM_TOKEN" || -z "$CCKM_USER" ]]; then
    echo "Error: JENKINS_USER and JENKINS_TOKEN must be set."
    exit 1
  fi
}

cckm_jenkins_run () {
  echo '=== running Jenkins job ==='
  CCKM_URL="https://jenkins.pruconnect.net/me/my-views/view/all/job/RT-SRE/job/PROD/job/infra/job/"
  
  # Check if input file exists
  if [[ ! -f "$input_file" ]]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
  fi

  # Use the generator function to read the file
  while IFS= read -r line
  do
    # Skip blank lines
    if [[ -n "$line" ]]; then
      # Split the line into parameters
      IFS=',' read -ra params <<< "$line"

      # Construct the command to trigger the Jenkins job (Provided default/direct value for Job)
      cmd="${CCKM_URL}blueprint-azure-state-tools/build?token=${CCKM_TOKEN}&job=blueprint-azure-state-tools&TYPE=${params[0]}&APP_REF=${params[1]}&BRANCH=${params[2]}&STATE_ADDRESS=${params[3]}&TO_STATE_ADDRESS=${params[4]}"

      # Trigger the Jenkins job and capture the return code
      QUEUE=$(curl -v -sIX POST --user ${CCKM_USER}:${CCKM_TOKEN} "${cmd}" | grep -F Location | cut -d' ' -f 2)
      QUEUE=${QUEUE%$'\r'}
      echo JENKINS_QUEUE_URL=${QUEUE}

      # loop and retrieve jenkins jobs url
      COUNTER=0
      JOB_NO=$null
      while [[ -z $JOB_NO && $COUNTER -lt 5 ]]
      do
        echo "Waiting for job to be queued..."
        JOB_NO=$(curl -sk --user ${CCKM_USER}:${CCKM_TOKEN} "${QUEUE}api/json" | jq -r '.executable.number')
        sleep 2
        let $((COUNTER++))
      done
      echo "JOB_ID: ${JOB_NO}"
      JOB_ID+=" $JOB_NO"
      let $((INDEX++))

      # Validate Jenkins job result
      for i in $JOB_ID
      do
        COUNTER=0
        JENKINS_JOB_STATUS="NotStarted"
        echo validating job status:
        echo JOB_URL=${CCKM_URL}/${i}/api/json
        while [ "$JENKINS_JOB_STATUS" != "\"SUCCESS\"" ] && [ $COUNTER -lt 5 ]
        do
          JENKINS_JOB_STATUS=$(curl -sk "${CCKM_URL}/${i}/api/json" --user "${CCKM_USER}:${CCKM_TOKEN}" | jq '.result')
          echo "Jenkins job status: $JENKINS_JOB_STATUS"
          if [ "$JENKINS_JOB_STATUS" == "\"FAILURE\"" ]; then
            echo "Error: Jenkins job failed for the line: $line"
            exit 1
          fi
          let $((COUNTER++))
          sleep 5
        done
      done

      # Wait for 30 seconds before triggering the next build
      sleep 30
    fi
  done < "$input_file"
}

# retrieving jenkin token to run jenkins job
cckm_jenkins_token

# run Jenkins job
cckm_jenkins_run
