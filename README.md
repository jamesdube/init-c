# init-c

Init Container for probing dependant services in Kubernetes

[![Issues](https://img.shields.io/github/issues/jamesdube/init-c)](https://img.shields.io/github/issues/jamesdube/init-c) ![Docker Pulls](https://img.shields.io/docker/pulls/jdube/init-c) ![Docker Image Version (latest by date)](https://img.shields.io/docker/v/jdube/init-c) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/jdube/init-c)


## About

In certain use cases you would want to delay starting up your deployment by checking if
dependent services are up either through http or tcp probing. This helps your services to boot 
up in the correct order, for reference check out this [example](#). Particular use cases
include service discovery and fetching startup configs for spring boot applications.

## Features

 - [x] HTTP probe
 - [x] TCP Probe
 - [x] DNS Probe
    
## Usage

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: default
  labels:
    app: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      # Add your init container here            
      initContainers:
      - name: init-c
        image: jdube/init-c
        args: ['http', '-u', "http://backend.default"]
      containers:
      - name: frontend
        image: jdube/frontend
        ports:
        - containerPort: 8000
```

## Local Testing

```shell script
docker run --rm jdube/init-c http -u https://www.google.com
```
## DNS Probe Usage

To use the DNS probe, specify `dns` as the probe type and use the `-h` or `--hostname` argument to provide the hostname to probe.

```yaml
initContainers:
  - name: init-c
    image: jdube/init-c
    args: ['dns', '-h', "google.com"]
```

```shell script
docker run --rm jdube/init-c dns -h google.com
```

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).
