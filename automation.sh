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
else systemctl start apache2.service
fi
ApacheServiceStatus="$(systemctl is-active apache2.service)"
if [ "${ApacheServiceStatus}" != "active" ]; then
        sudo systemctl start apache2.service
fi
myname="nikita"
s3_bucket="s3fullniki"
timestamp=$(date '+%d%m%Y-%H%M%S')
cd /var/log/apache2/
filename=$myname"-httpd-logs-"$timestamp
tar -cf ${filename}.tar *.log
aws s3 cp ${filename}.tar s3://${s3_bucket}/${filename}.tar

invent_file="/var/www/html/inventory.html"
if ! [ -f $invent_file ]
then
        touch $invent_file
        echo "<h><b>Log Type &ensp;&ensp;  Date Created  &ensp;&ensp; Type &ensp;&ensp; Size" > $invent_file
fi
size=$(ls -lh | grep "$filename" | awk '{print $5}')
echo "<p>httpd-logs &ensp;&ensp; $timestamp &ensp;&ensp; tar &ensp;&ensp; $size</p>" >> $invent_file

if  [ ! -f  /etc/cron.d/automation ]
then
        echo  "0 18 * * * \troot\t/root/Automation_Project/automation.sh" > /etc/cron.d/automation
fi
                                                             41,2          Bo
