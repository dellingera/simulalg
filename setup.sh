wget bshstsa.cloudapp.net:8080/simulalg/db.sqlite.gz
gzip -d db.sqlite.gz
mkdir lib/data
mv db.sqlite lib/data/db.sqlite
