===================================================================
===================================================================
===========================LINUX===================================
===================================================================

    Step-by-step guide to install Jenkins CLI on a secured VM:

    1. **Download Jenkins CLI**: You can download the Jenkins CLI jar file from your Jenkins server. The URL is usually `http://your-jenkins-server/cli`. Replace `your-jenkins-server` with the actual URL of your Jenkins server. You can use `wget` or `curl` to download the file. For example:

        ```bash
        wget http://your-jenkins-server/cli -O jenkins-cli.jar
        ```

    2. **Install Java**: Jenkins CLI is a Java application, so you need to have Java installed on your VM. You can install it using the package manager of your Linux distribution. For example, on Ubuntu, you can use the following command:

        ```bash
        sudo apt update
        sudo apt install openjdk-11-jdk
        ```

    3. **Test Jenkins CLI**: You can test if Jenkins CLI is working correctly by running the following command:

        ```bash
        java -jar jenkins-cli.jar -s http://your-jenkins-server/ help
        ```

        This should display the help information of Jenkins CLI.

    4. **Configure Jenkins CLI**: If your Jenkins server is secured, you might need to authenticate when using Jenkins CLI. You can do this by passing your username and password or API token with each command, or you can use SSH keys for authentication. To use SSH keys, you need to add your public SSH key to your Jenkins user profile.

    Please replace `http://your-jenkins-server/` with your actual Jenkins server URL. Also, remember to replace `jenkins-cli.jar` with the path where you downloaded the Jenkins CLI jar file.

    NOTE: These steps might vary depending on the specific configuration of your VM and Jenkins server. Always refer to the official Jenkins documentation for the most accurate information.

===================================================================
===================================================================
===============================WINDOWS=============================
===================================================================    

    How to install and use Jenkins CLI on a Windows machine:

    1. **Download Jenkins CLI**: Open a web browser and navigate to `http://your-jenkins-server/cli`. Replace `your-jenkins-server` with the actual URL of your Jenkins server. This will download the Jenkins CLI jar file. Save it to a location on your machine, for example, `C:\jenkins-cli.jar`.

    2. **Install Java**: Jenkins CLI is a Java application, so you need to have Java installed on your machine. If you don't have it installed, you can download it from the [Oracle website](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) and follow the instructions to install it.

    3. **Test Jenkins CLI**: Open a command prompt and navigate to the location where you saved the Jenkins CLI jar file. You can test if Jenkins CLI is working correctly by running the following command:

        ```bash
        java -jar C:\jenkins-cli.jar -s http://your-jenkins-server/ help
        ```

        This should display the help information of Jenkins CLI.

    4. **Configure Jenkins CLI**: If your Jenkins server is secured, you might need to authenticate when using Jenkins CLI. You can do this by passing your username and password or API token with each command, or you can use SSH keys for authentication. To use SSH keys, you need to add your public SSH key to your Jenkins user profile.

    Please replace `http://your-jenkins-server/` with your actual Jenkins server URL. Also, remember to replace `C:\jenkins-cli.jar` with the path where you downloaded the Jenkins CLI jar file.

    NOTE: These steps might vary depending on the specific configuration of your machine and Jenkins server. Always refer to the official Jenkins documentation for the most accurate information. Let me know if you have any questions!