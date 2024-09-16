#!/bin/bash

# Copy the Groovy script to JENKINS_HOME to ensure it runs every time
cp -f /usr/share/jenkins/ref/init.groovy.d/create_admin_user.groovy $JENKINS_HOME/init.groovy.d/

# Execute the original entrypoint script
exec /usr/bin/tini -- /usr/local/bin/jenkins.sh "$@"
