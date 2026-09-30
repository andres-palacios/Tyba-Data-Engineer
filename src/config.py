from pathlib import Path
from dataclasses import dataclass

@dataclass
class PipelineConfig:
    root_dir: Path = Path(__file__).resolve().parents[1]
    raw_dir: Path = root_dir / "data" / "raw"
    output_dir: Path = root_dir / "data" / "output"
    sql_dir: Path = root_dir / "sql"
    
    db_path: Path = output_dir / "tyba.duckdb"
    t_file: Path = raw_dir / "movimientos_dia_T.parquet"
    t1_file: Path = raw_dir / "movimientos_dia_T1.parquet"
    
    threads: int = 4

    def validate_paths(self) -> None:
        if not self.t_file.exists():
            raise FileNotFoundError(f"Archivo no encontrado: {self.t_file}")
        if not self.t1_file.exists():
            raise FileNotFoundError(f"Archivo no encontrado: {self.t1_file}")
        
        self.output_dir.mkdir(parents=True, exist_ok=True)