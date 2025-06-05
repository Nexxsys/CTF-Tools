# CTF-Tools
Scripts and other tools for CTF (Capture The Flag) activities.
* `vhost-fuzzer2.sh` | a ffuf wrapper for vhost fuzzing
* `vhost-fuzzer3.sh` | an enhanced version of vhost-fuzzer2.sh
* `pingsweep.sh` | great way to find out the IP address of any virtual machines on the same subnet in your hypervisor

## Completion Scripts
A set of scripts to easily mark your notes directory on a CTF with _COMPLETED.  As well as a script to run the last working solution command to produce the flag in the terminal and save the flag produced to a file for future reference.

## Other Tools & Tips

### zshrc aliases
Using an alias like this one makes is easier for you to search you seclists and pull a selected file back into clipboard for use
```bash
alias secsearch="find /usr/share/seclists -type f | fzf | xclip"
```

### Quick Scripts
Sometimes the exploit.py or other similar files you may find and want to use from `searchsploit` has a large number of 'header comments' and a script like [removecomments.sh](https://github.com/Nexxsys/CTF-Tools/blob/main/removecomments.sh) can help by removing those comments.
