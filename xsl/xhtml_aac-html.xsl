<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:m="http://www.w3.org/1998/Math/MathML" 
  xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml"
  xmlns:aac="https://www.senecasongs.earth">

<!-- TODO
  - change position of end punctuation outside of bib tags? 
  - tables of contents
  - nav
-->

  <xsl:output method="html" version="5.0" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:import href="bltxml_macros.xsl" />

  <xsl:template match="comment()" priority="1" />

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xhtml:html">
    <html lang="en">
      <xsl:apply-templates />
    </html>
  </xsl:template>

  <xsl:template match="xhtml:head">
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <xsl:apply-templates />
    </head>
  </xsl:template>

  <xsl:template match="aac:youtube">
    <iframe 
      width="560" height="315" 
      src="https://www.youtube.com/embed/{@key}" 
      title="YouTube video player" 
      frameborder="0" 
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
      allowfullscreen="true"></iframe>
  </xsl:template>

  <xsl:template match="xhtml:video">
    <video width="560" height="315" controls="true">
      <source src="{@src}" />
    </video>
  </xsl:template>

  <xsl:template match="xhtml:footer">
    <footer>
      <xsl:apply-templates />
      <p>
      Copyright © 2024 Bill Crouse, Sr., and Andrew A. Cashner.
      </p>
      <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
    </footer>
  </xsl:template>

  <!-- SPECIAL CHARACTERS and FORMATTED EXPRESSIONS -->
  <xsl:template match="aac:pcset">
    <code>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="@n" />
      <xsl:text>/</xsl:text>
    </code>
  </xsl:template>

  <xsl:template match="aac:degree">
    <m:math>
      <m:mi>
        <xsl:call-template name="accid">
          <xsl:with-param name="accid" select="@accid" />
        </xsl:call-template>
      </m:mi>
      <m:mover>
        <m:mi>
          <xsl:value-of select="@n" />
        </m:mi>
        <m:mi>&#x02c6;</m:mi>
      </m:mover>
    </m:math>
  </xsl:template>

  <xsl:template match="aac:pitch">
    <xsl:value-of select="@pname" />
    <xsl:call-template name="accid">
      <xsl:with-param name="accid" select="@accid" />
    </xsl:call-template>
    <sub>
      <xsl:value-of select="@oct" />
    </sub>
  </xsl:template>

  <xsl:template name="accid">
    <xsl:param name="accid" />
    <xsl:choose>
      <xsl:when test="@accid='na'">
        <xsl:text>♮</xsl:text>
      </xsl:when>
      <xsl:when test="@accid='fl'">
        <xsl:text>♭</xsl:text>
      </xsl:when>
      <xsl:when test="@accid='sh'">
        <xsl:text>♯</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="aac:na">
    <xsl:text>♮</xsl:text>
  </xsl:template>

  <xsl:template match="aac:fl">
    <xsl:text>♭</xsl:text>
  </xsl:template>
  
  <xsl:template match="aac:sh">
    <xsl:text>♯</xsl:text>
  </xsl:template>

  <!-- FLOATS AND CROSS-REFERENCES -->

  <!-- Internal references with automatic numbers -->
  <xsl:template match="aac:ref[@type='table']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:apply-templates />
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="//xhtml:table[@id=$target]" mode="number" />
    </a>
  </xsl:template>

  <xsl:template match="xhtml:table" mode="number">
    <xsl:number count="//xhtml:table" level="any" />
  </xsl:template>

  <xsl:template match="xhtml:table/xhtml:caption">
    <caption>
      <xsl:text>Table </xsl:text>
      <xsl:number count="xhtml:table" format="1. " level="any" />
      <xsl:apply-templates />
    </caption>
  </xsl:template>
  
  <xsl:template match="aac:ref[@type='diagram']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:apply-templates />
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="//xhtml:figure[@class='diagram' and @id=$target]" mode="number" />
    </a>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='diagram']" mode="number">
    <xsl:number count="//xhtml:figure[@class='diagram']" level="any" />
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='diagram']/xhtml:figCaption">
    <figCaption>
      <xsl:text>Diagram </xsl:text>
      <xsl:number count="xhtml:figure[@class='diagram']" format="1. " level="any" />
      <xsl:apply-templates />
    </figCaption>
  </xsl:template>


  <!-- CITATIONS AND BIBLIOGRAPHY -->

  <!-- Bring in the XML bibliography file, which was derived from the BibTeX file
    - Original BibTeX file must be set in metadata like so:
      <head>
        ...
        <meta name="bibliography" content="biblio.bib" />
      </head>
  -->
  <xsl:variable name="bibtexml-file">
    <xsl:variable name="bibtex-file" select="//xhtml:meta[@name='bibliography']/@content" />
    <xsl:value-of select="replace($bibtex-file, '.bib', '.bltxml')" />
  </xsl:variable>
 
  <xsl:variable name="bibfile" select="document(concat(environment-variable('PWD'), '/aux/', $bibtexml-file))/bltx:entries" />

  <!-- remove meta bibliography item -->
  <xsl:template match="xhtml:meta[@name='bibliography']" />

  <!-- REFERENCE LIST -->

  <!-- Filter the BiblateXML bibliography tree to include only entries cited in the text -->
  <xsl:variable name="references">
    <xsl:variable name="citations" select="distinct-values(//aac:citation/@key)" />
    <bltx:entries>
      <xsl:for-each select="$citations">
        <xsl:copy-of select="$bibfile/bltx:entry[@id=current()]" />
      </xsl:for-each>
    </bltx:entries>
  </xsl:variable>

  <!-- Generate the bibliography/reference list instead of the placeholder -->
  <xsl:template match="aac:bibliography">
    <section id="bibliography">
      <h1>References</h1>
      <xsl:apply-templates select="$references" />
    </section>
  </xsl:template>

  <!-- Sort entries by first surname listed and date -->
  <xsl:template match="bltx:entries">
    <ul class="biblio">
      <xsl:apply-templates>
        <xsl:sort select="bltx:names[1]/bltx:name[1]/bltx:namepart[@type='family']" />
        <xsl:sort select="bltx:date" />
      </xsl:apply-templates>
    </ul>
  </xsl:template>

  <!-- Convert bibliography entries --> 

  <!-- Book or collection of essays -->
  <xsl:template match="bltx:entry[@entrytype='book'] | bltx:entry[@entrytype='collection']">
    <xsl:variable name="authors">
      <xsl:call-template name="book-authors" />
    </xsl:variable>
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="bltx:date" />
      <xsl:text>. </xsl:text>
      <cite><xsl:apply-templates select="bltx:title" /></cite>
      <xsl:text>.</xsl:text>
      <xsl:apply-templates select="bltx:location" />
      <xsl:apply-templates select="bltx:publisher" />
      <xsl:apply-templates select="bltx:url" />
    </li>
  </xsl:template>

  <!-- List of authors or editors of a book or collection -->
  <xsl:template name="book-authors">
    <xsl:choose>
      <xsl:when test="bltx:names[@type='author']">
        <xsl:call-template name="name-list">
          <xsl:with-param name="names" select="bltx:names[@type='author']" />
          <xsl:with-param name="type">lastname-first</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="bltx:names[@type='editor']">
        <xsl:call-template name="name-list">
          <xsl:with-param name="names" select="bltx:names[@type='editor']" />
          <xsl:with-param name="type">lastname-first</xsl:with-param>
        </xsl:call-template>
        <xsl:choose>
          <xsl:when test="count(bltx:names[@type='editor']/bltx:name) > 1">
            <xsl:text>, eds</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>, ed</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Anonymous</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Article -->
  <xsl:template match="bltx:entry[@entrytype='article']">
    <xsl:variable name="authors">
      <xsl:call-template name="name-list">
        <xsl:with-param name="names" select="bltx:names[@type='author']" />
        <xsl:with-param name="type">lastname-first</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="bltx:date" />
      <xsl:text>. </xsl:text>
      <q><xsl:apply-templates select="bltx:title" /></q>
      <xsl:text>. </xsl:text>
      <cite><xsl:apply-templates select="bltx:journaltitle" /></cite>
      <xsl:if test="bltx:volume">
        <xsl:text> </xsl:text>
        <xsl:value-of select="bltx:volume" />
      </xsl:if>
      <xsl:if test="bltx:number">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="bltx:number" />
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="bltx:pages">
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="bltx:pages" />
      </xsl:if>
      <xsl:text>.</xsl:text>
      <xsl:apply-templates select="bltx:url" />
    </li>
  </xsl:template>

  <!-- Article in a collection of essays -->
  <xsl:template match="bltx:entry[@entrytype='incollection']">
    <xsl:variable name="authors">
      <xsl:call-template name="name-list">
        <xsl:with-param name="names" select="bltx:names[@type='author']" />
      </xsl:call-template>
    </xsl:variable>
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="bltx:date" />
      <xsl:text>. </xsl:text>
      <q><xsl:apply-templates select="bltx:title" /></q>
      <xsl:text>. In </xsl:text>
      <cite><xsl:apply-templates select="bltx:booktitle" /></cite>
      <xsl:text>, edited by </xsl:text>
      <xsl:call-template name="name-list">
        <xsl:with-param name="names" select="bltx:names[@type='editor']" />
        <xsl:with-param name="type">firstname-first</xsl:with-param>
      </xsl:call-template>
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="bltx:pages" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="bltx:location" />
      <xsl:apply-templates select="bltx:publisher" />
      <xsl:apply-templates select="bltx:url" />
    </li>
  </xsl:template>
  
  <xsl:template name="name-list">
    <xsl:param name="names" />
    <xsl:param name="type" />
    <xsl:variable name="nameCount" select="count($names/bltx:name)" />
    <xsl:for-each select="$names/bltx:name">
      <xsl:if test="$nameCount > 2 and not(position()=1) and not(position()=last())">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:if test="$nameCount > 1 and position()=last()">
        <xsl:text>, and </xsl:text>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="not($type='firstname-first') and position()=1">
          <xsl:apply-templates select="bltx:namepart[@type='family']" />
          <xsl:if test="bltx:namepart[@type='given']">
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="bltx:namepart[@type='given']" />
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="bltx:namepart[@type='given']">
            <xsl:apply-templates select="bltx:namepart[@type='given']" />
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="bltx:namepart[@type='family']" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- Process elements of bibliography entries
    - Remove TeX macros
  -->
  <xsl:template match="bltx:title | bltx:journaltitle | bltx:booktitle">
    <xsl:call-template name="macros" />
  </xsl:template>

  <!-- Names: bltx:namepart elements can be nested; insert space if there is another one after this -->
  <xsl:template match="bltx:namepart">
    <xsl:apply-templates />
    <xsl:if test="not(position()=last())">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="bltx:location">
    <xsl:text> </xsl:text>
    <xsl:call-template name="macros" />
    <xsl:text>: </xsl:text>
  </xsl:template>

  <xsl:template match="bltx:publisher">
    <xsl:call-template name="macros" />
    <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template match="bltx:url">
    <xsl:text> </xsl:text>
    <a href="{string()}"><xsl:value-of select="." /></a>
    <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template match="bltx:list">
    <xsl:value-of select="bltx:item" separator=" and " />
  </xsl:template>

  <xsl:template match="bltx:pages">
    <xsl:for-each select="bltx:list/bltx:item">
      <xsl:value-of select="bltx:start" />
      <xsl:text>–</xsl:text>
      <xsl:value-of select="bltx:end" />
      <xsl:if test="not(position()=last())">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- IN-TEXT CITATIONS -->
  <!-- Make a link for a single citation and enclose in parentheses -->
  <xsl:template match="aac:citation">
    <xsl:text>(</xsl:text>
    <xsl:call-template name="in-text-citation" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- For multiple citations, make links in semicolon-separated list and enclose in parentheses -->
  <xsl:template match="aac:citationList">
    <xsl:text>(</xsl:text>
    <xsl:for-each select="aac:citation">
      <xsl:call-template name="in-text-citation" />
      <xsl:if test="not(position()=last())">
        <xsl:text>; </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- Insert Author-Date text as link to reference-list entry -->
  <xsl:template name="in-text-citation">
    <xsl:variable name="ref" select="$references/bltx:entries/bltx:entry[@id=current()/@key]" />

    <a class="citation" href="#{@key}">
      <xsl:choose>
        <xsl:when test="$ref">
          <xsl:for-each select="$ref/bltx:names[1]/bltx:name/bltx:namepart[@type='family']">
            <xsl:apply-templates />
            <xsl:if test="not(position()=last())">
              <xsl:text> and </xsl:text>
            </xsl:if>
          </xsl:for-each>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$ref/bltx:date" />
        </xsl:when>
        <xsl:otherwise>
          <strong><xsl:value-of select="@key" /></strong>
        </xsl:otherwise>
      </xsl:choose>
    </a>
    <xsl:if test="@pages">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@pages" />
    </xsl:if>
    <xsl:apply-templates />
  </xsl:template>

  <!-- MODULAR DESIGN (web vs. print) -->

  <xsl:template match="*[@data-medium='print']" />

</xsl:stylesheet>


