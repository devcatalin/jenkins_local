import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl
import hudson.util.Secret

def jenkins = Jenkins.getInstance()
def domain = Domain.global()
def credentialsStore = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

// Function to create or update credentials
def createOrUpdateCredentials = { String credId, String credDescription, String credSecret ->
    println "Processing credential: ${credId}"
    
    // Delete existing credential if it exists
    def existingCredentials = credentialsStore.getCredentials(domain).find { it.id == credId }
    if (existingCredentials) {
        credentialsStore.removeCredentials(domain, existingCredentials)
        println "Removed existing credential: ${credId}"
    }

    // Create new secret text credential
    def credentials = new StringCredentialsImpl(
        CredentialsScope.GLOBAL,
        credId,
        credDescription,
        Secret.fromString(credSecret)
    )
    
    credentialsStore.addCredentials(domain, credentials)
    println "Created/Updated credential: ${credId}"
}

// Read and parse the credentials file
def credentialsFile = new File('/var/jenkins_home/credentials.env')
if (credentialsFile.exists()) {
    println "Processing credentials from file..."
    
    credentialsFile.eachLine { line ->
        // Skip empty lines and comments
        if (line.trim() && !line.startsWith('#')) {
            def parts = line.split('=', 2)
            if (parts.length == 2) {
                def key = parts[0].trim()
                def value = parts[1].trim()
                // Remove surrounding quotes if they exist
                value = value.replaceAll('^["\']|["\']$', '')
                
                // Create credential with same ID as environment variable name
                createOrUpdateCredentials(
                    key,
                    "Automatically created credential for ${key}",
                    value
                )
            }
        }
    }
    println "Finished processing credentials file."
} else {
    println "Credentials file not found at: ${credentialsFile.absolutePath}"
}

// Save the Jenkins instance
jenkins.save()
println "Credentials creation process completed."