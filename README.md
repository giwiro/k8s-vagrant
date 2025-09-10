<div align="center">
    <img src="https://raw.githubusercontent.com/giwiro/k8s-vagrant/main/logo.png" alt="logo" width="400" />
    ***
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
