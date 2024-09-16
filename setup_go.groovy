import jenkins.model.*
import hudson.tools.*
import hudson.plugins.golang.GolangInstallation

def instance = Jenkins.getInstance()

def descriptor = instance.getDescriptor("hudson.plugins.golang.GolangInstallation")

def installations = descriptor.getInstallations()

def goInstallation = new GolangInstallation("go1.23.1", "/usr/local/go", [])

if (installations.find { it.name == "go1.23.1" }) {
    println "Go 1.23.1 installation already exists."
} else {
    installations += goInstallation
    descriptor.setInstallations(installations)
    descriptor.save()
    println "Go 1.23.1 installation added."
}

instance.save()
