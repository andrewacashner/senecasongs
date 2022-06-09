<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml"
  exclude-result-prefixes="xi bltx">

  <xsl:output method="html" version="5.0" encoding="utf-8" indent="yes" />

  <xsl:strip-space 
    elements="document head title body header h1 h2 main footer section ul ol li" />

  <xsl:template match="text()">
    <xsl:value-of 
    select="replace(replace(replace(., 
    '---','—'),
    '--','–'),
    '''','’')" />
  </xsl:template>

  <xsl:template match="/document">
    <html lang="en-us">
      <xsl:apply-templates />
    </html>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="title | body | main | footer | section | h1 | h2 | p | ol | ul | li | blockquote | em | strong | q | cite | a">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="head">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <link rel="stylesheet" href="senecasongs.css" />
      <link rel="apple-touch-icon" sizes="180x180" href="media/favicon/apple-touch-icon.png" />
      <link rel="icon" type="image/png" sizes="32x32" href="media/favicon/favicon-32x32.png" />
      <link rel="icon" type="image/png" sizes="16x16" href="media/favicon/favicon-16x16.png" />
      <link rel="manifest" href="media/favicon/site.webmanifest" />
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

  <!-- TODO set doc filename as variable in metadata -->
  <xsl:template match="header">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates />
      <a href="main.pdf">Download PDF of this page</a>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="wtitle">
    <cite><xsl:apply-templates /></cite>
  </xsl:template>

  <xsl:template match="ptitle">
    <q><xsl:apply-templates /></q>
  </xsl:template>

  <xsl:template match="foreign">
    <em class="foreign">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match="term | mentioned">
    <em><xsl:apply-templates /></em>
  </xsl:template>

  <xsl:template match="LaTeX">
    <xsl:text>LaTeX</xsl:text>
  </xsl:template>

  <xsl:template match="usd">
    <xsl:text>$</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="parencite">
    <xsl:variable name="bibKey" select="@key" />
    <xsl:variable name="bibEntry" select="//bltx:entry[@id=$bibKey]" />
    <xsl:variable name="authors" select="$bibEntry/bltx:names[@type='author'] | $bibEntry/bltx:names[@type='editor']" />

    <!-- TODO what if date is not available? e.g., in collection xref -->
    <a class="citation" href="#{$bibKey}">
      <xsl:value-of select="$authors/bltx:name/bltx:namepart[@type='family']" separator=" and " />
      <xsl:text> </xsl:text>
      <xsl:value-of select="$bibEntry/bltx:date" />
      <xsl:if test="string(.)">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:apply-templates />
    </a>
  </xsl:template>

  <xsl:template match="citation">
    <xsl:text> (</xsl:text>
    <xsl:call-template name="parencite" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="citationList">
    <xsl:text> (</xsl:text>
    <xsl:for-each select="citation">
      <xsl:call-template name="parencite" />
      <xsl:if test="not(position() = last())">; </xsl:if>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="bltx:entries" />

  <xsl:template match="bibList">
    <ul class="bibliography">
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="bibItem">
    <li>
      <xsl:copy-of select="@id"/>
      <xsl:apply-templates />
    </li>
  </xsl:template>


</xsl:stylesheet>
