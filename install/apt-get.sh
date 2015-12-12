#first we install julia
add-apt-repository ppa:staticfloat/juliareleases
add-apt-repository ppa:staticfloat/julia-deps
apt-get update
apt-get install julia

#now we download the database
wget bshstsa.cloudapp.net:8080/simulalg/db.sqlite.gz
gzip -d db.sqlite.gz
mkdir ../lib/data
mv db.sqlite ../lib/data/db.sqlite

#now we install cmake
apt-get install cmake

#now we run the package installer
julia insPackages.jl

mkdir lib/scores
touch lib/scores/leaderboard.txt

echo install complete!
