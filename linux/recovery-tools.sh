#!/bin/bash

ver=0.0.0
verS=0.0.0B

trap catch ERR

catch() {
    echo "An error occured"
    exit -1
}

quit() {
    echo "Exiting Recovery Tools..."
    exit 0
}

help() {
    echo -e "Command\tAction\nhelp\tShow available commands\nexit\tQuit the recovery-tools application\nboot-repair\tInstall and run boot-repair for Linux" | column -t -s $'\t'
}

if [[ "$(uname)" == "Darwin" ]]; then
    platform=darwin
    name=macOS
else
    platform=linux
    name=Linux
fi

boot_repair() {
    if ! command -v boot-repair &> /dev/null
    then
        echo "Installing boot-repair..."
        sudo add-apt-repository ppa:yannubuntu/boot-repair
        sudo apt update
        sudo apt install -y boot-repair
    fi

    echo "Starting boot-repair..."
    boot-repair
    echo "Exiting boot-repair..."
}

echo "Welcome to Calebh101 Recovery Tools for $name"
echo "recovery-tools $ver ($verS)"

command-input() {
    echo ""
    echo "Type 'help' for commands"
    read -p ">> " user_input
    echo ""

    if [ -z "$user_input" ]; then
        quit
    else
        case "$user_input" in
            help)
                echo "Recovery Tools Help Menu (for version $ver)"
                help
                ;;
            exit|quit|stop)
                quit
                ;;
            boot-repair)
                echo "Running boot-repair..."
                if [ "$platform" == "darwin" ]; then
                    echo "Error: unsupported platform: $platform"
                else
                    boot_repair
                fi
                echo "Ended boot-repair session"
                ;;
            *)
                echo "Invalid command"
                ;;
        esac
        command-input
    fi
}

command-input