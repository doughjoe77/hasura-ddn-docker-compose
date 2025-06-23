import psycopg2
import os

conn = psycopg2.connect(os.environ['POSTGRES_URL'])
cur = conn.cursor()

def write_trace(span):
    cur.execute("""
        INSERT INTO otel.traces (trace_id, span_id, name, start_time, end_time, attributes)
        VALUES (%s, %s, %s, to_timestamp(%s / 1e9), to_timestamp(%s / 1e9), %s)
    """, (
        span.trace_id.hex(),
        span.span_id.hex(),
        span.name,
        int(span.start_time_unix_nano),
        int(span.end_time_unix_nano),
        "{}"
    ))
    conn.commit()

def write_log(log_record):
    cur.execute("""
        INSERT INTO otel.logs (body, time_unix_nano, attributes)
        VALUES (%s, to_timestamp(%s / 1e9), %s)
    """, (
        log_record.body.string_value,
        int(log_record.time_unix_nano),
        "{}"
    ))
    conn.commit()
