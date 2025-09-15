# tag: daliboris/morganaxproc-iiise:${MORGANA_VERSION}-saxonhe-${SAXON_VERSION}-jre-${JAVA_VERSION}
# tag: daliboris/morganaxproc-iiise:1.6.15-saxonhe-12.8-jre-11

ARG JAVA_BASE_IMAGE_TAG=21.0.8-21.44-jre
ARG DEPENDENCIES_IMAGE_TAG=8.14.3-jdk21-ubi-minimal

ARG JAVA_VERSION=21
ARG MORGANA_VERSION=1.7.1
ARG SAXON_VERSION=12.9

ARG COFFEEGRINDER_VERSION=3.2.9
ARG COFFEEFILTER_VERSION=3.2.9
ARG SCHXSLT_VERSION=1.10.1
ARG SCHXSLT2_VERSION=1.4.4
ARG SCHEMATRON_VERSION=2020-10-01
ARG MARKUPBLITZ_VERSION=1.9

FROM daliboris/markup-blitz:${MARKUPBLITZ_VERSION:-1.9}-jre-${JAVA_VERSION:-11} AS markup-blitz-image

FROM gradle:${DEPENDENCIES_IMAGE_TAG} AS dependencies

ARG JAVA_VERSION
ARG MORGANA_VERSION
ARG SAXON_VERSION
ARG COFFEEGRINDER_VERSION
ARG COFFEEFILTER_VERSION
ARG SCHXSLT_VERSION
ARG SCHXSLT2_VERSION
ARG SCHEMATRON_VERSION
ARG MARKUPBLITZ_VERSION

# creating directory structure
RUN mkdir -p /opt/xproc/xml-project && \
 mkdir -p /opt/nineml/coffeegrinder && \
 mkdir -p /opt/nineml/coffeefilter && \
 mkdir -p /opt/xproc/schxslt && \
 mkdir -p /opt/xproc/schxslt2 && \
 mkdir -p /opt/xproc/schematron/xslt1 && \
 mkdir -p /opt/xproc/schematron/xslt2

# Saxon uses dash instead of dot in the URL (12.8 >> 12-8)
# Saxon uses two different URL directories: 
#    SaxonHE-12-8/SaxonHE12-8J.zip 
#    SaxonHE12-7/SaxonHE12-7J.zip
# ADD doesn't handle SAXON_URL_VERSION
# ADD doesn't handle .../MorganaXProc-IIIse-${MORGANA_VERSION}.zip/download URL
# using identical wget command
RUN SAXON_URL_VERSION=$(echo "${SAXON_VERSION}" | sed 's/\./-/g') && \
    wget -q --spider https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE${SAXON_URL_VERSION}/SaxonHE${SAXON_URL_VERSION}J.zip 2>/dev/null && \
    wget  -O /tmp/SaxonHE${SAXON_VERSION}.zip https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE${SAXON_URL_VERSION}/SaxonHE${SAXON_URL_VERSION}J.zip || \
    wget  -O /tmp/SaxonHE${SAXON_VERSION}.zip https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE-${SAXON_URL_VERSION}/SaxonHE${SAXON_URL_VERSION}J.zip && \
    wget  -O /tmp/MorganaXProc-IIIse-${MORGANA_VERSION}.zip https://sourceforge.net/projects/morganaxproc-iiise/files/MorganaXProc-IIIse-${MORGANA_VERSION}/MorganaXProc-IIIse-${MORGANA_VERSION}.zip/download && \
    wget  -O /tmp/CoffeeGrinder-${COFFEEGRINDER_VERSION}.zip https://github.com/nineml/coffeegrinder/releases/download/${COFFEEGRINDER_VERSION}/coffeegrinder-${COFFEEGRINDER_VERSION}.zip && \
    wget  -O /tmp/CoffeeFilter-${COFFEEFILTER_VERSION}.zip https://github.com/nineml/coffeefilter/releases/download/${COFFEEFILTER_VERSION}/coffeefilter-${COFFEEFILTER_VERSION}.zip && \
    wget  -O /tmp/SchXslt-${SCHXSLT_VERSION}.zip https://codeberg.org/SchXslt/schxslt/releases/download/v${SCHXSLT_VERSION}/schxslt-${SCHXSLT_VERSION}-xslt-only.zip && \
    wget  -O /tmp/Schematron-${SCHEMATRON_VERSION}-xslt1.zip https://github.com/Schematron/schematron/releases/download/${SCHEMATRON_VERSION}/iso-schematron-xslt1.zip && \
    wget  -O /tmp/Schematron-${SCHEMATRON_VERSION}-xslt2.zip https://github.com/Schematron/schematron/releases/download/${SCHEMATRON_VERSION}/iso-schematron-xslt2.zip && \
    wget  -O /tmp/SchXslt2-${SCHXSLT2_VERSION}.zip https://codeberg.org/SchXslt/schxslt2/releases/download/v${SCHXSLT2_VERSION}/schxslt2-${SCHXSLT2_VERSION}.zip


# extracting zip files creates following directories

# /opt/xproc/schxslt-${SCHXSLT_VERSION}/1.0 
# /opt/xproc/schxslt-${SCHXSLT_VERSION}/2.0
# /opt/xproc/schxslt2/schxslt2-v${SCHXSLT2_VERSION}
# /opt/xproc/schematron/xslt1
# /opt/xproc/schematron/xslt2

RUN unzip /tmp/MorganaXProc-IIIse-${MORGANA_VERSION}.zip -d /opt/xproc/xml-project && \
    unzip /tmp/SaxonHE${SAXON_VERSION}.zip -d /tmp/saxon && \
    unzip /tmp/CoffeeGrinder-${COFFEEGRINDER_VERSION}.zip -d /opt/nineml && \
    unzip /tmp/CoffeeFilter-${COFFEEFILTER_VERSION}.zip -d /opt/nineml && \
    unzip /tmp/SchXslt-${SCHXSLT_VERSION}.zip -d /opt/xproc/schxslt  && \
    unzip /tmp/SchXslt2-${SCHXSLT2_VERSION}.zip -d /opt/xproc/schxslt2  && \
    unzip /tmp/Schematron-${SCHEMATRON_VERSION}-xslt1.zip -d /opt/xproc/schematron/xslt1 && \
    unzip /tmp/Schematron-${SCHEMATRON_VERSION}-xslt2.zip -d /opt/xproc/schematron/xslt2


# ADD https://github.com/GuntherRademacher/markup-blitz.git#${MARKUPBLITZ_VERSION} /tmp/markup-blitz/
# RUN cd /tmp/markup-blitz && \
#    ./gradlew clean jar

# Copying SaxonHE, CoffeeGrinder, and CoffeeFilter files to Morgana's MorganaXProc-IIIse_lib directory,
# you need them on classpath. (see https://xml-project.com/manual/ch02.html#configuration_s1_1_s2_7)

RUN cp /tmp/saxon/saxon-he-${SAXON_VERSION}.jar /opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}/MorganaXProc-IIIse_lib/saxon-he-${SAXON_VERSION}.jar && \
    cp /tmp/saxon/saxon-he-xqj-${SAXON_VERSION}.jar /opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}/MorganaXProc-IIIse_lib/saxon-he-xqj-${SAXON_VERSION}.jar && \
    cp /opt/nineml/coffeegrinder-${COFFEEGRINDER_VERSION}/CoffeeGrinder-${COFFEEGRINDER_VERSION}.jar /opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}/MorganaXProc-IIIse_lib/CoffeeGrinder-${COFFEEGRINDER_VERSION}.jar && \
    cp /opt/nineml/coffeefilter-${COFFEEFILTER_VERSION}/CoffeeFilter-${COFFEEFILTER_VERSION}.jar /opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}/MorganaXProc-IIIse_lib/CoffeeFilter-${COFFEEFILTER_VERSION}.jar
#    cp /tmp/markup-blitz/build/libs/markup-blitz.jar /opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}/MorganaXProc-IIIse_lib/markup-blitz.jar

FROM azul/zulu-openjdk:${JAVA_BASE_IMAGE_TAG}

ARG MORGANA_VERSION
ARG SAXON_VERSION
ARG JAVA_VERSION
ARG COFFEEGRINDER_VERSION
ARG COFFEEFILTER_VERSION
ARG SCHXSLT_VERSION
ARG MARKUPBLITZ_VERSION

ENV MORGANA_VERSION=${MORGANA_VERSION}
ENV JAVA_VERSION=${JAVA_VERSION}
ENV SAXON_VERSION=${SAXON_VERSION}
ENV COFFEEGRINDER_VERSION=${COFFEEGRINDER_VERSION}
ENV COFFEEFILTER_VERSION=${COFFEEFILTER_VERSION}
ENV SCHXSLT_VERSION=${SCHXSLT_VERSION}
ENV MARKUPBLITZ_VERSION=${MARKUPBLITZ_VERSION}

# https://specs.opencontainers.org/image-spec/annotations/#pre-defined-annotation-keys
# Specifies the author(s) of the image, including names and/or email addresses, 
# ie. individuals or organization responsible for creating and maintaining the Dockerfile and the container image.
LABEL org.opencontainers.image.authors="Boris Lehečka <boris@daliboris.cz>"
# Indicates the organization, company, or entity distributing the image.
LABEL org.opencontainers.image.vendor="Boris Lehečka"
# Points to the source code repository from which the image was built, ie. source code of the application that is included in the image.
LABEL org.opencontainers.image.source="https://sourceforge.net/projects/morganaxproc-iiise/files/MorganaXProc-IIIse-$MORGANA_VERSION"
# Links to the general project webpage or related information about the image.
LABEL org.opencontainers.image.url="https://github.com/daliboris/docker-morganaxproc-iiise/README.md"
# Links to the documentation for using, configuring, or deploying the image.
LABEL org.opencontainers.image.documentation="https://github.com/daliboris/docker-morganaxproc-iiise/$MORGANA_VERSION/jre-$JAVA_VERSION/$MORGANA_VERSION-saxonhe-$SAXON_VERSION-jre-$JAVA_VERSION/README.md"
# Specifies the version of the image (e.g., 1.0.0, v2.3.4).
LABEL org.opencontainers.image.version="1.0.0"
# Provides the name of the image reference, such as a tag or digest, for example 7.0.11-debian-11-r20.
LABEL org.opencontainers.image.ref.name="${MORGANA_VERSION}-saxonhe-${SAXON_VERSION}-jre-${JAVA_VERSION}"
# Specifies the creation time of the image in ISO 8601 format.
LABEL org.opencontainers.image.created=2025-09-15T22:24:56+02:00
# https://spdx.org/licenses/
# Indicates the license(s) under which the image, ie. the software and applications included in the image, is distributed (e.g., MIT).
LABEL org.opencontainers.image.licenses="GPL-3.0-only, Apache-2.0, BSD-3-Clause-Clear, MPL-2.0, MIT"
# A human-readable title or name for the image.
LABEL org.opencontainers.image.title="XProc 3.x MorganaXProc-IIIse $MORGANA_VERSION with SaxonHE $SAXON_VERSION, invisible XML by NineML"
# A detailed description of the image, explaining its purpose and functionality.
LABEL org.opencontainers.image.description="Docker image for XProc 3.x pipelines with MorganaXProc-IIIse $MORGANA_VERSION engine, SaxonHE $SAXON_VERSION, CoffeeGrinder $COFFEEGRINDER_VERSION, CoffeeFilter $COFFEEFILTER_VERSION"

# creating directory structure
RUN mkdir /data && \
    mkdir /config

# Set working directory
VOLUME /data

# the destination must be a directory (must end with a slash /)
# copy prepared files
COPY --from=dependencies /opt/xproc /opt/xproc/


COPY --from=markup-blitz-image /opt/ixml/markup-blitz.jar /opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}/MorganaXProc-IIIse_lib/markup-blitz.jar


# copy local config files
COPY config/config*.xml /config/


# add all needed directories to CLASSPATH
ENV CLASSPATH=/opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}:/opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}/MorganaXProc-IIIse_lib

# add Morgana's directories to PATH
ENV PATH="/opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}:/opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}/MorganaXProc-IIIse_lib:$PATH"

# Set runnable
RUN chmod +x /opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}/Morgana.sh && \
    echo 'export PATH="/opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}:$PATH"' >> ~/.bashrc && \
    cp /config/config.xml /opt/xproc/xml-project/MorganaXProc-IIIse-${MORGANA_VERSION}/

# set working directory
WORKDIR /data

# Use bash for Morgana.sh file
# ENTRYPOINT ["bash", "-c", "Morgana.sh", "-config=/config/config.xml"]

# ENTRYPOINT ["bash", "-c"]
ENTRYPOINT ["bash"]
# CMD ["Morgana.sh", "-config=/config/config.xml", "Diagnostics.xpl"]
