#!/bin/bash
arch=$(uname -a)
# Команда 'uname' позволяет посмотреть архитектуру ядра -a(включает набор флагов характеристик)
numCPUphys=$(cat /proc/cpuinfo | grep "physical id" | uniq | sort | wc -l)
# Смотрим количество физических процессов в /proc/cpuinfo, сортируем, объединяем, считаем количество
numCPUvirt=$(cat /proc/cpuinfo | grep "^processor" | wc -l)
# Смотрим
tram=$(free -m | grep "Mem" | awk '{print $2}')
# free -m (команда вывода памяти)
# awk инструмент фильтрации данных awk 'условие {действие}'
uram=$(free -m | grep "Mem" | awk '{print $3}')
k_ram=$(free -m | grep "Mem" | awk '{printf("%.2f"), $3/$2 * 100}')
