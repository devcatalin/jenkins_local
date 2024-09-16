import jenkins.model.*
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition

def jenkins = Jenkins.getInstance()
def pipelinesDir = new File("/var/jenkins_home/pipelines")

println "Starting pipeline creation/update process..."
println "Pipelines directory: ${pipelinesDir.absolutePath}"

if (!pipelinesDir.exists()) {
    println "Error: Pipeline directory does not exist: ${pipelinesDir.absolutePath}"
    return
}

if (!pipelinesDir.isDirectory()) {
    println "Error: Pipeline path is not a directory: ${pipelinesDir.absolutePath}"
    return
}

def pipelineFiles = pipelinesDir.listFiles()
println "Found ${pipelineFiles.size()} files in the pipelines directory"

pipelineFiles.each { file ->
    println "Processing file: ${file.name}"
    if (file.name.endsWith(".groovy")) {
        def jobName = file.name - ".groovy"
        def job = jenkins.getItem(jobName)
        
        if (job == null) {
            println "Creating pipeline job: ${jobName}"
            job = jenkins.createProject(WorkflowJob.class, jobName)
        } else {
            println "Updating existing pipeline job: ${jobName}"
        }
        
        job.setDefinition(new CpsFlowDefinition(file.text, true))
        job.save()
        println "Job ${jobName} saved successfully"
    } else {
        println "Skipping non-groovy file: ${file.name}"
    }
}

jenkins.save()
println "Pipeline creation/update process completed."