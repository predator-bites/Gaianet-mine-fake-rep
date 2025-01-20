#!/bin/bash

# Цветовые коды
NEON_RED='\033[38;5;196m'
NEON_BLUE='\033[38;5;45m'
RESET='\033[0m'

# Логотип
logo() {
    echo -e "
${NEON_RED}  ____   ${NEON_BLUE}____  
${NEON_RED} |  _ \\  ${NEON_BLUE}|  _ \\ 
${NEON_RED} | | | | ${NEON_BLUE}| |_) |
${NEON_RED} | |_| | ${NEON_BLUE}|  __/ 
${NEON_RED} |____/  ${NEON_BLUE}|_|    
${NEON_RESET}
"
}

# Вызов логотипа
logo
echo -e "${NEON_BLUE}https://t.me/DropPredator${RESET}"
# Основная логика
echo -e "${NEON_RED}Welcome to DP Script!${RESET}"

# Скрипт автоустановки ноды Gaianet для Ubuntu 22.04

set -e

# Обновляем систему
sudo apt update -y && sudo apt-get update -y

# Устанавливаем последнюю версию установщика Gaianet
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash

cat << EOF


