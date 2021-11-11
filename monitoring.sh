#!/bin/bash
arch=$(uname -a)
# Команда 'uname' позволяет посмотреть архитектуру ядра -a(включает набор флагов характеристик)
numCPUphys=$(cat /proc/cpuinfo | grep "physical id" | uniq | sort | wc -l)
# Смотрим количество физических процессов в /proc/cpuinfo, сортируем, объединяем, считаем количество
numCPUvirt=$(cat /proc/cpuinfo | grep "^processor" | wc -l)
# Смотрим виртуальные процессы
tram=$(free -m | grep "Mem" | awk '{print $2}')
# free -m (команда вывода памяти)   # доступно общее количество оперативной памяти
# awk инструмент фильтрации данных awk 'условие {действие}'
uram=$(free -m | grep "Mem" | awk '{print $3}')   # использовано оперативной памяти
k_ram=$(free -m | grep "Mem" | awk '{printf("%.2f"), $3/$2 * 100}')   # коэффициент использования оперативной памяти
tdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{total += $2} END {print total}')    # общая память на диске
udisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{used += $3} END {print used}')    # использованная память на диске
kdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{total += $2} {used += $3} END {printf("%d"), used/total*100}')  # процент использованной памяти


date=$(who -b | awk '{print $3, $4}')   #  дата и время последнего reboot
LVM=$(lsblk | grep 'lvm' | wc -l)
uLVM=$(if [$LVM -eq 0]; then echo no; else echo yes; fi)

if [awk '{lsblk | grep 'lvm' | wc -l}' -eq 0]; then echo no; else echo yes; fi
