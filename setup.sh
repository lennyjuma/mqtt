#!/bin/bash
set -e

# always run from the repo root regardless of where the script is called from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Creating directories..."
# mosquitto won't start if these don't exist on the host before the bind mount
mkdir -p config/data config/log

echo "==> Writing mosquitto.conf..."
cat > config/mosquitto.conf <<'EOF'
listener 1883
listener 9001
protocol websockets

persistence true
persistence_location /mosquitto/data/

log_dest file /mosquitto/log/mosquitto.log

# disable anonymous access — require username/password
allow_anonymous false
password_file /mosquitto/config/pwfile
EOF

echo "==> Setting up password file..."
if [ ! -f config/pwfile ]; then
  read -rp "Enter MQTT username: " MQTT_USER
  chmod 644 "$(pwd)/config/pwfile" 2>/dev/null || true
  # -c creates a new file; mosquitto_passwd prompts for password interactively
  docker run --rm -it \
    -v "$(pwd)/config:/mosquitto/config" \
    eclipse-mosquitto \
    mosquitto_passwd -c /mosquitto/config/pwfile "$MQTT_USER"
  # container writes the file as root — make it world-readable so mosquitto can read it
  chmod 644 "$(pwd)/config/pwfile"
  echo "Password file created."
else
  echo "Password file already exists, skipping."
  read -rp "Add another user? (y/N): " ADD_USER
  if [[ "$ADD_USER" =~ ^[Yy]$ ]]; then
    read -rp "Enter MQTT username: " MQTT_USER
    # omit -c so we append instead of overwriting the existing file
    docker run --rm -it \
      -v "$(pwd)/config:/mosquitto/config" \
      eclipse-mosquitto \
      mosquitto_passwd /mosquitto/config/pwfile "$MQTT_USER"
    chmod 644 "$(pwd)/config/pwfile"
  fi
fi

echo "==> Starting broker..."
docker compose up -d

echo ""
echo "Done. Broker is running."
echo "  MQTT      : localhost:1883"
echo "  WebSocket : localhost:9001"
echo ""
echo "Logs: docker logs mqtt"
echo "Stop: docker compose down"
