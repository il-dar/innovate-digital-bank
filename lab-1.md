# Workshop

If you have not done the setup, please finish the setup from [here](./workshop.md).

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

Initialize Helm on your cluster

```bash
$ helm init

$HELM_HOME has been configured at /Users/mofizur.rahman@ibm.com/.helm.
Warning: Tiller is already installed in the cluster.
(Use --client-only to suppress this message, or --upgrade to upgrade Tiller to the current version.)
Happy Helming!
```

> I am getting the warning because I already had Tiller installed in my cluster.

Check helm is properly installed

```bash
$ helm version

Client: &version.Version{SemVer:"v2.9.1", GitCommit:"20adb27c7c5868466912eebdf6664e7390ebe710", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.9.1", GitCommit:"20adb27c7c5868466912eebdf6664e7390ebe710", GitTreeState:"clean"}
```

## Step 3

We will make use of helm charts to deploy the application into our kubernetes cluster.

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
  ...
  <OUTPUT-OMITTED>
  ...
```

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

Give it a few seconds. Then run

```bash
$ kubectl get deploy

NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
innovate-portal-deployment           1         1         1            1           28s


$ kubectl get po

NAME                                                  READY     STATUS    RESTARTS   AGE
innovate-portal-deployment-57b478cc5f-gds6x           1/1       Running   0          1m


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

ExternalIP:  <SOME-IP>
```

