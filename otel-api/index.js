import express from 'express';
import { writeLog, writeTrace  } from './db.js';
import './tracer.js';

const TRACE_VERBOSE = process.env.TRACE_LOG_VERBOSE === 'true';
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

app.post(['/traces', '/v1/traces'], express.json({ limit: '5mb' }), async (req, res) => {

  console.log(`📥 Received message headers ${JSON.stringify(req.headers)}`);
  console.log(`📥 Received message body ${JSON.stringify(req.body)}`);
  
  try {
    const { resourceSpans = [] } = req.body;
    console.log(`📥 Received ${resourceSpans.length} resourceSpan(s)`);

    let totalSpans = 0;

    for (const [i, resourceSpan] of resourceSpans.entries()) {
      const { scopeSpans = [] } = resourceSpan;

      if (TRACE_VERBOSE) {
        console.log(`  ➤ ResourceSpan[${i}] with ${scopeSpans.length} scopeSpans`);
      }

      for (const [j, scopeSpan] of scopeSpans.entries()) {
        const { spans = [] } = scopeSpan;

        if (TRACE_VERBOSE) {
          console.log(`    ➤ ScopeSpan[${j}] with ${spans.length} span(s)`);
        }

        for (const [k, span] of spans.entries()) {
          const trace = {
            traceId: span.traceId,
            spanId: span.spanId,
            parentSpanId: span.parentSpanId,
            name: span.name,
            startTimeUnixNano: span.startTimeUnixNano,
            endTimeUnixNano: span.endTimeUnixNano,
            attributes: span.attributes || {}
          };

          if (TRACE_VERBOSE) {
            const summary = Object.entries(trace.attributes)
              .map(([k, v]) => `${k}=${v}`)
              .join(', ');
            console.log(`      📌 Span[${k}]: ${trace.name} [${trace.traceId}/${trace.spanId}] (${summary})`);
          }

          await writeTrace(trace);
          totalSpans++;
        }
      }
    }

    if (TRACE_VERBOSE) {
      console.log(`✅ Stored ${totalSpans} spans`);
    }

    res.status(202).send({ status: 'traces received', stored: totalSpans });
  } catch (err) {
    console.error('❌ Trace ingestion failed:', err);
    res.status(500).send({ error: 'Failed to process traces' });
  }
});


app.listen(3000, () => {
  console.log('📬 Logging API ready at http://localhost:3000');
});
