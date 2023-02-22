#!/bin/bash
echo "Установка и Развертывание Проекта Server SV"
distributivelinex=$(lsb_release -is)
numberversionlinex=$(lsb_release -rs)
if [ "$distributivelinex" == "Debian" ]; then
	echo "Линекс: $distributivelinex"
	if [ "$numberversionlinex" == 11 ]; then
	echo "Версия: $numberversionlinex"
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