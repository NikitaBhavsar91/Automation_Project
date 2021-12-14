sudo apt update -y
pkg=apache2
status="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg" 2>&1)"
if [ ! $?==0 ] || [ ! "$status" = installed ]; then
        install=true
        break
fi
if "$install"; then
        sudo apt-get install $pkg
fi
serverStat=$(service apache2 status)
if [[ $serverStat == *"active (running)"* ]]; then
        echo "Apache server is running"
else sudo /etc/init.d/apache2 start
fi
systemctl status httpd
bucket=s3fullniki
aws $bucket \
timestamp=$(date +'%d%m%Y-%H%M%S')
my_name=nikita
cp /tmp/${my_name}-httpd-logs-${timestamp}.tar \
${bucket}://${bucket}_bucket/${my_name}-httpd-logs-${timestamp}.tar
