#!/bin/bash

grey=$(printf '\x1b[1;30m'); red=$(printf '\x1b[1;31m'); green=$(printf '\x1b[1;32m')
yellow=$(printf '\x1b[1;33m'); default=$(printf '\x1b[1;0m')

function banner() {
    echo "+-------------------+"
    echo "${default}|    ${grey}adminFinder${default}    |"
    echo -e "+-------------------+\n"
}

function main() {
    site=$1; regex="[a-zA-Z0-9]+\.[a-zA-Z0-9]+.*"
    wordlist=$(echo "Li93b3JkbGlzdC9saXN0LnR4dAo=" | base64 -d)
    if [[ $site =~ $regex ]]; then
        site_="$(echo ${BASH_REMATCH[0]} | cut -d '/' -f 1)"
        if [[ $(curl -s -o /dev/null "https://${site_}" -w "%{http_code}") != "200" ]]; then
            if [[ $(curl -s -o /dev/null "http://${site_}" -w "%{http_code}") != "200" ]]; then
                echo "[${red}?${default}] Unknown protocol, maybe down or bad url."
                exit 0 > /dev/null 2>&1
            else
                protocol="http://"; echo "[${yellow}#${default}] Your site ${site_} is stable!"
            fi
        else
            protocol="https://"; echo "[${yellow}#${default}] Your site ${site_} is stable!"
        fi
    else
        echo "[${red}!${default}] That's not url anymore kiddie."
        exit 0 > /dev/null 2>&1
    fi; echo -e "[${yellow}#${default}] Wordlist: $(wc -l < ${wordlist})"; scan; exit 0 > /dev/null 2>&1
}

function scan() {
    x=1; while read -r path; do
        url="${protocol}${site_}/${path}"; status=$(curl -s -o /dev/null "${url}" -w "%{http_code}")
        if [[ "${status}" == "200" ]] || [[ "${status}" == "201" ]]; then
            _o=1; break; exit 0 > /dev/null 2>&1
        else
            echo -ne "\r[${yellow}SCANNING${default}]";
        fi; ((x++))
    done < <(grep "" $wordlist)
    if [[ $_o -gt 0 ]]; then
        echo -ne "\r[${green}FOUND${default}] ${url}\n"
    else
        echo -ne "\r[${red}NOTFOUND${default}] Try to find it by yourself.\n"
    fi; exit 0 >/dev/null 2>&1
}


## Start
if [[ ${#@} != 1 ]]; then
    clear; echo "Usage: $0 <url>"
    exit 0 > /dev/null 2>&1
else
    clear; banner; main $@
fi