# Teknik Araþtýrma Raporu: Linux Bash ile Süreç ve Disk Yönetimi  

## 1. Çalýþma Prensipleri (Core Concepts)  
- **ps komutu**: Kernel’in `/proc` dosya sisteminden süreç bilgilerini okur. Her PID için `task_struct` yapýsýndan veriler çekilir.  
- **df komutu**: Kernel’in VFS (Virtual File System) katmanýndan disk kullaným istatistiklerini alýr. `statfs()` sistem çaðrýsýný kullanarak blok ve inode bilgilerini raporlar.  
- **kill komutu**: Kernel’e `signal` gönderir. `sys_kill()` fonksiyonu üzerinden ilgili PID’ye sinyal iletilir. Örneðin `SIGTERM` süreç kapanýþýný baþlatýr, `SIGKILL` ise doðrudan sonlandýrýr.  

## 2. Best Practices (En Ýyi Uygulama Yöntemleri)  
- **Error Handling**  
  - `set -e` ile hata durumunda scriptin durmasýný saðlamak.  
  - Komutlarýn dönüþ kodlarýný `$?` ile kontrol etmek.  
- **Logging**  
  - `logger` komutu ile sistem loglarýna kayýt düþmek.  
  - Script içinde `exec > logfile 2>&1` ile çýktý yönlendirmek.  
- **Locking**  
  - `flock` kullanarak ayný anda birden fazla script çalýþmasýný engellemek.  
  - PID dosyalarý ile süreçlerin çakýþmasýný önlemek.  

## 3. Rakip Analizi ve Alternatifler  

| Araç     | Tür              | Avantaj                                      | Dezavantaj                          |  
| :---     | :---             | :---                                         | :---                                |  
| Glances  | CLI/WEB tabanlý  | Çok yönlü sistem izleme, Python tabanlý API  | Daha fazla baðýmlýlýk gerektirir    |  
| Htop     | CLI tabanlý      | Etkileþimli süreç yönetimi, renkli arayüz    | Disk yönetimi özellikleri sýnýrlý   |  
| Cockpit  | Web tabanlý GUI  | Modern web arayüzü, uzak yönetim desteði     | Daha fazla kaynak tüketimi          |  

##