#!/bin/bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
pathmain=$(pwd)
test -f /etc/debian_version
debian=$(echo $?)
test -f /etc/arch-release
arch=$(echo $?)
test -f /etc/redhat-release
fedora=$(echo $?)

trap ctrl_c INT

ctrl_c() {
	echo -e "\n\n${redColour}[!]${endColour}${grayColour} Exit...${endColour}\n"; exit
}

dfu() {
    test -f /usr/bin/dfu-programmer
    if [ "$(echo $?)" -ne 0 ]; then 
        echo -ne "$redColour\n[!]$grayColour You are missing a dependency (dfu-programmer) Enter to install" && read 
        if [ "$debian" -eq 0 ]; then
            sudo apt-get install dfu-programmer -y
        elif [ "$arch" -eq 0 ]; then
            sudo pacman -S dfu-programmer -y
        elif [ "$fedora" -eq 0 ]; then
            sudo dnf install dfu-programmer -y
        else
            echo -ne "$redColour\n[!]$grayColour Could not install, try installing it manually" && read
            exit
        fi
    else
        lenguage
    fi
}

lenguage () {
    echo -ne "$yellowColour[?]$grayColour Language: \n\n[1] Español\n[2] English\n$blueColour\n[>]: $grayColour" && read len
    case $len in
    1)
    mainesp
    ;;
    2)
    maineng
    ;;
    *)
    echo -e "${redColour}\n[!]$grayColour Invalid Option"; sleep 2
    ;;
    esac
   
}
resartfirm() {
    dfu-programmer atmega16u2 erase
    dfu-programmer atmega16u2 flash --suppress-bootloader-mem Arduino-COMBINED-dfu-usbserial-atmega16u2-Uno-Rev3.hex
    dfu-programmer atmega16u2 reset
}
keyfirm() {
    dfu-programmer atmega16u2 erase
    dfu-programmer atmega16u2 flash Arduino-keyboard-0.3.hex
    dfu-programmer atmega16u2 reset
}

mainesp() {
    tput civis
    echo -ne "\nConecta el ARDUINO UNO a tu PC con los dos pines conectados" && read
    echo -ne "\nRetire el puente que conecta los pines" && read
    echo -ne "\nRestableciendo el firmware por defecto del ARDUINO...\n"
    resartfirm
    echo -ne "\nDesconecte el ARDUINO del PC y vuelva a conectarlo" && read
    echo -ne "\nSi quieres aplicar algun cambio al codigo de ARDUINO ve a: ${pathmain}/ARDUINO.ino y editalo" && read 
    echo -ne "\nAplicando el codigo en el ARDUINO" && read
    echo -ne "\nConecte dos pines para reiniciar ARDUINO" && read 
    echo -ne "\nRetire el puente que conecta dos pines" && read
    echo -ne "\nSubiendo el firmware del teclado\n" && read
    keyfirm
    echo -ne "\nTu ARDUINO esta preparado!\n"
}

maineng() {
    tput civis
    echo -ne "\nPlug ARDUINO UNO into your PC with the two pins connected" && read 
    echo -ne "\nRemove the jumper that connect pins." && read
    echo -ne "\nReseting ARDUINO to default firmware...\n" && read
    resartfirm
    echo -ne "\nUnplug ARDUINO from pc and plug it again." && read
    echo -ne "\nIf you want to apply any changes to the ARDUINO code go to: ${pathmain}/ARDUINO.ino and edit it" && read 
    echo -ne "\nUpload the code into ARDUINO" && read
    echo -ne "\nConnect two pins to reset ARDUINO" && read
    echo -ne "\nRemove the jumper that connect two pins" && read
    echo -ne "\nWriting Keyboard Firmware\n" && read
    keyfirm
    echo -ne "\nYour ARDUINO is ready\n"
}

dfu