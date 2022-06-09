<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.tei-c.org/ns/1.0" 
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:aac="aac.xsd"
  exclude-result-prefixes="tei xi">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="aac:bibliography">
    <xsl:variable name="bibtex-source" select="@bibtex" />
    <xsl:variable name="file-basename" select="/tei:TEI/@xml:base" />
    <xsl:choose>
      <xsl:when test="$file-basename">
        <xsl:variable name="bib-basename" select="substring($file-basename, 1, string-length($file-basename) - 4)" />
        <xsl:variable name="tei-bib" select="concat($bib-basename, '-bib.tei')" />

        <div1 id="references">
          <head>References</head>
          <xi:include href="{$tei-bib}" />
        </div1>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Bibliography not found: You must include an @xml:base value on the outermost element in order to use the aac:bibliography element.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
