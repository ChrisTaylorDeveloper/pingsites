#!/bin/bash

run_curl () {
    curl --output /dev/null --connect-timeout 5 --max-time 20 --write-out "%{http_code},%{size_download}" -s -S "$1"
}

tbl=$(printf "ACTUAL\tEXPECTED\tSIZE\tURL\tDEPLOYMENT")

while read -r line; do
    url=$(echo "$line" | cut -d ',' -f 1)
    expected=$(echo "$line" | cut -d ',' -f 2)
    deploy=$(echo "$line" | cut -d ',' -f 4)
    the_write_out=$(run_curl "$url")
    IFS=',' read -ra frags <<< "$the_write_out"
    tbl+=$'\n'${frags[0]}$'\t'$expected$'\t'${frags[1]}$'\t'$url$'\t'$deploy
done

echo "$tbl" | column -t -s $'\t'
