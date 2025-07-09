#!/bin/bash

# Путь к файлу, который будем скачивать
URL="https://git.io/GeoLite2-Country.mmdb"
TEMP_FILE="/usr/share/GeoIP/GeoLite2-Country.mmdb.tmp"
DEST_FILE="/usr/share/GeoIP/GeoLite2-Country.mmdb"

# Скачиваем новый файл
wget -O "$TEMP_FILE" "$URL"

# Проверяем, существует ли уже целевой файл и отличается ли он от скачанного
if [ -f "$DEST_FILE" ]; then
    if cmp -s "$TEMP_FILE" "$DEST_FILE"; then
        echo "Файл не изменился. Удаляем временный файл."
        rm "$TEMP_FILE"
    else
        echo "Файл изменился. Обновляем и перезапускаем Nginx"
        mv "$TEMP_FILE" "$DEST_FILE"
        nginx -s reload
    fi
else
    echo "Целевой файл отсутствует. Перемещаем новый файл."
    mv "$TEMP_FILE" "$DEST_FILE"
fi

echo "База обновлена"