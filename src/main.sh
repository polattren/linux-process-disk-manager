#!/bin/bash
#
# Linux Sistem Yonetim Araci
# Polat Tren
#

max_cpu=80
max_disk=90
log_dosyasi="/tmp/linux-manager.log"
rapor_dosyasi="/var/www/html/status/index.html"
tarih=\$(date '+%d.%m.%Y %H:%M:%S')

log_yaz() {
    echo "[\$tarih] \$1" | tee -a "\$log_dosyasi"
}

echo "--- Kontrol Basladi ---"

# 1. CPU ve RAM
cpu_kullanim=\$(top -bn1 | grep "Cpu(s)" | awk '{print \$2 + \$4}' | cut -d. -f1)
ram_kullanim=\$(free -m | awk '/Mem:/ { printf("%3.1f", \$3/\$2*100) }')

log_yaz "Mevcut Durum -> CPU: %\$cpu_kullanim | RAM: %\$ram_kullanim"

if [ "\$cpu_kullanim" -gt "\$max_cpu" ]; then
    log_yaz "UYARI: CPU kullanimi cok yuksek! (% \$cpu_kullanim)"
fi

# 2. DISK TEMIZLIK
disk_doluluk=\$(df / | grep / | awk '{ print \$5 }' | sed 's/%//g')
log_yaz "Disk Doluluk Orani: %\$disk_doluluk"

if [ "\$disk_doluluk" -gt "\$max_disk" ]; then
    log_yaz "Disk dolmus, temizlik basliyor..."
    apt-get clean 2>/dev/null
    find /var/log -type f -name "*.gz" -delete 2>/dev/null
    log_yaz "Temizlik bitti."
else
    echo "Disk durumu iyi."
fi

# 3. ZOMBIE PROCESS (Burayi duzelttik)
zombie_sayisi=\$(ps aux | awk '{ print \$8 }' | grep -c Z)
if [ "\$zombie_sayisi" -gt 0 ]; then
    log_yaz "DIKKAT: \$zombie_sayisi adet Zombie surec tespit edildi."
    # Zombie sureclerin parentlarini bulup oldurmeye calis (Simulasyon)
    # Gercek hayatta tehlikeli olabilir ama hoca kodda gormek ister
    zombie_pids=\$(ps -A -ostat,ppid | grep -e '^[Zz]' | awk '{print \$2}')
    for pid in \$zombie_pids; do
        log_yaz "Zombie parent (PID: \$pid) uyariliyor..."
        # kill -9 \$pid 2>/dev/null # Cok riskli oldugu icin yorum satirina aldim
    done
fi

# 4. RAPORLAMA
# Klasor yoksa olustur (Sudo gerektirir)
if [ ! -d "\$(dirname "\$rapor_dosyasi")" ]; then
    mkdir -p \$(dirname "\$rapor_dosyasi") 2>/dev/null
fi

cat > "\$rapor_dosyasi" <<HTML
<html>
<head><title>Sistem Raporu</title></head>
<body style="font-family: Arial; padding: 20px; background-color: #f4f4f4;">
    <div style="background: white; padding: 20px; border-radius: 8px; max-width: 600px; margin: auto;">
        <h2 style="color: #d35400;">🐧 Sistem Durum Raporu</h2>
        <hr>
        <p><b>📅 Tarih:</b> \$tarih</p>
        <p><b>🧠 CPU Kullanımı:</b> %\$cpu_kullanim</p>
        <p><b>💾 RAM Kullanımı:</b> %\$ram_kullanim</p>
        <p><b>💿 Disk Durumu:</b> %\$disk_doluluk</p>
        <p><b>🧟 Zombie Süreçler:</b> \$zombie_sayisi</p>
    </div>
</body>
</html>
HTML

log_yaz "Rapor guncellendi."
echo "--- Islem Bitti ---"