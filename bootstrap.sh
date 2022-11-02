#!/bin/bash

source /etc/os-release
if [[ $ID == "ubuntu" ]]; then
  echo "Add this snippet to your ~/.profile (not ~/.bashrc!):

--8<--
# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi

unset rc
--8<--

"
fi

/usr/bin/which pip 1>/dev/null 2>/dev/null 
if [[ $? > 0 ]]; then
  echo 'Install pip first.'
  exit 1
fi

repodir="$PWD/$(/usr/bin/dirname ${0})"

declare -A configs

# file/dict in repo -> target path, relative to $HOME
configs['bashrc.d']='.bashrc.d'
configs['powerline']='.config/powerline'
configs['tmux.conf']='.tmux.conf'

for i in ${!configs[@]}; do
  pref=$(dirname ${configs[${i}]})
  if [ ${pref} != '.' -a ! -d ~/${pref} ]; then
    /usr/bin/mkdir -p ~/${pref} 
  fi
  if [ ! -L ~/${configs[${i}]} ]; then
    echo "Linking ~/${configs[${i}]} to ${repodir}/${i}."
    /usr/bin/ln -s ${repodir}/${i} ~/${configs[${i}]}
  fi
done

if [ -f requirements.txt ]; then
  /usr/bin/pip install --user --quiet -r requirements.txt
fi
