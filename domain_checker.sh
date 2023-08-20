#!/bin/bash
# sudo chmod 755 domain_checker.sh
# ./domain_checker.sh $DOMAIN_NAMES

IFS=',' read -ra split_array <<< "$1"

for domain in "${split_array[@]}"; do
  echo $domain $(dig $domain A +short)
done
