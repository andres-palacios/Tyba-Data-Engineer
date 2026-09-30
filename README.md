# Tyba - Data Engineering 
Pipeline de procesamiento de datos modularizado diseñado para la ingesta, estandarización, validación y análisis de movimientos transaccionales. Construido con **Python** y **DuckDB**, el proyecto aplica principios empresariales (código Python vs. consultas SQL), inyección de dependencias y contenedorización mediante **Docker**.

tecnologias en uso:
- Python 3.14
- DuckDB
- Parquet
- Docker
- Docker Compose
- SQL

## STRUCTURA DEL PROYECTO

```text
tyba_project/
├── data/                       # Almacenamiento local de datos (ignorado en git)
│   ├── raw/                    # Archivos de origen (Parquet)
│   │   ├── movimientos_dia_T.parquet
│   │   └── movimientos_dia_T1.parquet
│   └── output/                 # Salidas generadas por el pipeline (CSV, .duckdb)
├── sql/                        # Consultas de transformación aisladas
│   ├── 01_ingest.sql
│   ├── 02_standardize.sql
│   ├── 03_data_quality.sql
│   ├── 04_compare_snapshots.sql
│   ├── 05_transaction_history.sql
│   ├── 06_current_state.sql
│   └── 07_insights.sql
├── src/                        # Código fuente principal de Python
│   ├── __init__.py
│   ├── config.py               # Gestión de variables y rutas
│   ├── logger.py               # Configuración de registros (logs)
│   ├── pipeline.py             # Clase orquestadora y ejecución de DuckDB
│   └── main.py                 # Punto de entrada de la aplicación
├── docker-compose.yml          # Orquestación de contenedores
├── Dockerfile                  # Definición de la imagen
├── requirements.txt            # Dependencias de Python (ejem. duckdb)
└── README.md                   # Documentación

## REQUISITOS PREVIOS 
Para ejecutar este proyecto de manera óptima, se recomienda el uso de contenedores para evitar conflictos de dependencias en el sistema operativo:
Docker
Docker Compose
(Opcional) Python 3.14 si se desea ejecutar en un entorno local sin contenedores.

🛠️ INSTRUCCIONES DE EJECUCION
Opción 1: Usando Docker Compose (Recomendado)
Esta es la forma más limpia y segura de correr el pipeline, ya que (si tienes el volumen configurado) mapea la carpeta local con el contenedor para asegurar que los resultados persistan en tu máquina.

Asegúrate de que los archivos Parquet (movimientos_dia_T.parquet y movimientos_dia_T1.parquet) estén ubicados en la carpeta data/raw/.

Abre una terminal en la raíz del proyecto (tyba-data-engineering/).

Construye la imagen e inicia el contenedor:
Bash
docker compose up --build


📊 Entregables y Salidas
Una vez que el pipeline finalice exitosamente (indicado por el mensaje Ejecución finalizada con éxito. en los logs de la consola), se generarán automáticamente los siguientes artefactos en el directorio data/output/:

tyba.duckdb: Base de datos persistente con todas las tablas y vistas creadas durante el flujo (Raw, Snapshots, History, etc.). Puedes conectarte a ella usando la CLI de DuckDB, Python o clientes SQL visuales como DBeaver.

data_quality.csv: Resultados de las pruebas de calidad (registros nulos, duplicados, montos negativos o inconsistentes).

changes.csv: Tabla detallada con la comparación entre el día T y T1 (identificación precisa de registros marcados como NUEVO, ELIMINADO, CORREGIDO o SIN CAMBIOS).

insights.csv: Métricas clave agregadas, como el conteo de movimientos por producto, monto consolidado por fondo y la distribución de los tipos de cambio detectados.