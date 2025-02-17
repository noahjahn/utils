# Utils

Utilities I use on a daily basis, dockerized.

## Requirements

- Bash with built-in getopts
- [Docker](https://docs.docker.com/get-docker/)
- Any submodule dependencies
  - [Bagels Requirements](https://github.com/noahjahn/bagels?tab=readme-ov-file#requirements)

## Setup

1. Clone this repo somewhere your user has access. I prefer my home directory: `~`

```shell
git clone git@github.com:noahjahn/utils.git ~/utils
```

2. Pull submodules

```shell
git submodule update --init --recursive --remote
```

3. Add the directory to your users' `PATH`

- The file is different depending on your OS. Examples:

  - .bash_profile
  - .bashrc
  - .profile
  - .zshrc
  - .zprofile

- be sure to change the file path if you didn't clone this repo to your home directory

```bash
if [ -d "$HOME/utils" ] ; then
    PATH="$HOME/utils:$PATH"
fi
```

4. Launch a new shell, or source the shell config file from the previous step, and you can now use the `utils` on your terminal!

Example:

```
adminer
```
