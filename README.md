# My dot files

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
