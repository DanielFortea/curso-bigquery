-- Verificar que la tabla de usuarios tiene el esquema y los datos correctos
SELECT 
  user_id,
  first_name,
  signup_date,
  country
FROM 
  `lab02_dataset.users`
ORDER BY 
  user_id;

-- Verificar la tabla de productos cargada dinámicamente
SELECT 
  product_id,
  name,
  price,
  category
FROM 
  `lab02_dataset.products`
WHERE 
  price > 20.00;