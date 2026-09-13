-- Ejecutar como propietario (verás todas las filas, pero fallará el campo 'ssn' a menos que tengas el rol FineGrainedReader)
SELECT 
  emp_id,
  name,
  region
FROM 
  `lab07_dataset.employee_data`;