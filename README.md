# MQTT Mosquitto Broker

Eclipse Mosquitto MQTT broker running in Docker with password authentication and WebSocket support.

## Setup

### 1. Create required directories

```bash
mkdir -p config/data config/log
```

### 2. Create the config file

Create `config/mosquitto.conf` with the following content:

```
listener 1883
listener 9001
protocol websockets

persistence true
persistence_location /mosquitto/data/

log_dest file /mosquitto/log/mosquitto.log

allow_anonymous false
password_file /mosquitto/config/pwfile
```

### 3. Create a password file

```bash
docker run --rm -it eclipse-mosquitto mosquitto_passwd -c /mosquitto/config/pwfile <username>
```

Or generate it locally and copy it into the container volume:

```bash
# Create the file and add a user (you will be prompted for a password)
docker run --rm -v $(pwd)/config:/mosquitto/config eclipse-mosquitto mosquitto_passwd -c /mosquitto/config/pwfile <username>
```

### 4. Start the broker

```bash
docker compose up -d
```

### 5. Check logs

```bash
docker logs mqtt
# or tail the log file
tail -f config/log/mosquitto.log
```

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 1883 | MQTT (TCP) | Standard MQTT |
| 9001 | WebSocket | MQTT over WebSockets |

## Test

```bash
# Subscribe
mosquitto_sub -h localhost -p 1883 -u <username> -P <password> -t test/#

# Publish
mosquitto_pub -h localhost -p 1883 -u <username> -P <password> -t test/hello -m "world"
```

## Reference

- [Eclipse Mosquitto Docs](https://mosquitto.org/documentation/)
- [Setup video](https://www.youtube.com/watch?v=L26JY2NH-Ys&ab_channel=BurnsHA)
