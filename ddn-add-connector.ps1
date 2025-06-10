Clear-Host
$name = Read-Host "please enter the name of your connector: "
Push-Location "./domain-services/ddn"
ddn connector init $name -i
ddn connector introspect $name
ddn connector show-resources $name
ddn command add $name *
ddn supergraph build local
ddn run docker-start -- -d
Pop-Location