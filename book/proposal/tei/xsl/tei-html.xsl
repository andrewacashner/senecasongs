<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  exclude-result-prefixes="tei">

  <xsl:output method="html" version="5.0" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:include href="tei-html_bib.xsl" />

  <xsl:template match="/">
    <xsl:variable name="title" select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title" />
    <xsl:variable name="titlePage" select="tei:TEI/tei:text/tei:front/tei:titlePage" />
    <xsl:variable name="body" select="tei:TEI/tei:text/tei:body" />
    <xsl:variable name="fileDesc" select="tei:TEI/tei:teiHeader/tei:fileDesc" />
    <xsl:variable name="back" select="tei:TEI/tei:text/tei:back" />

    <html lang="en-us">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="main.css" />
        <title><xsl:apply-templates select="$title" /></title>
      </head>
      <body>
        <header>
          <xsl:call-template name="titlePage-header">
            <xsl:with-param name="titlePage" select="$titlePage" />
          </xsl:call-template>
        </header>
        <main>
          <xsl:apply-templates select="$body" />
          <xsl:apply-templates select="$back" />
        </main>
        <footer>
          <hr />
          <xsl:call-template name="fileDesc-footer">
            <xsl:with-param name="fileDesc" select="$fileDesc" />
          </xsl:call-template>
        </footer>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template name="titlePage-header">
    <xsl:param name="titlePage" />
    <xsl:variable name="docTitle" select="$titlePage/tei:docTitle" />
    <xsl:variable name="maintitle" select="$docTitle/tei:titlePart[@type='main' or @type='']" />
    <xsl:variable name="subtitle" select="$docTitle/tei:titlePart[@type='sub']" />
    <xsl:variable name="author" select="$titlePage/tei:docAuthor" />

    <xsl:choose>
      <xsl:when test="$maintitle and $subtitle">
        <h1 class="maintitle">
          <xsl:apply-templates select="$maintitle" />
        </h1>
        <h1 class="subtitle">
          <xsl:apply-templates select="$subtitle" />
        </h1>
      </xsl:when>
      <xsl:otherwise>
        <h1 class="maintitle">
          <xsl:apply-templates select="$docTitle" />
        </h1>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$author">
      <h2 class="author">
        <xsl:apply-templates select="$author" />
      </h2>
    </xsl:if>
  </xsl:template>

  <xsl:template name="fileDesc-footer">
    <xsl:param name="fileDesc" />
    <xsl:variable name="author" select="$fileDesc/tei:titleStmt/tei:author" />
    <xsl:variable name="date" select="$fileDesc/tei:publicationStmt/tei:date/@when" />
    <xsl:variable name="title" select="$fileDesc/tei:titleStmt/tei:title" />
    <xsl:variable name="place" select="$fileDesc/tei:publicationStmt/tei:pubPlace" />
    <xsl:variable name="publisher" select="$fileDesc/tei:publicationStmt/tei:publisher" />
    <xsl:variable name="copyright" select="$fileDesc/tei:publicationStmt/tei:availability" />
    <p>
      <xsl:apply-templates select="$author" />
      <xsl:text>. </xsl:text>
      <xsl:value-of select="$date" />
      <xsl:text>. </xsl:text>
      <cite><xsl:apply-templates select="$title" /></cite>
      <xsl:text>.</xsl:text>
      <xsl:if test="$place and $publisher">
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="$place" />
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="$publisher" />
        <xsl:text>.</xsl:text>
      </xsl:if>
    </p>
    <xsl:apply-templates select="$copyright" />
  </xsl:template>

  <xsl:template match="tei:div | tei:div1 | tei:div2 | tei:div3 | tei:div4">
    <section>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </section>
  </xsl:template>

  <xsl:template match="tei:div1/tei:head">
    <h1><xsl:apply-templates /></h1>
  </xsl:template>

  <xsl:template match="tei:div2/tei:head">
    <h2><xsl:apply-templates /></h2>
  </xsl:template>

  <xsl:template match="tei:div3/tei:head">
    <h3><xsl:apply-templates /></h3>
  </xsl:template>

  <xsl:template match="tei:div4/tei:head">
    <h4><xsl:apply-templates /></h4>
  </xsl:template>

  <xsl:template match="tei:p">
    <p><xsl:apply-templates /></p>
  </xsl:template>

  <xsl:template match="tei:link">
    <a href="{@target}"><xsl:apply-templates /></a>
  </xsl:template>

  <xsl:template match="tei:title[@type='m' or @type='']">
    <cite><xsl:apply-templates /></cite>
  </xsl:template>

  <xsl:template match="tei:title[@type='a']">
    <q><xsl:apply-templates /></q>
  </xsl:template>

  <xsl:template match="tei:foreign">
    <em class="foreign">
      <xsl:if test="@lang">
        <xsl:copy-of select="@lang" />
      </xsl:if>
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <xsl:template match="tei:q">
    <q><xsl:apply-templates /></q>
  </xsl:template>

  <xsl:template match="tei:ref">
    <a href="{@target}"><xsl:apply-templates /></a>
  </xsl:template>

  <xsl:template match="tei:hi">
    <strong><xsl:apply-templates /></strong>
  </xsl:template>


</xsl:stylesheet>
