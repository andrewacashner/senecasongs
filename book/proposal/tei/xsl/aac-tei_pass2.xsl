<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.tei-c.org/ns/1.0" 
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:aac="aac.xsd"
  exclude-result-prefixes="aac xi tei">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()" priority="1">
    <xsl:value-of select="replace(replace(replace(.,
    '''', '’'),
    '---', '—'),
    '--', '–')" />
  </xsl:template>

  <xsl:template match="comment()" priority="1" />

  <!-- TODO placeholder for fetching bib label -->
  <xsl:template name="parencite">
    <xsl:variable name="bibKey" select="@key" />
    <xsl:variable name="pages" select="@pages" />
    <xsl:variable name="ref" select="//tei:biblStruct[@id=$bibKey]" />
    <xsl:variable name="author" select="$ref//tei:author/tei:persName/tei:surname" />
    <xsl:variable name="date" select="$ref//tei:imprint/tei:date/@when" />

    <bibl>
      <link target="#{$bibKey}">
        <xsl:choose>
          <xsl:when test="$ref">
            <xsl:value-of select="$author" />
            <!-- TODO multiple authors, editors -->
            <xsl:text> </xsl:text>
            <xsl:value-of select="$date" />
            <!-- TODO pages -->
          </xsl:when>
          <xsl:otherwise>
            <hi><xsl:value-of select="$bibKey" /></hi>
          </xsl:otherwise>
        </xsl:choose>
      </link>
    </bibl>
  </xsl:template>

  <xsl:template match="aac:cite">
    <xsl:text> (</xsl:text>
    <xsl:call-template name="parencite" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="aac:citeList">
    <xsl:variable name="bibKey" select="@key" />
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
