FROM jenkins/jenkins:lts

USER root

# Install required packages and Node.js
RUN apt-get update && \
    apt-get install -y curl git unzip tar gzip gnupg2 software-properties-common && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Chrome
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable

# Install Firefox
RUN apt-get install -y firefox

# Install Microsoft Edge
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/ && \
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list' && \
    apt-get update && apt-get install -y microsoft-edge-stable && \
    rm microsoft.gpg

# Install Cypress dependencies
RUN npm install -g cypress
RUN chmod -R 777 /usr/local/lib/node_modules/cypress

# Set Jenkins user back
USER jenkins

# Expose Jenkins ports
EXPOSE 8080 50000
