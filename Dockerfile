FROM jenkins/jenkins:lts

USER root

# Install Maven and other necessary tools
RUN apt-get update && \
    apt-get install -y maven curl

# Install Go
ENV GO_VERSION 1.23.1
RUN curl -OL https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# Copy the Groovy scripts
COPY create_admin_user.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY setup_go.groovy /usr/share/jenkins/ref/init.groovy.d/

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch back to the jenkins user
USER jenkins

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]