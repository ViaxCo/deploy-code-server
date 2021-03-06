# Start from the code-server Debian base image
FROM codercom/code-server:latest 

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install VS Code extensions:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension ahmadawais.shades-of-purple
RUN code-server --install-extension dsznajder.es7-react-js-snippets
RUN code-server --install-extension formulahendry.auto-close-tag
RUN code-server --install-extension dbaeumer.vscode-eslint
RUN code-server --install-extension eamodio.gitlens
RUN code-server --install-extension xabikos.JavaScriptSnippets
RUN code-server --install-extension christian-kohler.path-intellisense
RUN code-server --install-extension bradlc.vscode-tailwindcss

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make
RUN sudo apt-get install -y vim

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool


# Install NodeJS
RUN sudo curl -fsSL https://deb.nodesource.com/setup_16.x | sudo bash -
RUN sudo apt-get install -y nodejs

# Update npm
RUN sudo npm install -g npm@latest
# Install Yarn
RUN sudo npm install -g yarn

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
