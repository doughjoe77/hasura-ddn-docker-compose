import grpc
from concurrent import futures
import os
import logging

from db import write_trace, write_log

# Logging config (default: INFO)
log_level = os.environ.get('LOG_LEVEL', 'INFO').upper()
logging.basicConfig(
    level=log_level,
    format='[%(asctime)s] %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Protobuf imports
from opentelemetry.proto.collector.trace.v1 import trace_service_pb2_grpc, trace_service_pb2
from opentelemetry.proto.collector.logs.v1 import logs_service_pb2_grpc, logs_service_pb2

class TraceService(trace_service_pb2_grpc.TraceServiceServicer):
    def Export(self, request, context):
        count = 0
        for resource_span in request.resource_spans:
            for scope_span in resource_span.scope_spans:
                for span in scope_span.spans:
                    write_trace(span)
                    count += 1
                    logger.debug(f"Received span: {span.name}")
        logger.info(f"Stored {count} span(s)")
        return trace_service_pb2.ExportTraceServiceResponse()

class LogService(logs_service_pb2_grpc.LogsServiceServicer):
    def Export(self, request, context):
        count = 0
        for resource_log in request.resource_logs:
            for scope_log in resource_log.scope_logs:
                for log_record in scope_log.log_records:
                    write_log(log_record)
                    count += 1
                    logger.debug(f"Received log: {log_record.body.string_value}")
        logger.info(f"Stored {count} log record(s)")
        return logs_service_pb2.ExportLogsServiceResponse()

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    trace_service_pb2_grpc.add_TraceServiceServicer_to_server(TraceService(), server)
    logs_service_pb2_grpc.add_LogsServiceServicer_to_server(LogService(), server)

    server.add_insecure_port('[::]:4317')
    logger.info("OTLP gRPC API is listening on port 4317")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    serve()
