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

  <xsl:template match="comment()" priority="0.8" />

  <xsl:template match="text()" priority="0.9">
    <xsl:call-template name="expand-tex-macros" />
  </xsl:template>

  <!-- TODO note, this does not handle nested brace expressions -->
  <xsl:template name="expand-tex-macros">
    <xsl:call-template name="expand-mkbibquote" />
  </xsl:template>
  
  <xsl:variable name="within-braces">\{([^\{\}]*)\}</xsl:variable>

  <xsl:template name="expand-mkbibquote">
    <xsl:analyze-string select="string()" regex="\\mkbibquote{$within-braces}">
      <xsl:matching-substring>
        <q><xsl:value-of select="regex-group(1)" /></q>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:call-template name="expand-mkbibemph" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="expand-mkbibemph">
    <xsl:analyze-string select="string()" regex="\\mkbibemph{$within-braces}">
      <xsl:matching-substring>
        <emph><xsl:value-of select="regex-group(1)" /></emph>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:call-template name="expand-mkbibparens" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="expand-mkbibparens">
    <xsl:analyze-string select="string()" regex="\\mkbibparens{$within-braces}">
      <xsl:matching-substring>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="regex-group(1)" />
        <xsl:text>)</xsl:text>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:call-template name="remove-tex-braces" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="remove-tex-braces">
    <xsl:analyze-string select="string()" regex="{$within-braces}">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)" />
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:call-template name="remove-tex-backslashes" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="remove-tex-backslashes">
    <xsl:value-of select="replace(., '\\', '')" />
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
        <title level="m"><xsl:value-of select="bltx:title" /></title>
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
        <title><xsl:value-of select="bltx:title" /></title>
      </analytic>
      <monogr>
        <title level="j"><xsl:value-of select="bltx:journaltitle" /></title>
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
        <title level="a"><xsl:value-of select="bltx:title" /></title>
      </analytic>
      <monogr>
        <title level="m"><xsl:value-of select="bltx:booktitle" /></title>
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
        <xsl:value-of select="$namepart" />
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

  <!-- recursive match-braces function
    - start at level 0, find open brace
    - copy from open brace at level 0 to close brace at level 0
    - after finding open brace, increase level if another brace is found and decrease when closing one is found
    - when inner open brace is found, do the match-brace function for the substring starting there
  -->
  <xsl:template name="match-braces">
    <xsl:param name="string" />
    <xsl:choose>
      <xsl:when test="contains($string, '\{{') and contains($string, '\}}')">
        <xsl:variable name="after-open-brace" select="substring-after($string, '\{{')" />
        <xsl:choose>
          <xsl:when test="contains($after-open-brace, '\{{')">
            <xsl:call-template name="inner-match-braces">
              <xsl:with-param name="string" select="$after-open-brace" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-before($after-open-brace, '\}}')" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="match-braces">
    <xsl:call-template name="inner-match-braces">
      <xsl:with-param name="string" select="string()" />
      <xsl:with-param name="braceLevel" select="0" />
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>


