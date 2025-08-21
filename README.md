# Energy Monitoring System

A complete IoT energy monitoring pipeline using MQTT, Logstash, and OpenSearch.

## Architecture

```
IoT Devices → EMQX (MQTT) → Logstash → OpenSearch → Dashboards
```

## Components

- **EMQX**: MQTT broker for device communication
- **Logstash**: Data processing and transformation pipeline
- **OpenSearch**: Search and analytics engine
- **OpenSearch Dashboards**: Visualization and monitoring

## Quick Start

1. **Start the services**:
   ```bash
   docker-compose up -d
   ```

2. **Verify services are running**:
   ```bash
   docker-compose ps
   ```

3. **Test MQTT data ingestion**:
   ```bash
   chmod +x test-mqtt.sh
   ./test-mqtt.sh
   ```

4. **Access dashboards**:
   - EMQX Dashboard: http://localhost:18083 (admin/public)
   - OpenSearch Dashboards: http://localhost:5601 (admin/Uyenmit123@#)
   - Logstash Monitoring: http://localhost:9600

## Data Format

Energy devices should publish JSON data to topic `energy/{device_id}/data`:

```json
{
  "device_id": "device001",
  "timestamp": "2025-08-21T10:30:00.000Z",
  "voltage": 230.5,
  "current": 8.2,
  "power": 1890.1,
  "energy": 189.01,
  "frequency": 50.0,
  "location": "Building A",
  "status": "online"
}
```

## Configuration

### Logstash Pipeline
- Configuration: `logstash/pipeline/mqtt-to-opensearch.conf`
- Processes MQTT messages and indexes to OpenSearch
- Automatic data type conversion and field mapping

### OpenSearch Index
- Index pattern: `energy-data-YYYY.MM.dd`
- Template includes proper field mappings for energy data

## Monitoring

- **Logstash logs**: `docker-compose logs logstash`
- **OpenSearch health**: `curl http://localhost:9200/_cluster/health`
- **MQTT topics**: Use EMQX dashboard or MQTT client

## Scaling

- Increase Logstash workers: Update `PIPELINE_WORKERS` environment variable
- Add OpenSearch nodes: Extend docker-compose with additional nodes
- EMQX clustering: Configure multiple EMQX instances

## Troubleshooting

1. **Check container logs**:
   ```bash
   docker-compose logs [service-name]
   ```

2. **Verify MQTT connectivity**:
   ```bash
   docker exec mqtt-client mosquitto_sub -h emqx -t "energy/+/data"
   ```

3. **Check OpenSearch indices**:
   ```bash
   curl http://admin:Uyenmit123@#@localhost:9200/_cat/indices
   ```
