#!/run/current-system/sw/bin/bash

layout=$(awk '/^\$layout/ {print $3}' ~/.cache/dotfiles/layout.conf)

case "$layout" in
"dwindle")
  echo ""
  ;;
"master")
  echo ""
  ;;
"scrolling")
  echo ""
  ;;
*)
  echo ""
  ;;
esac
