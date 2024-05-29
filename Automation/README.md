---
Shell Scripting-README.md

#Jenkins Job Trigger and Monitor Script
This Bash script interacts with a Jenkins server to trigger and monitor jobs based on an input file.

##Prerequisites

1. **Bash Shell**: This script is written in Bash, so you need a Unix-like environment to run it. If you’re on Windows, you can use WSL (Windows Subsystem for Linux) or Git Bash.

2. **Jenkins Server**: The script interacts with a Jenkins server, so you need to have a Jenkins server running and accessible. The script assumes the server is running on http://localhost:8080/.

3. **Jenkins User and Token**: You need a Jenkins user and a corresponding `API token`. These are used to authenticate with the Jenkins server. The script expects these to be set in the `JENKINS_USER` and `JENKINS_TOKEN` environment variables.

4. **Curl and Jq**: The script uses `curl` to make HTTP requests and `jq` to parse JSON responses. These tools must be installed on your system.

5. **Input File**: The script reads from an input file specified in the input_file variable. This file should contain the parameters for the Jenkins jobs, with each line representing a different job and the parameters separated by commas.

## Usage

1. **Prepare Your Input File**: Create your .txt file with the input values for the Jenkins job. Each line should contain the input values for one build.

```
state-mv.txt
```

2. Replace `"/path/to/your/input.txt"` in the script with the actual path to your input file. The input file should contain the parameters for the Jenkins job, one set of parameters per line, with parameters separated by commas.

3. If your Jenkins server is located at a different URL or if the job name is different, adjust these values in the script.

```
CCKM_URL="http://localhost:8080/"  ====> Change This to "blueprint-azure-state-tools" job URL
```

4. Set the `JENKINS_USER` and `JENKINS_TOKEN` environment variables to your Jenkins username and API token.

```
export JENKINS_USER=Mohan.reddy
export JENKINS_TOKEN=abcdxxxxxxxxxxxxxxxxyz
```

5. If your Jenkins job requires different parameters, adjust the `cmd` string construction accordingly.

6. Make sure the script has execute permissions. You can add execute permissions using the command `chmod +x script.sh`.

7. Run the script with `./script.sh`.

NOTE: The script will then retrieve the Jenkins token, trigger the Jenkins jobs as specified in the input file, and monitor their status. It will wait for 30 seconds before triggering the next build.

##Error Handling

Environment Variables: The script checks if the JENKINS_USER and JENKINS_TOKEN environment variables are set. If not, it prints an error message and exits.
Input File Existence: The script checks if the input file specified in the input_file variable exists. If not, it prints an error message and exits.
Job Execution: The script monitors the status of the Jenkins jobs it triggers. If a job fails, the script prints an error message along with the line from the input file for which the job has failed, and then it exits.
Secure Communication: Always use HTTPS for production Jenkins servers to ensure secure communication.

## Feature Enhancements

1. Currently we have developed script only for `"state-mv"`
2. Post successfull we will be updating/adding rest of the TYPE's.

---