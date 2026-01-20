# Teknik Araştırma Raporu: Linux Bash ile Süreç ve Disk Yönetimi

## 1. Çalışma Prensipleri (Core Concepts)
Linux sistemlerinde süreç ve disk yönetimi, kullanıcı alanı (user space) araçlarının çekirdek alanı (kernel space) ile sanal dosya sistemleri üzerinden haberleşmesi prensibine dayanır.

* **Procfs (`/proc`) Etkileşimi:** `ps`, `top` veya `kill` gibi komutlar sihirli değildir; bu araçlar aslında `/proc` dizini altındaki dosyaları okur ve yazar. Örneğin, `ps` komutu `/proc/[PID]/stat` ve `/proc/[PID]/status` dosyalarını parse ederek süreç bilgilerini kullanıcıya sunar.
* **VFS (Virtual File System) ve Disk İstatistikleri:** `df` komutu, `statfs` sistem çağrısını (system call) kullanarak dosya sistemi meta verilerini okur. Bu veriler süper bloklardan (superblocks) alınır ve diskteki toplam inode sayısı, boş bloklar gibi bilgileri içerir.
* **Sinyal Mekanizması (Signals):** `kill` komutu aslında bir süreci "öldürmez", ona bir sinyal (IPC - Inter-Process Communication) gönderir.
    * `SIGTERM (15)`: Sürece nazikçe kapanması gerektiğini bildirir (Cleanup işlemleri yapılabilir).
    * `SIGKILL (9)`: Süreci kernel seviyesinde zorla sonlandırır (Veri kaybı riski vardır, süreç müdahale edemez).
* **Inode Yapısı:** Disk yönetimi sadece dosya boyutu değil, inode kullanımıyla da ilgilidir. Bir diskte yer olsa bile, inode tablosu dolarsa (çok sayıda küçük dosya yüzünden) yeni dosya oluşturulamaz. Bash otomasyonları hem blok kullanımını (`du/df`) hem de inode kullanımını (`df -i`) izlemelidir.

## 2. Best Practices (En İyi Uygulama Yöntemleri)
Güvenilir, taşınabilir ve hata toleransı yüksek Bash otomasyon scriptleri için endüstri standartları şunlardır:

* **Bash Strict Mode Kullanımı:** Scriptin başına mutlaka `set -euo pipefail` eklenmelidir.
    * `-e`: Bir komut hata verirse scripti durdurur.
    * `-u`: Tanımsız değişken kullanılırsa hata verir.
    * `-o pipefail`: Pipe (`|`) içindeki herhangi bir komut hata verirse tüm zinciri hatalı sayar.
* **Locking Mekanizması (Flock):** Cronjob ile çalışan scriptlerin üst üste binmesini (overlapping) engellemek için `flock` kullanılmalıdır. Aynı anda çalışan iki temizlik scripti veri bozulmasına (race condition) yol açabilir.
* **Loglama Standartları:** Çıktılar sadece `echo` ile ekrana değil, zaman damgası (timestamp) ile bir log dosyasına yazılmalıdır. `logger` komutu ile syslog'a entegre olunması önerilir.
* **`ls` Çıktısını Parse Etmemek:** Dosya işlemleri için `ls` çıktısını `for` döngüsüne sokmak hatalıdır (boşluklu dosya adları sorunu). Bunun yerine `find` komutu veya `globbing` (`*.log`) kullanılmalıdır.
* **Idempotency (Tekrarlanabilirlik):** Script defalarca çalıştırılsa bile sisteme zarar vermemeli veya aynı sonucu üretmelidir.

## 3. Rakip Analizi ve Alternatifler
Bash scriptleri hafif ve özelleştirilebilirdir ancak karmaşık izleme ihtiyaçları için modern araçlarla kıyaslanmalıdır.

| Araç | Tür | Avantaj | Dezavantaj |
| :--- | :--- | :--- | :--- |
| **Bash Scripts** | Native Otomasyon | Kurulum gerektirmez, tam kontrol, sıfır kaynak tüketimi (sadece çalışınca). | Bakımı zordur, GUI yoktur, hata yönetimi manuel yapılmalıdır. |
| **Htop / Top** | TUI (Terminal UI) | Anlık interaktif izleme, düşük kaynak kullanımı, renklendirilmiş çıktı. | Geçmişe dönük veri tutmaz (natively), otomasyon için uygun değildir. |
| **Glances** | Cross-Platform | Python tabanlı, çok geniş metrik seti (Docker, GPU vb.), Web UI ve API desteği. | Bash'e göre daha fazla kaynak tüketir, Python bağımlılığı vardır. |
| **Cockpit** | Web GUI | Modern Web arayüzü, systemd entegrasyonu, log yönetimi ve terminal erişimi. | Bir servis olarak çalışır, güvenlik yapılandırması (port açma) gerektirir. |

## 4. Yapılandırma ve Güvenlik

### Kritik Dosyalar
* `/proc/`: Çekirdek ve süreç bilgilerinin anlık tutulduğu sanal dosya sistemi.
* `/etc/fstab`: Disklerin mount (bağlanma) noktalarını ve seçeneklerini belirleyen yapılandırma dosyası.
* `/var/log/syslog` veya `/var/log/messages`: Sistem genelindeki olayların ve cron çıktılarının loglandığı yer.
* `/etc/crontab` veya `/var/spool/cron/`: Otomasyon zamanlamalarının bulunduğu dosyalar.

### Güvenlik Önlemleri
* **Minimum Yetki (Least Privilege):** Scriptler gerekmedikçe `root` olarak çalıştırılmamalıdır. Disk temizliği yapılacaksa sadece ilgili dizine yetkili bir kullanıcı kullanılmalıdır.
* **Sudoers Kısıtlaması:** Eğer script `sudo` gerektiriyorsa, `/etc/sudoers` dosyasında sadece o scriptin çalıştırabileceği komutlara şifresiz izin verilmelidir (ALL yetkisi verilmemeli).
* **Input Sanitization:** Dışarıdan parametre alan scriptlerde, kullanıcı girdisi asla doğrudan `eval` veya `rm` komutlarına sokulmamalıdır.
* **Hardcoded Yollar:** Komutların tam yolları (`/bin/rm` gibi) kullanılmalı veya `$PATH` değişkeni script içinde güvenli bir şekilde tanımlanmalıdır.

## EKSTRA (Sadece Gemini Modelleri İçin):
Aşağıdaki akış şeması, disk ve süreç yönetimi yapan tipik bir otomasyon scriptinin mantıksal akışını göstermektedir.

```mermaid
graph TD
    A[Başlat: Cronjob/Manual] --> B{Disk Kullanımı > %90?}
    B -- Evet --> C[Eski Logları Temizle]
    C --> D[Admin'e Uyarı Maili At]
    B -- Hayır --> E{Yüksek CPU Süreci Var mı?}
    E -- Evet --> F{Süreç Kritik mi?}
    F -- Evet --> G[Logla ve Devam Et]
    F -- Hayır --> H[Süreci Sonlandır 'kill']
    H --> I[Admin'e Bildir]
    E -- Hayır --> J[Başarılı Çıkış]
    D --> J
    G --> J
    I --> J