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

  <xsl:template match="tei:listBibl[@type='auto' and @subtype='biblio']">
    <xsl:variable name="bibtex-source" select="@source" />
    <xsl:variable name="file-basename" select="/tei:TEI/@xml:base" />
    <xsl:if test="$file-basename">
      <xsl:variable name="bib-basename" select="substring($file-basename, 1, string-length($file-basename) - 4)" />
      <xsl:variable name="tei-bib" select="concat($bib-basename, '-bib.tei')" />
        <xi:include href="{$tei-bib}" />
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
