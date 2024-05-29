There are a few ways to authenticate with Jenkins when triggering builds from a script. Here are two common methods:

1. 
    - Generate an API Token: First, you need to generate an API token from your Jenkins user profile. Here’s how you can do it:
        Log in to your Jenkins server.
        Click on your username in the top-right corner of the dashboard.
        Click on Configure (on the left side of the page).
        In the API Token section, click on Add New Token.
        Give your token a name and click on Generate.
        You will see your new API token. Copy it immediately as you won’t be able to see it again for security reasons.

    - **Username and API Token**: You can use Jenkins username and an API token for authentication. You can generate an API token from your Jenkins user profile page. Once you have the API token, you can pass it to the Jenkins CLI along with your username. Here's how you can modify the command in the script to include the username and API token:

    ```python
    cmd = f"java -jar jenkins-cli.jar -auth username:token -s http://localhost:8080/ build your_job_name -p TYPE={params[0]} -p APP_REF={params[1]} -p BRANCH={params[2]} -p STATE_ADDRESS={params[3]} -p TO_STATE_ADDRESS={params[4]}"
    ```

    Replace `username` with your Jenkins username and `token` with your API token.

2. **SSH Keys**: If your Jenkins server is configured to use SSH keys for authentication, you can use your private SSH key to authenticate with Jenkins CLI. You need to add your public SSH key to your Jenkins user profile. Here's how you can modify the command in the script to use SSH keys:

    ```python
    cmd = f"java -jar jenkins-cli.jar -ssh -user username -i /path/to/private/key -s http://localhost:8080/ build your_job_name -p TYPE={params[0]} -p APP_REF={params[1]} -p BRANCH={params[2]} -p STATE_ADDRESS={params[3]} -p TO_STATE_ADDRESS={params[4]}"
    ```

    Replace `username` with your Jenkins username and `/path/to/private/key` with the path to your private SSH key.

NOTE: We might need to be adjusted based on your specific Jenkins setup and job configuration. Always refer to the official Jenkins documentation for the most accurate information.