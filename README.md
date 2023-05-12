# mqtt

add config directory with log,data,mosquitto.conf.

## mosquitto.conf.
listener 1883
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log


#allow_anonymous true
## Authentication ##
password_file /mosquitto/config/pwfile
