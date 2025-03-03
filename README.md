# My dot files

## Requirements

- JetBrains Nerd Font is required for the icons to work properly. You can download it from [here](https://www.nerdfonts.com/font-downloads)

You can install it with the following command:

On MacOS:

```Bash
brew install --cask font-jetbrains-mono-nerd-font
```

On Linux:

```Bash
sudo unzip JetBrainsMono.zip -d /usr/share/fonts/JetBrainsNerdFont
sudo fc-cache -fv
```

## Automatic Setup

You can use `setup.sh` to automatically backup and symlink configuration files.

> [!CAUTION]
> Before executing the script, make sure you understand what it does!

```Bash
chmod +x setup.sh # Make the script executable
./setup.sh
```

You can exclude some configurations by adding them to the `--ignore=<dirName>` option in the file `.stowrc`.

## Manual Setup

In order to symlink the files to the home directory, use the following command:

```Bash
stow .
```

If you want to copy one by one use:

```Bash
stow --targer ~/.config --dotfiles dirName
```

Install packages with brew:

```Bash
# Make a backup of the installed packages
brew leaves > leaves.txt
# Fresh installation
brew install < leaves.txt
```

By default some config files are disabled in the `.stowrc` file. To enable them, remove the `--ignore=<folders>` option.
