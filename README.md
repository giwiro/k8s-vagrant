<div align="center">
    <img src="https://raw.githubusercontent.com/giwiro/k8s-vagrant/main/resources/logo.png" alt="logo" width="400" />
    <hr />
    <p>Tired of cloud bills? Get a fully-functional local Kubernetes cluster in minutes! This project uses Vagrant & Ubuntu, powered by Kubeadm, Flannel, and CRI-O, making K8s development and testing accessible and free.</p>
</div>

<p align="center">
    <a href="https://github.com/kubernetes/kubernetes" alt="Kubernetes"><img src="https://img.shields.io/github/v/release/kubernetes/kubernetes?filter=v1.33.4&label=kubernetes" /></a>
    <a href="https://github.com/flannel-io/flannel" alt="Flannel"><img src="https://img.shields.io/github/v/release/flannel-io/flannel?label=flannel" /></a>
    <a href="https://github.com/cri-o/cri-o" alt="Crio"><img src="https://img.shields.io/github/v/release/cri-o/cri-o?filter=v1.33.4&label=cri-o" /></a>
    <a href="https://github.com/giwiro/k8s-vagrant/blob/main/LICENSE" alt="MIT"><img src="https://img.shields.io/github/license/giwiro/k8s-vagrant" /></a>
</p>

<!---
[![Kubernetes GitHub Release][kubernetes-badge]][kubernetes-url]
[![Crio GitHub Release][crio-badge]][crio-url]
[![Flannel GitHub Release][flannel-badge]][flannel-url]
[![GitHub License][license-badge]][license-url]
-->

## Installation

1. Clone this repository

```bash
git clone https://github.com/giwiro/k8s-vagrant.git
```

2. Change directory to the cloned repository

```bash
cd k8s-vagrant
```

3. Run the Vagrantfile

```bash
vagrant up
```

4. Verify installation

```bash
vagrant ssh master -c 'kubectl get nodes -o wide'
```

And you should see something like this:

```
NAME      STATUS   ROLES           AGE   VERSION
master    Ready    control-plane   15h   v1.33.4
worker1   Ready    worker          15h   v1.33.4
worker2   Ready    worker          15h   v1.33.4
```

## Configuration

In the `Vagrantfile` you can change the default configuration.

```ruby
#      _____             __ _
#     / ____|           / _(_)
#    | |     ___  _ __ | |_ _  __ _
#    | |    / _ \| '_ \|  _| |/ _` |
#    | |___| (_) | | | | | | | (_| |
#     \_____\___/|_| |_|_| |_|\__, |
#        Custom configuration  __/ |
#                             |___/

VMProvider = "virtualbox"
Image = "bento/ubuntu-22.04"
MasterPrivateIp = "192.168.1.2"
NumberNodes = 2
NodesPrivateIpPrefix = "192.168.2."
PodNetworkCIDR = "10.1.0.0/16"
KubernetesVersion = "v1.33"
CrioVersion = "v1.33"
TLSCheckDisable = "true"
```

- `VMProvider`: By default is `virtualbox`, but you can change it to whatever you want, make sure the box you provide
supports it.
- `Image`: By default is `bento/ubuntu-22.04`, this [box](https://portal.cloud.hashicorp.com/vagrant/discover/bento/ubuntu-22.04)
includes multiple architectures (arm64, amd64) for different providers (parallels, utm, virtualbox, vmware_desktop).
So if you have Apple Silicon Mac, you can/should use `bento/ubuntu-22.04`, otherwise you can use `ubuntu/jammy64`.
- `NumberNodes`: By default is `2`, but you can change it to whatever you want.
- `NodesPrivateIpPrefix`: It defined the first three octets of the worker nodes. By default is `192.168.2.`, and the
first ip will start from `2`. So for the first two nodes
their ips would be `192.168.2.2` and `192.168.2.3`.
- `TLSCheckDisable`: This option is by default set to `true`, which disables all TLS checks, in case you are behind a
firewall. What it does is:
  - Adds the `-k` option to `curl`.
  - Adds `Acquire::https::Verify-Peer "false";` configuration to `apt`.
  - Adds `insecure-registry` config to `crio`.
  - Adds `--no-check-certificate` option to `wget`.

## License

[MIT](LICENSE)


[kubernetes-badge]: https://img.shields.io/github/v/release/kubernetes/kubernetes?filter=v1.33.4&label=kubernetes
[kubernetes-url]: https://github.com/kubernetes/kubernetes

[flannel-badge]: https://img.shields.io/github/v/release/flannel-io/flannel?label=flannel
[flannel-url]: https://github.com/flannel-io/flannel

[crio-badge]: https://img.shields.io/github/v/release/cri-o/cri-o?filter=v1.33.4&label=cri-o
[crio-url]: https://github.com/cri-o/cri-o

[license-badge]: https://img.shields.io/github/license/giwiro/k8s-vagrant
[license-url]: https://github.com/giwiro/k8s-vagrant/blob/main/LICENSE
