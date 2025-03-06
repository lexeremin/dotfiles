# My automated dot files setup

## Requirements

- JetBrains Nerd Font is required for the icons to work properly. You can download it from [here](https://www.nerdfonts.com/font-downloads) or you can use whatever font you like just don't forget to change all the config files, I might automate this part in the future.

You can install fonts with the following command:

On MacOS:

```Bash
brew install --cask font-jetbrains-mono-nerd-font
```

On Linux:

```Bash
wget YourLinkToFont
sudo unzip JetBrainsMono.zip -d /usr/share/fonts/JetBrainsNerdFont
sudo fc-cache -fv
```

- Install packages, you don't need all of them, but most of them are required:

On MacOS:

```Bash
# if you want to make a backup of currently installed packages
brew leaves > leaves.txt
# Required packages
brew install < leaves/leaves.txt
```

On Linux:

> [!NOTE]
> It will depend on your package manager, but most of the packages are available in the official repositories.

## Automated Setup

You can use `setup.sh` to automatically backup and symlink configuration files. It will backup your current configuration:

- zsh files in the `$HOME` directory will be renamed to `fileName.bak` they will only be renamed if they exist.
- directories in the `$HOME/.config/` that interfere with the symlinking configuration will be renamed to `dirName.bak`.
- file `.zshenv` will be created in the `$HOME` directory with the content `ZDOTDIR=$HOME/.config/zsh`.

> [!CAUTION]
> Before executing the script, make sure you understand what it does!

```Bash
chmod +x setup.sh # Make the script executable
./setup.sh
```

You can exclude some configurations by adding them to the `--ignore=<dirName>` option in the file `.stowrc`. By default some configurations are disabled in the `.stowrc` file. To enable them, remove the `--ignore=<folders>` option.

If you want to revert the changes and restore your configuration, you can use the following command:

```Bash
./setup.sh --unstow
```

> [!NOTE]
> It will also remove the `.zshenv` file that was created with the script. So if you previously had a `.zshenv` file it will be restored too.

## Manual Setup

In order to symlink files to the configuration directory `$HOME/.config/`, use the following command:

```Bash
stow .
```

If you want to copy one by one use:

```Bash
stow --targer ~/.config --dotfiles dirName
```

Install packages with brew, you don't need all of them, but most of them are required:

```Bash
# Make a backup of the installed packages
brew leaves > leaves.txt
# Fresh installation
brew install < leaves.txt
```
