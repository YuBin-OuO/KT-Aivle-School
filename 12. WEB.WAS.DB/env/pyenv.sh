# install pyenv & python on ubuntu 20

sudo apt-get install liblzma-dev

# update apt-get
sudo apt-get update
sudo apt-get upgrade -y

# install packages
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev git

# install pyenv
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

# setting pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init --path)"\nfi' >> ~/.bashrc
source ~/.bashrc

# install python
pyenv install 3.8.5

# change global version
pyenv global 3.8.5

# update pip
pip install --upgrade pip
