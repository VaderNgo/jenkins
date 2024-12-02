FROM jenkins/jenkins:lts

# Switch to root to install additional tools
USER root

# Install Docker CLI and Docker Compose
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
RUN echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CLI
RUN apt-get update && apt-get install -y \
    docker-ce-cli \
    docker-compose-plugin

# Install additional tools that might be useful
RUN apt-get install -y \
    git \
    openssh-client \
    wget \
    unzip

# Ensure Docker group exists and add Jenkins user to it
RUN groupadd -f docker && \
    usermod -aG docker jenkins

# Switch back to jenkins user
USER jenkins

# Optional: Pre-install some initial configuration
COPY jenkins.yaml /var/jenkins_home/jenkins.yaml
ENV CASC_JENKINS_CONFIG /var/jenkins_home/jenkins.yaml