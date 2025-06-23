# Define directory tree
$protoDirs = @(
  "proto/opentelemetry/proto/collector/trace/v1",
  "proto/opentelemetry/proto/collector/logs/v1",
  "proto/opentelemetry/proto/trace/v1",
  "proto/opentelemetry/proto/logs/v1",
  "proto/opentelemetry/proto/common/v1",
  "proto/opentelemetry/proto/resource/v1",
  "proto/opentelemetry/proto/google/protobuf"
)

foreach ($dir in $protoDirs) {
  New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

# File map
$protoFiles = @{
  "proto/opentelemetry/proto/collector/trace/v1/trace_service.proto" = "https://raw.githubusercontent.com/open-telemetry/opentelemetry-proto/main/opentelemetry/proto/collector/trace/v1/trace_service.proto"
  "proto/opentelemetry/proto/collector/logs/v1/logs_service.proto"   = "https://raw.githubusercontent.com/open-telemetry/opentelemetry-proto/main/opentelemetry/proto/collector/logs/v1/logs_service.proto"
  "proto/opentelemetry/proto/trace/v1/trace.proto"                   = "https://raw.githubusercontent.com/open-telemetry/opentelemetry-proto/main/opentelemetry/proto/trace/v1/trace.proto"
  "proto/opentelemetry/proto/logs/v1/logs.proto"                     = "https://raw.githubusercontent.com/open-telemetry/opentelemetry-proto/main/opentelemetry/proto/logs/v1/logs.proto"
  "proto/opentelemetry/proto/common/v1/common.proto"                 = "https://raw.githubusercontent.com/open-telemetry/opentelemetry-proto/main/opentelemetry/proto/common/v1/common.proto"
  "proto/opentelemetry/proto/resource/v1/resource.proto"             = "https://raw.githubusercontent.com/open-telemetry/opentelemetry-proto/main/opentelemetry/proto/resource/v1/resource.proto"
  "proto/opentelemetry/proto/google/protobuf/timestamp.proto"        = "https://raw.githubusercontent.com/protocolbuffers/protobuf/main/src/google/protobuf/timestamp.proto"
  "proto/opentelemetry/proto/google/protobuf/any.proto"              = "https://raw.githubusercontent.com/protocolbuffers/protobuf/main/src/google/protobuf/any.proto"
}

# Download files
foreach ($target in $protoFiles.Keys) {
  Invoke-WebRequest -Uri $protoFiles[$target] -OutFile $target -UseBasicParsing
}
