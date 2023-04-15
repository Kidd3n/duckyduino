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
