---

# Jenkins Job Trigger Script

This Python script reads input values from a .txt file and triggers a Jenkins job every 30 seconds until all input values are used.

## Prerequisites

- Jenkins CLI installed on your machine (tool for interacting with Jenkins servers)
- Java installed on your machine
- A Jenkins server with a job configured to accept the input values from the .txt file
- Necessary permissions to execute the Jenkins job

## Input File Format

The input file should be a .txt file with each line containing the input values for one Jenkins job. The parameters should be separated by commas. Here's an example:

```
state-mv,my_app,my_branch,my_state_address1,my_to_state_address1

state-mv,my_app,my_branch,my_state_address2,my_to_state_address2
```

## How to Use

1. **Prepare Your Input File**: Create your .txt file with the input values for the Jenkins job. Each line should contain the input values for one build.

```
state-mv.txt
```

2. **Update the Script**: Open the Python script and replace `"http://localhost:8080/"` with your Jenkins server URL and `"your_job_name"` with your actual Jenkins job name. Also, replace `"/path/to/your/input.txt"` with the path to your input file.

3. **Run the Script**: Open a command prompt or terminal, navigate to the location of the Python script, and run the following command:

    ```bash
    python script.py
    ```

    Replace `script.py` with the name of your Python script.

The script will trigger the Jenkins job every 30 seconds with the next input values from the .txt file until all input values are used.

## Error Handling

The script checks the return code of each Jenkins job. If a job fails, the script prints an error message and stops. You can modify the error handling code to meet your needs (e.g., retry the failed job, skip it and move on to the next one, or stop the script entirely).

## Feature Enhancements

1. Currently we have developed script only for `"state-mv"`
2. Post successfull we will be updating/adding rest of the TYPE's.
---