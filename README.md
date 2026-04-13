# Dotfiles

Configuration files for the tools I use on Arch Linux.

## Installation

### Clone the whole repository

> [!NOTE]
> Installing dependencies is not described here yet.

You can clone the repository into a temporary directory and then copy the files you want into your home directory.

Be careful, as blindly copying everything into `~` may overwrite your existing files.
```bash
cd ~
mkdir temp_dotfiles_directory && cd temp_dotfiles_directory
git clone https://github.com/romacub/dot-files.git
cp -r dot-files/. ~
cd ~
rm -rf temp_dotfiles_directory
```

If you want to install only one config, you can use `svn export`:
```bash
cd ~
svn export https://github.com/romacub/dot-files/trunk/.config/<app-name> ~/.config/<app-name>
```

## Design principles

These configs are meant to be as simple as possible while still being useful.

The main goals are:

- readability
- low maintenance cost
- practical features without unnecessary complexity

I prefer a minimal visual style and the Rosé Pine theme.

## TODO

- [ ] Deal with Neovim config:
    - nested repo in nvim/pack
    - commit hashes in nvim/lazy-lock.json
    - configure new plugins
- [ ] Add more explanations for existing configs
- [x] Rewrite the Neovim config myself
- [ ] Create an installation script
- [ ] Describe required dependencies

## Note to __potential__ users

- Things are quite messy just yet.
- This was created mainly for my own use. I don't recommend doing anything without knowing what you're doing.
- Neovim config is especially messy. It has nested repos and commit hashes. If you dare to use it, be prepared to deal with it.
- Tmux has its plugin directory ignored.
- I use vim mode everywhere I can.
