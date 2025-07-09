# GeoIP-Nginx-Block
Блокировка доступа к сайту по странам используя Nginx + GeoIP, минималистичный гайд для Debian/Ubuntu без пересборки Nginx из исходников с автообновлением.

Для блокировки доступа используются данные базы данных GeoLite, (ресурс в настоящее время является платным и требует регистрации, кроме того, запрещен пользователям некоторых стран, в том числе РФ).

Есть клоны, регулярно обновляемые, доступ к которым свободен, без регистрации, оплаты и прочего. К примеру Git репозиторий с актуальными mmdb от P3TERX:

https://github.com/P3TERX/GeoLite.mmdb?tab=readme-ov-file

В данном GIT репозитории ссылки на базы данных geo ip по ASN - провайдеров, городам и странам. Для блокировки доступа к сайту по странам, берем ссылку на данную базу:  GeoLite2-Country.mmdb.


## Установка необходимых пакетов (Debian/Ubuntu)
```
sudo apt-get update
sudo apt-get install -y libnginx-mod-http-geoip2 libnginx-mod-http-geoip geoipupdate
```

После установки пакетов, следует проверить наличие в сборке Nginx установленного модуля:
```
sudo nginx -V
```
В списке vjlektq должно быть значение: --with-http_geoip_module, если нет - пересобираем


## Создаем директорию для базы данных и скачиваем mmdb базу данных в неё 
```
sudo mkdir /usr/share/GeoIP
```	
Переходим в созданную дерикторию и скачиваем базу данных
```
cd /usr/share/GeoIP && sudo wget  https://git.io/GeoLite2-Country.mmdb
```

## Приступаем к конфигурации nginx

Вносим изменения в следующие конфигурационные файлы Nginx (примеры в репозитории):
 1. nginx.conf (файл конфигурации NGINX)
 2. sites-available/*.conf (файл конфигурации хоста, к примеру: site-example.ru.conf)
 
Открвываем каждый файл в редакторе Nano: 
``` 
sudo nano /etc/nginx/nginx.conf
```
```
sudo nano /etc/nginx/sites-available/site-example.ru 
``` 
Вносим изменнеия согласно примерам в файлах из репозитория и сохраняем изменения (Ctrl + X, подтвердить Y)

Проверяем на наличие синтаксических ошибок (должны получить syntax is ok).
```	
sudo nginx -t	
```	
Перезагрузить Nginx, чтобы настроки вступили в силу:
```	
sudo systemctl reload nginx
```


## Добавляем скрипт autoupdate_db.sh в cron раз в неделю
Создать директорию scripts и исполняемый autoupdate_db.sh - фаил для запуска получения обнолений GeoIP базы данных.

Создаем директорию:
```
sudo mkdir /srv/scripts
```
Создаем новый файл:
```
sudo touch /srv/scripts/autoupdate_db.sh
```
Открыть файл в редакторе и внести изменения, выйти с сохраненеим (Ctrl + X, подтвердить Y)
```
sudo nano /srv/scripts/autoupdate_db.sh
```
Сделать созданный файл исполняемым:
```
sudo chmod +x /srv/scripts/autoupdate_db.sh
```
Добавить в Cron задание на запуск данного файла для автаматического обновления базы данных раз в неделю:
```
sudo crontab -e
```
добавить задание и выйти с сохраненеим (Ctrl + X, подтвердить Y)
```
00 6 * * SAT bash /srv/scripts/autoupdate_db.sh
```
