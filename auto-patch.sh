#!/bin/bash
#
# By Curar 2020r.
#
# Skrypt który automatycznie pobiera patch jądra kernela ze strony
# https://kernel.org przy użyciem programu curl, mapfile
# https://github.com/gpg/gnupg
# https://gnupg.org/
#
# Write using vim editor
# https://github.com/vim/vim
# https://www.vim.org/
# Wersja 1.0

clear
tablica_info["0"]="
==============================================
https://kernel.org

Write using vim editor

 https://github.com/vim/vim
 https://www.vim.org/
==============================================
"
tablica_logo["0"]="
==================================================
     ...::: KERNEL AUTO DOWNLOAD'S PATCH :::...
==================================================
"
echo -e "\e[33m${tablica_info["0"]}\e[0m"
echo -e "\e[32m${tablica_logo["0"]}\e[0m"
echo -e "\e[33mHELLOW !\e[0m"
echo ""
read -p "Press ENTER"
clear

# Definicja zmiennych
function zmienne() {
export ADRES_KERNELA_PLIKI="https://cdn.kernel.org/pub/linux/kernel/${galaz}/sha256sums.asc"
export ADRES_KERNELA="https://cdn.kernel.org/pub/linux/kernel/${galaz}/${wybor}"
}

function wyczysc() {
unset menu_list
unset galaz
unset wybor
unset menu
}

function exist() {
echo -e "\e[33mI will check if you have the appropriate programs in the system\e[0m"
sleep 2
for program in curl mapfile; do
        printf '%-10s' "$program"
  if hash "$program" 2>/dev/null; then
    echo -e "\e[32m- It is installed\e[0m"
    sleep 0.1
 else
    echo -e "\e[31m- It is not installed\e[0m"
    sleep 0.1
    echo "======================================================"
    echo -e "\e[31m STOP !!! - Must have installed packet\e[0m"
    echo "======================================================"
    exit 1
  fi
done
}

function kernele() {
        zmienne;
        curl --compressed -o kernele.asc $ADRES_KERNELA_PLIKI
        clear
        echo -e "\e[32m${tablica_logo["0"]}\e[0m"
        grep -o "patch-[[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+.xz" kernele.asc > patch.txt
        grep -o "patch-[[:digit:]]\+.[[:digit:]]\+.xz" kernele.asc >> patch.txt
        sort -V patch.txt > patch-sort.txt
        mapfile -t menu < patch-sort.txt
        echo $ADRES_KERNELA
        for i in "${!menu[@]}"; do
                menu_list[$i]="${menu[$i]}"
        done
        echo -e "\e[32mChoose a kernel patch :\e[0m"
                select wybor in "${menu_list[@]}" "EXIT"; do
                case "$wybor" in
                        "EXIT")
                        clear
                        ;;
                        *)
                        echo "You chose : $wybor"
                        zmienne;
                        if [ ! -f "$wybor" ] && [ ! -f "$KERNEL_SIGN" ]; then {
                                if curl --output /dev/null --silent --head --fail "$ADRES_KERNELA"; then {
                                        curl --compressed --progress-bar -o "$wybor" "$ADRES_KERNELA"
                                }
                                else {
                                     echo "Kernel patch not exist : $ADRES_KERNELA"
                                     sleep 2
                                } fi
                        }
                        else {
                             echo -e "\e[32m==========================================\e[0m"
                             echo -e "\e[32m= The kernel patch is already downloaded =\e[0m"
                             echo -e "\e[32m==========================================\e[0m"
                             echo -e "\e[33mKernel patch download: $wybor.tar.xz\e[0m"
                             sleep 2
                        } fi
                        ;;
                esac
                break
                done
        read -p "Press ENTER"
        clear
}

while :; do
wyczysc;
echo -e "\e[32m${tablica_logo["0"]}\e[0m"
select galaz in "Downloads kernel patch 3.x" "Downloads kernel patch 4.x" "Downloads kernel patch 5.x" "EXIT"; do
	case "$galaz" in
		"Downloads kernel patch 3.x")
			galaz="v3.x"
		;;
		"Downloads kernel patch 4.x")
			galaz="v4.x"
		;;
		"Downloads kernel patch 5.x")
			galaz="v5.x"
		;;
	"EXIT")
		clear
		exit 1
		;;
esac
break
done
exist;
kernele;
done
