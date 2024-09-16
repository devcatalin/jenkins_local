#!/bin/bash
set -e

# Set correct permissions
chown -R jenkins:jenkins /var/jenkins_home/pipelines /var/jenkins_home/init.groovy.d

# Call the original Jenkins entrypoint
exec /usr/local/bin/jenkins.sh "$@"
