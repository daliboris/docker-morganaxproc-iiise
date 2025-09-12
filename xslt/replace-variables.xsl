<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xsf="https://www.daliboris.cz/ns/xslt/functions"
  xmlns:xdl="https://www.daliboris.cz/ns/xproc/docker/layout/1.0"
  exclude-result-prefixes="xs math xd xdl"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Sep 10, 2025</xd:p>
      <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:param name="dockerfile-text" as="xs:string" /> <!-- select="unparsed-text('../templates/Dockerfile')" -->
  <xsl:mode on-no-match="shallow-skip"/>
  <xsl:output method="text" />
  
  <xsl:template match="xdl:directory[xdl:set]">
    <xsl:variable name="replacements" select="xdl:set"/>
    <xsl:value-of select="xsf:replace($dockerfile-text, $replacements)"/>
  </xsl:template>
  
  <xsl:function name="xsf:replace">
    <xsl:param name="where" as="xs:string" />
    <xsl:param name="replacements" as="element()*" />
    <xsl:variable name="replacement" select="head($replacements)"/>
    <xsl:choose>
      <xsl:when test="empty($replacement)">
        <xsl:value-of select="$where"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="regex" select="concat(
          '^(',
          if($replacement[@arg]) then '^ARG ' else '^LABEL ',
          $replacement/@arg,
          $replacement/@label,
           '=).*')" />
        <xsl:choose>
          <xsl:when test="matches($where, $regex, 'm')">
            <xsl:value-of select="replace($where, $regex, '$1' || $replacement/@value, 'm') => xsf:replace(tail($replacements))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="xsf:replace($where, tail($replacements))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
</xsl:stylesheet>