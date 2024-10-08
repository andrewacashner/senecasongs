<?xml version="1.0" encoding="utf-8"?>
<!-- XSL transformation from TEI-XML to HTML5
For Seneca songs website

Andrew A. Cashner, 2022/09/08

The input for this stylesheet is the TEI output produced by the teibib_tei stylesheet.

It uses the tei-html_bib stylesheet to convert the listBibl bibliography to an HTML5 reference list.

This stylesheet also inserts automatic numbers for tables, figures, etc., and references to them (ref[@type='auto' and @subtype='table'] for example).
-->
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  exclude-result-prefixes="tei">

  <xsl:output method="html" version="5.0" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:include href="tei-html_bib.xsl" />

  <xsl:template match="comment()" priority="1" />

  <xsl:template match="/">
    <xsl:variable name="title" select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title" />
    <xsl:variable name="titlePage" select="tei:TEI/tei:text/tei:front/tei:titlePage" />
    <xsl:variable name="cover-image" select="$titlePage/tei:figure[@type='cover']" />
    <xsl:variable name="body" select="tei:TEI/tei:text/tei:body" />
    <xsl:variable name="fileDesc" select="tei:TEI/tei:teiHeader/tei:fileDesc" />
    <xsl:variable name="back" select="tei:TEI/tei:text/tei:back" />

    <html lang="en-us">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="css/woods_edge.css" />
        <title><xsl:apply-templates select="$title" /></title>
      </head>
      <body>
        <xsl:apply-templates select="$cover-image" />
        <header>
          <xsl:call-template name="titlePage-header">
            <xsl:with-param name="titlePage" select="$titlePage" />
          </xsl:call-template>
          <xsl:call-template name="nav">
            <xsl:with-param name="filename" select="tei:TEI/@xml:base" />
          </xsl:call-template>
        </header>
        <main>
          <xsl:apply-templates select="$body" />
          <xsl:apply-templates select="$back" />
        </main>
        <xsl:call-template name="footer">
          <xsl:with-param name="fileDesc" select="$fileDesc" />
          <xsl:with-param name="image" select="$cover-image" />
        </xsl:call-template>
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
    <h2 class="author">
      <xsl:value-of select="$titlePage/tei:docAuthor" separator=" and " />
    </h2>
  </xsl:template>

  <!-- TODO expand as site grows -->
  <xsl:template name="nav">
    <xsl:param name="filename" />
    <nav>
      <ul>
        <li><a href="index.html">Home</a></li>
        <li><a href="about.html">About</a></li>
        <li><a href="{$filename}">Download TEI</a></li>
        <li><a href="{replace($filename, '.tei', '.pdf')}">Download PDF page</a></li>
        <li><a href="book.pdf">Download PDF book</a></li>
      </ul>
    </nav>
  </xsl:template>

  <xsl:template name="pdf-download">
    <xsl:param name="filename" />
  </xsl:template>

  <xsl:template name="footer">
    <xsl:param name="fileDesc" />
    <xsl:param name="image" />
    <xsl:variable name="author" select="$fileDesc/tei:titleStmt/tei:author" />
    <xsl:variable name="date" select="$fileDesc/tei:publicationStmt/tei:date/@when" />
    <xsl:variable name="title" select="$fileDesc/tei:titleStmt/tei:title" />
    <xsl:variable name="place" select="$fileDesc/tei:publicationStmt/tei:pubPlace" />
    <xsl:variable name="publisher" select="$fileDesc/tei:publicationStmt/tei:publisher" />
    <xsl:variable name="copyright" select="$fileDesc/tei:publicationStmt/tei:availability" />
    <footer>
      <hr />
        <!--
          <p>
        <xsl:value-of select="$author" separator=" and "/>
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
        -->
      <xsl:call-template name="cover-image-caption">
        <xsl:with-param name="image" select="$image" />
      </xsl:call-template>
      <xsl:call-template name="fonts" />
      <xsl:apply-templates select="$copyright" />
    </footer>
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
    <a href="{@target}">
      <xsl:apply-templates />
    </a>
  </xsl:template>

  <xsl:template match="tei:ref[@type='internal']">
    <a href="{replace(@target, '.tei', '.html')}">
      <xsl:apply-templates />
    </a>
  </xsl:template>

  <xsl:template match="tei:ref[@type='citation']">
    <a class="citation" href="{@target}">
      <xsl:apply-templates />
    </a>
  </xsl:template>

  <xsl:variable name="tables">
    <xsl:for-each select="//tei:table">
      <xsl:copy>
        <xsl:copy-of select="@xml:id" />
        <xsl:attribute name="n">
          <xsl:number count="tei:table" />
        </xsl:attribute>
      </xsl:copy>
    </xsl:for-each>
  </xsl:variable>

  <xsl:template match="tei:ref[@type='auto' and @subtype='table']">
    <xsl:variable name="label" select="substring(@target, 2)" />
    <a class="{@subtype}" href="{@target}">
      <xsl:apply-templates />
      <xsl:text> </xsl:text>
      <xsl:value-of select="$tables/tei:table[@xml:id=$label]/@n" />
    </a>
  </xsl:template>

  <xsl:template match="tei:hi[@type='TODO']">
    <strong class="alert"><xsl:apply-templates /></strong>
  </xsl:template>

  <xsl:template match="tei:hi">
    <strong><xsl:apply-templates /></strong>
  </xsl:template>

  <xsl:template match="tei:mentioned | tei:term">
    <em><xsl:apply-templates /></em>
  </xsl:template>

  <xsl:template match="tei:figure[@type='cover']">
    <img class="cover">
      <xsl:attribute name="src">
        <xsl:value-of select="tei:graphic/@url" />
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:value-of select="tei:figDesc" />
      </xsl:attribute>
    </img>
  </xsl:template>

  <xsl:template match="tei:availability/tei:p">
    <p class="copyright">
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template name="fonts">
    <p>This document is typeset in Crimson Pro, by Jacques Le Bailly (distributed under the terms of the <a href="https://scripts.sil.org/OFL_web">SIL Open Font License</a>), with headings in Venturis Gothic Titling and Venturis Sans by Arkandis Digital Foundry (distributed under a <a href="https://ctan.org/tex-archive/fonts/venturisadf">free license</a>).</p>
  </xsl:template>

  <xsl:template match="tei:list[@rend='numbered']">
    <ol>
      <xsl:apply-templates />
    </ol>
  </xsl:template>

  <xsl:template match="tei:list[@rend='bulleted']">
    <ul>
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="tei:item">
    <li><xsl:apply-templates /></li>
  </xsl:template>

  <xsl:template name="cover-image-caption">
    <xsl:param name="image" />
    <p>Background image: <xsl:apply-templates select="$image/tei:figDesc" /></p>
  </xsl:template>

  <xsl:template match="tei:table">
    <table id="{@xml:id}">
      <xsl:apply-templates />
    </table>
  </xsl:template>

  <xsl:template match="tei:table/tei:head">
    <caption>
      <xsl:text>Table </xsl:text>
      <xsl:number format="1. " count="tei:table" />
      <xsl:apply-templates />
    </caption>
  </xsl:template>

  <xsl:template match="tei:table/tei:row">
    <tr><xsl:apply-templates /></tr>
  </xsl:template>

  <xsl:template match="tei:table/tei:row/tei:cell">
    <td><xsl:apply-templates /></td>
  </xsl:template>

</xsl:stylesheet>
