<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml"
  exclude-result-prefixes="bltx">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:template match="/">
    <xsl:apply-templates select="bltx:entries" />
  </xsl:template>

  <xsl:import href="bltxml-tei_macros.xsl" />

  <xsl:template match="comment()" />

  <xsl:template match="bltx:entries">
    <listBibl>
      <xsl:apply-templates />
    </listBibl>
  </xsl:template>

  <xsl:template match="bltx:entry[@entrytype='book' or @entrytype='collection']">
    <biblStruct id="{@id}" type="book">
      <monogr>
        <xsl:apply-templates select="bltx:names" />
        <title level="m"><xsl:apply-templates select="bltx:title" /></title>
        <xsl:apply-templates select="bltx:url" />
        <imprint>
          <xsl:apply-templates select="bltx:location" />
          <xsl:apply-templates select="bltx:publisher" />
          <xsl:apply-templates select="bltx:date" />
        </imprint>
      </monogr>
    </biblStruct>
  </xsl:template>

  <xsl:template match="bltx:entry[@entrytype='article']">
    <biblStruct id="{@id}" type="article">
      <analytic>
        <xsl:apply-templates select="bltx:names" />
        <title><xsl:apply-templates select="bltx:title" /></title>
        <xsl:apply-templates select="bltx:url" />
      </analytic>
      <monogr>
        <xsl:apply-templates select="bltx:journaltitle" />
        <imprint>
          <xsl:apply-templates select="bltx:date" />
        </imprint>
        <xsl:apply-templates select="bltx:volume" />
        <xsl:apply-templates select="bltx:number" />
        <xsl:apply-templates select="bltx:pages" />
      </monogr>
    </biblStruct>
  </xsl:template>

  <xsl:template match="bltx:entry[@entrytype='incollection']">
    <biblStruct id="{@id}" type="inCollection">
      <analytic>
        <xsl:apply-templates select="bltx:names[@type='author']" />
        <title level="a"><xsl:apply-templates select="bltx:title" /></title>
        <xsl:apply-templates select="bltx:url" />
      </analytic>
      <monogr>
        <title level="m"><xsl:apply-templates select="bltx:booktitle" /></title>
        <xsl:apply-templates select="bltx:names[@type='editor']" />
        <imprint>
          <xsl:apply-templates select="bltx:location" />
          <xsl:apply-templates select="bltx:publisher" />
          <xsl:apply-templates select="bltx:date" />
        </imprint>
        <xsl:apply-templates select="bltx:pages" />
      </monogr>
    </biblStruct>
  </xsl:template>

  <xsl:template match="bltx:names[@type='author']">
    <author>
      <xsl:apply-templates select="bltx:name" />
    </author>
  </xsl:template>
  
  <xsl:template match="bltx:names[@type='editor']">
    <editor>
      <xsl:apply-templates select="bltx:name" />
    </editor>
  </xsl:template>

  <xsl:template match="bltx:name">
    <persName>
      <xsl:if test="bltx:namepart[@type='given']">
        <forename>
          <xsl:call-template name="names">
            <xsl:with-param name="namepart" select="bltx:namepart[@type='given']" />
          </xsl:call-template>
        </forename>
      </xsl:if>
      <surname>
        <xsl:call-template name="names">
          <xsl:with-param name="namepart" select="bltx:namepart[@type='family']" />
        </xsl:call-template>
      </surname>
    </persName>
  </xsl:template>

  <xsl:template name="names">
    <xsl:param name="namepart" />
    <xsl:choose>
      <xsl:when test="$namepart/bltx:namepart">
        <xsl:value-of select="$namepart/bltx:namepart" separator=" " />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$namepart" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="bltx:title">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="bltx:publisher">
    <publisher>
      <xsl:call-template name="and-list" />
    </publisher>
  </xsl:template>

  <xsl:template match="bltx:location">
    <pubPlace>
      <xsl:call-template name="and-list" />
    </pubPlace>
  </xsl:template>

  <xsl:template name="and-list">
    <xsl:apply-templates select="bltx:list">
      <xsl:with-param name="separator"> and </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="bltx:list">
    <xsl:param name="separator" />
    <xsl:for-each select="bltx:item">
      <xsl:apply-templates select="." />
      <xsl:if test="not(position() = last())">
        <xsl:text> and </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="bltx:item">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="bltx:date">
    <xsl:variable name="date" select="." />
    <date when="{$date}" />
  </xsl:template>

  <xsl:template match="bltx:journaltitle">
    <title level="j">
      <xsl:apply-templates />
    </title>
  </xsl:template>

  <xsl:template match="bltx:volume">
    <biblScope unit="volume"><xsl:apply-templates /></biblScope>
  </xsl:template>

  <xsl:template match="bltx:number">
    <biblScope unit="issue"><xsl:apply-templates /></biblScope>
  </xsl:template>

  <xsl:template match="bltx:pages">
    <xsl:variable name="start" select="bltx:list/bltx:item/bltx:start" />
    <xsl:variable name="end" select="bltx:list/bltx:item/bltx:end" />
    <biblScope unit="page" from="{$start}" to="{$end}" />
  </xsl:template>

  <xsl:template match="bltx:url">
    <ref>
      <xsl:attribute name="target">
        <xsl:value-of select="." />
      </xsl:attribute>
      <xsl:value-of select="." />
    </ref>
  </xsl:template>

</xsl:stylesheet>


