#!/bin/bash
versionscript=1.011
echo "Установка и Развертывание Проекта Server SV (Щ.В) (v $versionscript)"
distributivelinex=$(lsb_release -is)
numberversionlinex=$(lsb_release -rs)
gitprojectdownlama="https://github.com/antimatter15/alpaca.cpp"

function function_lama(){
	nameuser=$USER
	sudo apt-get install wget -y && \
	sudo apt install build-essential -y && \
	sudo apt-get install make -y && \
	sudo mkdir -p "Projects" && \
	rm -r "Projects" && \
	sudo mkdir -p "Projects" && \
	sudo chown -R $nameuser:$nameuser "Projects" && \
	sudo chmod 777 "Projects" && \
	cd "Projects/" && \
	sudo mkdir -p "alpaca" && \
	sudo chown -R $nameuser:$nameuser "alpaca" && \
	sudo chmod 777 "alpaca" && \
	cd "alpaca/" && \
	echo "Клонирвание Проекта" && \
	git clone "$gitprojectdownlama" && \
	sudo chown -R $nameuser:$nameuser "alpaca.cpp" && \
	sudo chmod 777 "alpaca.cpp" && \
	cd "alpaca.cpp/" && \
	ls && \
	make && \
	echo "----------------------------------" && \
	ls && \
	echo "----------------------------------" && \
	apt-get update -y && apt-get upgrade -y && \
	echo "Автообновление Завершено!" && \
	echo "Lama Создана!"
}
function function_runlama1(){
	cd "/content/Projects/alpaca/alpaca.cpp" && \
	ls && \
	./chat
}
function function_runlama2(){
	cd "/content/Projects/alpaca/alpaca.cpp" && \
	ls && \
	/chat -m ggml-alpaca-13b-q4.bin
}
function function_down_min(){
	ls && \
	wget "https://drive.google.com/uc?export=download&confirm=no_antivirus&id=1g3RDV6M2G3L-0v5h4KQ_2ZQpdDi8fu1R" -O "ggml-alpaca-7b-q4.bin" && \
	rm -r "ggml-alpaca-13b-q4.bin" && \
	!mv "/content/ggml-alpaca-7b-q4.bin" "/content/Projects/alpaca/alpaca.cpp/ggml-alpaca-7b-q4.bin" && \
	echo "Модель lama min Загружена!"
}
function function_down_norm(){
	ls && \
	wget "https://gateway.estuary.tech/gw/ipfs/Qme6wyw9MzqbrUMpFNVq42rC1kSdko7MGT9CL7o1u9Cv9G" -O "ggml-alpaca-13b-q4.bin" && \
	rm -r "ggml-alpaca-7b-q4.bin" && \
	!mv "/content/ggml-alpaca-13b-q4.binn" "/content/Projects/alpaca/alpaca.cpp/ggml-alpaca-13b-q4.bin" && \
	echo "Модель lama norm Загружена!" 
}
while true
do
	if [ "$distributivelinex" == "Ubuntu" ]; then
		echo "Линекс: $distributivelinex"
		if [ "$numberversionlinex" == 20.04 ]; then
			echo "Версия: $numberversionlinex"
			echo "Команда: python (Установка python)"
			echo "Команда: lama (Установка lama)"
			echo "Команда: lama_down_min (Загрузка модели lama min)"
			echo "Команда: lama_down_norm (Загрузка модели lama norm)"
			echo "Команда: lama_ran1 (Запуск lama min)"
			echo "Команда: lama_ran2 (Запуск lama norm)"
			read command
			if [ "$command" == "lama_down_min" ]; then
				function_down_min
			fi
			if [ "$command" == "lama_down_norm" ]; then
				function_down_norm
			fi
			if [ "$command" == "python" ]; then
				function_pack
			fi
			if [ "$command" == "lama" ]; then
				function_lama
			fi
			if [ "$command" == "lama_ran1" ]; then
				function_runlama1
			fi
			if [ "$command" == "lama_ran2" ]; then
				function_runlama2
			fi
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