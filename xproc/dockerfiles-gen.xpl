<p:library  xmlns:p="http://www.w3.org/ns/xproc" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:xdc="https://www.daliboris.cz/ns/xproc/docker"
 xmlns:xdl="https://www.daliboris.cz/ns/xproc/docker/layout/1.0"
 xmlns:xhtml="http://www.w3.org/1999/xhtml"
 version="3.0">
 
 <p:documentation>
  <xhtml:section>
   <xhtml:h1></xhtml:h1>
   <xhtml:p></xhtml:p>
  </xhtml:section>
 </p:documentation>
 
 <!-- 
      ×××××××××××××××××××××××××××
      ×××××  PIPELINE STEP  ×××××
      ×××××××××××××××××××××××××××
 -->
 <p:declare-step type="xdc:generate-dockerfiles" name="generating-dockerfiles">
  <p:documentation>
   <xhtml:section xml:lang="en">
    <xhtml:h2>Generates Dockefiles from templates and settings.</xhtml:h2>
    <xhtml:p></xhtml:p>
   </xhtml:section>
   <xhtml:section xml:lang="cs">
    <xhtml:h2>Generuje soubory Dockefile na základě šablony a nastavení.</xhtml:h2>
    <xhtml:p></xhtml:p>
   </xhtml:section>
  </p:documentation>
  
  <!--
   >>>>>>>>>>>>>>>>>
   >> INPUT PORTS >>
   >>>>>>>>>>>>>>>>>
  -->
  <p:input  port="source" primary="true" content-types="application/xml" />
  <p:input  port="dockerfile" primary="false" content-types="text/plain" />
  <p:input  port="readmefile" primary="false" content-types="text/plain" />
  
  <!--
   <<<<<<<<<<<<<<<<<<
   << OUTPUT PORTS <<
   <<<<<<<<<<<<<<<<<<
  -->
  <p:output port="result" primary="true" sequence="true" />
  <p:output port="result-uri" primary="false" sequence="true" />
  
  <!--
   +++++++++++++
   ++ OPTIONS ++
   +++++++++++++
  -->
  <p:option name="debug-path" as="xs:string?" select="()" />
  <p:option name="base-uri" as="xs:anyURI" select="static-base-uri()" />
  <p:option name="output-directory" as="xs:anyURI" select="xs:anyURI('../')"/>
  <p:option name="application-version" as="xs:string*" select="()" />
  <p:option name="latest-only" as="xs:boolean" select="true()" />
  <!--
   ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
   ÷÷ VARIABLES ÷÷
   ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
  -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="resolve-uri($debug-path, $base-uri)" />
  <p:variable name="output-directory-uri" select="resolve-uri($output-directory, $base-uri)" />
  
  
  <!--
   *******************
   ** PIPELINE BODY **
   *******************
  -->
  
  <p:xslt message="{p:document-property(., 'content-type')}">
   <p:with-input port="stylesheet" href="../xslt/prepare-layout.xsl" />
   <p:with-option name="parameters" select="map {
    'application-version' : $application-version,
    'output-directory' : $output-directory-uri,
    'latest-only' : $latest-only
    }" />
  </p:xslt>
  
  <p:identity name="layout" />
  
  <p:if test="$debug">
   <p:store href="layout.local.xml" message="   ... storing layout.local.xml" />
  </p:if>
  
  <xdc:apply-layout 
   output-directory="{$output-directory-uri}"
   debug-path="{$debug-path}" base-uri="{$base-uri}">
   <p:with-input port="dockerfile" pipe="dockerfile@generating-dockerfiles" />
   <p:with-input port="readmefile" pipe="readmefile@generating-dockerfiles" />
  </xdc:apply-layout>
  
  
  
  
 </p:declare-step>
 
 <!-- 
      ×××××××××××××××××××××××××××
      ×××××  PIPELINE STEP  ×××××
      ×××××××××××××××××××××××××××
 -->
 <p:declare-step type="xdc:apply-layout" name="applying-layout">
  
  <p:documentation>
   <xhtml:section xml:lang="en">
    <xhtml:h2>Generates Dockefiles from prepared layout.</xhtml:h2>
    <xhtml:p></xhtml:p>
   </xhtml:section>
   <xhtml:section xml:lang="cs">
    <xhtml:h2>Generuje soubory Dockefile na přpraveného obsahu repotitáře.</xhtml:h2>
    <xhtml:p></xhtml:p>
   </xhtml:section>
  </p:documentation>
  
  <!--
   >>>>>>>>>>>>>>>>>
   >> INPUT PORTS >>
   >>>>>>>>>>>>>>>>>
  -->
  <p:input  port="source" primary="true" content-types="application/xml" />
  
  <p:input  port="dockerfile" primary="false" content-types="text/plain" />
  
  <p:input  port="readmefile" primary="false" content-types="text/plain" />
  
  <!--
   <<<<<<<<<<<<<<<<<<
   << OUTPUT PORTS <<
   <<<<<<<<<<<<<<<<<<
  -->
  <p:output port="result" primary="true" sequence="true" />
  <p:output port="result-uri" primary="false" sequence="true" />
  
  <!--
   +++++++++++++
   ++ OPTIONS ++
   +++++++++++++
  -->
  <p:option name="debug-path" as="xs:string?" select="()" />
  <p:option name="base-uri" as="xs:anyURI" select="static-base-uri()" />
  <p:option name="output-directory" as="xs:anyURI" select="xs:anyURI('..')"/>
  
  <!--
   ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
   ÷÷ VARIABLES ÷÷
   ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
  -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="resolve-uri($debug-path, $base-uri)" />
  <p:variable name="output-directory-uri" select="resolve-uri($output-directory, $base-uri)" />
  <p:variable name="output-directory-uri" select="if(ends-with($output-directory-uri, '/')) 
    then substring($output-directory-uri, 1, string-length($output-directory-uri) - 1)
    else $output-directory-uri" />
  
  <p:variable name="dockerfile-text" select="/" pipe="dockerfile@applying-layout" />
  
  <!--
   *******************
   ** PIPELINE BODY **
   *******************
  -->
  
  
  
  <p:viewport match="xdl:directory[@path]">
   <p:variable name="tag" select="/xdl:directory/@tag/string()" />
   <p:variable name="path" select="/xdl:directory/@path" />
   <p:variable name="output-path" select="$output-directory-uri || '/' || $path" />
   <p:xslt>
    <p:with-input port="stylesheet" href="../xslt/replace-variables.xsl" />
    <p:with-option name="parameters" select="map {'dockerfile-text' : $dockerfile-text }" />
   </p:xslt>
   <p:store href="{$output-path}/Dockerfile" />
   
   <p:identity>
    <p:with-input port="source" pipe="readmefile@applying-layout" />
   </p:identity>
   <p:text-replace pattern="\[\[tag\]\]" replacement="{$tag}" />
   
   <p:store href="{$output-path}/README.md" serialization="map { 'method' : 'text' }" />
    
   
   
   <p:file-copy href="../templates/config.xml" target="{$output-path}/config/config.xml" />
   <p:file-copy href="../templates/config-mb.xml" target="{$output-path}/config/config-mb.xml" />
   
  </p:viewport>
  
  
 </p:declare-step>
 
 
</p:library>