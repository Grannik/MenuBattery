#!/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PowerSupplyCapacity ()
{
source /sys/class/power_supply/BAT1/uevent
echo "POWER_SUPPLY_CAPACITY=$POWER_SUPPLY_CAPACITY%"
LIMIT=$POWER_SUPPLY_CAPACITY
for ((a=1; a <= LIMIT ; a++))  # Двойные круглые скобки и "LIMIT" без "$".
do
  echo -en "\033[95m#\033[0m"
done
echo " "
echo -e "\e[92m####################################################################################################\e[0m"
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PowerSupplyStatus ()
{
echo "+~~~~~~~~+~~~~~~~~~~+~~~~~~~~~~~~~+
| Full   | Charging | Discharging |
+--------+----------+-------------+
| Полная | Зарядка  | Разрядка    |
+~~~~~~~~+~~~~~~~~~~+~~~~~~~~~~~~~+
"
source /sys/class/power_supply/BAT1/uevent
echo " $POWER_SUPPLY_STATUS
"
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 E='echo -e';    # -e включить поддержку вывода Escape последовательностей
 e='echo -en';   # -n не выводить перевод строки
 trap "R;exit" 2 # 
    ESC=$( $e "\e")
   TPUT(){ $e "\e[${1};${2}H" ;}
  CLEAR(){ $e "\ec";}
# 25 возможно это 
  CIVIS(){ $e "\e[?25l";}
# это цвет текста списка перед курсором при значении 0 в переменной  UNMARK(){ $e "\e[0m";}
MARK(){ $e "\e[45m";}
# 0 это цвет списка
 UNMARK(){ $e "\e[0m";}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Эти строки задают цвет фона ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  R(){ CLEAR ;stty sane;CLEAR;};                 # в этом варианте фон прозрачный
# R(){ CLEAR ;stty sane;$e "\ec\e[37;44m\e[J";}; # в этом варианте закрашивается весь фон терминала
# R(){ CLEAR ;stty sane;$e "\ec\e[0;45m\e[";};   # в этом варианте закрашивается только фон меню
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
HEAD(){ for (( a=1; a<=32; a++ ))
 do
  TPUT $a 1
       $E "\xE2\x94\x82                                          \xE2\x94\x82";
 done
 TPUT 3 2
           $E "$(tput bold)  Справочник состояние батареи$(tput sgr 0)";
 TPUT 5 2
        $E "$(tput setaf 2) /sys/class/power_supply/BAT1/uevent$(tput sgr 0)";
 TPUT 23 2
        $E "$(tput setaf 2) Утилиты$(tput sgr 0)";
 TPUT 29 2
        $E "$(tput setaf 2) Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter$(tput sgr 0)";
 MARK;TPUT 1 2
        $E " Программа написана на bash tput          ";UNMARK;}
   i=0; CLEAR; CIVIS;NULL=/dev/null
   FOOT(){ MARK;TPUT 32 2
        $E " Grannik | 2021.08.16                     ";UNMARK;}
# это управляет кнопками ввер/хвниз
 i=0; CLEAR; CIVIS;NULL=/dev/null
#
 ARROW(){ IFS= read -s -n1 key 2>/dev/null >&2
           if [[ $key = $ESC ]];then 
              read -s -n1 key 2>/dev/null >&2;
              if [[ $key = \[ ]]; then
                 read -s -n1 key 2>/dev/null >&2;
                 if [[ $key = A ]]; then echo up;fi
                 if [[ $key = B ]];then echo dn;fi
              fi
           fi
           if [[ "$key" == "$($e \\x0A)" ]];then echo enter;fi;}
#
 M0(){ TPUT  6 3; $e " Показать всю инфорьацию о батарее      ";}
 M1(){ TPUT  7 3; $e " Наименование источника питания         ";}
 M2(){ TPUT  8 3; $e " Тип источника питания                  ";}
 M3(){ TPUT  9 3; $e " Зарядка/Разрядка                       ";}
 M4(){ TPUT 10 3; $e " Наличие источника питания              ";}
 M5(){ TPUT 11 3; $e " Технология питания                     ";}
 M6(){ TPUT 12 3; $e " Счетчик циклов питания                 ";}
 M7(){ TPUT 13 3; $e " Минимальное значение источника питания ";}
 M8(){ TPUT 14 3; $e " Напряжение питания сейчас              ";}
 M9(){ TPUT 15 3; $e " Полная конструкция источника питания   ";}
M10(){ TPUT 16 3; $e " Значение полного источника питания     ";}
M11(){ TPUT 17 3; $e " Источник питания зарядка сейчас        ";}
M12(){ TPUT 18 3; $e " Показать заряд батареи                 ";}
M13(){ TPUT 19 3; $e " Уровень мощьности электропитания       ";}
M14(){ TPUT 20 3; $e " Наименование модели источника питания  ";}
M15(){ TPUT 21 3; $e " Производитель блока питания            ";}
M16(){ TPUT 22 3; $e " Серийный номер источника питания       ";}
#
M17(){ TPUT 24 3; $e " acpi                                   ";}
M18(){ TPUT 25 3; $e " upower                                 ";}
M19(){ TPUT 26 3; $e " tlp                                    ";}
M20(){ TPUT 27 3; $e " batstat                                ";}
M21(){ TPUT 28 3; $e " upower                                 ";}
#
M22(){ TPUT 30 3; $e " EXIT                                   ";}
# далее идет переменная LM=16 позволяющая бегать по списоку.
LM=22
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    POS(){ if [[ $cur == up ]];then ((i--));fi
           if [[ $cur == dn ]];then ((i++));fi
           if [[ $i -lt 0   ]];then i=$LM;fi
           if [[ $i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
           if [[ $before -lt 0  ]];then before=$LM;fi
           if [[ $after -gt $LM ]];then after=0;fi
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
# Функция возвращения в меню
     ES(){ MARK;$e " ENTER = main menu ";$b;read;INIT;};INIT
  while [[ "$O" != " " ]]; do case $i in
# Здесь необходимо следить за двумя перепенными 0) и S=M0 Они должны совпадать между собой и переменной списка M0().
    0) S=M0 ;SC;if [[ $cur == enter ]];then R;cat /sys/class/power_supply/BAT1/uevent;ES;fi;;
    1) S=M1 ;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_NAME";ES;fi;;
    2) S=M2 ;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_TYPE";ES;fi;;
    3) S=M3 ;SC;if [[ $cur == enter ]];then R;PowerSupplyStatus;ES;fi;;
    4) S=M4 ;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_PRESENT";ES;fi;;
    5) S=M5 ;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_TECHNOLOGY";ES;fi;;
    6) S=M6 ;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_CYCLE_COUNT";ES;fi;;
    7) S=M7 ;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_VOLTAGE_MIN_DESIGN";ES;fi;;
    8) S=M8 ;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_VOLTAGE_NOW";ES;fi;;
    9) S=M9 ;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_CHARGE_FULL_DESIGN";ES;fi;;
   10) S=M10;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_CHARGE_FULL";ES;fi;;
   11) S=M11;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_CHARGE_NOW";ES;fi;;
   12) S=M12;SC;if [[ $cur == enter ]];then R;PowerSupplyCapacity;ES;fi;;
   13) S=M13;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_CAPACITY_LEVEL";ES;fi;;
   14) S=M14;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_MODEL_NAME";ES;fi;;
   15) S=M15;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_MANUFACTURER";ES;fi;;
   16) S=M16;SC;if [[ $cur == enter ]];then R;source /sys/class/power_supply/BAT1/uevent;echo " $POWER_SUPPLY_SERIAL_NUMBER";ES;fi;;
#
   17) S=M17 ;SC;if [[ $cur == enter ]];then R;echo "
 Установкa:
 sudo apt install acpi

 Чтобы увидеть емкость аккумулятора
 acpi -i

 Проверка температуры батареи:
 acpi -t

 Мы можем просмотреть приведенный выше вывод в градусах Фаренгейта, используя флаг -f:
 acpi -t -f

 Хотите знать, подключен ли источник переменного тока или нет? Просто запустите следующую команду:
 acpi -a

 Чтобы увидеть более подробную информацию
 acpi -V 
";ES;fi;;
#
  18) S=M18 ;SC;if [[ $cur == enter ]];then R;echo "
 upower -i /org/freedesktop/UPower/devices/battery_BAT0
 upower -i `upower -e | grep 'BAT'`
 upower -i $(upower -e | grep BAT) | grep --color=never -E \"state|to\\ full|to\\ empty|percentage\"
 ------------------------------------
 upower -i $(upower -e | grep '/battery') | grep --color=never -E \"state|to\\ full|to\\ empty|percentage\"
 ------------------------------------
 upower -i $(upower -e | grep '/battery') | grep --color=never -E percentage|xargs|cut -d' ' -f2|sed s/%//
=========================================================================================================
 Upower отображает не только состояние батареи, но и полную информацию о ней
 upower -i `upower -e | grep 'BAT'`
 upower -i $(upower -e | grep BAT) | grep --color=never -E \"state|to\\ full|to\\ empty|percentage\"
";ES;fi;;
  19) S=M19 ;SC;if [[ $cur == enter ]];then R;echo "
 sudo tlp-stat -b
 sudo tlp-stat -s
";ES;fi;;
  20) S=M20 ;SC;if [[ $cur == enter ]];then R;echo "
 Установка batstat. Клонируйте последню версию из Git с помощью команды:
 git clone https://github.com/Juve45/batstat.git

 Приведенная выше команда извлечет последнюю версию batstat и сохранит ее содержимое в папке с именем «batstat».
 Перейдите в каталог batstat/bin/:
 cd batstat/bin/

 Скопируйте двоичный файл «batstat» в ваш PATH, например /usr/local/bin/.
 sudo cp batstat /usr/local/bin/

 Сделайте его исполняемым с помощью команды:
 sudo chmod +x /usr/local/bin/batstat

 вам нужно установить пакет libncurses
 sudo apt-get install libncurses5

 Наконец, выполните приведенную ниже команду, чтобы просмотреть состояние батареи.
 batstat
";ES;fi;;
  21) S=M21 ;SC;if [[ $cur == enter ]];then R;echo "
 получить подробный отчет об аккумуляторе:
 upower -i `upower -e | grep 'BAT'`

 просмотреть только состояние зарядки аккумулятора
 upower -i $(upower -e | grep BAT) | grep --color=never -E \"state|to\\ full|to\\ empty|percentage\"

 Показать заряда батареи
 upower -i $(upower -e | grep BAT) | grep --color=never -E percentage|xargs|cut -d' ' -f2|sed s/%//;ES;fi;;
";ES;fi;;

   22) S=M22;SC;if [[ $cur == enter ]];then R;exit 0;fi;;
 esac;POS;done
