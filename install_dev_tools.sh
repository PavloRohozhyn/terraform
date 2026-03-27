#!/bin/bash
# update index
sudo apt-get update
# system doesnt have 
if ! command -v docker &> /dev/null; then
    echo "Docker not found and vill be installed."
    # install curl utilite
    sudo apt-get install -y ca-certificates curl gnupg
    # set GPG-key for docker 
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://docker.com | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    # set repo, create docker list file in to source list folder 
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://docker.com \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    # after that need to reload data into index
    sudo apt-get update
    # install docker 
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
    echo "Docker --- Done"
else
# docker is already installed 
    echo "Docker already installed. Versjon: $(docker --version)"
fi

# Docker Compose,
# Python 3.9 or newest,
# Django by pip.