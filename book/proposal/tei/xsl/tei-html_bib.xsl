<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  exclude-result-prefixes="tei">

  <xsl:template match="tei:listBibl">
    <ul class="biblio">
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="tei:biblStruct[@type='book']">
    <li id="{@id}">
      <xsl:choose>
        <xsl:when test="tei:monogr/tei:author">
          <xsl:apply-templates select="tei:monogr/tei:author" />
        </xsl:when>
        <xsl:when test="tei:monogr/tei:editor">
          <xsl:apply-templates select="tei:monogr/tei:editor" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Anonymous</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="tei:monogr/tei:imprint/tei:date/@when" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="tei:monogr/tei:title[@level='m']" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="tei:monogr/tei:imprint" />
      <xsl:text>.</xsl:text>
    </li>
  </xsl:template>

  <xsl:template match="tei:title[@level='m']">
    <cite><xsl:apply-templates /></cite>
  </xsl:template>

  <xsl:template match="tei:monogr/tei:author">
    <xsl:value-of select="tei:persName/tei:surname" />
    <xsl:text>, </xsl:text>
    <xsl:value-of select="tei:persName/tei:forename" />
  <!-- list of names -->
  </xsl:template>

  <xsl:template match="tei:monogr/tei:editor">
  <!-- list of names -->
    <xsl:value-of select="tei:persName/tei:surname" />
    <xsl:text>, </xsl:text>
    <xsl:value-of select="tei:persName/tei:forename" />
    <xsl:text>, ed</xsl:text>
  </xsl:template>

  <xsl:template match="tei:monogr/tei:imprint">
    <xsl:apply-templates select="tei:pubPlace" />
    <xsl:text>: </xsl:text>
    <xsl:apply-templates select="tei:publisher" />
  </xsl:template>

</xsl:stylesheet>

