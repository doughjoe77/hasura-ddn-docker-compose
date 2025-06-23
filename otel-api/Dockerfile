FROM python:3.11-slim

# Set working directory
WORKDIR /app

# System dependencies (for grpc_tools, psycopg2)
RUN apt-get update && apt-get install -y gcc build-essential && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code and protos
COPY . .

# Compile .proto files into Python
RUN python -m grpc_tools.protoc \
    -I./proto \
    --python_out=. \
    --grpc_python_out=. \
    proto/opentelemetry/proto/collector/trace/v1/trace_service.proto \
    proto/opentelemetry/proto/collector/logs/v1/logs_service.proto \
    proto/opentelemetry/proto/trace/v1/trace.proto \
    proto/opentelemetry/proto/logs/v1/logs.proto \
    proto/opentelemetry/proto/common/v1/common.proto \
    proto/opentelemetry/proto/resource/v1/resource.proto \
    proto/opentelemetry/proto/google/protobuf/timestamp.proto \
    proto/opentelemetry/proto/google/protobuf/any.proto

# Add __init__.py files to enable imports
RUN find opentelemetry -type d -exec touch {}/__init__.py \;

# Expose gRPC port
EXPOSE 4317

# Start the API
CMD ["python", "otel_api.py"]
