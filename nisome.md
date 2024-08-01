# mqtt

# docker-compose.yaml
version: '3.8'

services:
mosquitto:
container_name: umbua
image: eclipse-mosquitto
ports:
- 1883:1883
- 9001:9001
volumes:
- ./config/mosquitto/mosquitto.conf:/mosquitto/config/mosquitto.conf
- ./config/mosquitto/pwfile:/mosquitto/config/passwordfile
- ./config/data:/mosquitto/data
- ./config/log:/mosquitto/log
restart: unless-stopped
networks:
shamba:


networks:
shamba:
external: true

# mosquitto.conf
persistence true persistence_location /mosquitto/data/ log_dest file /mosquitto/log/mosquitto.log

allow_anonymous true   #false

password_file /mosquitto/config/passwordfile

listener 1883
listener 9001
protocol websockets


## create inner folder called config and cd into it.
mkdir -p mosquitto data log

# cd into mosquitto folder
Create mosquitto.conf in mosquitto folder

## command, run this in mosquitto folder
mosquitto_passwd -c /mosquitto/config/pwfile user_name 

In the docker-compose.yaml this file is used in the volumes part to copy it into the container innit! haha



# credentials
user - byte
pass - 7fpLxthn

# create the password file inside a Docker container: OBSELETE, VERY BUGGY APPROACH WASTED 3 HOURS ON 2/8/2024
docker run -it --rm -v "$(pwd)/mosquitto/config:/mosquitto/config" eclipse-mosquitto mosquitto_passwd -c /mosquitto/config/passwordfile your_username

# publish message to topic
mosquitto_pub -h localhost -p 1883 -u chemi -P 1234  -t "test/topic" -m "Hello, MQTT"

#shamba_lab_pub
mosquitto_pub -h localhost -p 1883 -u chemi -P 1234  -t "shambaLab" -m '{
"Soil": {
"Nitrogen": 134,
"Phosphorous": 122,
"Potassium": 456,
"Conductivity": 32,
"Moisture": 65.45,
"Temperature": 15.12,
"pH": 6.8
},
"Air": {
"Humidity": 49.39,
"Temperature": 25.12
},
"GPS": {
"Latitude": 0.723673256,
"Longitude": 34.8757378,
"Date": "25/04/2024",
"Time": "09.45 AM"
},
"Farm": {
"Crop": "Maize",
"Phone": "0706086296",
"deviceID": "SL00000001"
}
}'


# subscribe to topics
mosquitto_sub -h localhost -p 1883 -u chemi -P 1234  -t "test/topic"

# youtube
https://www.youtube.com/watch?v=L26JY2NH-Ys&ab_channel=BurnsHA