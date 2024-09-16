import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
def username = "admin"
def password = "admin"

println "Starting admin user setup..."

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
instance.setSecurityRealm(hudsonRealm)
println "Security realm set to HudsonPrivateSecurityRealm."

def user = instance.getSecurityRealm().createAccount(username, password)
user.save()
println "Admin user created: ${username}"

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)
println "Authorization strategy set."

instance.save()
println "Jenkins instance saved."