import time
import subprocess

# Path to your input file
input_file = "/path/to/your/input.txt"

# Define a generator function to read the file line by line
def read_file_line_by_line(file_path):
    with open(file_path, 'r') as file:
        for line in file:
            # Skip blank lines
            if line.strip():
                yield line.strip()
                
# Use the generator function to read the file
for line in read_file_line_by_line(input_file):
    # Split the line into parameters
    params = line.split(',')

    # Construct the command to trigger the Jenkins job
    cmd = f"java -jar jenkins-cli.jar -s http://localhost:8080/ build blueprint-azure-state-tools -p TYPE={params[0]} -p APP_REF={params[1]} -p BRANCH={params[2]} -p STATE_ADDRESS={params[3]} -p TO_STATE_ADDRESS={params[4]}"
    
    # Method-1: Username and API Token (Authendication to Jenkins)
    # Replace "username" with your Jenkins username and "token" with your API token.
    # cmd = f"java -jar jenkins-cli.jar -auth username:token -s http://localhost:8080/ build blueprint-azure-state-tools -p TYPE={params[0]} -p APP_REF={params[1]} -p BRANCH={params[2]} -p STATE_ADDRESS={params[3]} -p TO_STATE_ADDRESS={params[4]}"
    
    # Method-2: SSH Keys (Authendication to Jenkins)
    # Replace "username" with your Jenkins username and "/path/to/private/key" with the path to your private SSH key.
    # cmd = f"java -jar jenkins-cli.jar -ssh -user username -i /path/to/private/key -s http://localhost:8080/ build blueprint-azure-state-tools -p TYPE={params[0]} -p APP_REF={params[1]} -p BRANCH={params[2]} -p STATE_ADDRESS={params[3]} -p TO_STATE_ADDRESS={params[4]}"

    # Trigger the Jenkins job and capture the return code
    result = subprocess.run(cmd, shell=True)

    # Check the return code
    if result.returncode != 0:
        print(f"Jenkins job failed with exit status {result.returncode}")
        # Handle the failure (e.g., retry, skip, or stop the script)
        break

    # Wait for 30 seconds before triggering the next build
    time.sleep(30)
