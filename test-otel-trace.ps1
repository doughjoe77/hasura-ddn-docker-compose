$traceId = "abc123def4560000"
$spanId = "span0001"
$parentId = "parent0000"

$trace = @{
  resourceSpans = @(
    @{
      scopeSpans = @(
        @{
          spans = @(
            @{
              traceId = $traceId
              spanId = $spanId
              parentSpanId = $parentId
              name = "TestSpan-PowerShell"
              kind = "SPAN_KIND_INTERNAL"
              startTimeUnixNano = ([string]([int64](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalMilliseconds * 1000000))
              endTimeUnixNano = ([string]([int64](Get-Date).ToUniversalTime().AddSeconds(1).Subtract([datetime]'1970-01-01').TotalMilliseconds * 1000000))
              attributes = @{
                language = "powershell"
                user_id = 42
                operation = "diagnostic_test"
              }
            }
          )
        }
      )
    }
  )
} | ConvertTo-Json -Depth 10 -Compress

Invoke-RestMethod `
  -Method Post `
  -Uri http://localhost:3000/traces `
  -ContentType "application/json" `
  -Body $trace
