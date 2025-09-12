<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:cx="http://xmlcalabash.com/ns/extensions"
 xmlns:pos="http://exproc.org/proposed/steps/os"
 version="3.0">

 <p:output port="result" serialization="map{'indent' : true()}"/>

 <p:identity>
  <p:with-input>
   <p:inline>
    <diagnostics xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:p="http://www.w3.org/ns/xproc">
     <system-properties>
      <item name="p:episode"/>
      <item name="p:locale"/>
      <item name="p:product-name"/>
      <item name="p:product-version"/>
      <item name="p:vendor"/>
      <item name="p:vendor-uri"/>
      <item name="p:version"/>
      <item name="p:xpath-version"/>
      <item name="p:psvi-supported"/>
     </system-properties>
     <steps>
      <item name="p:directory-list" />
      <item name="p:file-copy" />
      <item name="p:file-delete" />
      <item name="p:file-info" />
      <item name="p:file-mkdir" />
      <item name="p:file-move" />
      <item name="p:file-create-tempfile" />
      <item name="p:file-touch" />
      <item name="p:ixml" />
      <item name="p:os-info" />
      <item name="p:os-exec" />
      <item name="p:send-mail" />
      <item name="p:css-formatter" />
      <item name="p:xsl-formatter" />
      <item name="p:run" />
      <item name="p:markdown-to-html" />
      <item name="p:validate-with-dtd" />
      <item name="p:validate-with-json-schema" />
      <item name="p:validate-with-nvdl" />
      <item name="p:validate-with-relax-ng" />
      <item name="p:validate-with-schematron" />
      <item name="p:validate-with-xml-schema" />
      <item name="p:add-attribute" />
      <item name="p:add-xml-base" />
      <item name="p:archive" />
      <item name="p:archive-manifest" />
      <item name="p:cast-content-type" />
      <item name="p:compare" />
      <item name="p:compress" />
      <item name="p:count" />
      <item name="p:delete" />
      <item name="p:error" />
      <item name="p:filter" />
      <item name="p:hash" />
      <item name="p:http-request" />
      <item name="p:identity" />
      <item name="p:insert" />
      <item name="p:json-join" />
      <item name="p:json-merge" />
      <item name="p:label-elements" />
      <item name="p:load" />
      <item name="p:make-absolute-uris" />
      <item name="p:namespace-delete" />
      <item name="p:namespace-rename" />
      <item name="p:pack" />
      <item name="p:parameters" />
      <item name="p:rename" />
      <item name="p:replace" />
      <item name="p:set-attributes" />
      <item name="p:set-properties" />
      <item name="p:sink" />
      <item name="p:sleep" />
      <item name="p:split-sequence" />
      <item name="p:store" />
      <item name="p:string-replace" />
      <item name="p:text-count" />
      <item name="p:text-head" />
      <item name="p:text-join" />
      <item name="p:text-replace" />
      <item name="p:text-sort" />
      <item name="p:text-tail" />
      <item name="p:unarchive" />
      <item name="p:uncompress" />
      <item name="p:unwrap" />
      <item name="p:uuid" />
      <item name="p:wrap" />
      <item name="p:wrap-sequence" />
      <item name="p:www-form-urldecode" />
      <item name="p:www-form-urlencode" />
      <item name="p:xinclude" />
      <item name="p:xquery" />
      <item name="p:xslt" />
      <!-- 3.1 -->
      <item name="p:message" />
      <item name="p:sleep" />
      <item name="p:encode" />
     </steps>
    </diagnostics>
   </p:inline>
  </p:with-input>
 </p:identity>

 <p:viewport match="/diagnostics/system-properties/item">
  <!-- EN: current port contains matched element as a root element -->
  <!-- CS: aktuální port obsahuje nalezený prvek jako kořenový prvek -->
  <p:variable name="property" select="/item/@name"/>
  <p:add-attribute attribute-name="value" attribute-value="{p:system-property($property)}"/>
 </p:viewport>

 <p:viewport match="/diagnostics/steps/item">
  <!-- EN: current port contains matched element as a root element -->
  <!-- CS: aktuální port obsahuje nalezený prvek jako kořenový prvek -->
  <p:variable name="property" select="/item/@name"/>
  <p:add-attribute attribute-name="available" attribute-value="{p:step-available($property)}"/>
 </p:viewport>
 
 <p:namespace-delete prefixes="p" />
 
 <!-- EN: uncomment following step for storing result to the current directory  -->
 <!-- CS: pro uložení výsledků do současné složky stačí odkomentovat následující krok  -->
  <!-- <p:store href="diagnostics.xml" /> -->
 
</p:declare-step>
