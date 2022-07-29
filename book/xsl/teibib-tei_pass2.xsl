<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.tei-c.org/ns/1.0" 
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xi="http://www.w3.org/2001/XInclude"
  exclude-result-prefixes="xi tei">

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

  <xsl:template name="parencite">
    <xsl:variable name="bibKey" select="substring(@corresp, 2)" />
    <xsl:variable name="pages" select="string()" />
    <xsl:variable name="ref" select="//tei:biblStruct[@id=$bibKey]" />

    <xsl:variable name="author-list">
      <xsl:call-template name="author-cite">
        <xsl:with-param name="ref" select="$ref" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="date" select="$ref//tei:imprint/tei:date/@when" />

    <bibl>
      <ref target="#{$bibKey}">
        <xsl:choose>
          <xsl:when test="$ref">
            <xsl:value-of select="$author-list" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$date" />
            <xsl:if test="$pages">
              <xsl:text>, </xsl:text>
              <xsl:value-of select="$pages" />
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <hi><xsl:value-of select="$bibKey" /></hi>
          </xsl:otherwise>
        </xsl:choose>
      </ref>
    </bibl>
  </xsl:template>

  <xsl:template name="author-cite">
    <xsl:param name="ref" />
    <xsl:choose>
      <xsl:when test="$ref[@type='inCollection' or @type='article']">
        <xsl:call-template name="author-or-editor">
          <xsl:with-param name="work" select="$ref/tei:analytic" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="author-or-editor">
          <xsl:with-param name="work" select="$ref/tei:monogr" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="author-or-editor">
    <xsl:param name="work" />
    <xsl:choose>
      <xsl:when test="$work/tei:editor and not($work/tei:author)">
        <xsl:call-template name="name-list">
          <xsl:with-param name="names" select="$work/tei:editor/tei:persName" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="name-list">
          <xsl:with-param name="names" select="$work/tei:author/tei:persName" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="name-list">
    <xsl:param name="names" />
    <xsl:value-of select="$names/tei:surname" separator=" and " />
  </xsl:template>


  <xsl:template match="tei:bibl[@type='auto']">
    <xsl:text> (</xsl:text>
    <xsl:call-template name="parencite" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="tei:listBibl[@type='auto' and @subtype='intext']">
    <xsl:text> (</xsl:text>
    <xsl:for-each select="tei:bibl">
      <xsl:call-template name="parencite" />
      <xsl:if test="not(position() = last())">
        <xsl:text>; </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:template>

</xsl:stylesheet>
