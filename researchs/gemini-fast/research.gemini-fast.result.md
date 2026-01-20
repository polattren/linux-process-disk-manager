# Teknik Araştırma Raporu: Linux Bash ile Süreç ve Disk Yönetimi

## 1. Çalışma Prensipleri (Core Concepts)
Linux sistemlerinde süreç ve kaynak yönetimi çekirdek (kernel) katmanında gerçekleşir:

* **Süreç Bilgileri ve `/proc`:** Linux'ta her süreç bir dosya olarak temsil edilir. `ps` ve `top` gibi araçlar, kernel'in süreç meta verilerini sunduğu sanal dosya sistemi olan `/proc` dizinini okur.
* **Sinyalizasyon (`kill`):** Süreç yönetimi sinyallerle yapılır. `kill` komutu çekirdeğe bir `signal` gönderir. Örneğin `SIGTERM (15)` sürecin temiz bir şekilde kapanmasını isterken, `SIGKILL (9)` çekirdeğin süreci zorla durdurmasını sağlar.
* **Disk Blok Analizi (`df`, `du`):** `df` (Disk Free), dosya sistemi bazında süper bloklardan (superblocks) veri çeker. `du` (Disk Usage) ise dizin ağacındaki dosyaları özyinelemeli (recursive) olarak tarayıp blok boyutlarını hesaplar.



## 2. Best Practices (En İyi Uygulama Yöntemleri)
Profesyonel Bash otomasyonu için şu standartlar takip edilmelidir:

* **Error Handling:** Script'in başına `set -euo pipefail` ekleyerek hatalı komutlarda veya tanımlanmamış değişkenlerde script'in durması sağlanmalıdır.
* **Logging:** Çıktılar hem `stdout` üzerinden takip edilmeli hem de `timestamp` (zaman damgası) ile bir log dosyasına yönlendirilmelidir.
* **Locking:** Cron ile çalışan scriptlerin çakışmaması için `/var/lock/` altında bir kilit dosyası (PID file) veya `flock` komutu kullanılmalıdır.
* **Dry Run Modu:** Tehlikeli işlemlerden (silme, disk formatlama vb.) önce bir `-d` veya `--dry-run` bayrağı ile işlemin ne yapacağının gösterilmesi sağlanmalıdır.

## 3. Rakip Analizi ve Alternatifler
| Araç | Tür | Avantaj | Dezavantaj |
| :--- | :--- | :--- | :--- |
| **Bash (Native)** | Kabuk Betiği | Ek yükleme gerektirmez, en hızlısıdır. | Karmaşık logic'lerde bakımı zordur. |
| **Glances** | Python Aracı | Tek ekranda tüm sistem verilerini sunar. | Python bağımlılığı ve yüksek CPU kullanımı. |
| **Htop** | İnteraktif İzleyici | Görsel ve kolay süreç yönetimi. | Otomasyona (non-interactive) uygun değildir. |
| **Cockpit** | Web GUI | Uzaktan yönetim ve dashboard desteği. | Sunucuda ekstra port ve servis yükü. |

## 4. Yapılandırma ve Güvenlik
### Kritik Dosyalar
* `/proc/[PID]/status`: Sürecin durumu, bellek kullanımı ve sahipliği.
* `/etc/fstab`: Disk bölümlerinin mount konfigürasyonları.
* `/etc/security/limits.conf`: Kullanıcı başına açılacak süreç ve dosya limiti.

### Güvenlik Önlemleri
* **Privilege Escalation:** Script içinde `sudo` kullanımını minimize edin. Gerekirse sadece belirli komutlar için `visudo` üzerinden şifresiz yetki tanımlayın.
* **Permissions:** Script dosyalarını `700 (rwx------)` izinleriyle koruyarak yetkisiz erişimi engelleyin.
* **Environment Sanity:** Script'in güvenliği için `PATH` değişkenini script içinde açıkça tanımlayın.

## EKSTRA (Mermaid Akış Şeması)
```mermaid
graph TD
    Start[Sistem Kontrolünü Başlat] --> Disk{Disk Doluluğu > %90?}
    Disk -- Evet --> Alert[Admin'e Uyarı Gönder ve Log Temizle]
    Disk -- Hayır --> Proc[Zombi Süreç Kontrolü Yap]
    Alert --> Proc
    Proc --> Zombi{Zombi Süreç Var mı?}
    Zombi -- Evet --> Kill[Süreci Temizle]
    Zombi -- Hayır --> Finish[Rapor Oluştur ve Kapat]
    Kill --> Finish