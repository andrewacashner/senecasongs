<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  exclude-result-prefixes="tei">

  <xsl:template match="listBibl">
    <ul class="biblio">
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="biblStruct[@type='book']">
    <li id="{@id}">
      <xsl:choose>
        <xsl:when test="monogr/author">
          <xsl:apply-templates select="monogr/author" />
        </xsl:when>
        <xsl:when test="monogr/editor">
          <xsl:apply-templates select="monogr/editor" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Anonymous</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="title[@level='m']" />
      <xsl:value-of select="monogr/imprint/date[@when]" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="monogr/imprint" />
    </li>
  </xsl:template>

  <xsl:template match="title[@level='m']">
    <cite><xsl:apply-templates /></cite>
  </xsl:template>

  <xsl:template match="monogr/author">
    <xsl:value-of select="persName/surname" />
    <xsl:text>, </xsl:text>
    <xsl:value-of select="persName/forename" />
    <xsl:text>.</xsl:text>
  <!-- list of names -->
  </xsl:template>

  <xsl:template match="monogr/editor">
  <!-- list of names -->
    <xsl:value-of select="persName/surname" />
    <xsl:text>, </xsl:text>
    <xsl:value-of select="persName/forename" />
    <xsl:text>, ed.</xsl:text>
  </xsl:template>

  <xsl:template match="monogr/imprint">
    <xsl:apply-templates select="pubPlace" />
    <xsl:text>: </xsl:text>
    <xsl:apply-templates select="publisher" />
    <xsl:text>.</xsl:text>
  </xsl:template>

</xsl:stylesheet>

