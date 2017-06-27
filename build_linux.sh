./bootstrap.sh --prefix=/usr/local
user_configFile=`find $PWD -name user-config.jam`
echo "using mpi ;" >> $user_configFile
n=`cat /proc/cpuinfo | grep "cpu cores" | uniq | awk '{print $NF}'`
sudo ./b2 --with=all -j $n install
sudo sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/local.conf'
sudo ldconfig