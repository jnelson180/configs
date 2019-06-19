# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.local/bin

# Path to your oh-my-zsh installation.
export ZSH="/Users/jakenelson/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=random

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
ZSH_THEME_RANDOM_CANDIDATES=( "philips" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh/Users/jakenelson/Downloads/Slack.app/Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  
. `brew --prefix`/etc/profile.d/z.sh

# checkout remote branch that matches grep
function ckr { 
    a=$(git branch -r | grep $1 | xargs); git checkout $a
}

# checkout local branch that matches grep
function ckl { 
    a=$(git branch | grep $1 | xargs); git checkout $a
}

# change directories and ls automatically
function cdls { cd "$@" && ls -a; }

# reload zsh with a "." keypress
function _accept-line() {
    if [[ $BUFFER == "." ]]; then
        BUFFER="source ~/.zshrc"
    fi
    zle .accept-line
} 

zle -N accept-line _accept-line

Function weather() {
	curl -L http://www.freeweather.com/cgi-bin/weather/weather.cgi\?pands\=61111\&daysonly\=0\&maxdays\=14 | sed -E 's/<[^>]*>//g' | sed -E 's/&nbsp;//g' | sed -E 's/;F/ F/g' | sed -E 's/&/ /g' | grep -A11 "Current Conditions"
}

Function forecast() {
	curl -L http://www.freeweather.com/cgi-bin/weather/weather.cgi\?pands\=61111\&daysonly\=0\&maxdays\=14 | sed -E 's/<[^>]*>//g' | sed -E 's/&nbsp;//g' | sed -E 's/;F/ F/g' | sed -E 's/&/ /g' | grep -A17 "Daily Forecast"
}

Function sunrise() {
	curl -L http://www.freeweather.com/cgi-bin/weather/weather.cgi\?pands\=61111\&daysonly\=0\&maxdays\=14 | sed -E 's/<[^>]*>//g' | sed -E 's/&nbsp;//g' | grep Sunrise:
}

Function sunset() {
curl -L http://www.freeweather.com/cgi-bin/weather/weather.cgi\?pands\=61111\&daysonly\=0\&maxdays\=14 | sed -E 's/<[^>]*>//g' | sed -E 's/&nbsp;//g' | grep Sunset: 
}

# some git aliases for connect-web
alias gf="git fetch --all"
alias gp="git pull"
alias gforcepull="git checkout develop; git fetch --all; git reset --hard origin/develop"
alias gd="git checkout develop"
alias gb="git checkout @{-1}"
alias grdevelop="git rebase develop"
alias grstaging="git rebase staging"
alias s="npm start"
alias t="npm run test"
alias tw="npm run test:watch" 

# automatic rebase on develop
Function rdev() {
  echo -e 'Starting automatic rebase...'
  wait
  gd
  wait
  echo -e 'Checked out develop...'
  gf 
  wait
  echo -e 'Fetched updates...'
  if (git pull | grep -q "Already up to date."); then
    # if already up to date, go back to previous branch
    # then initiate the rebase
    echo -e 'Already up to date, going back to original branch...' 
    gb
    wait
    echo -e 'At original branch...'
    grdevelop
    wait
    echo -e 'Rebase complete...!'
  else
    # if not up to date, reset to origin/develop
    echo -e 'Not up to date, resetting develop to origin/develop...'
    git reset --hard origin/develop
    wait
    echo -e 'Reset to origin/develop, checking out previous branch...'
    gb
    wait
    echo -e 'At original branch...'
    grdevelop
    wait
    echo -e 'Rebase complete...!'
  fi
}

export PATH="/usr/local/opt/php@7.2/bin:$PATH"
export PATH="/usr/local/opt/php@7.2/sbin:$PATH"
export PATH="/usr/local/opt/node@10/bin:$PATH"

