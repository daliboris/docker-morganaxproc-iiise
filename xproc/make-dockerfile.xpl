<p:declare-step 
	xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xdc="https://www.daliboris.cz/ns/xproc/docker"
	xmlns:xdl="https://www.daliboris.cz/ns/xproc/docker/layout/1.0"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	version="3.0" name="make">
	
	<p:import href="dockerfiles-gen.xpl" />
	
	<p:documentation>
		<xhtml:section>
			<xhtml:h2></xhtml:h2>
			<xhtml:p></xhtml:p>
		</xhtml:section>
	</p:documentation>
   
	<!--
   >>>>>>>>>>>>>>>>>
   >> INPUT PORTS >>
   >>>>>>>>>>>>>>>>>
  -->
  <p:input port="source" primary="true">
  	<p:document href="settings.xml" />
  </p:input>
	
	<p:input port="dockerfile" primary="false" content-types="text/plain">
		<p:document href="../templates/Dockerfile" content-type="text/plain"  />
	</p:input>
	
	<p:input port="readmefile" primary="false" content-types="text/plain">
		<p:document href="../templates/README.md" content-type="text/plain"  />
	</p:input>
   
	<!--
   <<<<<<<<<<<<<<<<<<
   << OUTPUT PORTS <<
   <<<<<<<<<<<<<<<<<<
  -->
	<p:output port="result" primary="true" />
	
	<!--
   +++++++++++++
   ++ OPTIONS ++
   +++++++++++++
  -->
	<p:option name="debug-path" as="xs:string?" select="'.'" />
	<p:option name="base-uri" as="xs:anyURI" select="static-base-uri()" />
	<p:option name="output-directory" as="xs:anyURI" select="xs:anyURI('../')" />
	<p:option name="application-version" as="xs:string*" />
	<p:option name="latest-only" as="xs:boolean" select="true()" />
	
	<!--
   ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
   ÷÷ VARIABLES ÷÷
   ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
  -->
	<p:variable name="debug" select="$debug-path || '' ne ''" />
	<p:variable name="debug-path-uri" select="resolve-uri($debug-path, $base-uri)" />
	
	<!--
   *******************
   ** PIPELINE BODY **
   *******************
  -->
	
	<xdc:generate-dockerfiles
		latest-only="{$latest-only}"
		output-directory="{$output-directory}"
		debug-path="{$debug-path}" base-uri="{$base-uri}">
		<p:with-option name="application-version" select="$application-version" />
		<p:with-input port="dockerfile" pipe="dockerfile@make" />
		<p:with-input port="readmefile" pipe="readmefile@make" />
	</xdc:generate-dockerfiles>
	

</p:declare-step>
