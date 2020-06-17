#!/bin/sh

echo "What is the APN?"
read carrierapn

echo "What is the username (Leave empty if no auth is required)"
read username

if [ ! -z "$username" ]
then
    echo "What is the password"
    read password

    if [ -z "$password" ]
    then
        echo "Must provide a password"
        exit 1
    fi
else
    sed -i -e "s/ #USER//" qmi_reconnect.sh
    sed -i -e "s/ #PASS//" qmi_reconnect.sh
fi

wget --no-check-certificate https://raw.githubusercontent.com/ndomx/Sixfab_RPi_3G-4G-LTE_Base_Shield/master/tutorials/QMI_tutorial/reconnect_service -O qmi_reconnect.service
wget --no-check-certificate https://raw.githubusercontent.com/ndomx/Sixfab_RPi_3G-4G-LTE_Base_Shield/master/tutorials/QMI_tutorial/reconnect_sh -O qmi_reconnect.sh

sed -i "s/#APN/$carrierapn/" qmi_reconnect.sh
sed -i "s/#USER/$username/" qmi_reconnect.sh
sed -i "s/#PASS/$password/" qmi_reconnect.sh

mv qmi_reconnect.sh /usr/src/
mv qmi_reconnect.service /etc/systemd/system/

systemctl daemon-reload
systemctl start qmi_reconnect.service
systemctl enable qmi_reconnect.service

echo "DONE"
