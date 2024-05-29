#!/bin/bash

# Path to your input file
input_file="/path/to/your/input.txt"

cckm_jenkins_token () {
  echo '=== retrieving jenkins token ==='
  CCKM_TOKEN=${JENKINS_TOKEN}
  CCKM_USER=${JENKINS_USER}
}

cckm_jenkins_run () {
  echo '=== running Jenkins job ==='
  CCKM_URL="http://localhost:8080/"
  
  # Use the generator function to read the file
  while IFS= read -r line
  do
    # Skip blank lines
    if [[ -n "$line" ]]; then
      # Split the line into parameters
      IFS=',' read -ra params <<< "$line"

      # Construct the command to trigger the Jenkins job
      cmd="${CCKM_URL}build?token=${CCKM_TOKEN}&job=blueprint-azure-state-tools&TYPE=${params[0]}&APP_REF=${params[1]}&BRANCH=${params[2]}&STATE_ADDRESS=${params[3]}&TO_STATE_ADDRESS=${params[4]}"

      # Trigger the Jenkins job and capture the return code
      QUEUE=$(curl -sIX POST --user ${CCKM_USER}:${CCKM_TOKEN} "${cmd}" | grep -F Location | cut -d' ' -f 2)
      QUEUE=${QUEUE%$'\r'}
      echo JENKINS_QUEUE_URL=${QUEUE}

      # loop and retrieve jenkins jobs url
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

      # Validate Jenkins job result
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

      # Wait for 30 seconds before triggering the next build
      sleep 30
    fi
  done < "$input_file"
}

# retrieving jenkin token to run jenkins job
cckm_jenkins_token

# run Jenkins job
cckm_jenkins_run
