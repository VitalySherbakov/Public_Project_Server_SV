#!/bin/bash
echo "Установка и Развертывание Проекта Server SV (Щ.В)"
distributivelinex=$(lsb_release -is)
numberversionlinex=$(lsb_release -rs)
gitprojectdown="https://github.com/VitalySherbakov/Server_Nord_Palantir"
gitprojectdir="Server_Nord_Palantir"
gitprojectrun="BlazorApp1"
command=""
# иницилизацыя
function_init(){
	echo "Настройка Сети на Публикацию"
	echo "Укажыте IP Стартовое Основное:"
	read ipone
	echo "Укажыте IP Второе:"
	read iptwo
	echo "Укажыте IP Роутера:"
	read ipgateway
	echo "Напишыте Имя Папки с Проектом:"
	read dirproject
	echo "Укажыте IP или Хост Проекта для Публикации:"
	read iphostproject
	rm "/etc/network/interfaces"
	echo "# This file describes the network interfaces available on yoyr system" >> /etc/network/interfaces
	echo "# and how to activate them. For more information, see interfaces(5)" >> /etc/network/interfaces
	echo "" >> /etc/network/interfaces
	echo "source /etc/network/interfaces.d/*" >> /etc/network/interfaces
	echo "" >> /etc/network/interfaces
	echo "# The loopback network interface" >> /etc/network/interfaces
	echo "auto enp0s3" >> /etc/network/interfaces
	echo "iface enp0s3 inet static" >> /etc/network/interfaces
	echo "	address $ipone/24" >> /etc/network/interfaces
	echo "	gateway $ipgateway/24" >> /etc/network/interfaces
	echo "iface enp0s3 inet static" >> /etc/network/interfaces
	echo "	address $iptwo/24" >> /etc/network/interfaces
	ip addr add $iptwo dev enp0s3
	systemctl restart networking.service
	mkdir projects
	sudo mkdir -p /var/www/dotnet_sites
	sudo chown -R :www-data /var/www/dotnet_sites
	sudo chown -R www-data:www-data /var/www/dotnet_sites
	sudo chmod 775 /var/www/dotnet_sites
	echo "После просмотра статуса нажымаем клавищы CTRL+C для выхода"
	#sudo systemctl status nginx.service
	mkdir "/var/www/dotnet_sites/$dirproject"
	cd "/var/www/dotnet_sites/$dirproject"
	git clone $gitprojectdown
	cd ..
	cd ..
	cd ..
	cd ..
	rm "/etc/hosts"
	echo "127.0.0.1       localhost" >> /etc/hosts
	echo "127.0.1.1       debiantest.debiantest   debiantest" >> /etc/hosts
	echo "127.0.0.1		$dirproject.local" >> /etc/hosts
	echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts
	echo "::1     localhost ip6-localhost ip6-loopback" >> /etc/hosts
	echo "ff02::1 ip6-allnodes" >> /etc/hosts
	echo "ff02::2 ip6-allrouters" >> /etc/hosts
	echo "Запуск Пинга..."
	ping "$dirproject.local"
	echo "Копирование настроек..."
	sudo cp "/etc/nginx/sites-available/default" "/etc/nginx/sites-available/$dirproject.local"
	cd "/etc/nginx/sites-available/"
	sudo chmod 764 "$dirproject.local"
	sudo chmod 746 "$dirproject.local"
	sudo chmod 777 "$dirproject.local"
	cd ..
	cd ..
	cd ..
	echo "Изменение настроек..."
	rm "/etc/nginx/sites-available/$dirproject.local"
	echo "server {" >> /etc/nginx/sites-available/$dirproject.local
	echo "	listen 80;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	listen [::]:80;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	" >> /etc/nginx/sites-available/$dirproject.local
	echo "	root /var/www/html;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	index index.html index.htm index.nginx-debian.html" >> /etc/nginx/sites-available/$dirproject.local
	echo "	" >> /etc/nginx/sites-available/$dirproject.local
	echo "	server_name $dirproject.local;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	" >> /etc/nginx/sites-available/$dirproject.local
	echo "	location / {" >> /etc/nginx/sites-available/$dirproject.local
	echo "	proxy_pass $iphostproject;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	}" >> /etc/nginx/sites-available/$dirproject.local
	echo "}" >> /etc/nginx/sites-available/$dirproject.local
	sudo systemctl restart nginx.service
	sudo ln -s "/etc/nginx/sites-available/$dirproject.local" "/etc/nginx/sites-enabled/$dirproject.local"
	sudo systemctl restart nginx.service
	sudo nginx -t
	echo "Запуск Проекта..."
	echo "/var/www/dotnet_sites/$dirproject/$gitprojectdir"
	cd "/var/www/dotnet_sites/$dirproject/$gitprojectdir"
	echo ./$gitprojectrun
	./$gitprojectrun
}
function_run(){
	echo "Напишыте Имя Папки с Проектом:"
	read dirproject
	echo "Запуск Проекта..."
	echo "/var/www/dotnet_sites/$dirproject/$gitprojectdir"
	cd "/var/www/dotnet_sites/$dirproject/$gitprojectdir"
	echo ./$gitprojectrun
	./$gitprojectrun
}
function_pack11(){
	apt-get install ssh -y
	sudo apt-get install nginx -y
	sudo apt-get install wget -y
	echo "Загрузка Пакетов 1..."
	wget "https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb" -O "packages-microsoft-prod.deb"
	sudo dpkg -i "packages-microsoft-prod.deb"
	rm "packages-microsoft-prod.deb"
	echo "Установка Пакетов 2..."
	sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-7.0
	echo "Установка Пакетов 3..."
	sudo apt-get update && \
    sudo apt-get install -y aspnetcore-runtime-7.0
	echo "Установка Пакетов 4..."
	sudo apt-get install -y dotnet-runtime-7.0
	apt-get update -y && apt-get upgrade -y
	echo "Автообновление Завершено!"
}
function_delssh(){
	sudo apt-get remove ssh
	apt-get update -y && apt-get upgrade -y
	echo "Автообновление Завершено!"
	echo "SSH Удален!"
}
if [ "$distributivelinex" == "Debian" ]; then
	echo "Линекс: $distributivelinex"
	if [ "$numberversionlinex" == 11 ]; then
	echo "Версия: $numberversionlinex"
	echo "Команда: pack (Установка необходимых пакетов)"
	echo "Команда: init (Установка и настройка проекта)"
	echo "Команда: sshrm (Удаление ssh доступа)"
	echo "Команда: run (Запуск проекта)"
	echo "Введите Команду:"
	read command
	# удалить ssh
	if ["$command"=="sshrm"] them
	function_delssh
	fi
	# установка пакетов
	if ["$command"=="pack"] them
	function_pack11
	fi
	# установка проекта
	if ["$command"=="init"] them
	function_init
	fi
	# запуск пакетов
	if ["$command"=="run"] them
	function_run
	fi
	if [ "$numberversionlinex" == 10 ]; then
	echo "Версия: $numberversionlinex"
	echo "Пока не доступно!"
	fi
	if [ "$numberversionlinex" == 9 ]; then
	echo "Версия: $numberversionlinex"
	echo "Пока не доступно!"
	fi
fi
if [ "$distributivelinex" == "Ubuntu" ]; then
	echo "Линекс: $distributivelinex"
	if [ "$numberversionlinex" == 10 ]; then
	echo "Версия: $numberversionlinex"
	echo "Пока не доступно!"
	fi
fi
read -p "Нажмите Enter, чтобы продолжить"