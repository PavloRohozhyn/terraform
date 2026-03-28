#!/bin/bash
# ---------------
# Docker
# ---------------
sudo apt-get update    
if command -v "docker" >/dev/null 2>&1 ; then
    echo "docker is already installed."
else
    echo "docker install process is runs."
    # Add Docker's official GPG key:
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
    echo " === docker done. === "
fi
# ----------------
# docker-compose
# ----------------
if command -v "docker-compose" >/dev/null 2>&1 ; then
    echo "docker-compose is already installed."
else
    echo "docker-compose install process is runs."
    sudo apt-get install -y docker-compose-plugin
    echo " === docker-compose done. === "
fi
# --------------
# Python
# ---------------
if command -v "python3" > /dev/null 2>&1 ; then
    PYTHON_VERSION=$(python3 --version)
    echo "python (${PYTHON_VERSION}) is already installed"
    if ! command -v "pip3" > /dev/null 2>&1; then
        echo "pip3 is already installed"
    else    
        echo "pip3 install process is runs."
	sudo apt-get install -y python3-pip python3-venv
	echo " === pip done. ==="
    fi
else
    if ! command -v "pip3" > /dev/null 2>&1; then
        echo "python install process is runs"
        sudo apt-get update && sudo apt-get install -y python3 python3-pip python3-venv
        echo " === python done. === "
    fi
fi
# -------------
# Django
# -------------
if python3 -m pip show django >/dev/null 2>&1; then
    echo "django is already installed"
else
    echo "django instal process is runnig"
    python3 -m venv venv
    source ./venv/bin/activate
    pip install django
    echo " === django done. === "
fi
# Sumamry
echo "Summary:"
docker --version
docker-compose --version
python3 --version
echo "Django: $(python3 -m django --version)"

