#!/bin/bash
versionscript=1.010
echo "Установка и Развертывание Проекта Server SV (Щ.В) (v $versionscript)"
distributivelinex=$(lsb_release -is)
numberversionlinex=$(lsb_release -rs)
gitprojectdown="https://github.com/VitalySherbakov/Server_Nord_Palantir"
gitprojectdir="Server_Nord_Palantir"
gitprojectrun="Server_Nord_Palantir"
# настройка сети
function function_lan(){
	echo "Настройка Сети на Публикацию"
	namelan=$(ls /sys/class/net/ | head -n 1)
	echo "IP Адреса Машыны"
	ip addr show
	echo "IP Шлюза Машыны (Роутер, или WIFI, или Проводной Интернет)"
	ip route
	echo "Имя Сетевого Интерфейса: $namelan"
	echo "Укажыте IP Стартовое Основное:"
	read ipone
	echo "Укажыте IP Второе:"
	read iptwo
	echo "Укажыте IP Роутера:"
	read ipgateway
	rm "/etc/network/interfaces"
	echo "# This file describes the network interfaces available on yoyr system" >> /etc/network/interfaces
	echo "# and how to activate them. For more information, see interfaces(5)" >> /etc/network/interfaces
	echo "" >> /etc/network/interfaces
	echo "source /etc/network/interfaces.d/*" >> /etc/network/interfaces
	echo "" >> /etc/network/interfaces
	echo "# The loopback network interface" >> /etc/network/interfaces
	echo "auto lo" >> /etc/network/interfaces
	echo "iface lo inet loopback" >> /etc/network/interfaces
	echo "" >> /etc/network/interfaces
	echo "auto $namelan" >> /etc/network/interfaces
	echo "iface $namelan inet static" >> /etc/network/interfaces
	echo "	address $ipone/24" >> /etc/network/interfaces
	echo "	#netmask 255.255.255.0" >> /etc/network/interfaces
	echo "	gateway $ipgateway" >> /etc/network/interfaces
	echo "	#dns-nameservers 8.8.8.8 8.8.4.4" >> /etc/network/interfaces
	echo "iface $namelan inet static" >> /etc/network/interfaces
	echo "	address $iptwo/24" >> /etc/network/interfaces
	#ip addr add $iptwo dev $namelan
	systemctl restart networking.service
	ip a
	echo "IP Основной: $ipone"
	echo "IP Дополнительный: $iptwo"
	echo "IP Источник: $ipgateway"
	echo "Если нужно откоректировать выполните команду"
	echo "nano /etc/network/interfaces"
	echo "Сеть на Публикацию Настроина!"
}
# ip информация
function function_ipa(){
	echo "IP Адреса Машыны"
	ip addr show
	echo "IP Шлюза Машыны (Роутер, или WIFI, или Проводной Интернет)"
	ip route
}
function function_init3(){
	nameuser=$USER
	echo "Имя Пользователя: $nameuser"
	# чтение проекта
	echo "---------Список Проектов---------"
	cat projects_list.txt
	echo "---------------------------------"
	echo "Напишыте Имя Папки с Проектом:"
	read dirproject
	echo "Укажыте Хост Запуска Проекта (http или https)"
	read hostrunhttp
	hostrun="$hostrunhttp://localhost:5000/"
	echo "IP Адреса Машыны"
	ip addr show
	echo "Укажыте IP или Хост Проекта для Публикации:"
	read iphostproject
	sudo mkdir -p "/var/www/sites"
	sudo chown -R $nameuser:$nameuser /var/www/sites
	echo "Путь: $gitprojectdown"
	ls
	git clone "$gitprojectdown"
	ls
	rm -r "/var/www/sites/$dirproject"
	mkdir "/var/www/sites/$dirproject"
	pwddir=$(pwd)
	sudo cp -R "$pwddir/Server_Nord_Palantir/." "/var/www/sites/$dirproject/"
	rm -r "$pwddir/Server_Nord_Palantir"
	echo "Изменение настроек..."
	filenginx="/etc/nginx/nginx.conf"
	rm -r $filenginx
	echo "user www-data;" >> $filenginx
	echo "worker_processer auto;" >> $filenginx
	echo "pid /run/nginx.pid;" >> $filenginx
	echo "include /etc/nginx/modules-enabled/*.conf;" >> $filenginx
	echo "" >> $filenginx
	echo "events {" >> $filenginx
	echo "        worker_connection 768;" >> $filenginx
	echo "        # multi_accept on;" >> $filenginx
	echo "}" >> $filenginx
	echo "" >> $filenginx
	echo "http {" >> $filenginx
	echo "        server {" >> $filenginx
	echo "                listen $iphostproject;" >> $filenginx
	echo "                location / {" >> $filenginx
	echo "                   proxy_pass $hostrun;" >> $filenginx
	echo "                   proxy_http_version 1.1;" >> $filenginx
	echo "                   proxy_set_header Upgrade $http_upgrade;" >> $filenginx
	echo "                   proxy_set_header Connection keep-alive;" >> $filenginx
	echo "                   proxy_set_header Host $host;" >> $filenginx
	echo "                   proxy_cache_bypass $http_upgrade;" >> $filenginx
	echo "                   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;" >> $filenginx
	echo "                   proxy_set_header X-Forwarded-Proto $scheme;" >> $filenginx
	echo "                   }" >> $filenginx
	echo "               }" >> $filenginx
	echo "               ##" >> $filenginx
	echo "               # Basic Settings" >> $filenginx
	echo "               ##" >> $filenginx
	echo "" >> $filenginx
	echo "               sendfile on;" >> $filenginx
	echo "               tcp_nopush on;" >> $filenginx
	echo "               types_hash_max_size 2048;" >> $filenginx
	echo "               # server_tokens off;" >> $filenginx
	echo "" >> $filenginx
	echo "               # server_names_hash_bucket_size 64;" >> $filenginx
	echo "               # server_names_in_redirect off;" >> $filenginx
	echo "" >> $filenginx
	echo "               include /etc/nginx/mime.types;" >> $filenginx
	echo "               default_type application/octet-stream;" >> $filenginx
	echo "" >> $filenginx
	echo "               ##" >> $filenginx
	echo "               # SSL Settings" >> $filenginx
	echo "               ##" >> $filenginx
	echo "" >> $filenginx
	echo "               ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; #Dropping SSLv3, ref: POOf: POOODLE" >> $filenginx
	echo "               ssl_prefer_server_ciphers on;" >> $filenginx
	echo "" >> $filenginx
	echo "               ##" >> $filenginx
	echo "               # Logging Settings" >> $filenginx
	echo "               ##" >> $filenginx
	echo "" >> $filenginx
	echo "               access_log /var/log/nginx/access.log;" >> $filenginx
	echo "               error_log /var/log/nginx/error.log;" >> $filenginx
	echo "" >> $filenginx
	echo "               ##" >> $filenginx
	echo "               # Gzip Settings" >> $filenginx
	echo "               ##" >> $filenginx
	echo "" >> $filenginx
	echo "               gzip on;" >> $filenginx
	echo "" >> $filenginx
	echo "               # gzip_vary on;" >> $filenginx
	echo "               # gzip_proxied any;" >> $filenginx
	echo "               # gzip_comp_level 6;" >> $filenginx
	echo "               # gzip_buffers 16 8k;" >> $filenginx
	echo "               # gzip_http_version 1.1;" >> $filenginx
	echo "               # gzip_types text/plain text/css application/json application/javascript text/xml application/xml+rss text/javascript;" >> $filenginx
	echo "" >> $filenginx
	echo "               ##" >> $filenginx
	echo "               # Virtual Host Configs" >> $filenginx
	echo "               ##" >> $filenginx
	echo "" >> $filenginx
	echo "include /etc/nginx/conf.d/*.conf;" >> $filenginx
	echo "include /etc/nginx/sites-enabled/*;" >> $filenginx
	echo "}" >> $filenginx
	echo "" >> $filenginx
	echo "" >> $filenginx
	echo "#mail {" >> $filenginx
}
function function_init2(){
	nameuser=$USER
	echo "Имя Пользователя: $nameuser"
	# чтение проекта
	echo "---------Список Проектов---------"
	cat projects_list.txt
	echo "---------------------------------"
	echo "Напишыте Имя Папки с Проектом:"
	read dirproject
	echo "Укажыте Хост Запуска Проекта (http или https)"
	read hostrunhttp
	hostrun="$hostrunhttp://localhost:5000/"
	echo "IP Адреса Машыны"
	ip addr show
	echo "Укажыте IP или Хост Проекта для Публикации:"
	read iphostproject
	sudo mkdir -p "/var/www/sites"
	sudo chown -R $nameuser:$nameuser /var/www/sites
	echo "Путь: $gitprojectdown"
	ls
	git clone "$gitprojectdown"
	ls
	rm -r "/var/www/sites/$dirproject"
	mkdir "/var/www/sites/$dirproject"
	pwddir=$(pwd)
	sudo cp -R "$pwddir/Server_Nord_Palantir/." "/var/www/sites/$dirproject/"
	rm -r "$pwddir/Server_Nord_Palantir"
	# Использование /etc/hosts
	# Создание настроек...
	# Изменение настроек...
	echo "Изменение настроек..."
	rm "/etc/nginx/sites-available/$dirproject.local"
	echo "server {" >> /etc/nginx/sites-available/$dirproject.local
	echo "	listen 80;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	server_name $iphostproject;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	" >> /etc/nginx/sites-available/$dirproject.local
	echo "	location / {" >> /etc/nginx/sites-available/$dirproject.local
	echo "	  proxy_pass $hostrun;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	  proxy_http_version 1.1;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	  proxy_set_header   Upgrade \$http_upgrade;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	  proxy_set_header   Connection keep-alive;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	  proxy_set_header   Host \$host;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	  proxy_cache_bypass \$http_upgrade;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	  proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	  proxy_set_header   X-Forwarded-Proto \$scheme;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	}" >> /etc/nginx/sites-available/$dirproject.local
	echo "}" >> /etc/nginx/sites-available/$dirproject.local
	sudo chmod 777 "/etc/nginx/sites-available/$dirproject.local"
	sudo ln -s "/etc/nginx/sites-available/$dirproject.local" "/etc/nginx/sites-enabled/"
	sudo chmod 777 "/etc/nginx/sites-enabled/$dirproject.local"
	sudo systemctl restart nginx.service
	sudo nginx -t
	sudo systemctl restart nginx
	sudo chmod 777 "/var/www/sites/$dirproject/$gitprojectrun"
	ip a
	# запись проекта
	echo "$dirproject | $dirproject.local | $iphostproject | $gitprojectrun" >> projects_list.txt
	# чтение проекта
	echo "---------Список Проектов---------"
	cat projects_list.txt
	echo "---------------------------------"
	echo "Адресс Проекта: $iphostproject"
	cd "/var/www/sites/$dirproject"
	./$gitprojectrun
}
function function_clear(){
	echo "Очистка Всего"
	nameuser=$USER
	pwddir=$(pwd)
	rm -r "/var/www/sites"
	sudo mkdir -p "/var/www/sites"
	sudo chown -R $nameuser:$nameuser /var/www/sites
	# настройки
	sudo mkdir -p "/var/www/available_tmp/default"
	sudo chown -R $nameuser:$nameuser /var/www/available_tmp/default
	sudo cp -R "$pwddir/etc/nginx/sites-available/default" "/var/www/available_tmp/default"
	rm -r "/etc/nginx/sites-available"
	sudo mkdir -p "/etc/nginx/sites-available"
	sudo chown -R $nameuser:$nameuser /etc/nginx/sites-available
	sudo cp -R "$pwddir/var/www/available_tmp/default" "$pwddir/etc/nginx/sites-available/default"
	rm -r "/var/www/available_tmp"
	# настройки 2
	sudo mkdir -p "/var/www/enabled_tmp/default"
	sudo chown -R $nameuser:$nameuser /var/www/enabled_tmp/default
	sudo cp -R "$pwddir/etc/nginx/sites-enabled/default" "/var/www/enabled_tmp/default"
	rm -r "/etc/nginx/sites-enabled"
	sudo mkdir -p "/etc/nginx/sites-enabled"
	sudo chown -R $nameuser:$nameuser /etc/nginx/sites-enabled
	sudo cp -R "$pwddir/var/www/enabled_tmp/default" "$pwddir/etc/nginx/sites-enabled/default"
	rm -r "/var/www/enabled_tmp"
	rm -r "$pwddir/projects_list.txt"
	echo "Очистка Закончина!"
}
# иницилизацыя
function function_init(){
	echo "Напишыте Имя Папки с Проектом:"
	read dirproject
	echo "Укажыте IP или Хост Проекта для Публикации:"
	read iphostproject	
	#mkdir projects
	sudo mkdir -p "/var/www/dotnet_sites"
	sudo chown -R :www-data /var/www/dotnet_sites
	sudo chown -R www-data:www-data /var/www/dotnet_sites
	sudo chmod 775 "/var/www/dotnet_sites"
	#echo "После просмотра статуса нажымаем клавищы CTRL+C для выхода"
	#sudo systemctl status nginx.service
	echo "Путь: $gitprojectdown"
	ls
	git clone "$gitprojectdown"
	ls
	#read -p "Нажмите Enter, чтобы продолжить"
	rm -r "/var/www/dotnet_sites/$dirproject"
	mkdir "/var/www/dotnet_sites/$dirproject"
	pwddir=$(pwd)
	sudo cp -R "$pwddir/Server_Nord_Palantir/." "/var/www/dotnet_sites/$dirproject/"
	rm -r "./Server_Nord_Palantir"
	rm "/etc/hosts"
	echo "127.0.0.1       localhost" >> /etc/hosts
	echo "127.0.1.1       debiantest.debiantest   debiantest" >> /etc/hosts
	echo "127.0.0.1	$dirproject.local" >> /etc/hosts
	echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts
	echo "::1     localhost ip6-localhost ip6-loopback" >> /etc/hosts
	echo "ff02::1 ip6-allnodes" >> /etc/hosts
	echo "ff02::2 ip6-allrouters" >> /etc/hosts
	#echo "Запуск Пинга..."
	#ping "$dirproject.local"
	echo "Копирование настроек..."
	sudo cp "/etc/nginx/sites-available/default" "/etc/nginx/sites-available/$dirproject.local"
	sudo chmod 764 "/etc/nginx/sites-available/$dirproject.local"
	sudo chmod 746 "/etc/nginx/sites-available/$dirproject.local"
	sudo chmod 777 "/etc/nginx/sites-available/$dirproject.local"
	#cd "/etc/nginx/sites-available/"
	#sudo chmod 764 "$dirproject.local"
	#sudo chmod 746 "$dirproject.local"
	#sudo chmod 777 "$dirproject.local"
	#cd ..
	#cd ..
	#cd ..
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
	echo "	  proxy_pass $iphostproject;" >> /etc/nginx/sites-available/$dirproject.local
	echo "	}" >> /etc/nginx/sites-available/$dirproject.local
	echo "}" >> /etc/nginx/sites-available/$dirproject.local
	sudo chmod 777 "/etc/nginx/sites-available/$dirproject.local"
	sudo cp "/etc/nginx/sites-available/$dirproject.local" "/etc/nginx/sites-enabled/$dirproject.local"
	sudo chmod 777 "/etc/nginx/sites-enabled/$dirproject.local"
	sudo systemctl restart nginx.service
	sudo nginx -t
	echo "Запуск Проекта..."
	#echo "Проект: /var/www/dotnet_sites/$dirproject"
	#echo "Запуск: ./$gitprojectrun"
	sudo chmod 777 "/var/www/sites/$dirproject"
	sudo chmod 777 "/var/www/sites/$dirproject/$gitprojectrun"
	cd "/var/www/sites/$dirproject"
	ip a
	./$gitprojectrun
	#read -p "Нажмите Enter, чтобы продолжить"
	cd ..
	cd ..
	cd ..
	cd ..
	#rm -r "/var/www/dotnet_sites/$dirproject"
}
function function_run(){
	echo "---------Список Проектов---------"
	cat projects_list.txt
	echo "---------------------------------"
	echo "Напишыте Имя Папки с Проектом:"
	read dirproject
	echo "Запуск Проекта..."
	#echo "/var/www/dotnet_sites/$dirproject"
	sudo chmod 777 "/var/www/sites/$dirproject"
	ip a
	cd "/var/www/sites/$dirproject"
	./$gitprojectrun
	cd ..
	cd ..
	cd ..
	cd ..
}
function function_list(){
	# чтение проекта
	echo "---------Список Проектов---------"
	cat projects_list.txt
	echo "---------------------------------"
}
function function_pack10(){
	sudo apt-get install ssh -y && \
	sudo apt-get install nginx -y && \
	sudo apt-get install wget -y && \
	echo "Загрузка Пакетов 1..." && \
	wget "https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb" -O "packages-microsoft-prod.deb" && \
	sudo dpkg -i "packages-microsoft-prod.deb" && \
	rm "packages-microsoft-prod.deb" && \
	echo "Установка Пакетов 2..." && \
	sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-7.0 && \
	echo "Установка Пакетов 3..." && \
	sudo apt-get update && \
    sudo apt-get install -y aspnetcore-runtime-7.0 && \
	echo "Установка Пакетов 4..." && \
	sudo apt-get install -y dotnet-runtime-7.0 && \
	apt-get update -y && apt-get upgrade -y && \
	echo "Автообновление Завершено!"
}
function function_pack11(){
	sudo apt-get install ssh -y && \
	sudo apt-get install nginx -y && \
	sudo apt-get install wget -y && \
	echo "Загрузка Пакетов 1..." && \
	wget "https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb" -O "packages-microsoft-prod.deb" && \
	sudo dpkg -i "packages-microsoft-prod.deb" && \
	rm "packages-microsoft-prod.deb" && \
	echo "Установка Пакетов 2..." && \
	sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-7.0 && \
	echo "Установка Пакетов 3..." && \
	sudo apt-get update && \
    sudo apt-get install -y aspnetcore-runtime-7.0 && \
	echo "Установка Пакетов 4..." && \
	sudo apt-get install -y dotnet-runtime-7.0 && \
	apt-get update -y && apt-get upgrade -y && \
	echo "Автообновление Завершено!"
}
function function_delssh(){
	sudo apt-get remove ssh && \
	apt-get update -y && apt-get upgrade -y
	echo "Автообновление Завершено!" && \
	echo "SSH Удален!"
}
function testing(){
	echo "testing"
}

while true
do
	if [ "$distributivelinex" == "Debian" ]; then
		echo "Линекс: $distributivelinex"
		if [ "$numberversionlinex" == 11 ]; then
			echo "Версия: $numberversionlinex"
			echo "Команда: pack (Установка необходимых пакетов)"
			echo "Команда: lan (Установка сети на публикацию)"
			echo "Команда: init (Установка и настройка проекта)"
			echo "Команда: clear (Удалить все проектов)"
			echo "Команда: list (Список Проектов)"
			echo "Команда: ip (Информацыя о ip адресах)"
			echo "Команда: run (Запуск проекта)"
			echo "Команда: sshrm (Удаление ssh доступа)"
			echo "Команда: exit (Выход)"
			echo "Введите Команду:"
			read command
			if [ "$command" == "exit" ]; then
				break
			fi
			if [ "$command" == "lan" ]; then
				function_lan
			fi
			if [ "$command" == "clear" ]; then
				function_clear
			fi
			if [ "$command" == "sshrm" ]; then
				function_delssh
			fi
			if [ "$command" == "pack" ]; then
				function_pack11
			fi
			if [ "$command" == "init" ]; then
				function_init3
			fi
			if [ "$command" == "list" ]; then
				function_list
			fi
			if [ "$command" == "ip" ]; then
				function_ipa
			fi
			if [ "$command" == "run" ]; then
				function_run
			fi
		fi
		if [ "$numberversionlinex" == 10 ]; then
			echo "Версия: $numberversionlinex"
			echo "Команда: pack (Установка необходимых пакетов)"
			echo "Команда: lan (Установка сети на публикацию)"
			echo "Команда: init (Установка и настройка проекта)"
			echo "Команда: clear (Удалить все проектов)"
			echo "Команда: ip (Информацыя о ip адресах)"
			echo "Команда: run (Запуск проекта)"
			echo "Команда: sshrm (Удаление ssh доступа)"
			echo "Команда: exit (Выход)"
			echo "Введите Команду:"
			read command
			if [ "$command" == "exit" ]; then
				break
			fi
			if [ "$command" == "lan" ]; then
				function_lan
			fi
			if [ "$command" == "clear" ]; then
				function_clear
			fi
			if [ "$command" == "sshrm" ]; then
				function_delssh
			fi
			if [ "$command" == "pack" ]; then
				function_pack10
			fi
			if [ "$command" == "init" ]; then
				function_init2
			fi
			if [ "$command" == "list" ]; then
				function_list
			fi
			if [ "$command" == "ip" ]; then
				function_ipa
			fi
			if [ "$command" == "run" ]; then
				function_run
			fi
		fi
		if [ "$numberversionlinex" == 9 ]; then
			echo "Версия: $numberversionlinex"
			echo "Пока не доступно!"
		fi
	fi
	if [ "$distributivelinex" == "Ubuntu" ]; then
		echo "Линекс: $distributivelinex"
		echo "Пока не доступно!"
	fi
	read -p "Нажмите Enter, чтобы продолжить"
done