#!/bin/bash
arch=$(uname -a)
# Команда 'uname' позволяет посмотреть архитектуру ядра -a(включает набор флагов характеристик)
numCPUphys=$(cat /proc/cpuinfo | grep "physical id" | uniq | sort | wc -l)
# Смотрим количество физических процессов в /proc/cpuinfo, сортируем, объединяем, считаем количество
numCPUvirt=$(cat /proc/cpuinfo | grep "^processor" | wc -l)
# Смотрим виртуальные процессы
total_ram=$(free -m | grep "Mem" | awk '{print $2}')  # доступно общее количество оперативной памяти
# free -m (команда вывода памяти)
# awk инструмент фильтрации данных awk 'условие {действие}'
used_ram=$(free -m | grep "Mem" | awk '{print $3}')   # использовано оперативной памяти
k_used_ram=$(free -m | grep "Mem" | awk '{printf("%.2f"), $3/$2 * 100}')   # коэффициент использования оперативной памяти
total_disk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{total += $2} END {print total}')    # общая память на диске
used_disk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{used += $3} END {print used}')    # использованная память на диске
k_used_disk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{total += $2} {used += $3} END {printf("%d"), used/total*100}')  # процент использованной памяти
CPU_load=$(top -bn1 | grep "^%Cpu" | cut -c 9- | xargs | awk '{printf("%.1f"), $1 + $3}')
last_boot=$(who -b | awk '{print $3, $4}')   #  дата и время последнего reboot
nLVM=$(lsblk | grep 'lvm' | wc -l)
LVMu=$(if [ $LVM -eq 0 ]; then echo "no"; else echo "yes"; fi)
connectTCP=$(cat /proc/net/sockstat{,6} | grep "TCP:" | awk '{print $3}')
user_log=$(users | wc -w)
ip=$(hostname -I)
MACadress=$(ip linl show | grep "link/ether" | awk '{print $2}')
n_cmd=$(journalctl _COMM=sudo -q | grep "COMMAND" | wc -l)
wall "#architecture: ${arch}
      #CPU physical: ${numCPUphys}
      #vCPU: ${numCPUvirt}
      #Memory Usage: ${used_ram}/${total_ram}MB (${k_used_ram}%)
      #Disk Usage: ${used_disk}/${total_disk}Gb (${k_used_disk}%)
      #CPU load: ${CPU_load}%
      #Last boot: ${last_boot}
      #LVM use: ${LVMu}
      #Connecxions TCP: ${connectTCP} ESTABLISHED
      User log: ${user_log}
      #Network: IP $ip (${MACadress})
      #Sudo: ${n_cmd} cmd"
