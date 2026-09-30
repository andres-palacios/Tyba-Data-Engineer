import sys
from pathlib import Path
# path para asegurar que la carpeta src/ sea reconocida como módulo
sys.path.append(str(Path(__file__).resolve().parents[1]))

from src.config import PipelineConfig
from src.pipeline import TybaDataPipeline
from src.logger import get_logger

def main():
    logger = get_logger()
    config = PipelineConfig()
    
    try:
        logger.info("INICIANDO TYBA DATA ENGINEERING PIPELINE")
        with TybaDataPipeline(config) as pipeline:
            pipeline.run()
            logger.info("Ejecucion finalizada con exito.")
            
    except Exception as e:
        logger.critical(f"Pipeline interrumpido por un error : {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()