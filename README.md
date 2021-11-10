# born2beroot

## Установка Debian на VirtualBox, разбиение диска на тома.
## *sudo*
### 1. Установка *sudo*
#### 1.1. Меняем пользователя на root.
#### *su [option][-][user]*
[-] - смена контекста выполнения оболочки на контекст указанного пользователя. Переменные $PATH, $HOME, $SHELL, $USER, $LOGNAME содержат значения, характерные для указанного пользователя. Домашняя папка пользователя меняется на другую.
user — имя пользователя, под которым продолжит работать командная оболочка.
```
$ su -
Password:
```
#### 1.2. Устанавливаем sudo
```
$ apt-get update -y
```
Это команда, которая обычно вызывается после новой установки системы или перед установкой нового программного пакета.
Команда apt update обновляет индекс пакетов в системе Linux или списки пакетов.
Он не обновляет какие-либо пакеты, как заблуждаются некоторые пользователи Linux.
Индексный файл пакетов – это файл или база данных, которые содержат список программных пакетов, определенных в репозиториях, расположенных в файле /etc/apt/sources.list.
Остальные списки пакетов находятся в каталоге /etc/apt/sources.list.d.
> -y (это ключ yes)
```
$ apt-get upgrade -y
```
Команда apt upgrade без каких-либо аргументов обновляет все устаревшие пакеты, находящиеся в вашей системе, до последних версий.
Если требуются какие-либо зависимости, команда также запускает установку новых пакетов.
```
$ apt install sudo
```
#### 1.3. Добавляем пользователя в группу *sudo*
```
usermod -aG sudo your_username
```
#### 1.4. Проверка: какие пользователи входят в группу *sudo*
```
$ getent group sudo
```
### 2. Настройка конфигурации *sudo*
В файле /etc/sudoers.d/filename
*filename* не должен оканчиваться на ~ или содержать .
```
Defaults        passwd_tries=3
Defaults        badpass_message="custom-error-message"
```
Журнал действий sudo (нужно создать папку sudo по данной директории)
```
# Defaults        logfile="/var/log/sudo/filename
```
Архивация всех входов и выходов
```
Defaults        log_input,log_output
Defaults        iolog_dir="/var/log/sudo"
```
Требование TTY (что это)
```
Defaults        requiretty
```
Установка путей *sudo*
```
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```
## *SSH*
### 1. Установка и конфигурация SSH
Установка *openssh-server*.
```
$ sudo apt install openssh-server
```
Проверка, что установлен *openssh-server*, выполняем команду `dpkg -l | grep ssh`.
```
$ dpkg -l | grep ssh
```
Настраиваем конфигурацию SSH
```
$ sudo vi /etc/ssh/sshd_config
```
Устанавливаем SSH Port 4242:
```
13 #Port 22
```
меняем на:
```
13 Port 4242
```
Чтобы отключить вход по SSH как *root* независимо от механизма аутификации, меняем строку
```
32 #PermitRootLogin prohibit-password
```
на:
```
32 PermitRootLogin no
```
Проверка статуса SSH:
```
$ sudo service ssh status
```
>или командой:.
>```
>$ systemctl status ssh
>```
Перезапуск SSH сервиса
```
>$ service ssh restart
```
### 2. Установка и конфигурация UFW (Uncomplicated Firewall)
Установка ufw
> UFW (Uncomplicated Firewall) - является самым простым и довольно популярным инструментарием командной строки для настройки и управления брандмауэром в дистрибутивах Ubuntu и Debian.
```
$ apt-get install ufw
```
Включение
```
$ sudo ufw enable
```
Проверка состояния ufw
```
$ sudo ufw status numbered
```
Настройка правил
```
$ sudo ufw allow ssh
```
Разрешение на подключение по порту 4242
```
$ sudo ufw allow 4242
```
Удаление правила (на защите)
```
$ sudo ufw status numbered
$ sudo ufw delete (that number, for example 5 or 6)
```
### 3. Подключение SSH сервера
В виртуальной машине в настройках сети указать порт хоста и гостя 4242 без IP
Перезапуск сервиса SSH
```
$ sudo systemctl restart ssh
```
```
$ sudo service sshd status
```
Подключение из терминала компа
```
$ ssh your_username@127.0.0.1 -p 4242
```
Выход из соединения
```
$ exit
```
