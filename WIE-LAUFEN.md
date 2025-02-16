# Beispiel starten

Die ist eine Schritt-für-Schritt-Anleitung zum Starten der Beispiele.
Informationen zu Maven und Docker finden sich im
[Cheatsheet-Projekt](https://github.com/ewolff/cheatsheets-DE).


## Installation Minikube

* Installiere
[minikube](https://github.com/kubernetes/minikube/releases). Minikube
bietet eine Kubernetes-Umgebung in einer virtuellen Maschine. Minikube
ist einfach zu benutzen und zu installieren. Es soll keine
Produktionsumgebung sein, sondern dient nur dazu, Kubernetes
auszuprobieren oder Entwicklermaschinen aufzubauen.


* Installiere eine Minikube-Instanz mit `minikube start
--memory=5000`. Die Instanz hat dann 5.000 MB RAM. Das sollte für das
Beispiel ausreichend sein. Die Anzahl der CPUs kann je nach genutzter
Hardware geändert werden. Lösche vor der Installation gegebenenfalls
bereits vorhandene Minikube-Instanzen mit `minikube delete`, da
Minikube anderenfalls die Einstellungen für Speicher und CPU nicht
beachtet.

```
[~/microservice-istio]minikube start --cpus=2 --memory=5000
Starting local Kubernetes v1.12.4 cluster...
Starting VM...
Getting VM IP address...
Moving files into cluster...
Setting up certs...
Connecting to cluster...
Setting up kubeconfig...
Starting cluster components...
Kubectl is now configured to use the cluster.
```

* Installiere
  [kubectl](https://kubernetes.io/docs/tasks/kubectl/install/). Das
  ist das Kommandozeilenwerkzeug für den Umgang mit Kubernetes.

## Installation Google Cloud

* Registriere Dich bei der [Google Cloud](https://cloud.google.com/).

* Gehe zut [Kubernetes Engine Page](https://console.cloud.google.com/projectselector/kubernetes?_ga=2.66966445.-2058400183.1547494992)

* Erzeuge ein Projekt oder wähle eines aus.

Hinweis: Die Installation und alle folgende Schritte kann man in der
[Google Cloud Shell](https://cloud.google.com/shell/docs/)
durchführen.  Die Google Cloud Shell bietet Zugriff auf ein
Linux-System. Daher ist es nicht notwendig, Software auf der lokalen
Maschine zu installieren. Ein Web Browser ist völlig ausreichend.

Sonst muss das [Google Cloud
 SDK](https://cloud.google.com/sdk/docs/quickstarts) und
 [kubectl](https://kubernetes.io/docs/tasks/kubectl/install/)
 installiert werden.

* Wähle das Projekt aus der Kubernetes Engine Page mit `gcloud
  config set project <projekt name>` aus.

* Wähle ein Rechenzentrum, z.B. das in Frankfurt: `gcloud config set
  compute/zone europe-west3-a`
  
* Definiere die `PROJECT_ID` mit `export PROJECT_ID="$(gcloud config
  get-value project -q)"`
  
* Konfiguriere Docker `gcloud auth configure-docker`

* Erzeuge einen Cluster mit `gcloud container clusters create
  hello-cluster --num-nodes=3`
  
* Weise dem Nutzer die Rechte zu, die für einen Installation von
  Kubernetes notwendig sind: `kubectl create clusterrolebinding
  cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud
  config get-value core/account)`
  


## Installation von Istio

Dieser und die folgenden Schritte können entweder auf der
Kommandozeile (Minkube / Google Cloud) oder in der Google Cloud Shell
durchgeführt werden.

* [Lade Istio
herunter](https://istio.io/docs/setup/kubernetes/download-release/)
und [installiere
es](https://istio.io/docs/setup/kubernetes/install/kubernetes/). Für das
Beispiel ist Istio ohne "mutual TLS authentication" ausreichend.

## Docker Images bauen

* Die Beispiele sind in Java implementiert. Daher muss Java
  installiert werden. Die Anleitung findet sich unter
  https://www.java.com/en/download/help/download_options.xml . Da die
  Beispiele kompiliert werden müssen, muss ein JDK (Java Development
  Kit) installiert werden. Das JRE (Java Runtime Environment) reicht
  nicht aus. Nach der Installation sollte sowohl `java` und `javac` in
  der Eingabeaufforderung möglich sein.  Das Beispiel benötigt
  mindestens Java 10. In der Google Cloud Shell kann man Java 11 mit
  `sudo update-java-alternatives -s java-1.11.0-openjdk-amd64 &&
  export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64` auswählen.
  
* Die Beispiele laufen in Docker Containern. Dazu ist eine
  Installation von Docker Community Edition notwendig, siehe
  https://www.docker.com/community-edition/ . Docker kann mit
  `docker` aufgerufen werden. Das sollte nach der Installation ohne
  Fehler möglich sein.

Wechsel in das Verzeichnis `microservice-istio-demo` und starte
`./mvnw clean package` (macOS / Linux) bzw. `mvnw.cmd clean package`
(Windows). Das wird einige Zeit dauern:

```
[~/microservice-istio/microservice-istio-demo]./mvnw clean package
....
[INFO] 
[INFO] --- maven-jar-plugin:2.6:jar (default-jar) @ microservice-istio-order ---
[INFO] Building jar: /Users/wolff/microservice-istio/microservice-istio/microservice-istio-order/target/microservice-istio-order-0.0.1-SNAPSHOT.jar
[INFO] 
[INFO] --- spring-boot-maven-plugin:1.4.5.RELEASE:repackage (default) @ microservice-istio-order ---
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] microservice-istio ....................... SUCCESS [  0.986 s]
[INFO] microservice-istio-invoicing .............. SUCCESS [ 16.953 s]
[INFO] microservice-istio-shipping ............... SUCCESS [ 18.016 s]
[INFO] microservice-istio-order ................. SUCCESS [ 18.512 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 57.633 s
[INFO] Finished at: 2017-09-08T09:36:32+02:00
[INFO] Final Memory: 56M/420M
[INFO] ------------------------------------------------------------------------
```
Weitere Information zu Maven gibt es im
[Maven Cheatsheet](https://github.com/ewolff/cheatsheets-DE/blob/master/MavenCheatSheet.md).

Falls es dabei zu Fehlern kommt:

* Stelle sicher, dass die Datei `settings.xml` im Verzeichnis  `.m2`
in deinem Heimatverzeichnis keine Konfiguration für ein spezielles
Maven Repository enthalten. Im Zweifelsfall kannst du die Datei
einfach löschen.

* Die Tests nutzen einige Ports auf dem Rechner. Stelle sicher, dass
  im Hintergrund keine Server laufen.

* Führe die Tests beim Build nicht aus: `./mvnw clean package
-Dmaven.test.skip=true` (macOS / Linux) bzw. `mvnw.cmd clean package
-Dmaven.test.skip=true` (Windows).

* In einigen selten Fällen kann es vorkommen, dass die Abhängigkeiten
  nicht korrekt heruntergeladen werden. Wenn du das Verzeichnis
  `repository` im Verzeichnis `.m2` löscht, werden alle Abhängigkeiten
  erneut heruntergeladen.

Der Java-Code ist nun kompiliert. Der nächste Schritt ist, die Docker
Images zu erstellen:

* Nur Minikube: Konfiguriere Docker so, dass es den Kubernetes Cluster nutzt. Nur so
  können die Docker Images in den Kubernetes Cluster übertragen
  werden: `minikube docker-env`(macOS / Linux) oder `minikube.exe
  docker-env`(Windows) beschreibt, wie man dafür vorgehen muss.

* Nur Minikube: Danach sollte `docker images` die Kubernetes Docker Images anzeigen:

```
[~/microservice-istio/microservice-istio]docker images
REPOSITORY                                TAG                 IMAGE ID            CREATED             SIZE
k8s.gcr.io/kubernetes-dashboard-amd64     v1.10.1             f9aed6605b81        3 weeks ago         122MB
k8s.gcr.io/kube-proxy                     v1.12.4             6d393e89739f        3 weeks ago         96.5MB
k8s.gcr.io/kube-apiserver                 v1.12.4             c04b373449d3        3 weeks ago         194MB
k8s.gcr.io/kube-controller-manager        v1.12.4             51b2a8e5ff78        3 weeks ago         164MB
k8s.gcr.io/kube-scheduler                 v1.12.4             c1b5e63c0b56        3 weeks ago         58.4MB
istio/sidecar_injector                    1.0.5               091fd902183a        4 weeks ago         52.9MB
istio/servicegraph                        1.0.5               cef5bb589599        4 weeks ago         16.5MB
istio/proxyv2                             1.0.5               e393f805ceac        4 weeks ago         380MB
istio/pilot                               1.0.5               68f5cc3a87ff        4 weeks ago         313MB
istio/mixer                               1.0.5               582d5c76010e        4 weeks ago         70MB
istio/galley                              1.0.5               e35efbcb45ed        4 weeks ago         73.1MB
istio/citadel                             1.0.5               3e6285f52cd0        4 weeks ago         56.1MB
k8s.gcr.io/etcd                           3.2.24              3cab8e1b9802        3 months ago        220MB
k8s.gcr.io/coredns                        1.2.2               367cdc8433a4        4 months ago        39.2MB
grafana/grafana                           5.2.3               17a5ba3b1216        4 months ago        245MB
prom/prometheus                           v2.3.1              b82ef1f3aa07        6 months ago        119MB
jaegertracing/all-in-one                  1.5                 93f16463fee4        7 months ago        48.4MB
k8s.gcr.io/kube-addon-manager             v8.6                9c16409588eb        10 months ago       78.4MB
k8s.gcr.io/pause                          3.1                 da86e6ba6ca1        12 months ago       742kB
gcr.io/k8s-minikube/storage-provisioner   v1.8.1              4689081edb10        14 months ago       80.8MB
quay.io/coreos/hyperkube                  v1.7.6_coreos.0     2faf6f7a322f        15 months ago       699MB
```

* Starte `docker-build.sh` im Verzeichnis
`microservice-istio-demo`. Das Skript erzeugt die Docker
Images.

```
[~/microservice-istio/microservice-istio-demo]./docker-build.sh 
...
Successfully tagged microservice-istio-invoicing:latest
Sending build context to Docker daemon  47.88MB
Step 1/4 : FROM openjdk:11.0.2-jre-slim
 ---> 4bd06752ac4a
Step 2/4 : COPY target/microservice-istio-order-0.0.1-SNAPSHOT.jar .
 ---> 31d666e6ecab
Step 3/4 : CMD /usr/bin/java -Xmx400m -Xms400m -jar microservice-istio-order-0.0.1-SNAPSHOT.jar
 ---> Running in 6a3aafef3449
Removing intermediate container 6a3aafef3449
 ---> a83eb4e8a9fe
Step 4/4 : EXPOSE 8080
 ---> Running in 5054a949c575
Removing intermediate container 5054a949c575
 ---> b60004d121e5
Successfully built b60004d121e5
Successfully tagged microservice-istio-order:latest
```

* Manchmal können die Images nicht heruntergeladen werden. Versuche
  dann, `docker logout` einzugeben und das Skript erneut zu starten.


* Die Images sollten nun verfügbar sein:

```
[~/microservice-istio/microservice-istio-demo]docker images
REPOSITORY                                TAG                 IMAGE ID            CREATED              SIZE
microservice-istio-order             latest              b60004d121e5        About a minute ago   342MB
microservice-istio-invoicing          latest              287e662e8111        About a minute ago   342MB
microservice-istio-shipping           latest              3af9dd80a8ee        About a minute ago   342MB
microservice-istio-apache            latest              eff5fd508880        About a minute ago   240MB
microservice-istio-postgres          latest              deadbeef8880        About a minute ago   42MB
...
```
* Nur Google Cloud: Lade die Docker Images mit `docker-push-gcp.sh` in
  die Cloud hoch.

## Container starten

* Konfiguriere Istio so, dass die Istio Container automatisch in die
Kubernetes Pods injiziert werden: `kubectl label namespace default
istio-injection=enabled`

* Nur Google Cloud: Modifiziere die YAML-Dateien so, dass sie die
  Docker Images aus dem Google Docker Repository herunterladen mit
  `fix-microservices-gcp.sh` 


* Deploye die Infrastruktur für die Microservices mit `kubectl` im
Verzeichnis `microservice-kubernetes-demo` :

```
[~/microservice-istio/microservice-istio-demo]kubectl apply -f infrastructure.yaml
deployment.apps/apache created
deployment.apps/postgres created
service/apache created
service/postgres created
gateway.networking.istio.io/microservice-gateway created
virtualservice.networking.istio.io/apache created
```


* Deploye die Microservices mit `kubectl`:


```
[~/microservice-istio/microservice-istio-demo]kubectl apply -f microservices.yaml
deployment.apps/invoicing created
deployment.apps/shipping created
deployment.apps/order created
service/invoicing created
service/shipping created
service/order created
virtualservice.networking.istio.io/shipping created
virtualservice.networking.istio.io/invoicing created
virtualservice.networking.istio.io/order created
```

Das Skript erzeugt Pods mit den Docker Images, die zuvor gebaut worden
sind. Pods können einen oder mehrere Docker Container enthalten. In
diesem Fall enthält jeder Pod einen Docker Container mit dem
Microservice und einen weiteren mit der Istio-Infrastruktur.

Hinweis: Die Postgres-Installation ist sehr einfach, d.h. es ist nicht
garantiert, dass die Daten einen Neustart oder Änderungen im Cluster
überstehen. Für eine Demo-Umgebung ist das allerdings nicht notwendig
und so bleibt das Setup recht einfach.

Das Skript erzeugt auch Kubernetes-Services. Services haben eine im
Cluster eindeutige IP-Adresse und einen DNS-Eintrage. Ein Service kann
dann viele Pods umfassen, um Lastverteilung umzusetzen.

* Starte `kubectl get services`, um die Kubernetes-Services zu sehen:

```
[~/microservice-istio/microservice-istio-demo]kubectl get services
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
apache       NodePort    10.110.196.4     <none>        80:31475/TCP     4m13s
catalog      NodePort    10.96.45.251     <none>        8080:32300/TCP   4m13s
customer     NodePort    10.101.227.211   <none>        8080:31621/TCP   4m13s
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP          152m
order        NodePort    10.109.230.95    <none>        8080:32182/TCP   4m13s
```


* `kubectl describe service` gibt weitere Details über die Services
  aus.  Das funktioniert auch mit Pods (`kubectl describe pod`) und
  Deployments (`kubectl describe deployment`).

```
[~/microservice-istio/microservice-istio-demo]kubectl describe service order
Name:                     order
Namespace:                default
Labels:                   run=order
                          visualize=true
Annotations:              kubectl.kubernetes.io/last-applied-configuration:
                            {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"creationTimestamp":null,"labels":{"run":"order","visualize":"true"},"nam...
Selector:                 run=order,serving=true
Type:                     NodePort
IP:                       10.109.230.95
Port:                     http  8080/TCP
TargetPort:               8080/TCP
NodePort:                 http  32182/TCP
Endpoints:                172.17.0.20:8080
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>kubectl describe services
```

* Man kann sich auch eine Liste der Pods geben lassen:

```
[~/microservice-istio/microservice-istio-demo]kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
apache-7f7f7f79c6-jbqx8      2/2     Running   0          8m51s
invoicing-77f69ff854-rpcbk   2/2     Running   0          8m43s
order-cc7f8866-9zbnf         2/2     Running   0          8m43s
postgres-5ddddbbf8f-xfng5    2/2     Running   0          8m51s
shipping-5d58798cdd-9jqj8    2/2     Running   0          8m43s
```

* ...und man kann sich die Logs eines Pods anschauen:

```
~/microservice-istio/microservice-istio-demo$ kubectl logs order-cc7f8866-9zbnf order 

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v2.0.6.RELEASE)

2019-01-17 16:56:30.909  INFO 6 --- [           main] com.ewolff.microservice.order.OrderApp   : Starting OrderApp v0.0.1-SNAPSHOT on order-cc7f8866-9zbnf with PID 6 (/microservice-istio-order-0.0.1-SNAPSHOT.jar started by root in /)
2019-01-17 16:56:30.918  INFO 6 --- [           main] com.ewolff.microservice.order.OrderApp   : No active profile set, falling back to default profiles: default
2019-01-17 16:56:31.200  INFO 6 --- [    es-writer-1] es-logger                                : {"index":{"_index":"logs-2019-01-17","_type":"tester"}}
{"@timestamp":"2019-01-17T16:56:30.909+0000","message":"Starting OrderApp v0.0.1-SNAPSHOT on order-cc7f8866-9zbnf with PID 6 (/microservice-istio-order-0.0.1-SNAPSHOT.jar started by root in /)","host":"order-cc7f8866-9zbnf","severity":"INFO","thread":"main","logger":"com.ewolff.microservice.order.OrderApp"}
{"index":{"_index":"logs-2019-01-17","_type":"tester"}}
{"@timestamp":"2019-01-17T16:56:30.918+0000","message":"No active profile set, falling back to default profiles: default","host":"order-cc7f8866-9zbnf","severity":"INFO","thread":"main","logger":"com.ewolff.microservice.order.OrderApp"}
...
```

* Außerdem kann man in einem Pod ein Kommando ausführen:

```
[~/microservice-istio/microservice-istio-demo]kubectl exec order-cc7f8866-9zbnf /bin/ls
Defaulting container name to order.
Use 'kubectl describe pod/order-cc7f8866-9zbnf -n default' to see all of the containers in this pod.
bin
boot
dev
docker-java-home
etc
home
lib
lib32
lib64
libx32
media
microservice-istio-order-0.0.1-SNAPSHOT.jar
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
```

* Es ist sogar möglich, eine Shell in einem Container zu starten:

```
[~/microservice-istio/microservice-istio-demo]kubectl exec order-cc7f8866-9zbnf -it /bin/sh
Defaulting container name to order.
Use 'kubectl describe pod/order-cc7f8866-9zbnf -n default' to see all of the containers in this pod.
# ls
bin  boot  dev	docker-java-home  etc  home  lib  lib32  lib64	libx32	media  microservice-istio-order-0.0.1-SNAPSHOT.jar  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
#
```

## Demo verwenden

Die Funktionalitäten der Demo sind durch einen Ingress verfügbar, der
Zugriff auf alle Microservices anbietet.

* Überprüfe, ob das Ingress Gateway funktioniert:

```
[~/microservice-istio/microservice-istio-demo] kubectl get gateway
NAME                   AGE
microservice-gateway   30m
```

* `ingress-url.sh`  gibt die Ingress-URL für Minikube aus. Für die
  Google Cloud ist es `ingress-gcp.sh`

* Wenn Du nun die Ingress URL öffnest, dann wird
eine statische HTML-Seite angezeigt, die vom Apache-Webserver
angezeigt wird. Sie hat Links zu den andern Microservices.

* Sollte der Zugriff auf den Ingress nicht funktionieren oder die
  Skripte keine sinnvolle URL ausgegeben, dann kannst du mit
  dem Skript `ingress-forward.sh` einen Proxy zu dem Ingress auf dem
  lokalen Rechner erzeugen. Das Skript dann die URL des Proxys aus.

## Microservice hinzufügen

Im Verzeichnis `microservice-istio-bonus` gibt es einen weiteren
Microservice. Um auch diesen Microservice zu deployen, sind die
folgenden Schritte notwendig:

* Wechsel in das Verzeichnis`microservice-isitio-bonus` und starte
`./mvnw clean package` (macOS / Linux) oder `mvnw.cmd clean package`
(Windows), um den Java Code zu kompilieren.

* Starte `docker-build.sh` im Verzeichnis
`microservice-istio-bonus`. Das Skript erzeugt das Docker image und
lädt es in den Kubernetes cluster.

* Deploye die Microservices mit `kubectl apply -f bonus.yaml`.

* Mit `kubectl delete -f bonus.yaml` kann man die  Microservices
  wieder löschen.

## Microservice mit Helm hinzufügen

Man kann einen Microservice ebenfalls mit Helm
hinzufügen. [Helm](https://helm.sh/) ist ein Package-Manager 
für Kubernetes, der  Templates für die
Kubernetes-Konfigurationen unterstützt. Das macht es einfacher, einen
neuen Microservice zu dem System hinzuzufügen:

* Als Erstes muss
  [Helm](https://docs.helm.sh/using_helm/#installing-helm) in den
  Kubernetes Cluster installiert werden.
  
* Das Verzeichnis `spring-boot-microservice` enthält einen Helm Chart
  für die Microservices in diesem Projekt. Daher reicht `helm install
  --set name=bonus spring-boot-microservice/`, um einen Microservice
  zu deploymen.
  
```
[~/microservice-istio] helm install --set name=bonus  spring-boot-microservice/
NAME:   waxen-newt
LAST DEPLOYED: Wed Feb 13 14:25:52 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME   TYPE      CLUSTER-IP     EXTERNAL-IP  PORT(S)         AGE
bonus  NodePort  10.108.31.211  <none>       8080:30878/TCP  5s

==> v1/Deployment
NAME   DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
bonus  1        1        1           1          5s

==> v1alpha3/VirtualService
NAME   AGE
bonus  1s

==> v1/Pod(related)
NAME                    READY  STATUS   RESTARTS  AGE
bonus-55d854b9d9-sn4pm  2/2    Running  0         4s
```

* Dem Helm Release wird automatisch ein Name zugewiesen. Bei diesem
  Beispiel ist es `waxen-newt`. `helm list` gibt eine Liste aller
  derzeit installierten Helm Releases zurück.

* Helm Release können anhand des Names gelöscht werden, also
  beispielsweise mit `helm delete waxen-newt`.

#### Den neuen Microservice nutzen

Der Bonus-Microservice ist nicht in der statischen Webseite enthalten,
die Links zu den Microservices enthält. Dennoch kann der Microservice
durch das Ingress Gateway erreicht werden. Wenn die URL des Ingress
Gateways http://192.168.99.127:31380/ ist, dann kann auf den
Bonus-Microservice unter http://192.168.99.127:31380/bonus
zugegriffen werden.

Der Bonus-Microservice zeigt keinen Umsatz an. Das liegt daran, dass
der Microservices ein Feld  `revenue` in den Daten aus dem
Order-Microservice erwartet. Dieses Feld ist im Moment in der
Datenstruktur nicht enthalten. Das verdeutlicht, dass ein neuer
Microservice gegebenfalls Änderungen an den Datenstrukturen
erforderlich machen kann. Solche Änderungen können dann wiederum
andere Microservices beeinflussen.

## Prometheus

Istio enthält eine Installation von
[Prometheus](https://prometheus.io/). 
Dieses Werkzeug sammelt Metriken von den Proxies ein, über welche die
Microservices miteinander kommunizieren. Es stellt daher die Basis für
das Monitoring dar. 

Mit `kubectl -n istio-system port-forward deployment/prometheus
9090:9090` kann man einen Proxy erzeugen, um dann auf Prometheus unter
http://localhost:9090/ zuzugreifen. 
In der Google Cloud Shell kann man die [Web
+Preview](https://cloud.google.com/shell/docs/using-web-preview)
nutzen, um die Oberfläche im Browser anzuzeigen.

Das Skript `monitoring-prometheus.sh` enthält ebenfalls diesen Befehl.

Metriken sind nur sinnvoll, wenn das System unter Last ist. Das
Shell-Skript `load.sh` nutzt `curl`, um eine bestimmte URL 1.000
aufzurufen. Du kannst das eine oder mehrere Instanzen des Skripts
starten und dabei beispielsweise die URL der Home Page des Shipping
Microservice übergeben, um so Last auf diesem Service zu erzeugen.

## Grafana

Prometheus bietet nur sehr limitierte Dashboards an. Deswegen hat
Istio außerdem eine Installation von 
[Grafana](https://grafana.com/), das viel bessere Graphen und
Dashboards anbietet.

Gib `kubectl -n istio-system port-forward deployment/grafana
3000:3000` ein, um einen Proxy für Grafana zu erzeugen.  Das Werkzeug
ist dann unter http://localhost:3000/ erreichbar. Es enthält einige
vordefinierte Dashboards.

Das Skript `monitoring-grafana.sh` erzeugt ebenfalls den für den
Zugriff notwendigen Proxy.

## Tracing

[Jaeger](https://www.jaegertracing.io/) ist ein System, um Aufrufe
zwischen Microservices zu verfolgen.
Istio enthält eine Installation von Jaeger. Nach einem Aufruf von
`kubectl -n istio-system port-forward deployment/istio-tracing
16686:16686` kann man es unter http://localhost:16686/ erreichen.

Das Skript `tracing.sh` enhält ebenfalls den notwendigen Befehl.

## Kiali

[Kiali](https://www.kiali.io/) ist ein Werkzeug, dass die
Abhängigkeiten zwischen den Microservices visualisiert. Es generiert
Abhängigkeitsgraphen und zeigt einige wesentliche Metriken an. Das
Skript `kiali.sh` dient dazu, einen Proxy zu Istios Kiali-Installation
zu starten. Danach steht die Kiali-Konsole unter
http://localhost:20001/ bereits. Der voreingestellte Benutzername ist
admin. Das Passwort ist ebenfalls admin.

## Logging

Istio unterstützt auch Logging. Aber Istio kann in den Logs nur die
Informationen aus den HTTP Request loggen. Diese Informationen sind
zwar wertvoll, aber reichen oft nicht aus, um Probleme in den
Microservices zu untersuchen. Daher müssen die Microservices selber
einige Informationen loggen. Die Logs müssen in einem zentralen System
gespeichert werden, Um eine große Anzahl von Microservices zu
unterstützen und um sicherzustellen, dass die Log-Informationen auch
noch nach Restarts usw. zur Verfügung stehene,

Die Demo nutzt
[Elasticsearch](https://www.elastic.co/products/elasticsearch), um die
Logs zu speichern. Die Microservices schreiben ihre Logs direkt in
Elasticsearch. 
[Kibana](https://www.elastic.co/products/kibana) kann genutzt werden,
um die Logs anzuzeigen und zu analysieren.

Um die Log-Infrastruktur zu nutzen, muss sie mit `kubectl apply -f
logging.yaml` gestartet werden.


`kubectl -n logging port-forward deployment/kibana 5601:5601` startet
den Proxy für Kibana, so dass er unter http://localhost:5601/
zugreifbar ist.  Das Skript `kibana.sh` ermöglicht dasselbe.

Wenn die Microservices gestartet worden sind, ohne dass der
Elasticsearch-Server gestartet worden ist, dann kann es vorkommen,
dass nach dem Start die Microservices nicht mehr versuchen auf den
Server zuzugreifen. Gegebenenfalls ist es dann notwendig, die
Microservices mit `kubectl delete -f microservices.yaml` zu stoppen
und mit `kubectl apply -f microservices.yaml` wieder zu starten.

Die Log-Infrastruktur kann mit `kubectl delete -f logging.yaml` wieder
gelöscht werden.

## Fault Injection

Istio kann auch Fehler in das System einbauen, um so die Resilienz des
Systems zu überprüfen. 

`fault-injection.yaml` erzeugt bei jedem
REST Request zum Order Microservice einen HTTP-500-Fehler. Mit
`kubectl apply
-f fault-injection.yaml` kann diese Konfiguration zum System
hinzugefügt werden. Wenn man nun den Invoicing oder Shipping
Microservice Informationen vom Order Microservice pollen lässt, dann
dauert dieser Vorgang deutlich länger und endet in einem Fehler.

Mit `kubectl delete -f fault-injection.yaml`verschwindet diese
Verzögerung wieder aus dem System.

## Delay Injection

Mit `kubectl apply -f
delay-injection.yaml` kann man eine Verzögerung von 7s zu jedem REST-Aufruf
des Order Microservice hinzufügen und mit `kubectl delete -f
delay-injection.yaml` wieder entfernen. Wenn man nun den Shipping
Microservice den Order Microservice pollen lässt, dauert dieser
Vorgang entsprechend länger.

## Circuit Breaker

Istio enthält ebenfalls einen Circuit Breaker (Sicherung). Wenn ein
System zu langsame ist oder Fehler zurückgibt, dass macht es keinen
Sinn, immer noch alle Requests zu dem System zu schicken. Istio kann
daher mit einer Regel so konfiguriert werden, dass ein Circuit Breaker
ausgelöst wird, wenn eine bestimmte Anzahl Requests auf die
Bearbeitung warten oder auf Fehler laufen. Dann werden die Requests
nicht mehr an das eigentliche System weitergeschickt, sondern laufen
direkt auf einen Fehler.

Nutze `kubectl apply -f cicuit-breaker.yaml`, um die Regel zu
aktivieren. Die Anzahl der Requests, die warten oder parallel
bearbeitet werden dürfen, wird dabei so stark eingeschränkt, dass es
sehr einfach ist, das System zu überlasten. Erzeuge dann Last. Dazu
gibt es ein sehr einfacher Skrpt, dass mit cURL last erzeugt. Ein paar
Mall `./load.sh
"-X POST http://192.168.99.110:31380/invoicing/poll" &` zu starten
sollte reichen. In der Ausgabe wirst Du einige  HTTP-500-Fehler sehen,
die der Circuit Breaker erzeugt hat. Weitere
`curl -X POST http://192.168.99.110:31380/invoicing/poll`,
werden mit hoher Wahrscheinlichkeit auch ein 500 zurückgeben. Nutze
`ingress-url.sh` (Minikube) oder `ingress-gcp.sh` (Google Cloud), um
die richtige URL zu finden.

Mit `kubectl delete -f cicuit-breaker.yaml` kann die Regel wieder
entfernt werden.

Es ist auch möglich, einen Timeout in Istio einzufügen, siehe
https://istio.io/docs/tasks/traffic-management/request-timeouts/ .

## Retry

Mit `kubectl apply -f failing-order-service.yaml` kann man eine
Version des Order-Microservices deployen, der 50%  aller Requests mit
einen HTTP-500-Fehler beantwortet. Wenn man nun die Web UI des Order
Microservice nutzt bzw Invoicing order Shipping dazu bringt, den
Order-Microservices zu pollen, dann gibt es vermutlich einen Fehler.

Mit `kubectl apply -f retry.yaml` kann man Istio dazu bringen, jeden
Request an den Order-Microservice noch ein zweites Mal
auszuführen. Diese Wiederholungen fügt Istio sowohl in die
Kommunikation zwischen den Microservices ein als auch bei der
Kommunikation mit dem Ingress Gateway. Also funktioniert sowohl das
Pollen als auch die Web UI wieder.

Mit `kubectl delete -f retry.yaml` kann man die Retrys aus dem System
wieder entfernen. Der Microservice kann mit `kubectl apply -f
microservices.yaml` zurückgesetzt werden.

## Aufräumen

* Um alle Microservices zu löschen, starte `kubectl delete -f
  microservices.yaml`:

```
[~/microservice-istio/microservice-istio-demo]kubectl  delete -f microservices.yaml
deployment.apps "catalog" deleted
deployment.apps "customer" deleted
deployment.apps "order" deleted
service "catalog" deleted
service "customer" deleted
service "order" deleted
virtualservice.networking.istio.io "customer" deleted
virtualservice.networking.istio.io "catalog" deleted
virtualservice.networking.istio.io "order" deleted
```

* Lösche dann die Infrastruktur mit `kubectl  delete -f
  infrastructure.yaml`:

```
[~/microservice-istio/microservice-istio-demo]kubectl  delete -f infrastructure.yaml
deployment.apps "apache" deleted
service "apache" deleted
gateway.networking.istio.io "microservice-gateway" deleted
virtualservice.networking.istio.io "apache" deleted
```

## Installation mit Helm

Die Kubernetes-Konfiguration für die Microservices sind alle sehr
ähnlich. Es ist daher sinnvoll, ein Template zu nutzen und es zu
parametrisieren.  [Helm](https://helm.sh/) ist ein Werkzeug, um solche
Templates zu erzeugen und sie zu nutzen. Die Templates heißen Helm
Charts.

* Installiere Helm, siehe
https://github.com/helm/helm/blob/master/docs/install.md

* Um Helm in dem Kubernetes Cluster zu nutzen, muss man zunächst 
  `helm init`starten.
  
* Stelle sicher, dass die Infrastruktur mit `kubectl apply -f
  infrastructure.yaml` deployt worden ist (siehe oben).

* Um einen der Microservices `order`, `shipping`, und `invoicing`
  starten, muss man nur z.B. `helm install --set name=order
  ../spring-boot-microservice/`
  ausführen. `../spring-boot-microservice` ist das Verzeichnis, dass
  den Helm Chart enthält.
  
* Die Datei `spring-boot-microservice/values.yaml`enthält die weiteren
  Paramter, die wie `name` bei der Installation geändert werden können.

* `helm install --dry-run --set name=order
  ../spring-boot-microservice/`. `../spring-boot-microservice` macht
  einen "Dry Run", d.h. es wird nichts geändert sondern nur die
  entsprechenden Meldungen ausgegeben.

* `install-helm.sh` enhält alle notwendigen Befehle, um alle drei
Microservices zu deployen:

```
[~/microservice-istio/microservice-istio-demo]./install-helm.sh
NAME:   wobbling-billygoat
LAST DEPLOYED: Wed Jan 16 10:07:50 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Pod(related)
NAME                    READY  STATUS   RESTARTS  AGE
order-79cd6c8844-vhcqj  0/2    Pending  0         0s

==> v1/Service
NAME   TYPE      CLUSTER-IP      EXTERNAL-IP  PORT(S)         AGE
order  NodePort  10.109.102.171  <none>       8080:31666/TCP  0s

==> v1/Deployment
NAME   DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
order  1        1        1           0          0s
...
```

* Das Ergebnis sind mehrere Releases der Helm Chart mit
  unterschiedlichen Parametern. Das Relase in der Ausgabe oben heißt
  `wobbling-billygoat`. Der Name wird automatisch generier.t


## Helm-Installation aufräumen

* Zunächst muss man die Namen der Helm Releases ermitteln:

```
[~/microservice-istio/microservice-istio-demo] helm list
NAME            REVISION        UPDATED                         STATUS          CHART                           APP VERSION                                          NAMESPACE
flabby-abalone  1               Wed Jan 16 08:21:50 2019        DEPLOYED        spring-boot-microservice-0.1.0  1.0                                                  default
insipid-puma    1               Wed Jan 16 08:21:57 2019        DEPLOYED        spring-boot-microservice-0.1.0  1.0                                                  default
lame-skunk      1               Wed Jan 16 08:21:40 2019        DEPLOYED        spring-boot-microservice-0.1.0  1.0                                                  default
``` 

* Dann kann man die Releases anhand der Namen löschen:

``` 
[~/microservice-istio/microservice-istio-demo] helm delete flabby-abalone
release "flabby-abalone" deleted
[~/microservice-istio/microservice-istio-demo] helm delete insipid-puma
,release "insipid-puma" deleted
[~/microservice-istio/microservice-istio-demo] helm delete lame-skunk
release "lame-skunk" deleted
``` 


* Schließlich kann man mit `kubectl delete -f infrastructure.yaml` die
  Infrastruktur löschen.
