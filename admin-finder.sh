#!/usr/bin/bash
# admin-finder: A script used to find the admin login page of a website.
# https://github.com/wannabewastaken/admin-finder
#-----------------------------------------------------------------------

version=1.1

# Speed up script by not using unicode
LC_ALL=C
LANG=C

# Color definition
: "${orange:=\e[38;5;202m}"
: "${red:=\e[38;5;160m}"
: "${yellow:=\e[38;5;220m}"
: "${green:=\e[38;5;40m}"
: "${reset:=\e[m}"

# Checking dependecies
command -v curl &> /dev/null || { printf "%b\n" \
     "${red}curl ${reset}not installed."; exit 1; }
command -v cut &> /dev/null || { printf "%b\n" \
     "${red}cut ${reset}not installed."; exit 1; }

# Trap ctrl+c
trap "printf '\e[K\r[${red}EXIT${reset}] ctrl+c detected\n\n'; exit" INT

banner() { printf "%b" "\
${orange}▄▀█  ${reset}admin-finder
${orange}█▀█  ${reset}version (${orange}v1.1${reset})\n\n"
}

usage() { printf "%s" "\
Usage:
    $0 [option] [value]
Options:
    -h, --help              Show this help message and exit
    -u, --url <url>         Target url (e.g. 'www.example.com' or 'example.com')
    -t, --thread <thread>   Set thread number (default: 100)
    -w, --wordlist <file>   Use custom wordlist

"
exit 1
}

scan_protocol() {
    if [[ $(curl -s "https://${1}" \
                 -w "%{http_code}" \
                 -o /dev/null) =~ 200 ]]; then
        protocol="https://"
    else
        if [[ $(curl -s "http://${1}" \
                     -w "%{http_code}" \
                     -o /dev/null) =~ 200 ]]; then
            protocol="http://"
        else
            printf "%b\n" \
            "[$(date +%H:%M:%S)] Connection failed, aborted"
            printf "%b\n\n" \
            "[$(date +%H:%M:%S)] Please check your internet connection or maybe website is down"
            exit 1
        fi
    fi
}

scan_robots() {
    for robotPath in "robot.txt" "robots.txt"; do
        if [[ $(curl -s "${1}${2}/${robotPath}" \
                     -w "%{http_code}" \
                     --connect-timeout 1 \
                     -o /dev/null) =~ 200 ]]; then
            printf "%s\n" \
            " |-- robots.txt -> ${1}${2}/${robotPath}"
            isFound=true
            break
        fi
    done
    [[ ${isFound} ]] && return || {
        printf "%s\n" \
        " |-- robots.txt -> not found"
    }
}

scan_path() {
    if [[ $(curl -s "${1}${2}/${3}" -w "%{http_code}" -o /dev/null) -eq 200 ]]; then
        printf "%b" \
        "\e[J |-- (${green}200${reset}) -> ${1}${2}/${3}\n"
    else
        printf "%b" \
        "\e[K |-- (${yellow}${4}${reset}) -> ${1}${2}/${3}${reset}\r"
    fi
}

main() {
    if [[ -z $@ ]]; then
        usage
    fi

    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                shift
            ;;
            -u|--url)
                url="$2"
                shift
            ;;
            -t|--thread)
                thread="$2"
                shift
            ;;
            -w|--wordlist)
                wordlist="$2"
                shift
            ;;
            *)
                printf "%s\n%s\n" "admin-finder: unrecognize option '$1'" \
                       "See the output of $0 -h for summary options."
                exit 1
            ;;
        esac
        shift
    done

    if [[ "$url" =~ [^https?://].* ]]; then
        url=$(printf $url | cut -d "/" -f 3)
    fi

    if [[ -z "$thread" ]]; then
        thread=100
    fi

    if [[ -z "$wordlist" ]]; then
        wordlist="./wordlist.txt"
    fi

    clear
    banner

    printf "%s\n" \
    "[$(date +%H:%M:%S)] Starting connection to ${url}"
    scan_protocol ${url}
    printf "%s\n" \
    "[$(date +%H:%M:%S)] Connection successful"
    printf "%s\n" \
    "[$(date +%H:%M:%S)] Using protocol (${protocol})"
    printf "%s\n" \
    "[$(date +%H:%M:%S)] Scanning..."
    scan_robots ${protocol} ${url}

    while read -r path; do
        ((x=x%${thread})); ((x++==0)) && wait
            scan_path ${protocol} ${url} ${path} ${x} &
    done < <(grep "" ${wordlist})
    wait

    printf "%b\n" \
    "\e[K[$(date +%H:%M:%S)] Disconnect from ${url}"
    printf "%s\n\n" \
    "[$(date +%H:%M:%S)] Scanning done, exit"
}

main "$@"
wait
