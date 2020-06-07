# Drone plugin S2I

S2I plugin can be used to build and push images to Docker registry using S2I

Source-to-Image (S2I) is a toolkit and workflow for building reproducible container images from source code. S2I produces ready-to-run images by injecting source code into a container image and letting the container prepare that source code for execution. By creating self-assembling builder images, you can version and control your build environments exactly like you use container images to version your runtime environments.


### Example configuration:
```
- name: Test plugin
  image: getais/drone-plugin-s2i
  privileged: true
  settings:
    builder: examplebuilderimage
    target: examplerepo/exampleimage
    tags:
      - latest
    push: true
    registry: registry.example.domain    
    username: kevinbacon
    password: pa55word
```

### Example configuration using different context dir for S2i:
```
- name: Test plugin
  image: getais/drone-plugin-s2i
  privileged: true
  settings:
    builder: examplebuilderimage
    target: examplerepo/exampleimage
    context: somedir
    tags:
      - latest
    push: true
    registry: registry.example.domain    
    username: kevinbacon
    password: pa55word
```

### Example configuration using multi tags:
```
- name: Test plugin
  image: getais/drone-plugin-s2i
  privileged: true
  settings:
    builder: examplebuilderimage
    target: examplerepo/exampleimage
    tags:
      - latest
      - othertag
    push: true
    registry: registry.example.domain    
    username: kevinbacon
    password: pa55word
```

### Example configuration using secrets:
```
- name: Test plugin
  image: getais/drone-plugin-s2i
  privileged: true
  settings:
    builder: examplebuilderimage
    target: examplerepo/exampleimage
    registry: registry.example.domain
    tags:
      - latest
    push: true
    username:
      from_secret: INTERNAL_REGISTRY_USER
    password:
      from_secret: INTERNAL_REGISTRY_TOKEN
```

### Dry run without pushing the image:
```
- name: Test plugin
  image: getais/drone-plugin-s2i
  privileged: true
  settings:
    builder: examplebuilderimage
    target: examplerepo/exampleimage
    tags:
      - latest
```

### Example using hosts docker socket:
```
steps:
- name: Test plugin
  image: getais/drone-plugin-s2i
  privileged: true
  settings:
    builder: examplebuilderimage
    target: examplerepo/exampleimage
    tags:
      - latest
  volumes:
    - name: docker-socket
      path: /var/run/docker.sock

volumes:
- name: docker-socket
  host:
    path: /var/run/docker.sock
```

# Parameter reference

##### builder (required)
the Docker image to be used in building the final image

##### target (required)
the name of the final Docker image

##### context [default: ./] (optional)
context directory to use in build

##### tags (optional)
tag list built image will be tagged

##### registry (optional)
Docker registry

##### username (optional)
Docker registry username

##### password (optional)
Docker registry password
