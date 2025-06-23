import psycopg2
import os
import logging

# Configure a logger for DB-level diagnostics
logger = logging.getLogger(__name__)

# Establish a persistent connection
conn = psycopg2.connect(os.environ['POSTGRES_URL'])
cur = conn.cursor()

def write_trace(t):
    try:
        cur.execute("""
            INSERT INTO otel.traces (
                trace_id,
                span_id,
                name,
                start_time,
                end_time,
                attributes
            )
            VALUES (
                %s, %s, %s,
                to_timestamp(%s / 1e9),
                to_timestamp(%s / 1e9),
                %s::jsonb
            )
        """, (
            t["trace_id"],
            t["span_id"],
            t["name"],
            t["start_time_unix_nano"],
            t["end_time_unix_nano"],
            t["attributes"]
        ))
        conn.commit()
    except Exception as e:
        logger.error(f"Error writing trace: {e}")
        conn.rollback()

def write_log(l):
    try:
        cur.execute("""
            INSERT INTO otel.logs (
                body,
                time_unix_nano,
                attributes
            )
            VALUES (
                %s,
                to_timestamp(%s / 1e9),
                %s::jsonb
            )
        """, (
            l["body"],
            l["time_unix_nano"],
            l["attributes"]
        ))
        conn.commit()
    except Exception as e:
        logger.error(f"Error writing log: {e}")
        conn.rollback()
