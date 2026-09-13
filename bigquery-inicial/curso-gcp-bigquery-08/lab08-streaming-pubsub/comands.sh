gcloud pubsub topics publish realtime-topic \
  --message='{"event_id": "E102", "event_type": "purchase", "user_id": "U301", "timestamp": "2026-03-01T12:05:00Z"}'
gcloud pubsub topics publish realtime-topic \
  --message='{"event_id": "E101", "event_type": "click", "user_id": "U404", "timestamp": "2026-03-01T12:00:00Z"}'