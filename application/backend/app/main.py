import os
import psycopg2
from fastapi import FastAPI, HTTPException

app = FastAPI(title="Production Lab API")

DB_HOST = os.getenv("DB_HOST", "demo-database")
DB_NAME = os.getenv("DB_NAME", "appdb")
DB_USER = os.getenv("DB_USER", "appuser")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_PORT = int(os.getenv("DB_PORT", "5432"))


@app.get("/health")
def health():
    return {"status": "healthy", "service": "python-backend"}


@app.get("/db-health")
def db_health():
    try:
        connection = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            port=DB_PORT,
            connect_timeout=3
        )

        cursor = connection.cursor()
        cursor.execute("SELECT 1;")
        result = cursor.fetchone()

        cursor.close()
        connection.close()

        return {
            "status": "connected",
            "database": DB_NAME,
            "query_result": result[0]
        }

    except Exception as error:
        raise HTTPException(status_code=503, detail=str(error))
