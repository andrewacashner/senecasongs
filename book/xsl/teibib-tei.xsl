<?xml version="1.0" encoding="utf-8"?>
<!-- XSL transformation from custom TEIbib to standard TEI
For Seneca songs website

Andrew A. Cashner, 2012/12/12

We write input files in a customized version of TEI, which allows for TeX character macros (`-\-\-`, `'s`) and automatic bibliography.
This includes automatic inline citation labels and automatically generated bibliography (reference list).

For inline citations:

- Where we would use `\Autocite[25]{key}` in LaTeX with `biblatex-chicago` 
  here we use `<bibl type="auto" corresp="#key">25</bibl>`.
- Where we would use `\Autocites{key1}[1-\-2]{key2}` here we use
  ````
  <listBibl type="auto" subtype="intext">
    <bibl type="auto" corresp="#key1" />
    <bibl type="auto" corresp-"#key2">1-\-2</bibl>
  </listBibl>
  ````

For automatic bibliography:

  - The source BibTeX file must be specified with the `@source`
  - Where in LaTeX we would write `addbibresource{biblio.bib}` in the preamble and `\printbibliography` at the end, here we write just
  `<listBibl type="auto" subtype="biblio" source="biblio.bib" />`.
  - The `@source` attribute must be the local URI of a BibTeX database file.
  - For example:
  ````
  <div1 id="references">
    <head>References</head>
    <listBibl type="auto" subtype="biblio" source="tex/indigenous.bib" />
  </div1>
  ````

The stylesheet requires a TEI bibliography file, which in our setup is previously generated via Biber (BibLaTeX->Biblatexml) and XSLT (Biblatexml->TEI, stylesheet `bltxml-tei.xsl`).
We bring in that file as a variable, then to process the in-text citations we search the bibliography tree for a matching id and substitute the author and date. 
For the reference list we filter the bibliography by the citation keys in the input document.

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

  <!-- Expand TeX-style character macros -->
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

  <!-- Bring in the TEI bibliography file -->
  <xsl:variable name="bibfile" 
  select="document(concat(environment-variable('PWD'), '/build/biblio.tei'))/tei:listBibl" />

  <!-- Create a list of in-text citation keys in this document -->
  <xsl:variable name="citations" select="//tei:bibl[@type='auto']" />

  <!-- Generate the bibliography/reference list instead of the placeholder -->
  <xsl:template match="tei:listBibl[@type='auto' and @subtype='biblio']">
    <listBibl>
      <xsl:apply-templates select="$bibfile/tei:biblStruct" />
    </listBibl>
  </xsl:template>

  <!-- Select only those entries from the TEI bibliography that have a matching key in the in-text citations.
    - The in-text citations are written in the format `#Author:Keyword` but are converted to the format `Author-Keyword`. 
  -->
  <xsl:template match="tei:biblStruct">
    <xsl:if test="$citations/replace(@xml:id=substring(@corresp, 2), ':', '-')">
      <xsl:copy-of select="." />
    </xsl:if>
  </xsl:template>

  <!-- In-text citations, enclosed in parentheses, author-date format -->
  <xsl:template match="tei:bibl[@type='auto']">
    <xsl:text> (</xsl:text>
    <xsl:call-template name="parencite" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- List of in-text citations, in parentheses, author-date format separated by commas and `and` -->
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

  <!-- Create list of author-date pairs to put inside parenthetical citations -->
  <xsl:template name="parencite">
    <xsl:variable name="bibKey" select="replace(substring(@corresp, 2), ':', '-')" />
    <xsl:variable name="pages" select="replace(string(), '--', '–')" />
    <xsl:variable name="ref" select="$bibfile//tei:biblStruct[@xml:id=$bibKey]" />

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

</xsl:stylesheet>
