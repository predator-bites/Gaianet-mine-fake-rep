#!/bin/bash

# Скрипт автоустановки ноды Gaianet для Ubuntu 22.04

set -e

# Обновляем систему
sudo apt update -y && sudo apt-get update -y

# Устанавливаем последнюю версию установщика Gaianet
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash

# Настраиваем окружение Bash
sleep 2 
source /root/.bashrc
sleep 2 

# Инициализируем ноду
CONFIG_URL="https://raw.gaianet.ai/qwen2-0.5b-instruct/config.json"
gaianet init --config "$CONFIG_URL"

# Запускаем ноду
gaianet start

# Получаем и сохраняем информацию о ноде
echo "Сохраняем Node ID и Device ID в файл gaianet_info.txt..."
gaianet info > ~/gaianet_info.txt

# Извлекаем Node ID для использования в скрипте
NODE_ID=$(grep 'Node ID:' ~/gaianet_info.txt | awk '{print $3}')
echo "Node ID: $NODE_ID"

# Настраиваем автозапуск для ноды
SERVICE_FILE="/etc/systemd/system/gaianet.service"
echo "Создаем systemd service файл: $SERVICE_FILE"
echo "[Unit]
Description=Gaianet Node Service
After=network.target

[Service]
Type=forking
RemainAfterExit=true
ExecStart=/root/gaianet/bin/gaianet start
ExecStop=/root/gaianet/bin/gaianet stop
ExecStopPost=/bin/sleep 20
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE

# Применяем изменения в systemd
sudo systemctl daemon-reload
sudo systemctl restart gaianet.service
sudo systemctl enable gaianet.service

# Проверяем статус ноды
sudo systemctl status gaianet.service

# Устанавливаем необходимые пакеты для работы с Gaianet AI
sudo apt update -y
sudo apt install -y python3-pip nano screen
pip install requests faker

# Создаем скрипт общения с Gaianet AI
CHAT_SCRIPT="~/random_chat_with_faker.py"
echo "Создаем скрипт: $CHAT_SCRIPT"
echo "import requests
import random
import logging
import time
from faker import Faker
from datetime import datetime

node_url = \"https://$NODE_ID.gaia.domains/v1/chat/completions\"

faker = Faker()

headers = {
    \"accept\": \"application/json\",
    \"Content-Type\": \"application/json\"
}

logging.basicConfig(filename='chat_log.txt', level=logging.INFO, format='%(asctime)s - %(message)s')

def log_message(node, message):
    logging.info(f\"{node}: {message}\")

def send_message(node_url, message):
    try:
        response = requests.post(node_url, json=message, headers=headers)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f\"Failed to get response from API: {e}\")
        return None

def extract_reply(response):
    if response and 'choices' in response:
        return response['choices'][0]['message']['content']
    return \"\"

while True:
    random_question = faker.sentence(nb_words=10)
    message = {
        \"messages\": [
            {\"role\": \"system\", \"content\": \"You are a helpful assistant.\"},
            {\"role\": \"user\", \"content\": random_question}
        ]
    }

    question_time = datetime.now().strftime(\"%Y-%m-%d %H:%M:%S\")

    response = send_message(node_url, message)
    reply = extract_reply(response)

    reply_time = datetime.now().strftime(\"%Y-%m-%d %H:%M:%S\")

    log_message(\"Node replied\", f\"Q ({question_time}): {random_question} A ({reply_time}): {reply}\")

    print(f\"Q ({question_time}): {random_question}\nA ({reply_time}): {reply}\")

    delay = random.randint(1, 3)
    time.sleep(delay)" > $CHAT_SCRIPT

# Запускаем скрипт в screen
echo "Запускаем скрипт в screen сессии faker_session..."
sleep 2 
screen -dmS faker_session bash -c "python3 $CHAT_SCRIPT"

# Инструкция по завершению
cat << EOF

Установка завершена! Скрипт общения с Gaianet AI запущен в screen сессии faker_session.
Для подключения к сессии выполните:
   screen -r faker_session
Чтобы выйти из сессии, не останавливая скрипт, нажмите Ctrl+A, затем D.
EOF
