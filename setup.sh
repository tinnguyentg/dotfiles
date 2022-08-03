#!/usr/bin/bash

install_packages() {
    local packages=(
        bat
        build-essential
        ca-certificates
        curl
        cmake
        file
        g++
        gcc
        gnupg
        lsb-release
        procps
        python3
        python3-pip
        software-properties-common
        tree
        unzip
        wget
        zip
        zsh
    )

    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
    sudo apt-get autoremove -y
    sudo apt-get autoclean
}

install_git() {
    sudo add-apt-repository ppa:git-core/ppa -y
    sudo apt-get update
    sudo apt install git -y
}


install_brew() {
    if [[ -x "$(command -v brew)" ]]
    then
        brew update
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

install_ohmyzsh() {
    rm -rf ~/.oh-my-zsh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
}

install_ohmyposh() {
    sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
    sudo chmod +x /usr/local/bin/oh-my-posh
}

install_zsh_plugins() {
    local ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
    rm -rf "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
    rm -rf "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
}

install_nvm() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
}

install_poetry() {
    if [[ -x "$(command -v poetry)" ]]; then
        poetry self update
    else
        curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -
    fi
}

install_neovim() {
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt-get update
    sudo apt-get install neovim -y
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
    sudo update-alternatives --config vi
    sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
    sudo update-alternatives --config vim
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
    sudo update-alternatives --config editor
}

install_vim_plug() {
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

install_exa() {
    local EXA_VERION="v0.10.1"
    mkdir -p /tmp && wget https://github.com/ogham/exa/releases/download/${EXA_VERION}/exa-linux-x86_64-${EXA_VERION}.zip -O /tmp/exa.zip
    unzip /tmp/exa.zip -d /tmp/exa
    sudo mv /tmp/exa/bin/exa /usr/local/bin/
    rm -rf /tmp/exa.zip /tmp/exa
}

install_ripgrep() {
    local RIPGREP_VERSION="13.0.0"
    mkdir -p /tmp && wget https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}_amd64.deb -O /tmp/ripgrep.deb
    sudo dpkg -i /tmp/ripgrep.deb
    rm -f /tmp/ripgrep.deb
}

install_bat_extras() {
    rm -rf ~/.bat-extras
    git clone https://github.com/eth-p/bat-extras ~/.bat-extras
    sudo ~/.bat-extras/build.sh --install
}

install_gh() {
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh
}

install_docker() {
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

install_fd() {
    sudo apt install fd-find -y
    ln -s $(which fdfind) ~/.local/bin/fd
}

install_fzf() {
    sudo apt-get install fzf -y
}

install_pyright() {
    npm install --location=global pyright
}

backup_and_link() {

    if [ -f $2 ] || [ -d $2 ]; then
        mv -f $2 ~/.backup
    fi

    ln -svf $1 $2
}

main() {

    install_packages
    install_git
    # install_brew
    install_ohmyzsh
    install_ohmyposh
    install_zsh_plugins
    install_nvm
    install_poetry
    install_neovim
    install_vim_plug
    install_exa
    install_ripgrep
    install_bat_extras
    install_gh
    install_docker
    install_fd
    install_fzf
    install_pyright

    mkdir -p ~/.backup
    mkdir -p ~/.config/nvim
    backup_and_link "${PWD}/.zshrc" ~/.zshrc
    backup_and_link "${PWD}/.zsh_aliases" ~/.zsh_aliases
    backup_and_link "${PWD}/.vimrc" ~/.config/nvim/init.vim
    backup_and_link "${PWD}/.mytheme.omp.json" ~/.mytheme.omp.json
    backup_and_link "${PWD}/.zfunc/" ~/.zfunc

    # Change default shell
    if ! [ "$(basename -- "$SHELL")" = "zsh" ]; then
        sudo -k chsh -s $(which zsh) "$USER"
    fi

    exec zsh -l
}

main "$@"