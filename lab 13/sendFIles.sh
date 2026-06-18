#! /bin/bash

#folder który wysyłamy i do którego wysyłamy
BACKUP="Dane"
UPLOAD="uploads"

#archwizuejmy i kompresujemy plik przed wysłanie
# -c ~ tworzymy nowe archiwą, -z ~ używamy kompresji gzip, -f ściezka do archiwum
tar -czf "$BACKUP.tar.gz" $BACKUP

#metryki do logowania do ftp
HOST="127.0.0.1"
USER="lab"
PASS="lab"

#łączymy sie z server i wysyłamy komendy
# -i ~ wyłączamy interaktywny terminal, żeby niczego nie potwierdzać -n ~ wyłączmy auto login
ftp -in $HOST << EOF
user $USER $PASS
cd $UPLOAD
bin
put $BACKUP.tar.gz 
bye
EOF