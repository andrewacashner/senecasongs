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
    <xsl:apply-templates select="bltx:entries"/>
  </xsl:template>

  <xsl:template match="comment()" />

  <xsl:template match="text()">
    <!-- TODO note, this does not handle nested brace expressions -->
    <xsl:variable name="quoted">
      <xsl:call-template name="expand-mkbibquote">
        <xsl:with-param name="string" select="." />
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$quoted" />
    <!--
    <xsl:variable name="emphasized">
      <xsl:call-template name="expand-mkbibemph">
        <xsl:with-param name="string" select="$quoted" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="parenthesized">
      <xsl:call-template name="expand-mkbibparens">
        <xsl:with-param name="string" select="$emphasized" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="debraced">
      <xsl:call-template name="remove-tex-braces">
        <xsl:with-param name="string" select="$parenthesized" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="debackslashed">
      <xsl:call-template name="remove-tex-backslashes">
        <xsl:with-param name="string" select="$debraced" />
      </xsl:call-template>
    </xsl:variable>
      <xsl:value-of select="$debackslashed" />
    -->
  </xsl:template>
  
  <xsl:variable name="within-braces">\{([^\}]*)\}</xsl:variable>

  <xsl:template name="expand-mkbibquote">
    <xsl:param name="string" />
    <xsl:analyze-string select="$string" regex="\\mkbibquote{$within-braces}"> 
      <xsl:matching-substring>
        <xsl:element name="q"> <!-- TODO doesn't come through -->
          <xsl:value-of select="concat('[RACCOON]', regex-group(1))" />
          </xsl:element>
      </xsl:matching-substring>
      <xsl:non-matching-substring> <!-- TODO also copies matched strings? -->
        <xsl:value-of select="concat('[SQUIRREL]', $string)" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="expand-mkbibemph">
    <xsl:param name="string" />
    <xsl:analyze-string select="$string" regex="\\mkbibemph{$within-braces}">
      <xsl:matching-substring>
        <emph><xsl:value-of select="regex-group(1)" /></emph>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="$string" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="expand-mkbibparens">
    <xsl:param name="string" />
    <xsl:analyze-string select="$string" regex="\\mkbibparens{$within-braces}">
      <xsl:matching-substring>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="regex-group(1)" />
        <xsl:text>)</xsl:text>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="$string" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="remove-tex-braces">
    <xsl:param name="string" />
    <xsl:analyze-string select="$string" regex="{$within-braces}">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)" />
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="$string" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="remove-tex-backslashes">
    <xsl:param name="string" />
    <xsl:value-of select="replace($string, '\\', '')" />
  </xsl:template>

  <xsl:template match="bltx:entries">
    <listBibl>
      <xsl:apply-templates />
    </listBibl>
  </xsl:template>

  <!-- TODO match type=collection-->
  <xsl:template match="bltx:entry[@entrytype='book']">
    <biblStruct id="{@id}" type="book">
      <monogr>
        <xsl:apply-templates select="bltx:names" />
        <title level="m"><xsl:apply-templates select="bltx:title" /></title>
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
      </analytic>
      <monogr>
        <title level="j"><xsl:apply-templates select="bltx:journaltitle" /></title>
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
      <forename>
        <xsl:call-template name="names">
          <xsl:with-param name="namepart" select="bltx:namepart[@type='given']" />
        </xsl:call-template>
      </forename>
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
        <xsl:apply-templates select="$namepart" />
      </xsl:otherwise>
    </xsl:choose>
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
    <xsl:value-of select="bltx:item" separator="$separator" />
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

  <!-- TODO replace TeX dash macros -->

</xsl:stylesheet>


