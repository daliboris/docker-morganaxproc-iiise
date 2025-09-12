<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xds="https://www.daliboris.cz/ns/xproc/docker/settings/1.0"
  xmlns:xdl="https://www.daliboris.cz/ns/xproc/docker/layout/1.0"
  exclude-result-prefixes="xs math xd xds"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Sep 10, 2025</xd:p>
      <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:param name="application-version" as="xs:string*" />
  <xsl:param name="latest-only" as="xs:boolean" select="true()" />
  <xsl:param name="output-directory" as="xs:anyURI?" />
  
  <xsl:mode on-no-match="shallow-skip" />
  <xsl:output method="xml" indent="yes" />
  
  <xsl:key name="images" match="xds:image" use="xds:version/@java" />
  
  <xsl:template match="/">
    <xsl:variable name="versions" select="if(exists($application-version)) then $application-version else .//xds:runtime[@type='morgana']/xds:version/@tag"/>
    <xsl:variable name="versions" select="if($latest-only) then $versions[1] else $versions"/>
    <xsl:variable name="saxons" select=".//xds:addition[@type='xslt'][@name='saxonhe']/xds:version/@tag"/>
    <xsl:variable name="saxons" select="if($latest-only) then $saxons[1] else $saxons"/>
    
    <xsl:variable name="javas" select=".//xds:image[@name='JAVA_BASE_IMAGE_TAG']/xds:version/@java"/>
    <xsl:variable name="created" select="format-dateTime(current-dateTime(),'[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][Z]')"/>
    <xdl:layout xmlns:xdl="https://www.daliboris.cz/ns/xproc/docker/layout/1.0"
      root="{$output-directory}"
      created="{$created}">
      <xsl:for-each select="$versions">
        <xsl:variable name="version" select="."/>
        <xdl:directory name="{$version}">
          <xsl:for-each select="$javas">
            <xsl:variable name="java" select="."/>
            <xsl:variable name="images" select="key('images', $java)"/>
            <xdl:directory name="jre-{$java}">
              <xsl:for-each select="$saxons">
                <xsl:variable name="saxon" select="."/>
                <xsl:variable name="path" select="concat($version, '/', 'saxonhe', '-', $saxon, '/', 'jre-', $java)"/>
                <xsl:variable name="tag" select="string-join(($version, 'saxonhe', $saxon, 'jre', $java), '-')"/>
                <xdl:directory name="saxonhe-{$saxon}" tag="{$tag}" path="{$path}">
                  <xdl:set arg="JAVA_VERSION" value="{$java}" />
                  <xdl:set arg="MORGANA_VERSION" value="{$version}" />
                  <xdl:set arg="SAXON_VERSION" value="{$saxon}" />
                  <xsl:for-each select="$images">
                    <xsl:variable name="image" select="."/>
                    <xsl:variable name="image-version" select="$image/xds:version[@java = $java]"/>
                    <xdl:set arg="{$image/@name}" value="{$image-version/@tag}" />
                  </xsl:for-each>
                  <xdl:set label="org.opencontainers.image.created" value="{$created}" />
                  <xdl:content />
                  <xdl:build>cd <xsl:value-of select="replace($output-directory || $path, '^file:/+', '') => replace('/', '\\')"/></xdl:build>
                  <xdl:build>docker build --file Dockerfile --tag daliboris/morganaxproc-iiise:<xsl:value-of select="$tag"/> .</xdl:build>
                </xdl:directory>
              </xsl:for-each>
            </xdl:directory>
          </xsl:for-each>
        </xdl:directory>
      </xsl:for-each>
    </xdl:layout>
  </xsl:template>
  
  
</xsl:stylesheet>