#first we install julia
dnf copr enable nalimilan/julia
yum install julia

#now for whatever other packages we need
yum install wget
yum install gzip #check this later


#now we download the database
wget bshstsa.cloudapp.net:8080/simulalg/db.sqlite.gz
gzip -d db.sqlite.gz
mkdir ../lib/data
mv db.sqlite ../lib/data/db.sqlite

#now we install cmake
dnf install cmake

#now we run the package installer
julia insPackages.jl

mkdir lib/scores
touch lib/scores/leaderboard.txt

echo install complete!
