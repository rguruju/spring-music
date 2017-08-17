#!/bin/bash

echo "Please enter the Username and Password of your jenkins server"

read -p "UserName: " username
read -s -p "Password: " password

curl -X POST \
-u "${username}":"${password}" \
--data @plugin.txt \
--header 'Content-Type: text/xml' \
http://localhost:7080/pluginManager/installNecessaryPlugins
