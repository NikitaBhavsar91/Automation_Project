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

sudo /etc/init.d/apache2 start
sudo systemctl status apache2
systemctl status httpd
bucket=s3fullniki
aws $bucket \
timestamp=$(date '+%d%m%Y-%H%M%S')
cp /tmp/${nikita}-httpd-logs-${timestamp}.tar \
$bucket://${$bucket_bucket}/${nikita}-httpd-logs-${timestamp}.tar

