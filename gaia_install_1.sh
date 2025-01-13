#!/bin/bash

# Скрипт автоустановки ноды Gaianet для Ubuntu 22.04

set -e

# Обновляем систему
sudo apt update -y && sudo apt-get update -y

# Устанавливаем последнюю версию установщика Gaianet
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash

cat << EOF


