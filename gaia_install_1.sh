#!/bin/bash

# Цветовые коды
RED='\033[31m'
BLUE='\033[34m'
RESET='\033[0m'

# Логотип
logo() {
    echo -e "
${RED}  ____   ${BLUE}____  
${RED} |  _ \\  ${BLUE}|  _ \\ 
${RED} | | | | ${BLUE}| |_) |
${RED} | |_| | ${BLUE}|  __/ 
${RED} |____/  ${BLUE}|_|    
${RESET}
"
}

# Вызов логотипа
logo

# Основная логика
echo "Welcome to DropPredator!"

# Скрипт автоустановки ноды Gaianet для Ubuntu 22.04

set -e

# Обновляем систему
sudo apt update -y && sudo apt-get update -y

# Устанавливаем последнюю версию установщика Gaianet
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash

cat << EOF


