echo  "----------------------------------------------------------------"
echo  "Starting nginx and lets encrypt setup using"
_args=""
_server_names=""
if [ "x${MY_DOMAIN_NAME}" != "x" ]; then
    echo  "Domain : $MY_DOMAIN_NAME"
    _args=" -d ${MY_DOMAIN_NAME} -d www.${MY_DOMAIN_NAME}"
    _server_names="${MY_DOMAIN_NAME} www.${MY_DOMAIN_NAME} "
fi
if [ "x${MY_DOMAIN_NAMES}" != "x" ]; then
    echo  "Domains : $MY_DOMAIN_NAMES"
    for domain in $MY_DOMAIN_NAMES; do
        _args="${_args} -d ${domain}"
        _server_names="${_server_names} ${domain}"
    done
fi
echo  "Email  : $EMAIL_ADDRESS"
echo  "----------------------------------------------------------------"
sed -i "s/___server_names___/$_server_names/g" /etc/nginx/nginx.conf
sleep 5
nginx
sleep 5
certbot --nginx ${_args} --text --agree-tos --no-self-upgrade --keep --no-redirect --email $EMAIL_ADDRESS -v -n
nginx -s stop
sleep 3
nginx -g "daemon off;"
