-- Consultar la tabla de eventos en tiempo real
-- para comprobar que el flujo directo de Pub/Sub ha insertado los mensajes JSON con éxito.

SELECT 
  event_id,
  event_type,
  user_id,
  timestamp
FROM 
  `lab08_dataset.realtime_events`
ORDER BY 
  timestamp DESC;