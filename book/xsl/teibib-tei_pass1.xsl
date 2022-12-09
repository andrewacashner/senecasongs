<?xml version="1.0" encoding="utf-8"?>
<!-- XSL transformation from TEI with custom bibliography extensions to standard TEI: First pass

For Seneca Songs website

Andrew A. Cashner, 2022/09

The input file is in TEI-XML but used listBibl[@type='auto'] as placeholders for
bibliography entries and bibl[@type='auto'] for in-text citations.
In a first pass, we use this stylesheet to replace the listBibl[@type='auto']
with an xi:include command to pull in the actual bibliography file.
The bibliography is generated from a BibTeX sourcefile via Biber (to bltxml)
and via our bltxml_tei stylesheet.

The stylesheet also cleans up the input text and processes TeX-style character "macros": straight apostrophes, TeX dashes.
-->
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.tei-c.org/ns/1.0" 
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xi="http://www.w3.org/2001/XInclude"
  exclude-result-prefixes="tei xi">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()" priority="1">
    <xsl:variable name="quote">
      <xsl:value-of select="replace(., '''', '’')" />
    </xsl:variable>
    <xsl:variable name="em-dash">
      <xsl:value-of select="replace($quote, '---', '—')" />
    </xsl:variable>
    <xsl:variable name="en-dash">
      <xsl:value-of select="replace($em-dash, '--', '–')" />
    </xsl:variable>
    <xsl:variable name="newline">
      <xsl:value-of select="replace($en-dash, '&#10;', ' ')" />
    </xsl:variable>
    <xsl:variable name="space">
      <xsl:value-of select="replace($newline, '  ', ' ')" />
    </xsl:variable>
    <xsl:value-of select="$space" />
  </xsl:template>

  <xsl:template match="tei:listBibl[@type='auto' and @subtype='biblio']">
    <xsl:variable name="bibtex-source" select="@source" />
    <xsl:variable name="file-basename" select="/tei:TEI/@xml:base" />
    <xsl:if test="$file-basename">
      <xsl:variable name="bib-basename" select="substring($file-basename, 1, string-length($file-basename) - 4)" />
      <xsl:variable name="tei-bib" select="concat($bib-basename, '-bib.tei')" />
        <xi:include href="{$tei-bib}" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:bibl[@type='auto']/@corresp">
    <xsl:attribute name="corresp">
      <xsl:value-of select="replace(., ':', '-')" />
    </xsl:attribute>
  </xsl:template>


</xsl:stylesheet>
