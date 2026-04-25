#!/bin/bash
# ==============================================================================
# This script manages the download and setup of the necessary files for 
# custom Vim setup
# ==============================================================================
set -e
echo -e "Starting Setup...\n"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo -e "[1/5] Installing system dependencies (Requires sudo)..."
sudo apt update && sudo apt install -y curl vim nodejs npm clang clang-format shellcheck shfmt python3-pip python3-venv black flake8
echo -e "[2/5] Linking your .vimrc..."
if [ -f "$HOME/.vimrc" ] && [ ! -L "$HOME/.vimrc" ]; then
    mv "$HOME/.vimrc" "$HOME/.vimrc.backup"
    echo "Backed up existing ~/.vimrc to ~/.vimrc.backup"
fi
if [ -f "$REPO_DIR/.vimrc" ]; then
    ln -sf "$REPO_DIR/.vimrc" "$HOME/.vimrc"
elif [ -f "$REPO_DIR/vimrc" ]; then
    ln -sf "$REPO_DIR/vimrc" "$HOME/.vimrc"
else
    echo "Error: Could not find .vimrc or vimrc in $REPO_DIR"
    exit 1
fi
echo -e "[3/5] Installing vim-plug..."
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo "vim-plug is already installed."
fi
echo -e "[4/5] Installing Vim plugins..."
vim +PlugInstall +qall
echo -e "[5/5] Installing CoC Language Servers..."
vim -c 'CocInstall -sync coc-clangd coc-pyright coc-sh coc-json' -c 'qa'
echo -e "Setup Complete!"
