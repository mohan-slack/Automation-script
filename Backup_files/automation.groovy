//
String Parameter with Delimiter: 
    You can still use a string parameter and ask the user to input multiple values separated by a specific delimiter (like a comma). Then in your pipeline script, you can split the string into a list of values.
Active Choices Plugin: 
    You can use the Active Choices Plugin, which allows dynamic and interactive parameters. This plugin can create more complex parameters, like a dynamically updated list of checkboxes.
//

properties([
    parameters([
        string(name: 'resource_ids', defaultValue: 'id1,id2,id3', description: 'Comma-separated list of resource IDs'),
        // Add more parameters as needed...
    ])
])

node {
    stage('Run') {
        script {
            def resource_ids = params.resource_ids.split(',')
            resource_ids.each { id ->
                echo "Processing resource ID: ${id}"
                // Your code here...
            }
        }
    }
}

==============

properties([
    parameters([
        string(name: 'resource_ids', defaultValue: 'a,c,e', description: 'Comma-separated list of resource IDs'),
        string(name: 'to_resource_ids', defaultValue: 'b,d,f', description: 'Comma-separated list of target resource IDs'),
        // Add more parameters as needed...
    ])
])

node {
    stage('Run') {
        script {
            def resource_ids = params.resource_ids.split(',')
            def to_resource_ids = params.to_resource_ids.split(',')
            
            if (resource_ids.size() != to_resource_ids.size()) {
                error("The number of resource_ids and to_resource_ids must be the same.")
            }

            def mapping = [:]
            for (int i = 0; i < resource_ids.size(); i++) {
                mapping[resource_ids[i]] = to_resource_ids[i]
            }

            mapping.each { resource_id, to_resource_id ->
                echo "Processing resource ID: ${resource_id} to ${to_resource_id}"
                // Your code here...
            }
        }
    }
}
