import duckdb
from pathlib import Path
from src.config import PipelineConfig
from src.logger import get_logger

class TybaDataPipeline:
    def __init__(self, config: PipelineConfig):
        self.config = config
        self.logger = get_logger()
        self.con = None

    def __enter__(self):
        self.config.validate_paths()
        self.con = duckdb.connect(str(self.config.db_path))
        self.con.execute(f"PRAGMA threads={self.config.threads}")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.con:
            self.con.close()
        if exc_type:
            self.logger.error(f"Fallo crítico: {exc_val}")
        return False

    def _sql_path(self, path: Path) -> str:
        return str(path).replace("\\", "/")

    def _execute_sql_file(self, filename: str) -> None:
        sql_file_path = self.config.sql_dir / filename
        if not sql_file_path.exists():
            raise FileNotFoundError(f"Archivo SQL no encontrado: {sql_file_path}")
        
        sql_query = sql_file_path.read_text(encoding="utf-8")
        
        # Inyección dinámica de rutas de archivos en el SQL
        sql_query = sql_query.replace("{T_FILE}", self._sql_path(self.config.t_file))
        sql_query = sql_query.replace("{T1_FILE}", self._sql_path(self.config.t1_file))
        
        self.con.execute(sql_query)

    def export_results(self) -> None:
        self.logger.info("Exportando tablas a archivos CSV...")
        tables_to_export = ["data_quality", "changes", "insights"]
        
        for table in tables_to_export:
            export_path = self._sql_path(self.config.output_dir / f"{table}.csv")
            self.con.execute(f"COPY {table} TO '{export_path}' (HEADER, DELIMITER ',')")
            self.logger.info(f" - Exportado: {table}.csv")

    def print_summary(self) -> None:
        summary = self.con.execute("""
            SELECT
                (SELECT COUNT(*) FROM snapshot_t) AS rows_t,
                (SELECT COUNT(*) FROM snapshot_t1) AS rows_t1,
                (SELECT COUNT(*) FROM changes WHERE change_type = 'NUEVO') AS new_rows,
                (SELECT COUNT(*) FROM changes WHERE change_type = 'CORREGIDO') AS corrected_rows,
                (SELECT COUNT(*) FROM changes WHERE change_type = 'ELIMINADO') AS deleted_rows,
                (SELECT COUNT(*) FROM changes WHERE change_type = 'SIN_CAMBIOS') AS unchanged_rows
        """).fetchone()

        self.logger.info("=" * 50)
        self.logger.info("RESUMEN DEL PIPELINE")
        self.logger.info("=" * 50)
        self.logger.info(f"Filas Totales T   : {summary[0]}")
        self.logger.info(f"Filas Totales T1  : {summary[1]}")
        self.logger.info(f"Registros Nuevos  : {summary[2]}")
        self.logger.info(f"Registros Correg. : {summary[3]}")
        self.logger.info(f"Registros Elimin. : {summary[4]}")
        self.logger.info(f"Sin Cambios       : {summary[5]}")
        self.logger.info(f"Directorio Salida : {self.config.output_dir}")
        self.logger.info("=" * 50)

    def run(self) -> None:
        steps = [
            ("01_ingest.sql", "[1/7] Ingestando archivos Parquet (RAW)..."),
            ("02_standardize.sql", "[2/7] Estandarizando esquemas..."),
            ("03_data_quality.sql", "[3/7] Ejecutando validaciones de calidad (Data Quality)..."),
            ("04_compare_snapshots.sql", "[4/7] Comparando Snapshot T vs T1..."),
            ("05_transaction_history.sql", "[5/7] Construyendo el historial de transacciones (SCD)..."),
            ("06_current_state.sql", "[6/7] Construyendo el estado actual..."),
            ("07_insights.sql", "[7/7] Generando metricas (Insights)...")
        ]

        for sql_file, log_msg in steps:
            self.logger.info(log_msg)
            self._execute_sql_file(sql_file)
            
        self.export_results()
        self.print_summary()