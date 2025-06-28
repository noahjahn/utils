# Utils

Utilities I use on a daily basis, Dockerized where necessary.

## Requirements

- Bash, see the `verify` function in the `utils` script for all dependencies
- [Docker](https://docs.docker.com/get-docker/)
- [Git](https://git-scm.com/downloads)
- Any submodule dependencies
  - [Bagels Requirements](https://github.com/noahjahn/bagels?tab=readme-ov-file#requirements)
  - [Posting Requirements](https://github.com/noahjahn/posting?tab=readme-ov-file#requirements)

## Setup

1. Clone this repo somewhere your user has access. I prefer my home directory: `~`

```shell
git clone git@github.com:noahjahn/utils.git ~/utils
```

2. Add the utils `rc` file to be sourced on login:

- The file is different depending on your OS. Examples:

  - .bash_profile
  - .bashrc
  - .profile
  - .zshrc
  - .zprofile

- be sure to change the file path if you didn't clone this repo to your home directory

```bash
if [ -d "$HOME/utils" ] && [ -f "$HOME/utils/rc" ] ; then
  export NOAHJAHN_UTILS_DIR="$HOME/utils"
  source "$HOME/utils/rc"
fi
```

3. Launch a new shell, or source the shell config file from the previous step, and you can now use the `utils` on your terminal!

4. Pull submodules

```shell
utils update
```

5. Ensure you have all the requirements to run the utils:

```shell
utils verify
```

## Updating

Run `utils update`

```shell
utils update
```
