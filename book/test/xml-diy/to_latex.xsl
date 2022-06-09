<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml"
  exclude-result-prefixes="xi bltx">

  <xsl:output method="text" encoding="utf-8" indent="no" />

  <xsl:strip-space elements="document head body header main footer section h1 h2 ul ol li" />

  <xsl:template match="/">
    <xsl:text>\documentclass{senecasongs}&#xA;</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

  <!-- need better way to set title, author, date, copyright -->
  <xsl:template match="head">
    <xsl:text>\title{</xsl:text>
    <xsl:value-of select="title" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:text>\author{</xsl:text>
    <xsl:value-of select="//body/header/h2[@class='author']" />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="head/*" />

  <xsl:template match="body">
    <xsl:text>\begin{document}&#xA;\maketitle&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{document}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="header" />

  <xsl:template match="section/h1">
    <xsl:text>\section{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>
  
  <xsl:template match="section/h2">
    <xsl:text>\subsection{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="p">
    <xsl:text>&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="q">
    <xsl:text>\quoted{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="ol">
    <xsl:text>\begin{enumerate}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{enumerate}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="ul">
    <xsl:text>\begin{itemize}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{itemize}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="li">
    <xsl:text>\item{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="wtitle">
    <xsl:text>\wtitle{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="ptitle">
    <xsl:text>\ptitle{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- TODO special treatment for Seneca? -->
  <xsl:template match="foreign">
    <xsl:text>\foreign{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="LaTeX">
    <xsl:text>\LaTeX{}</xsl:text>
  </xsl:template>

  <xsl:template match="usd">
    <xsl:text>\$</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="parencite">
    <xsl:text>{</xsl:text>
    <xsl:value-of select="@key" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="citationList">
    <xsl:text> \autocites</xsl:text>
    <xsl:for-each select="citation">
      <xsl:call-template name="parencite" />
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="citation">
    <xsl:text> \autocite</xsl:text>
    <xsl:call-template name="parencite" />
  </xsl:template>

  <xsl:template match="section[@id='references']">
    <xsl:apply-templates select="bibList"/>
  </xsl:template>

  <xsl:template match="bltx:entries">
    <xsl:text>\printbibliography&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="bibItem" />

  <xsl:template match="footer" />
</xsl:stylesheet>
