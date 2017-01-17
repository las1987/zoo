;<? exit(); ?>

license = cggafbhcce ioopqniojk srnovxvyw2 34aaaecge7 iifgfdimkn mpkppnmnpn opsaya6886 egbfabddbg fimnglmogm surptwtxst s77b

[database]

;Сервер базы данных
db_server = "localhost"

;Пользователь базы данных
;db_user = "simpla"
db_user = "zoo812"

;Пароль к базе
;db_password = "fG34DbZg23TXiOpE"
db_password = "puoCh1uW0noh"

;Имя базы
db_name = "simpla"

;Префикс для таблиц
db_prefix = s_;

;Кодировка базы данных
db_charset = UTF8;

;Режим SQL
db_sql_mode =;

[php]
error_reporting = E_ALL;
php_charset = UTF8;
php_locale_collate = ru_RU;
php_locale_ctype = ru_RU;
php_locale_monetary = ru_RU;
php_locale_numeric = ru_RU;
php_locale_time = ru_RU;

logfile = admin/log/log.txt;

[smarty]

smarty_compile_check = true;
smarty_caching = false;
smarty_cache_lifetime = 0;
smarty_debugging = false;
 
[images]
;Использовать imagemagick для обработки изображений (вместо gd)
use_imagick = true

;Директория оригиналов изображений
original_images_dir = files/originals/;

;Директория миниатюр
resized_images_dir = files/products/;



;Изображения категорий
categories_images_dir = files/categories/;

;Изображения брендов
;Изображения брендов
brands_images_dir = files/brands/;
resized_brands_images_dir = files/brands/;

;Изображения баннеров
banners_images_dir = files/banners/;

;Изображения акций
promos_images_dir = files/promos/;
;Импорты товаров для акций
promos_imports_dir = files/promos/imports/;

;Файл изображения с водяным знаком
watermark_file = simpla/files/watermark/watermark.png;

[files]

;Директория хранения цифровых товаров
downloads_dir = files/downloads/;
