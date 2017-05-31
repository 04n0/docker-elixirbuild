## Elixir build and release environment for prvrs:labs

### ubuntu-16.04/Dockerfile

*   base.image: ubuntu 16.04
*   erlang: 19.3
*   elixir: latest (apt)

### alpine/Dockerfile

*   base.image: alpine 3.6
*   erlang: 19.3
*   elixir: 1.4.2


## Pre-built Docker images

x86_64 Alpine based Docker image:
```docker pull docker.io/04n0/elixirbuild:alpine```

ARM64 (aarch64) Alpine based Docker image:
```docker pull docker.io/04n0/elixirbuild:alpine-aarch64```

x86_64 Ubuntu 16 based Docker image:
```docker pull docker.io/04n0/elixirbuild:ubuntu```


prvrs:labs 2o17
