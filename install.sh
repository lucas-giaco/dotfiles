#!/bin/bash
# Adapted from https://github.com/nicknisi/dotfiles

echo "creating symlinks"
linkables=$( find -H $(pwd) -maxdepth 3 -name '*.lnk' )
for file in $linkables ; do
  target="$HOME/.$( basename $file ".lnk" )"
  if [ -f "$target" ]; then
    mv "${target}" "${target}.bkp"
  fi
  echo "creating symlink for $file"
  ln -s "${file}" "${target}"
done
