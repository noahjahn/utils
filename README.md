# Utils

Utilities I use on a daily basis, dockerized.

## Requirements

- Bash with built-in getopts
- [Docker](https://docs.docker.com/get-docker/)

## Setup

1. Clone this repo somewhere your user has access. I prefer my home directory: `~`

2. Add this directory to your users' `PATH`

* the file is different depending on your OS. Examples:
    - .bash_profile
    - .bashrc
    - .profile

* be sure to change the file path if you didn't clone this repo to your home directory

```bash
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/utils" ] ; then
    PATH="$HOME/utils:$PATH"
fi
```

3. Launch a new shell and you can now use the utils on your terminal!

Example:

```
adminer
```
