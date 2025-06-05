#!/bin/bash

# remove comments from the supplied file
# most commonly used to remove comments for searchsploit found scripts 
# example:  windows/remote/42031.py

args=("$@")
# echo ${args[0]}
sudo sed -i 's/^\#.*$//g' ${args[0]} && sudo sed -i '/^$/d' ${args[0]}
