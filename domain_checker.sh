#!/bin/bash
# sudo chmod 755 domain_checker.sh
# ./domain_checker.sh $DOMAIN_NAMES

IFS=',' read -ra split_array <<< "$1"

prev_val_ip=""
all_same=true

for domain in "${split_array[@]}"; do
  temp_val_ip=$(dig $domain A +short)

  echo $domain $temp_val_ip

  if [[ $all_same && $prev_val_ip != "" && "$prev_val_ip" != "$temp_val_ip" ]]; then
    all_same=false
  fi

  prev_val_ip=$temp_val_ip
done

if $all_same; then
  echo "Everything is okay"
else
  echo "WARNING: Please re-check all domain have same ip!"
fi
