
# PowerShell script using Kompose to convert a docker-compose to K8ts YAML,
# and then to Helm charts

# $path = ".\kubernetes\datasource"
# $targetPath = '\..\..\kubernetes\datasource'

# delete any files/folders in the target directory
Remove-Item -Path ".\kubernetes\datasource\*" -Recurse -Force

# create helm charts for the data sources
kompose convert --with-kompose-annotation=false -f .\domain-services\datasource\compose.yaml -o .\kubernetes\datasource
kompose convert --chart --with-kompose-annotation=false --namespace datasource -f .\domain-services\datasource\compose.yaml -o .\kubernetes\datasource
# change the name to be something else
# (Get-Content .\kubernetes\datasource\Chart.yaml) -replace "name: .\\kubernetes", "name: " | Set-Content .\Chart.yaml

#install the helm chart in k8ts
# 
# helm list
# kubectl get pods
# kubectl delete all --all -n k8ts-datasource


