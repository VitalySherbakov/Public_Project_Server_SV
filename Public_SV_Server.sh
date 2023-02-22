#!/bin/bash
echo "Установка и Развертывание Проекта Server SV"
distributivelinex=$(lsb_release -is)
numberversionlinex=$(lsb_release -rs)
if [ "$distributivelinex" == "Debian" ]; then
	echo "Линекс: $distributivelinex"
	if [ "$numberversionlinex" == 11 ]; then
	echo "Версия: $numberversionlinex"
	apt-get install ssh
	echo "Укажыте IP Стартовое:"
	read ipone
	echo "Укажыте IP Второе:"
	read iptwo
	echo "Укажыте IP Роутера:"
	read ipgateway
	echo "# This file describes the network interfaces available on yoyr system" >> /etc/network/interfaces2
	echo "# and how to activate them. For more information, see interfaces(5)" >> /etc/network/interfaces2
	echo "" >> /etc/network/interfaces2
	echo "source /etc/network/interfaces.d/*" >> /etc/network/interfaces2
	echo "" >> /etc/network/interfaces2
	echo "# The loopback network interface" >> /etc/network/interfaces2
	echo "auto enp0s3" >> /etc/network/interfaces2
	echo "iface enp0s3 inet static" >> /etc/network/interfaces2
	echo "	address $ipone/24" >> /etc/network/interfaces2
	echo "	gateway $ipgateway/24" >> /etc/network/interfaces2
	echo "iface enp0s3 inet static" >> /etc/network/interfaces2
	echo "	address $iptwo/24" >> /etc/network/interfaces2
	#systemctl restart networking.service
	fi
	if [ "$numberversionlinex" == 10 ]; then
	echo "Версия: $numberversionlinex"
	fi
	if [ "$numberversionlinex" == 9 ]; then
	echo "Версия: $numberversionlinex"
	fi
fi
if [ "$distributivelinex" == "Ubuntu" ]; then
	echo "Линекс: $distributivelinex"
	if [ "$numberversionlinex" == 10 ]; then
	echo "Версия: $numberversionlinex"
	fi
fi
read -p "Нажмите Enter, чтобы продолжить"