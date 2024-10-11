# Use the LTS version with JDK 11
FROM jenkins/jenkins:lts-jdk11

# Switch to root user to install packages and make system changes
USER root

# Install Python and necessary dependencies
RUN apt-get update && \
    apt-get install -y python3 python3-pip curl \
    build-essential \
    g++ \
    libatlas-base-dev \
    libssl-dev \
    libffi-dev \
    python3-venv

# Set up a Python virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements.txt and install dependencies in the virtual environment
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Set up Jenkins environment
ENV JENKINS_HOME /var/jenkins_home
ENV JAVA_OPTS -Djenkins.model.Jenkins.buildsDir="/var/jenkins_home/builds" -Djava.awt.headless=true

# Create necessary directories and set permissions
RUN mkdir -p /var/jenkins_home/builds && \
    mkdir -p /var/jenkins_home/jobs && \
    mkdir -p /var/jenkins_home/scripts && \
    chown -R jenkins:jenkins /var/jenkins_home

# Copy jobs and scripts into the Jenkins home directory
COPY jobs /var/jenkins_home/jobs
COPY scripts /var/jenkins_home/scripts

# Ensure scripts are executable
RUN chmod +x /var/jenkins_home/scripts/*.sh

# Create a directory for temporary files
RUN mkdir -p /var/jenkins_home/tmp && \
    chown -R jenkins:jenkins /var/jenkins_home/tmp

# Switch back to the Jenkins user
USER jenkins

# Expose port 8080 for the web interface and 50000 for agent connections
EXPOSE 8080 50000

# Start Jenkins
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]