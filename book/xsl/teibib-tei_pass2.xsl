<?xml version="1.0" encoding="utf-8"?>
<!-- XSL transformation from TEI with custom bibliography extensions to standard TEI: First pass

For Seneca Songs website

Andrew A. Cashner, 2022/09

The input file is in TEI-XML but uses bibl[@type='auto'] as placeholders for in-text citations.
In the first pass, we used the teibib-tei_pass1 stylesheet to insert a bibliography file.
Now we substitute in-text citations (Chicago author-date format) for the bibl[@type='auto'] elements.
We pull the information for these from the bibliography file using the xml:ids, and link the citation to the bibliography.

The bibliography was generated from a BibTeX sourcefile via Biber (to bltxml)
and via our bltxml_tei stylesheet.
Here we convert the bibliography data to the appropriate format for the reference list.

Output is a standard TEI format. 
We still omit automatic reference numbers (e.g., tables, figures), since these may be added in a future XSL transformation. 
(We do it in the tei-html stylesheet.)
-->
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.tei-c.org/ns/1.0" 
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xi="http://www.w3.org/2001/XInclude"
  exclude-result-prefixes="xi tei">

  <xsl:output method="xml" encoding="utf-8" indent="yes" include-content-type="no"/>

  <xsl:strip-space elements="*" />

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()" priority="1" />

  <xsl:template match="@xml:id">
    <xsl:attribute name="xml:id">
      <xsl:value-of select="replace(., ':', '-')" />
    </xsl:attribute>
  </xsl:template>


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
      <ref type="citation" target="#{$bibKey}">
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
