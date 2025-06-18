import pg from 'pg';

const pool = new pg.Pool({
  connectionString: process.env.POSTGRES_URL || 'postgres://postgres:postgres@localhost:5432/logs'
});

export async function writeLog({ level, message, attributes }) {
  await pool.query(
    `INSERT INTO otel.logs (level, message, attributes, created_at)
     VALUES ($1, $2, $3, NOW())`,
    [level, message, JSON.stringify(attributes)]
  );
}

export async function writeTrace(trace) {
  await pool.query(
    `INSERT INTO otel.traces
     (trace_id, span_id, parent_span_id, name, start_time, end_time, attributes)
     VALUES ($1, $2, $3, $4, to_timestamp($5::double precision / 1e9), to_timestamp($6::double precision / 1e9), $7)`,
    [
      trace.traceId,
      trace.spanId,
      trace.parentSpanId,
      trace.name,
      trace.startTimeUnixNano,
      trace.endTimeUnixNano,
      JSON.stringify(trace.attributes || {})
    ]
  );
}
