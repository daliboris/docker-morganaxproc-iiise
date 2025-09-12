# docker-morganaxproc-iiise

Repository for Dockerfiles for [MorganaXProx-IIIse](https://www.xml-project.com/morganaxproc-iiise.html) developed by Achim Berndzen ([`<xml-project />`](https://www.xml-project.com)).

Docker images are available in Docker Hub in [daliboris/morganaxproc-iiise](https://hub.docker.com/r/daliboris/morganaxproc-iiise) repository.

This repository is maintained by Boris Lehečka, Your interaction via GitHub issues or pull requests is welcome. 

Dockerfiles are prepared for different versions of [Java](https://github.com/zulu-openjdk/zulu-openjdk), [MorganaXProc-IIIse](https://sourceforge.net/projects/morganaxproc-iiise/files/) and [Saxon-HE](https://github.com/Saxonica/Saxon-HE.git). Eeach Dockerfile is stored in separate folder and its tag is composed from following parts connected with hyphen, for example `1.6.15-saxonhe-12.8-jre-11`:
- version of MorganaXProc-IIIse (for example `1.6.5`)
- version of Saxon-HE (for example `saxonhe-12.8`)
- version of Java runtime (for example `jre-11`)

Each directory contains README with instructions how to build images, run container and run XProc pipelines. 

[Example](../1.6.15/saxonhe-12.8/jre-21/README.md) of such a document follows:

## To build image

- change working directory to the current directory
- run one of the following, fully equivalent scripts   

```script
docker build --file Dockerfile --tag daliboris/morganaxproc-iiise:1.6.15-saxonhe-12.8-jre-21 .
``` 

```script
docker build --tag daliboris/morganaxproc-iiise:1.6.15-saxonhe-12.8-jre-21 .
``` 


## To run image

This will create and run Docker container with interactive bash.

**Note:** Replace `C:\path\to-folder\with-xpl\files` with existing path on your computer where XProc 3.0 pipelines are stored.

```script
docker run -it --rm --volume C:\path\to-folder\with-xpl\files:/data daliboris/morganaxproc-iiise:1.6.15-saxonhe-12.8-jre-21
```

Continue using MorganaXProc-IIIse via interactive [command line interface (CLI)](https://www.xml-project.com/manual/index.html), for example:

```script
Morgana.sh -config=/config/config.xml ./path-to/pipeline.xpl
```

- `Morgana.sh` is main entry point of the MorganaXProc-IIIse engine
- config files are stored in the `/config/` folder of the container's file system
  - `config.xml` allows use of [`NineML`](https://docs.nineml.org/current/) implementation of [Invisible XML, ixml](https://invisiblexml.org)
  - `config-mb.xml` allows use of [`Markup Blitz`](https://github.com/GuntherRademacher/markup-blitz) implementation of [ixml](https://invisiblexml.org)
- `./path-to/pipeline.xpl` points to pipeline file stored on your computer

See all [command line options](https://www.xml-project.com/manual/index.html) of MorganaXProc-IIIse.