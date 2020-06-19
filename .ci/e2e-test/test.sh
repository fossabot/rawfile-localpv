#!/bin/sh
set -ex

helm upgrade -n kube-system -i rawfile-csi --set serviceMonitor.enabled=false ./deploy/charts/rawfile-csi/

cd $(dirname $0)
curl --location https://dl.k8s.io/v1.17.0/kubernetes-test-linux-amd64.tar.gz | tar --strip-components=3 -zxf - kubernetes/test/bin/e2e.test kubernetes/test/bin/ginkgo

ssh-keygen -N "" -f $HOME/.ssh/id_rsa
cat $HOME/.ssh/id_rsa.pub >>$HOME/.ssh/authorized_keys

./ginkgo -p -v \
  -focus='External.Storage' \
  -skip='\[Feature:|\[Disruptive\]|\[Serial\]' \
  ./e2e.test \
  -- \
  -storage.testdriver=rawfile-driver.yaml

./ginkgo -v \
  -focus='External.Storage.*(\[Feature:|\[Disruptive\]|\[Serial\])' \
  ./e2e.test \
  -- \
  -storage.testdriver=rawfile-driver.yaml
