
<!-- 
Text Encoding Initiative Consortium XSLT stylesheet family
$Date$, $Revision$, $Author$

XSL stylesheet to format TEI XML documents to HTML or XSL FO

 
##LICENSE
--> 
<xsl:stylesheet
  xmlns:tei="http://www.tei-c.org/ns/1.0"

  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

<xsl:template match="tei:figure">
  <xsl:if test="@url|@entity">
    <xsl:call-template name="showGraphic">
      <xsl:with-param name="ID">
	<xsl:if test="@id|@xml:id">
	  <xsl:value-of select="@id|@xml:id"/>
	</xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates/>
 <xsl:if test="tei:head"><p>
   <xsl:if test="$numberFigures='true'" >
     Figure <xsl:number level="any"/>.<xsl:text> </xsl:text>
   </xsl:if>
   <xsl:apply-templates select="tei:head"/>
 </p>
 </xsl:if>
</xsl:template>

<xsl:template match="tei:graphic">
  <xsl:call-template name="showGraphic">
      <xsl:with-param name="ID">
	<xsl:if test="../@id|./@xml:id">
	  <xsl:value-of select="../@id|../@xml:id"/>
	</xsl:if>
      </xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template name="showGraphic">
  <xsl:param name="ID"/>
  <xsl:if test="$ID">
    <a name="{$ID}"/>
  </xsl:if>
 <xsl:variable name="File">
  <xsl:choose> 
  <xsl:when test="@url">
   <xsl:value-of select="@url"/>
   <xsl:if test="not(contains(@url,'.'))">
      <xsl:value-of select="$graphicsSuffix"/>
   </xsl:if>
  </xsl:when>
  <xsl:when test="@entity">
    <xsl:variable name="entity">
      <xsl:value-of select="unparsed-entity-uri(@entity)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="starts-with($entity,'file:')">
        <xsl:value-of select="substring-after($entity,'file:')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$entity"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:message terminate="yes">Cant work out how to do a graphic </xsl:message>
  </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>
 <xsl:variable name="Head">
   <xsl:choose>
     <xsl:when test="tei:figDesc">
       <xsl:value-of select="tei:figDesc//text()"/>
     </xsl:when>
     <xsl:when test="parent::tei:figure/tei:figDesc">
       <xsl:value-of select="parent::tei:figure/tei:figDesc//text()"/>
     </xsl:when>
     <xsl:when test="tei:head">
       <xsl:value-of select="tei:head/text()"/>
     </xsl:when>
     <xsl:when test="parent::tei:figure/tei:head">
       <xsl:value-of select="parent::tei:figure/tei:head/text()"/>
     </xsl:when>
   </xsl:choose>
 </xsl:variable>
 <xsl:choose>
   <xsl:when test="$showFigures='true'">
     <span>
       <xsl:if test="$ID">
	 <xsl:attribute name="name"><xsl:value-of select="$ID"/></xsl:attribute>
       </xsl:if>
       <xsl:if test="string-length(@rend) &gt;0">
	 <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
       </xsl:if>
       <img src="{$graphicsPrefix}{$File}">
	 <xsl:if test="@rend='inline'">
	   <xsl:attribute name="border">0</xsl:attribute>
	 </xsl:if>
	 <xsl:if test="@width&gt;0 and not(contains(@width,'in'))">
	   <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
	 </xsl:if>
	 <xsl:if test="@height&gt;0 and not(contains(@height,'in'))">
	   <xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
	 </xsl:if>
	 <xsl:attribute name="alt">
	   <xsl:value-of select="$Head"/>
	 </xsl:attribute>
	 <xsl:call-template name="imgHook"/>
       </img>
     </span>
   </xsl:when>
   <xsl:otherwise>
     <hr/>
     <p>Figure <xsl:for-each
     select="self::tei:figure|parent::tei:figure">
     <xsl:number level="any"/>
   </xsl:for-each>
     file <xsl:value-of select="$File"/>
     <xsl:choose>
       <xsl:when test="tei:figDesc">
	 [<xsl:apply-templates select="tei:figDesc//text()"/>]
       </xsl:when>
       <xsl:when test="parent::tei:figure/tei:figDesc">
	 [<xsl:apply-templates select="parent::tei:figure/tei:figDesc//text()"/>]
       </xsl:when>
     </xsl:choose>
     </p>
     <hr/>
   </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="imgHook"/>

<xsl:template match="tei:figDesc"/>


</xsl:stylesheet>
