<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:xfs="https://www.daliboris.cz/ns/xslt/functions/strings/1.0"
  exclude-result-prefixes="xs xd map xfs"
  version="3.0">
  
  <xsl:param name="replacements" as="map(xs:string, xs:string)" />
  
  <xsl:function name="xfs:replace-items">
    <xsl:param name="text" as="xs:string"/>
    <xsl:param name="replacements" as="map(xs:string, xs:string)"/>
    <xsl:value-of select="xfs:replace-items($text, $replacements, '')"/>
  </xsl:function>
  
  <xsl:function name="xfs:replace-items">
    <xsl:param name="text" as="xs:string"/>
    <xsl:param name="replacements" as="map(xs:string, xs:string)"/>
    <xsl:param name="flags" as="xs:string" />
    <xsl:value-of select="fold-left(
      map:keys($replacements), $text, function($text, $pattern) {
      if(matches($text, $pattern, $flags)) then
      replace($text, $pattern, $replacements($pattern), $flags)
      else $text
      }
      )"/>
  </xsl:function>
  
</xsl:stylesheet>