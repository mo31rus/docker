#!/bin/bash

# Конфигурация переменных
S3_ACCESS_KEY=$S3_ACCESS_KEY || "ваш_ключ"
S3_SECRET_KEY=$S3_SECRET_KEY || "ваш_секретный_ключ"
S3_BUCKET_NAME=$S3_BUCKET_NAME || "ваш_бакет"
S3_ENDPOINT_URL="https://storage.yandexcloud.net"
FILE_PATH=$1
# get short filename from FILE_PATH
BUCKET_NAME=${FILE_PATH##*/}
DESTINATION_PATH="путь_в_бакете"

# Установка s3cmd, если не установлена
if ! [ -x "$(command -v s3cmd)" ]; then
  echo 'Error: s3cmd не установлена. Устанавливаю...' >&2
  sudo apt-get update
  sudo apt-get install s3cmd -y
fi

# Конфигурация s3cmd
s3cmd --configure <<EOF
$S3_ACCESS_KEY
$S3_SECRET_KEY
$DEFAULT_REGION
$S3_ENDPOINT_URL

EOF

# Загрузка файла
s3cmd put $FILE_PATH s3://$BUCKET_NAME/$DESTINATION_PATH