## Quick reference

Maintained by: [Boris Lehečka](https://github.com/daliboris/docker-morganaxproc-iiise)

## What is MorganaXProc-IIIse?

[MorganaXProx-IIIse](https://www.xml-project.com/morganaxproc-iiise.html) is [XProc 3.x](https://xproc.org) engine developed by Achim Berndzen ([`<xml-project />`](https://www.xml-project.com)).

## How to use this image

This will create and run Docker container with interactive bash.

**Notes:** 

- replace `C:\path\to-folder\with-xpl\files` with existing path on your computer where XProc 3.0 pipelines are stored.
- replace `[[tag]]`` with appropriate value, for example `1.6.15-saxonhe-12.8-jre-21`

```script
docker run -it --rm --volume C:\path\to-folder\with-xpl\files:/data daliboris/morganaxproc-iiise:[[tag]]
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
