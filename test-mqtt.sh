#!/bin/bash

# Test script to send sample energy data to MQTT
# Usage: ./test-mqtt.sh

echo "Sending test energy data to MQTT..."
echo "Press Ctrl+C to stop the loop"

# Sample energy data for different devices
devices=("device001" "device002" "device003" "device004" "device005" "device006" "device007" "device008" "device009" "device010")

while true; do
    for device in "${devices[@]}"; do
        echo "Publishing data for $device..."
        
        # Generate sample energy data
        voltage=$(awk "BEGIN {printf \"%.2f\", 220 + ($RANDOM % 20)}")
        current=$(awk -v s=$RANDOM 'BEGIN{srand(s); printf "%.2f", rand()*20 }')
        power=$(awk "BEGIN {printf \"%.2f\", $voltage * $current}")
        energy=$(awk "BEGIN {printf \"%.2f\", $power * 0.1}")
        frequency=50.0
        timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
        
        # Create JSON payload
        payload=$(cat <<EOF
{
  "device_id": "$device",
  "timestamp": "$timestamp",
  "voltage": $voltage,
  "current": $current,
  "power": $power,
  "energy": $energy,
  "frequency": $frequency,
  "location": "Building A",
  "status": "online"
}
EOF
)
        
        # Publish to MQTT with authentication
        docker exec mqtt-client mosquitto_pub \
            -h admin-pc.tail413f7a.ts.net \
            -p 1883 \
            -t "energy/$device/data" \
            -m "$payload"
        
        echo "Published: $payload"
    done
    
    echo "Cycle completed, starting next round..."
    sleep 5
done
