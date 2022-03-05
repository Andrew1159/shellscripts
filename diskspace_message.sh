#!/bin/bash

# filesystem -> Provide information about location.
filesystems=("/dev/nvme0n1p5")
# threshold -> Here we can change the percentage value.
threshold=90

for i in ${filesystems[*]}; do
  usage=$(df -h "$i" | tail -n 1 | awk '{print $5}' | cut -d % -f1)
  if [ "$usage" -gt "$threshold" ]; then
    alert="Running out of space on $i, Usage is: $usage%"
    echo "Sending out a disk space alert email."
    echo "$alert" | mail -s "$i is $usage% full" example@gmail.com
  fi
done