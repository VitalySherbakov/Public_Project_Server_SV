#!/bin/bash
versionscript=1.011
echo "Установка и Развертывание Проекта Server SV (Щ.В) (v $versionscript)"
distributivelinex=$(lsb_release -is)
numberversionlinex=$(lsb_release -rs)
pythonversion=3.8.0
pythonrun="python3.8"
gitprojectdownlama="https://github.com/antimatter15/alpaca.cpp"
function function_pack(){
	Python-3.8.0/python -m pip install shell-gpt && \
	echo "Адррес: https://platform.openai.com/account/api-keys" && \
	echo "Введите Ключь API ChatGPT" && \
	sgpt
}
function function_pack2(){
	nameuser=$USER
	sudo apt-get install wget -y && \
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
	rm -r "Python-$pythonversion.tgz" && \
	echo "Установка Пакетов Завершена 2!" && \
	$pythonrun --version && \
	echo "Команда Вызова" && \
	echo "$pythonrun script.py"
	cd "/home/$nameuser"
}
while true
do
	if [ "$distributivelinex" == "Debian" ]; then
		echo "Линекс: $distributivelinex"
		if [ "$numberversionlinex" == 11 ]; then
			echo "Версия: $numberversionlinex"
			echo "Команда: python (Установка python)"
			echo "Команда: shell (Установка shell-gpt)"
			echo "Команда: sgpt --help"
			echo "Команда: sgpt \"Раскажы про Апельсин\""
			echo "Команда: mkdir test && nano 1.txt"
			echo "Команда: sgpt --shell \"Сделай файл 1.txt доступным только для чтения\""
			echo "Команда: sgpt --shell --execute \"Сделай файл 1.txt доступным только для чтения\" -y (Отдать управление Линексом, ChatGPT, где он сам все сделает за человека)"
			echo "Команда: sgpt -se \"Обнови мою систему\" (Сокращенный вариант)"
			echo "Команда: sgpt --code \"Создай код генерации ключей\" (Для создание кода)"
			echo "Команда: sgpt --code \"Создай код генерации ключей\" > Main.py (Для создание кода, запись в файл Main.py)"
			echo "Команда: sgpt --chat number \"Запомни высоту ветра 170 метров\" (Использование Кеша)"
			echo "Команда: sgpt --chat number \"К моей высоте прибавь 45 метров\" (Использование Кеша)"
			read command
			if [ "$command" == "shell" ]; then
				function_pack
			fi
			if [ "$command" == "python" ]; then
				function_pack2
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
		if [ "$numberversionlinex" == 20.04 ]; then
			echo "Версия: $numberversionlinex"
		fi
		if [ "$numberversionlinex" == 22.10 ]; then
			echo "Версия: $numberversionlinex"
		fi
		if [ "$numberversionlinex" == 18.04 ]; then
			echo "Версия: $numberversionlinex"
		fi
		if [ "$numberversionlinex" == 16.04 ]; then
			echo "Версия: $numberversionlinex"
		fi
		if [ "$numberversionlinex" == 14.04 ]; then
			echo "Версия: $numberversionlinex"
		fi
	fi
	read -p "Нажмите Enter, чтобы продолжить"
done