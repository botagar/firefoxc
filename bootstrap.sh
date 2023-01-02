#!/bin/bash
pkg_manager='apt-get'

install_brew () {
    if ! command -v brew &> /dev/null
    then
        echo "Brew could not be found"
        echo "Installing brew"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Check if brew already registered in user profile for PATH inclusion
        grep -q "# Set PATH, MANPATH, etc., for Homebrew.." /home/$USER/.profile
        if [ $? -eq 1 ]; then
            echo "Adding Brew to PATH and Profile"
            echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/$USER/.profile
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.profile
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    fi
    echo "Brew installed"
}

install_awscli () {
    if ! command -v aws &> /dev/null
    then
        echo "AWS CLI v2 could not be found"
        echo "Installing AWS CLI v2"
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
        unzip /tmp/awscliv2.zip
        sudo /tmp/awscliv2/aws/install
        aws --version
    fi
    echo "AWS CLI v2 installed"
}

install_pulumi () {
    if ! command -v pulumi &> /dev/null
    then
        echo "Pulumi could not be found"
        curl -fsSL https://get.pulumi.com | sh
    fi
    echo "Pulumi installed"
}

install_terraform () {
    if ! command -v terraform &> /dev/null
    then
        wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
        sudo nala update && sudo nala install -y terraform
    fi
    echo "Terraform installed"
}

install_nvm () {
    if ! command -v pulumi &> /dev/null
    then
        echo "nvm could not be found"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
    fi
    echo "nvm installed"
}

sudo apt-get install -y nala
sudo nala update && sudo nala upgrade -y
sudo nala install -y ansible docker paprefs

install_nvm
install_awscli
install_brew
install_pulumi
install_terraform

nvm install node
nvm use node
brew install aws-vault
