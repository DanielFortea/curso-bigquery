import os
import sys
from google.cloud import bigquery
from google.api_core.exceptions import GoogleAPIError

def run_bigquery_pipeline():
    """
    Inicializa el cliente oficial de BigQuery, ejecuta una consulta sobre datos públicos,
    convierte los resultados a un DataFrame de Pandas de forma optimizada y los guarda localmente.
    """
    print("Inicializando el cliente oficial de BigQuery...")
    
    # El cliente hereda automáticamente las credenciales Application Default Credentials (ADC)
    try:
        client = bigquery.Client()
    except Exception as e:
        print(f"Error de autenticación. Asegúrate de haber ejecutado 'gcloud auth application-default login'. Detalle: {e}")
        sys.exit(1)

    # Consulta SQL estándar sobre el dataset público de bicicletas de Londres
    query = """
        SELECT 
            name, 
            docks_count, 
            --nbBikes AS bikes_available, 
            latitude, 
            longitude
        FROM 
            `bigquery-public-data.london_bicycles.cycle_stations`
        WHERE 
            docks_count > 30
        ORDER BY 
            docks_count DESC
        LIMIT 50;
    """

    print("Enviando trabajo de consulta (Query Job) a BigQuery...")
    try:
        # Ejecutar la consulta de forma asíncrona en el motor de GCP
        query_job = client.query(query)
        
        # Esperar a que finalice la ejecución de la consulta
        results = query_job.result()
        print(f"Trabajo completado con éxito. ID del Job: {query_job.job_id}")

        # Convertir los resultados a un DataFrame utilizando pyarrow para un rendimiento superior
        print("Convirtiendo los resultados serializados a un DataFrame de Pandas...")
        df = results.to_dataframe()

        # Mostrar resumen descriptivo en la consola
        print("\n--- Primeros 5 registros del DataFrame ---")
        print(df.head())

        print("\n--- Estadísticas descriptivas de capacidad de estaciones ---")
        print(df.describe())

        # Exportar a CSV local
        output_dir = "output"
        os.makedirs(output_dir, exist_ok=True)
        output_path = os.path.join(output_dir, "london_large_cycle_stations.csv")
        
        df.to_csv(output_path, index=False)
        print(f"\nDatos guardados exitosamente en la ruta: {output_path}")

    except GoogleAPIError as api_err:
        print(f"Ocurrió un error en la API de BigQuery: {api_err}")
    except Exception as e:
        print(f"Ocurrió un error inesperado durante el procesamiento: {e}")

if __name__ == "__main__":
    run_bigquery_pipeline()