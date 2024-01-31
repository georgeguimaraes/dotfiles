#!/bin/sh
# Ref:
#     http://www.semicomplete.com/blog/geekery/ssh-key-invalid-hack.html
#
eval "value=\$$#"

if [ "$#" -lt 1 ] ; then
  echo "Invalid arguments."
  exit 1
fi

if ! echo "$value" | egrep -q '.*:[0-9]+$' ; then
  echo "Invalid file:lineno format: $value"
  exit 1
fi

echo "$value" | awk -F: '{print "sed -i -e "$2"d",$1}' | sh -x
