import express from 'express';
import { writeLog } from './db.js';
import './tracer.js';

const app = express();
app.use(express.json());

app.post('/log', async (req, res) => {
  try {
    const records = req.body?.resourceLogs?.flatMap(r =>
      r.scopeLogs?.flatMap(s =>
        s.logRecords?.map(l => ({
          level: l.severityText || 'INFO',
          message:
            typeof l.body === 'object' && 'stringValue' in l.body
              ? l.body.stringValue
              : JSON.stringify(l.body),
          attributes: l.attributes || {}
        }))
      )
    ) || [];

    if (!records.length) {
      return res.status(400).send({ error: 'No log records found' });
    }

    for (const record of records) {
      console.log(`[${record.level}] ${record.message}`, record.attributes);
      await writeLog(record);
    }

    res.status(201).send({ status: `${records.length} log(s) written` });
  } catch (err) {
    console.error('❌ Log ingestion error:', err.message);
    res.status(500).send({ error: 'Failed to process logs' });
  }
});

app.listen(3000, () => {
  console.log('📬 Logging API ready at http://localhost:3000');
});
