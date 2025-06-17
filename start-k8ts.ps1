# clean up and run helm to run our Hasura DDN related images in K8ts

# remove datasource deployment
kubectl delete all --all -n datasource

# install datasource namespace (backend db's, plus api, idp and hasura 2.0 engine)
kubectl delete namespace datasource
kubectl delete namespace k8ts-datasource
kubectl create namespace k8ts-datasource
#helm uninstall datasource
helm install datasource .\kubernetes\datasource --namespace k8ts-datasource --set ingress.host=datasource.local
# kubectl apply -f .\kubernetes\datasource\templates\ingress.yaml