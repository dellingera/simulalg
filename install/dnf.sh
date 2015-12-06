#first we install julia
sudo dnf copr enable nalimilan/julia
sudo yum install julia

#now we download the database
wget bshstsa.cloudapp.net:8080/simulalg/db.sqlite.gz
gzip -d db.sqlite.gz
mkdir ../lib/data
mv db.sqlite ../lib/data/db.sqlite

#now we install cmake
dnf install cmake

#now we run the package installer
julia insPackages.jl

echo install complete!
