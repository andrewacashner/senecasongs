<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.tei-c.org/ns/1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xi="http://www.w3.org/2001/XInclude" 
  xmlns:aac="aac.xsd" 
  exclude-result-prefixes="xi aac">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <!-- TODO normalize space -->

  <!-- TODO placeholder for fetching bib label -->
  <xsl:template name="parencite">
    <xsl:variable name="bibKey" select="@key" />
    <link target="#{$bibKey}">
      <hi rend="bold">
        <xsl:value-of select="$bibKey" />
      </hi>
      <xsl:if test="string(.)">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:apply-templates />
    </link>
  </xsl:template>

  <xsl:template match="aac:cite">
    <xsl:variable name="bibKey" select="@key" />
    <xsl:text> (</xsl:text>
    <xsl:call-template name="parencite" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="aac:citeList">
    <xsl:text> (</xsl:text>
    <xsl:for-each select="aac:cite">
      <xsl:call-template name="parencite" />
      <xsl:if test="not(position() = last())">
        <xsl:text>; </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="aac:LaTeX">
    <xsl:text>LaTeX</xsl:text>
  </xsl:template>

  <xsl:template match="aac:usd">
    <xsl:text>$</xsl:text>
    <xsl:apply-templates />
  </xsl:template>
</xsl:stylesheet>
