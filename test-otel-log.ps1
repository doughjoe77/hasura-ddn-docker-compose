$log = @{
    resourceLogs = @(
        @{
            scopeLogs = @(
                @{
                    logRecords = @(
                        @{
                            severityText = "INFO"
                            body = @{
                                stringValue = "PowerShell log test from OTEL pipeline"
                            }
                            attributes = @{
                                source = "PowerShell"
                                script = "LogTest.ps1"
                                user_id = 42
                            }
                        }
                    )
                }
            )
        }
    )
} | ConvertTo-Json -Depth 10

Invoke-RestMethod `
  -Method Post `
  -Uri http://localhost:3010/log `
  -ContentType "application/json" `
  -Body $log
