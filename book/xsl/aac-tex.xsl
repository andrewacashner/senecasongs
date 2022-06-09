<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:aac="aac.xsd"
  exclude-result-prefixes="tei aac">

  <xsl:output method="text" encoding="utf-8" indent="no" />
  <xsl:strip-space elements="*" />

  <xsl:variable name="par">
    <xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:variable name="title" select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title" />
    <xsl:variable name="titlePage" select="//tei:text/tei:front/tei:titlePage" />
    <xsl:variable name="body" select="//tei:text/tei:body" />
    <xsl:variable name="fileDesc" select="//tei:teiHeader/tei:fileDesc" />

    <xsl:text>\documentclass{tex/aac}&#xA;</xsl:text>
    <xsl:call-template name="bibresource">
      <xsl:with-param name="bibfile" select="//aac:bibliography/@bibtex" />
    </xsl:call-template>
    <xsl:call-template name="maketitle">
      <xsl:with-param name="titlePage" select="$titlePage" />
      <xsl:with-param name="fileDesc" select="$fileDesc" />
    </xsl:call-template>
    <xsl:text>\begin{document}&#xA;\maketitle</xsl:text>
    <xsl:value-of select="$par" />
    <xsl:apply-templates select="$body" />
    <xsl:text>\printbibliography&#xA;</xsl:text>
    <xsl:text>\end{document}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="bibresource">
    <xsl:param name="bibfile" />
    <xsl:if test="$bibfile">
      <xsl:text>\addbibresource{</xsl:text>
      <xsl:value-of select="$bibfile" />
      <xsl:text>}&#xA;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="maketitle">
    <xsl:param name="titlePage" />
    <xsl:param name="fileDesc" />

    <xsl:variable name="docTitle" select="$titlePage/tei:docTitle" />
    <xsl:variable name="maintitle" select="$docTitle/tei:titlePart[@type='main' or @type='']" />
    <xsl:variable name="subtitle" select="$docTitle/tei:titlePart[@type='sub']" />
    <xsl:variable name="author" select="$titlePage/tei:docAuthor" />

    <xsl:text>\title{</xsl:text>
    <xsl:choose>
      <xsl:when test="$maintitle and $subtitle">
        <xsl:apply-templates select="$maintitle" />
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="$subtitle" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$docTitle" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}&#xA;</xsl:text>
    <xsl:text>\author{</xsl:text>
    <xsl:apply-templates select="$author" />
    <xsl:text>\thanks{</xsl:text>
    <xsl:call-template name="fileDesc-footer">
      <xsl:with-param name="fileDesc" select="$fileDesc" />
    </xsl:call-template>
    <xsl:text>}}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="fileDesc-footer">
    <xsl:param name="fileDesc" />
    <xsl:variable name="copyright" select="$fileDesc/tei:publicationStmt/tei:availability" />
    <xsl:value-of select="normalize-space($copyright)" />
  </xsl:template>
  <!-- TODO make real title page
  <xsl:template name="fileDesc-footer">
    <xsl:param name="fileDesc" />
    <xsl:variable name="author" select="$fileDesc/tei:titleStmt/tei:author" />
    <xsl:variable name="date" select="$fileDesc/tei:publicationStmt/tei:date/@when" />
    <xsl:variable name="title" select="$fileDesc/tei:titleStmt/tei:title" />
    <xsl:variable name="place" select="$fileDesc/tei:publicationStmt/tei:pubPlace" />
    <xsl:variable name="publisher" select="$fileDesc/tei:publicationStmt/tei:publisher" />
    <xsl:variable name="copyright" select="$fileDesc/tei:publicationStmt/tei:availability" />

    <xsl:apply-templates select="$author" />
    <xsl:text>. </xsl:text>
    <xsl:value-of select="$date" />
    <xsl:text>. \wtitle{</xsl:text>
    <xsl:apply-templates select="$title" />
    <xsl:text>}.</xsl:text>
    <xsl:if test="$place and $publisher">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$place" />
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="$publisher" />
      <xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:text>&#xA;</xsl:text>
    <xsl:value-of select="normalize-space($copyright)" />
  </xsl:template>
  -->

  <xsl:template match="tei:div | tei:div1 | tei:div2 | tei:div3 | tei:div4">
    <xsl:apply-templates />
  </xsl:template>

  <!-- todo chapter -->

  <xsl:template match="tei:div1/tei:head">
    <xsl:text>\section{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$par" />
  </xsl:template>

  <xsl:template match="tei:div2/tei:head">
    <xsl:text>\subsection{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$par" />
  </xsl:template>

  <xsl:template match="tei:div3/tei:head">
    <xsl:text>\subsubsection{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$par" />
  </xsl:template>

  <xsl:template match="tei:div4/tei:head">
    <xsl:text>\paragraph{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$par" />
  </xsl:template>

  <xsl:template match="tei:p">
    <xsl:apply-templates />
    <xsl:value-of select="$par" />
  </xsl:template>

  <xsl:template match="tei:title[@type='m' or @type='']">
    <xsl:text>\wtitle{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="tei:title[@type='a']">
    <xsl:text>\ptitle{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- todo mark language -->
  <xsl:template match="tei:foreign">
    <xsl:text>\foreign{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="tei:q">
    <xsl:text>\quoted{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="tei:ref">
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="@target" />
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="tei:hi">
    <xsl:text>\strong{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="aac:LaTeX">
    <xsl:text>\LaTeX{}</xsl:text>
  </xsl:template>

  <!-- TODO doesn't work -->
  <xsl:template match="aac:usd">
    <xsl:text>\$</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="citeKey">
    <xsl:text>{</xsl:text>
    <xsl:value-of select="@key" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="aac:cite">
    <xsl:text> \Autocite</xsl:text>
    <xsl:if test="string(.)">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates />
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:call-template name="citeKey" />
  </xsl:template>

  <xsl:template match="aac:citeList">
    <xsl:text> \Autocites</xsl:text>
    <xsl:for-each select="aac:cite">
      <xsl:call-template name="citeKey" />
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
