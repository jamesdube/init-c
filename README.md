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

## TCP Probe Usage

To use the TCP probe, specify `tcp` as the probe type and use the `-i` or `--ip` argument to provide the IP address and `-p` or `--port` argument to provide the port to probe.

### Basic TCP Probe Examples

#### Database Connection (PostgreSQL)
```yaml
initContainers:
  - name: init-c
    image: jdube/init-c
    args: ['tcp', '-i', "database.default", '-p', "5432"]
```

#### Redis Cache
```yaml
initContainers:
  - name: init-c
    image: jdube/init-c
    args: ['tcp', '-i', "redis.default", '-p', "6379"]
```

#### MySQL Database
```yaml
initContainers:
  - name: init-c
    image: jdube/init-c
    args: ['tcp', '-i', "mysql.default", '-p', "3306"]
```

#### MongoDB
```yaml
initContainers:
  - name: init-c
    image: jdube/init-c
    args: ['tcp', '-i', "mongodb.default", '-p', "27017"]
```

#### Custom Application Service
```yaml
initContainers:
  - name: init-c
    image: jdube/init-c
    args: ['tcp', '-i', "backend-service.default", '-p', "8080"]
```

### TCP Probe with Custom Timeout

You can specify a custom timeout using the `-t` or `--timeout` argument:

```yaml
initContainers:
  - name: init-c
    image: jdube/init-c
    args: ['tcp', '-i', "database.default", '-p', "5432", '-t', "30"]
```

### Local Testing Examples

```shell script
# Test local service
docker run --rm jdube/init-c tcp -i 127.0.0.1 -p 80

# Test database connection
docker run --rm jdube/init-c tcp -i 127.0.0.1 -p 5432

# Test with custom timeout (30 seconds)
docker run --rm jdube/init-c tcp -i 127.0.0.1 -p 3306 -t 30

# Test external service
docker run --rm jdube/init-c tcp -i google.com -p 80
```

### Complete Deployment Example with TCP Probe

Here's a complete example showing how to use TCP probes in a real deployment scenario:

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-application
  namespace: default
  labels:
    app: web-application
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-application
  template:
    metadata:
      labels:
        app: web-application
    spec:
      # Wait for database and cache to be ready
      initContainers:
      - name: wait-for-db
        image: jdube/init-c
        args: ['tcp', '-i', "postgres.default", '-p', "5432", '-t', "60"]
      - name: wait-for-cache
        image: jdube/init-c
        args: ['tcp', '-i', "redis.default", '-p', "6379", '-t', "30"]
      containers:
      - name: web-app
        image: myapp/web-application:latest
        ports:
        - containerPort: 8080
        env:
        - name: DATABASE_URL
          value: "postgres://postgres.default:5432/myapp"
        - name: REDIS_URL
          value: "redis://redis.default:6379"
```

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).
