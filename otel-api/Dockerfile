FROM python:3.11-slim-bookworm

# Set working directory
WORKDIR /app

# Install required system packages for gRPC and psycopg2-binary
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        libpq-dev \
        build-essential \
        curl && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy source code and requirements
COPY . .

# Upgrade pip and install Python packages
RUN pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Compile .proto files
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

# Add __init__.py for proto packages
RUN find opentelemetry -type d -exec touch {}/__init__.py \;

# Set runtime environment
ENV LOG_LEVEL=INFO

# Expose gRPC port
EXPOSE 4317

# Launch the OTLP API
CMD ["python", "otel_api.py"]
