FROM jenkins/jenkins:lts

USER root

# Install Maven and other necessary tools
RUN apt-get update && \
    apt-get install -y maven curl make

# Install Go
ENV GO_VERSION 1.23.1
RUN curl -OL https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# Create GOPATH directory and set permissions
RUN mkdir -p "$GOPATH" && \
    chown -R jenkins:jenkins "$GOPATH"

# Create a writable directory for Jenkins user
RUN mkdir -p /usr/local/bin && \
    chown -R jenkins:jenkins /usr/local/bin

# Copy plugins.txt
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Install plugins
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch back to the jenkins user
USER jenkins

# Skip the setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]