#!/bin/bash

catch() {
    echo "An error occured"
    exit -1
}

trap catch ERR

if [[ "$(uname)" == "Darwin" ]]; then
    platform=darwin
    name=macOS
else
    platform=linux
    name=Linux
fi

echo "Welcome to Calebh101 Recovery Tools for $name"
echo "recovery-tools 0.0.0"

command-input() {
    echo ""
    echo "Type 'help' for commands"
    read -p ">> " user_input
    echo ""

    case "$user_input" in
        help)
            echo "Possible commands\n"
            echo -e "help\nShow commands\nexit\nquit\nboot-repair\nInstalls and runs boot-repair for Linux" | paste -d "\t" - - 
            ;;
        exit)
            echo "Exiting..."
            echo "Goodbye"
            exit 0
            ;;
        boot-repair)
            echo "Running boot-repair..."
            if [ "$platform" == "darwin" ]; then
                echo "Error: unsupported platform: $platform"
            else
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
            fi
            echo "Ended boot-repair session"
            ;;
        *)
            echo "Invalid command"
            ;;
    esac
    command-input
}

command-input