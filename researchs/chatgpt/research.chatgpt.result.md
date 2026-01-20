# Teknik Araþtýrma Raporu: Linux Bash ile Süreç ve Disk Yönetimi

## 1. Çalýþma Prensipleri (Core Concepts)

- **ps**
  - `/proc` sanal dosya sistemi üzerinden kernel tarafýndan saðlanan süreç metriklerini okur.
  - PID, PPID, CPU ve bellek istatistikleri doðrudan kernel task_struct yapýlarýndan türetilir.
  - Kullanýcý alanýnda çalýþan bir araçtýr; kernel’e sistem çaðrýsý (syscall) yaparak deðil, sanal FS okuyarak bilgi toplar.

- **df**
  - `statfs()` sistem çaðrýsýný kullanarak mount edilmiþ dosya sistemlerinin blok, inode ve kullaným bilgilerini alýr.
  - Kernel VFS (Virtual File System) katmanýndan veri toplar.
  - Disk donanýmýyla doðrudan deðil, dosya sistemi soyutlamasý üzerinden çalýþýr.

- **kill**
  - `kill()` syscall’ý ile kernel’e sinyal gönderir.
  - Varsayýlan `SIGTERM`, süreçlere kontrollü kapanma fýrsatý verir.
  - `SIGKILL` (`-9`) kernel tarafýndan doðrudan süreci sonlandýrýr; yakalanamaz veya engellenemez.

---

## 2. Best Practices (En Ýyi Uygulama Yöntemleri)

- **Error Handling**
  - `set -euo pipefail` kullanarak hatalý durumlarý erken yakala.
  - Komut dönüþ kodlarýný (`$?`) kontrol et.
  - Beklenen hatalar için kontrollü `trap` tanýmla.

- **Logging**
  - `logger` veya dosya tabanlý loglama (`/var/log/...`) kullan.
  - Zaman damgasý ve PID içeren log formatý uygula.
  - Stdout ve stderr’i ayýr (`>> file.log 2>&1`).

- **Locking**
  - Ayný script’in eþ zamanlý çalýþmasýný önlemek için `flock` kullan.
  - PID dosyasý yaklaþýmýyla çakýþmalarý engelle.
  - Cron ortamlarýnda özellikle kilitleme zorunludur.

---

## 3. Rakip Analizi ve Alternatifler

| Araç     | Tür                 | Avantaj                                   | Dezavantaj                               |
| :------- | :------------------ | :----------------------------------------- | :--------------------------------------- |
| Glances  | Python Tabanlý TUI  | Çok kapsamlý metrikler, plugin desteði     | Python baðýmlýlýðý, daha fazla kaynak    |
| Htop     | Ýnteraktif TUI      | Kullanýcý dostu, hýzlý süreç yönetimi      | Otomasyon için sýnýrlý                   |
| Cockpit  | Web Tabanlý Arayüz  | Merkezi yönetim, görsel izleme             | Web servisi gereksinimi, daha aðýr        |
| Bash + CLI | Script / CLI     | Hafif, otomasyona uygun, her sistemde var  | Görsellik yok, manuel geliþtirme gerekir |

---

## 4. Yapýlandýrma ve Güvenlik

### Kritik Dosyalar

- `/proc`
  - Süreç ve sistem metrikleri için ana veri kaynaðýdýr.
- `/etc/fstab`
  - Disk mount yapýlandýrmalarýný belirler.
- `/etc/passwd`, `/etc/group`
  - Kullanýcý ve yetki yönetimiyle iliþkilidir.

### Güvenlik Önlemleri

- `sudo`
  - Yetki yükseltmeyi sýnýrlý ve kontrollü kullan.
- `chmod` / `chown`
  - Script ve log dosyalarýnda en az yetki prensibini uygula.
- `umask`
  - Varsayýlan dosya izinlerini kýsýtla.
- Root olarak çalýþan otomasyon script’lerinde giriþ doðrulamasý yap.

