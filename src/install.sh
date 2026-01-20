#!/bin/bash

# Root kontrolu
if [ "$EUID" -ne 0 ]; then
  echo "Lutfen bu scripti sudo ile calistirin: sudo ./src/install.sh"
  exit 1
fi

klasor=$(pwd)
dosya_yolu="$klasor/src/main.sh"
yeni_gorev="*/5 * * * * $dosya_yolu >> /tmp/cron_log.txt 2>&1"

chmod +x "$dosya_yolu"

mevcut_cron=$(crontab -l 2>/dev/null)

if [[ "$mevcut_cron" == *"$dosya_yolu"* ]]; then
    echo "Zaten kurulu, islem yapilmadi."
else
    (crontab -l 2>/dev/null; echo "$yeni_gorev") | crontab -
    echo "Otomasyon (Cron Job) basariyla kuruldu."
    echo "Sistem her 5 dakikada bir kontrol edilecek."
fi
