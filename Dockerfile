FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt /app/requirements.txt

RUN python -m pip install --upgrade pip && \
    python -m pip install --no-cache-dir -r /app/requirements.txt

COPY src /app/src
COPY data/raw /app/data/raw
COPY sql /app/sql/
RUN mkdir -p /app/data/output

CMD ["python", "/app/src/main.py"]