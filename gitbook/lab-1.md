# Workshop

If you have not done the setup, please finish the [setup from here](./workshop.md).

## Step 1

Check your kubernetes cluster.

```bash
$ kubectl version

Client Version: version.Info{Major:"1", Minor:"11", GitVersion:"v1.11.3", GitCommit:"a4529464e4629c21224b3d52edfe0ea91b072862", GitTreeState:"clean", BuildDate:"2018-09-10T11:44:36Z", GoVersion:"go1.11", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"11", GitVersion:"v1.11.6+IKS", GitCommit:"002d263ed027db260968616b951fb46f2bab9bb1", GitTreeState:"clean", BuildDate:"2019-01-09T08:07:22Z", GoVersion:"go1.10.3", Compiler:"gc", Platform:"linux/amd64"}

$ kubectl get nodes

NAME             STATUS    ROLES     AGE       VERSION
10.176.239.180   Ready     <none>    2d        v1.11.6+IKS
10.176.239.182   Ready     <none>    2d        v1.11.6+IKS
10.177.184.153   Ready     <none>    2d        v1.11.6+IKS
```

Your versions may look a little different. As long as we don't see any connection errors we should be good to go.

## Step 2

Initialize Helm on your cluster.

```bash
$ helm init

$HELM_HOME has been configured at /Users/mofizur.rahman@ibm.com/.helm.
Warning: Tiller is already installed in the cluster.
(Use --client-only to suppress this message, or --upgrade to upgrade Tiller to the current version.)
Happy Helming!
```

> I am getting the warning because I already had Tiller installed in my cluster.

The command above will install helm for your kubernetes cluster and also store the cofig to your local directory. It will also install tiller in the cluster. **_Tiller_** is the in-cluster component of Helm. It interacts directly with the Kubernetes API server to _install_, _upgrade_, _query_, and _remove_ Kubernetes resources. It also stores the objects that represent releases.

Check helm is properly installed

```bash
$ helm version

Client: &version.Version{SemVer:"v2.9.1", GitCommit:"20adb27c7c5868466912eebdf6664e7390ebe710", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.9.1", GitCommit:"20adb27c7c5868466912eebdf6664e7390ebe710", GitTreeState:"clean"}
```

## Step 3

We will make use of helm charts to deploy the application into our kubernetes cluster. A chart is a collection of files that describe a related set of Kubernetes resources. A single chart might be used to deploy something simple, like a memcached pod, or something complex, like a full web app stack with HTTP servers, databases, caches, and so on. For our lab each helm chart is used for one kubernetes deployment.

You should already have the repo cloned. Change directory into the folder.

```bash
cd innovate-digital-bank
```

Lets see all the directories in the folder

```bash
$ ls -1 -d */

accounts/
authentication/
bills/
doc/
portal/
support/
transactions/
userbase/
```

We can see our 7 mircoservices and the doc folder.

> The flags on the `ls` command is basically listing just the directories and forcing them to be printed on separate lines.

We will deploy the `portal` first.

```bash
cd portal
```

Lets look at the helm chart we are about to deploy.

```bash
$ cat chart/innovate-portal/values.yaml

# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
replicaCount: 1
revisionHistoryLimit: 3
image:
  repository: moficodes/innovate-portal
  tag: v1.0.1-alpine
  pullPolicy: Always
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
livenessProbe:
  initialDelaySeconds: 3000
  periodSeconds: 1000
service:
  name: Node
  type: NodePort
  servicePort: 3100
  serviceNodePort: 30060
hpa:
  enabled: false
  minReplicas: 2
  maxReplicas: 3
  metrics:
    cpu:
      targetAverageUtilization: 80
    memory:
      targetAverageUtilization: 80
services:
```

There are some important information in this helm chart. We can see what image we are using for our deployment. We have also set some [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/). We have a liveness probe that [health checks](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/) our application every second. We could also have [horizontal pod autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) for automatically scalling based on load. For this workshop we will keep it as false.

For this workshop we are using prebuilt images of the services. This images live in [Docker Hub](https://hub.docker.com/u/moficodes).

```bash
$ helm upgrade innovate-portal chart/innovate-portal --install

Release "innovate-portal" has been upgraded. Happy Helming!
LAST DEPLOYED: Sun Jan 27 20:42:16 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME             TYPE      CLUSTER-IP     EXTERNAL-IP  PORT(S)         AGE
innovate-portal  NodePort  172.21.236.41  <none>       3100:30060/TCP  2d

==> v1beta1/Deployment
NAME                        DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
innovate-portal-deployment  1        1        1           0          0s

==> v1/Pod(related)
NAME                                         READY  STATUS             RESTARTS  AGE
innovate-portal-deployment-57b478cc5f-gds6x  0/1    ContainerCreating  0         0s
```

The `--install` flag install the helm chart if it already was not installed and upgrade otherwise.

Give it a few seconds. Then run

```bash
$ kubectl get po

NAME                                                  READY     STATUS    RESTARTS   AGE
innovate-portal-deployment-57b478cc5f-gds6x           1/1       Running   0          1m


$ kubectl get deploy

NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
innovate-portal-deployment           1         1         1            1           28s


$ kubectl get svc

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
innovate-portal           NodePort    172.21.236.41    <none>        3100:30060/TCP   2d
```

So the image was deployed and a service was created for us to be access it from anywhere.

Thats one of the 7 microservices deployed. Go ahead and deploy the other 6.

General steps are,

* Change directory into the service

* Run following command

  ```bash
  helm upgrade innovate-<microservice-name> chart/<microservice-name> --install
  ```

When its all done. Check all the pods, deployments and services are running properly. If you see any pod in any other state than `Running` get an instructor to troubleshoot.

```bash
$ kubectl get po

NAME                                                  READY     STATUS    RESTARTS   AGE
innovate-accounts-deployment-d9ffcfcf5-7rqmp          1/1       Running   0          1h
innovate-authentication-deployment-59d6796fdc-pbgxg   1/1       Running   0          1h
innovate-bills-deployment-5896bbf875-qj7lb            1/1       Running   0          1h
innovate-portal-deployment-57b478cc5f-gds6x           1/1       Running   0          1h
innovate-support-deployment-5b9889dd84-4b58w          1/1       Running   0          1h
innovate-transactions-deployment-88889b98f-gdm8n      1/1       Running   0          1h
innovate-userbase-deployment-5f8478b8f-c4vm4          1/1       Running   0          1h


$ kubectl get deploy

NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
innovate-accounts-deployment         1         1         1            1           1h
innovate-authentication-deployment   1         1         1            1           1h
innovate-bills-deployment            1         1         1            1           1h
innovate-portal-deployment           1         1         1            1           1h
innovate-support-deployment          1         1         1            1           1h
innovate-transactions-deployment     1         1         1            1           1h
innovate-userbase-deployment         1         1         1            1           1h

$ kubectl get svc

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
innovate-accounts         NodePort    172.21.10.10     <none>        3400:30120/TCP   1h
innovate-authentication   NodePort    172.21.24.92     <none>        3200:30100/TCP   1h
innovate-bills            NodePort    172.21.122.166   <none>        3800:30160/TCP   1h
innovate-portal           NodePort    172.21.236.41    <none>        3100:30060/TCP   1h
innovate-support          NodePort    172.21.93.40     <none>        4000:30180/TCP   1h
innovate-transactions     NodePort    172.21.166.41    <none>        3600:30200/TCP   1h
innovate-userbase         NodePort    172.21.240.7     <none>        4100:30050/TCP   1h
kubernetes                ClusterIP   172.21.0.1       <none>        443/TCP          2d
```

## Step 5

Find your cluster Public IP

```bash
$ kubectl get nodes

NAME             STATUS    ROLES     AGE       VERSION
10.176.239.180   Ready     <none>    2d        v1.11.6+IKS
10.176.239.182   Ready     <none>    2d        v1.11.6+IKS
10.177.184.153   Ready     <none>    2d        v1.11.6+IKS
```

Pick any of the nodes.

```bash
$ kubectl describe nodes 10.176.239.180 | grep ExternalIP

ExternalIP:  <YOUR-IP>
```

Save this IP address. We will need it to access our application.

## Step 6

Open any browser.
Go to `<YOUR-IP>:30060`

With any luck, you should see something like this.

![Image](../doc/source/images/website.png)

For this workshop we used a prebuilt docker image hosted at docker hub. For the next part of the lab we will see how we can create the docker image ourself.

[Lab Part II](lab-2.md)