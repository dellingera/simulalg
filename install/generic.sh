echo you will probably need cmake installed for this
echo you will definitely need julia installed for this

#now we download the database
wget bshstsa.cloudapp.net:8080/simulalg/db.sqlite.gz
gzip -d db.sqlite.gz
mkdir ../lib/data
mv db.sqlite ../lib/data/db.sqlite

#now we install julia
julia insPackages.jl

mkdir lib/scores
touch lib/scores/leaderboard.txt

echo install complete!
