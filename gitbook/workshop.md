# Microservices and Kubernetes for Banking Workshop

This document is the guided workshop for the code pattern Innovate Digital Bank. In this workshop we will use Helm to deploy a micro-service based application into Kubernetes Cluster.

## Step 1

[Sign Up for IBM Cloud.](https://ibm.biz/Bd2zDm)

## Step 2

[Install IBM Cloud CLI](https://console.bluemix.net/docs/cli/reference/ibmcloud/download_cli.html#install_use)

You can use the installer for your os. Or you can use the shell installer.

* MacOS

  ```bash
  curl -fsSL https://clis.ng.bluemix.net/install/osx | sh
  ```

* Linux

  ```bash
  curl -fsSL https://clis.ng.bluemix.net/install/linux | sh
  ```

* Windows Powershell (Run as Administrator)

  ```bash
  iex(New-Object Net.WebClient).DownloadString('https://clis.ng.bluemix.net/install/powershell')
  ```

## Step 3

Install IBM CLI Plugins

For the LAB we will need a few plugins.

* container-service

  ```bash
  ibmcloud plugin install container-service
  ```

* container-registry

  ```bash
  ibmcloud plugin install container-registry
  ```

## Step 4

[Install Kubectl for your OS](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

* MacOS

  * Homebrew

    ```bash
    brew install kubernetes-cli
    ```
  * MacPorts

    ```bash
    sudo port selfupdate
    sudo port install kubectl
    ```

* Linux

  * Ubuntu, Debian or HypriotOS

    ```bash
    sudo apt-get update && sudo apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
    ```

  * CentOS, RHEL or Fedora
    ```bash
    cat <<EOF > /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    EOF
    yum install -y kubectl
    ```

  * Snap

    ```bash
    sudo snap install helm --classic
    ```

* Windows

  * Powershell

    ```bash
    Install-Script -Name install-kubectl -Scope CurrentUser -Force
    install-kubectl.ps1 [-DownloadLocation <path>]
    ```

    > Note
    > ```If you do not specify a `DownloadLocation`, `kubectl` will be installed in the user's temp Directory.```

  * Chocolatey

    ```bash
    choco install kubernetes-helm
    ```

You can also install using [curl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-using-curl).

Once Kubernetes is installed, test successful installation with,

```bash
kubectl version
```

## Step 5

[Install Helm for your OS](https://docs.helm.sh/using_helm/#installing-helm)

* MacOS

  * Homebrew

    ```bash
    brew install kubernetes-helm
    ```

* Linux

  * Snap

    ```bash
    sudo snap install helm --classic
    ```

* Windows

  * Chocolatey

    ```bash
    choco install kubernetes-helm
    ```

## Step 6

Get access to the lab Kubernetes Cluster.

## Step 7

Clone the workshop repo.

```bash
git clone --single-branch -b workshop https://github.com/moficodes/innovate-digital-bank.git
```

We are cloning the repo directly to the workshop branch.

[Lab Part I](./lab-1.md)
