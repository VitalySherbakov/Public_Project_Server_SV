#!/bin/bash
versionscript=1.011
echo "Установка и Развертывание Проекта Server SV (Щ.В) (v $versionscript)"
distributivelinex=$(lsb_release -is)
numberversionlinex=$(lsb_release -rs)
pythonversion=3.8.0
function function_pack(){
	sudo apt-get install build-essential -y && \
	sudo apt-get install zlib1g-dev -y && \
	sudo apt-get install libncurses5-dev -y && \
	sudo apt-get install libgdbm-dev -y && \
	sudo apt-get install libnss3-dev -y && \
	sudo apt-get install libssl-dev -y && \
	sudo apt-get install libreadline-dev -y && \
	sudo apt-get install libffi-dev -y && \
	echo "Установка Пакетов Завершена 1!" && \
	apt-get update -y && apt-get upgrade -y && \
	echo "Автообновление Завершено!" && \
	wget "https://www.python.org/ftp/python/$pythonversion/Python-$pythonversion.tgz" -O  "Python-$pythonversion.tgz" && \
	tar -zxvf "Python-$pythonversion.tgz" && \
	cd "Python-$pythonversion" && \
	./configure --enable-optimizations && \
	make -j $(nproc) && \
	sudo make altinstall && \
	apt-get update -y && apt-get upgrade -y && \
	echo "Автообновление Завершено!" && \
	echo "Установка Пакетов Завершена 2!"
}
while true
do
	if [ "$distributivelinex" == "Debian" ]; then
		echo "Линекс: $distributivelinex"
		if [ "$numberversionlinex" == 11 ]; then
			echo "Версия: $numberversionlinex"
			echo "Команда: pack (Установка необходимых пакетов)"
			read command
			if [ "$command" == "pack" ]; then
				function_pack
			fi
		fi
		if [ "$numberversionlinex" == 10 ]; then
			echo "Версия: $numberversionlinex"
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