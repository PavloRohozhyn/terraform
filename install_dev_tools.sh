sudo apt-get update
    
# Docker
if ! command -v docker &> /dev/null; then
    echo "Docker not found and vill be installed."
    sudo apt-get install -y ca-certificates curl gnupg
    # Set GPG-key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://docker.com | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    # Set official Repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://docker.com \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    # Installer Docker Engine
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
    echo "Docker --- Done"
else
    echo "Docker already installed. Versjon: $(docker --version)"
fi

# Docker Compose,
# Python 3.9 or newest,
# Django by pip.