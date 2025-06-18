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
