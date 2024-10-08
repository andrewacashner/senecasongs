<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml"
  xmlns:aac="https://www.senecasongs.earth"
  exclude-result-prefixes="aac bltx xhtml">

<!-- TODO
  - tables of contents
  - nav
-->

  <xsl:output method="html" version="5.0" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:import href="bltxml_macros.xsl" />

  <xsl:template match="comment()" priority="1" />
  <xsl:template match="aac:comment" />

  <xsl:template match="@* | node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xhtml:html">
    <html lang="en">
      <xsl:apply-templates />
    </html>
  </xsl:template>
  
  <!-- Google tag (gtag.js) -->
  <xsl:variable name="google-tag">
    <script async="true" src="https://www.googletagmanager.com/gtag/js?id=G-NX6RE0S740"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', 'G-NX6RE0S740');
    </script>
  </xsl:variable>

  <xsl:template match="xhtml:head">
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <xsl:apply-templates />
    </head>
    <xsl:copy-of select="$google-tag" />
  </xsl:template>

  <xsl:template match="xhtml:header">
    <header>
      <xsl:apply-templates />
      <nav>
        <ul>
          <li><a href="index.html">Home</a></li>
          <li><a href="about.html">About</a></li>
        </ul>
      </nav>
    </header>
  </xsl:template>

  <!-- iframe width="560" height="315"  -->
  <xsl:template match="aac:youtube">
    <iframe 
      src="https://www.youtube.com/embed/{@key}" 
      title="YouTube video player" 
      frameborder="0" 
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
      allowfullscreen="true"></iframe>
  </xsl:template>
  
  <xsl:template match="xhtml:iframe">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*" />
      <xsl:attribute name="frameborder">0</xsl:attribute>
      <xsl:attribute name="allowfullscreen">true</xsl:attribute>
      <xsl:apply-templates select="*" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xhtml:video">
    <video width="560" height="315" controls="true">
      <source src="{@src}" />
    </video>
  </xsl:template>

  <xsl:template match="xhtml:footer">
    <xsl:variable name="version" select="//xhtml:meta[@name='version']/@content" />
    <footer>
      <xsl:apply-templates />
      <p>
      <xsl:if test="$version">
          <xsl:value-of select="$version" />
          <xsl:text>. </xsl:text>
      </xsl:if>
      <xsl:value-of select="//xhtml:meta[@name='copyright']/@content" />
      <xsl:text>.</xsl:text>
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
    <xsl:if test="@accid">
      <xsl:call-template name="accid">
        <xsl:with-param name="accid" select="@accid" />
      </xsl:call-template>
    </xsl:if>
    <span class="scale-degree">
      <span class="hat">
        <span class="symbol">&#770;</span>
      </span>
      <span class="degree">
        <xsl:value-of select="@n" />
      </span>
    </span>
  </xsl:template>

  <xsl:template match="aac:ampersand">
    <xsl:text>&amp;</xsl:text>
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
        <xsl:call-template name="natural" />
      </xsl:when>
      <xsl:when test="@accid='fl'">
        <xsl:call-template name="flat" />
      </xsl:when>
      <xsl:when test="@accid='sh'">
        <xsl:call-template name="sharp" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="natural" match="aac:na">
    <span class="music">♮</span>
  </xsl:template>

  <xsl:template name="flat" match="aac:fl">
    <span class="music">♭</span>
  </xsl:template>
  
  <xsl:template name="sharp" match="aac:sh">
    <span class="music">♯</span>
  </xsl:template>

  <!-- FLOATS AND CROSS-REFERENCES -->

  <!-- Internal references with automatic numbers -->
  <xsl:template match="aac:ref[@type='image']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:choose>
        <xsl:when test="string()">
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>figure</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="//xhtml:figure[@class='image' and @id=$target]" mode="number" />
    </a>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='image']" mode="number">
    <xsl:number count="//xhtml:figure[@class='image']" level="any" />
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='image']/xhtml:figCaption">
    <figCaption>
      <xsl:text>Figure </xsl:text>
      <xsl:number count="xhtml:figure[@class='image']" format="1. " level="any" />
      <xsl:apply-templates />
    </figCaption>
  </xsl:template>


  <!-- Video -->
  <xsl:template match="aac:ref[@type='video']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:choose>
        <xsl:when test="string()">
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>video</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="//xhtml:figure[@class='video' and @id=$target]" mode="number" />
    </a>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='video']" mode="number">
    <xsl:if test="ancestor::xhtml:section[@class='chapter']">
      <xsl:number count="//xhtml:section[@class='chapter']" level="any"/>
      <xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:number count="//xhtml:figure[@class='video']" from="xhtml:article" level="any" />
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='video']/xhtml:figCaption">
    <figCaption>
      <xsl:text>Video </xsl:text>
      <xsl:apply-templates select=".." mode="number" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates />
    </figCaption>
  </xsl:template>

  <!-- Music example -->
  <xsl:template match="aac:ref[@type='music']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:choose>
        <xsl:when test="string()">
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>music example</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="//xhtml:figure[@class='music' and @id=$target]" mode="number" />
    </a>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='music']" mode="number">
    <xsl:number count="//xhtml:figure[@class='music']" level="any" />
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='music']/xhtml:figCaption">
    <figCaption>
      <xsl:text>Music example </xsl:text>
      <xsl:number count="xhtml:figure[@class='music']" format="1. " level="any" />
      <xsl:apply-templates />
    </figCaption>
  </xsl:template>

  <!-- Audio -->
  <xsl:template match="xhtml:audio">
    <audio controls="true">
      <xsl:apply-templates />
    </audio>
  </xsl:template>

  <xsl:template match="aac:ref[@type='audio']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:choose>
        <xsl:when test="string()">
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>audio</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="//xhtml:figure[@class='audio' and @id=$target]" mode="number" />
    </a>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='audio']" mode="number">
    <xsl:number count="//xhtml:figure[@class='audio']" level="any" />
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='audio']/xhtml:figCaption">
    <figCaption>
      <xsl:text>Audio </xsl:text>
      <xsl:number count="xhtml:figure[@class='audio']" format="1. " level="any" />
      <xsl:apply-templates />
    </figCaption>
  </xsl:template>

  <!-- Table -->
  <xsl:template match="aac:ref[@type='table']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:choose>
        <xsl:when test="string()">
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>table</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="//xhtml:table[@id=$target]" mode="number" />
    </a>
  </xsl:template>

  <xsl:template match="@data-cols" />

  <xsl:template match="xhtml:td[not(@class) and ancestor::xhtml:table/@data-cols]">
    <td>
      <xsl:attribute name="class">
        <xsl:value-of select="substring(ancestor::xhtml:table/@data-cols, position(), 1)" />
      </xsl:attribute>
      <xsl:apply-templates />
    </td>
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

  <!-- Diagram -->
  <xsl:template match="aac:ref[@type='diagram']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:choose>
        <xsl:when test="string()">
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>diagram</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
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
    <xsl:if test="//aac:citation">
      <section id="bibliography">
        <h1>References</h1>
        <xsl:apply-templates select="$references" />
      </section>
    </xsl:if>
  </xsl:template>

  <!-- Sort entries by first surname listed and date -->
  <xsl:template match="bltx:entries">
    <ul class="biblio">
      <xsl:apply-templates>
        <xsl:sort select="bltx:names[1]/bltx:name[1]/bltx:namepart[@type='family']" />
        <xsl:sort select="bltx:date[not(@type)]" />
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
      <xsl:value-of select="bltx:date[not(@type)]" />
      <xsl:apply-templates select="bltx:date[@type='orig']" />
      <xsl:text>. </xsl:text>
      <cite><xsl:apply-templates select="bltx:title" /></cite>
      <xsl:text>.</xsl:text>
      <xsl:call-template name="imprint">
        <xsl:with-param name="location" select="bltx:location" />
        <xsl:with-param name="publisher" select="bltx:publisher" />
      </xsl:call-template>
      <xsl:apply-templates select="bltx:url" />
    </li>
  </xsl:template>

  <xsl:template match="bltx:date[@type='orig']">
    <xsl:text> (</xsl:text>
    <xsl:apply-templates />
    <xsl:text>)</xsl:text>
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

  <!-- Manuscript: Like book but in quotes -->
  <xsl:template match="bltx:entry[@entrytype='report']">
    <xsl:variable name="authors">
      <xsl:call-template name="book-authors" />
    </xsl:variable>
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="bltx:date[not(@type)]" />
      <xsl:apply-templates select="bltx:date[@type='orig']" />
      <xsl:text>. </xsl:text>
      <q>
        <xsl:apply-templates select="bltx:title" />
        <xsl:text>.</xsl:text>
      </q>
      <xsl:call-template name="imprint">
        <xsl:with-param name="location" select="bltx:location" />
        <xsl:with-param name="publisher" select="bltx:institution/bltx:list/bltx:item" />
      </xsl:call-template>
      <xsl:apply-templates select="bltx:url" />
    </li>
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
      <q>
        <xsl:apply-templates select="bltx:title" />
        <xsl:text>.</xsl:text>
      </q>
      <xsl:text> </xsl:text>
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
      <q>
        <xsl:apply-templates select="bltx:title" />
        <xsl:text>.</xsl:text>
      </q>
      <xsl:text> In </xsl:text>
      <cite><xsl:apply-templates select="bltx:booktitle" /></cite>
      <xsl:if test="bltx:names[@type='editor']">
        <xsl:text>, edited by </xsl:text>
        <xsl:call-template name="name-list">
          <xsl:with-param name="names" select="bltx:names[@type='editor']" />
          <xsl:with-param name="type">firstname-first</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="bltx:pages">
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="bltx:pages" />
      </xsl:if>
      <xsl:text>. </xsl:text>
      <xsl:call-template name="imprint">
        <xsl:with-param name="location" select="bltx:location" />
        <xsl:with-param name="publisher" select="bltx:publisher" />
      </xsl:call-template>
      <xsl:apply-templates select="bltx:url" />
    </li>
  </xsl:template>

  <xsl:template name="name-list">
    <xsl:param name="names" />
    <xsl:param name="type" />
    <xsl:variable name="nameCount" select="count($names/bltx:name)" />
    <xsl:for-each select="$names/bltx:name">
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
      <xsl:call-template name="and-list">
        <xsl:with-param name="nameCount" select="$nameCount" />
        <xsl:with-param name="position" select="position()" />
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="$names/@morenames='1'">
      <xsl:text>, et al.</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="and-list">
    <xsl:param name="nameCount" />
    <xsl:param name="position" />
    <xsl:choose>
      <xsl:when test="$nameCount > 2 and $position &lt; $nameCount - 1">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:when test="$nameCount > 2 and $position = $nameCount - 1">
        <xsl:text>, and </xsl:text>
      </xsl:when>
      <xsl:when test="$nameCount = 2 and $position = 1">
        <xsl:text> and </xsl:text>
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>
  </xsl:template>

  <!-- Unpublished: Thesis, Interview, Personal communication, etc. -->
  <xsl:template match="bltx:entry[@entrytype='unpublished' or @entrytype='misc']">
    <xsl:variable name="authors">
      <xsl:call-template name="book-authors" />
    </xsl:variable>
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="bltx:date[not(@type)]" />
      <xsl:apply-templates select="bltx:date[@type='orig']" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="bltx:title" mode="quoted"/>
      <xsl:apply-templates select="bltx:note" />
    </li>
  </xsl:template>


  <!-- Process elements of bibliography entries
    - Remove TeX macros
  -->
  <xsl:template match="bltx:title | bltx:journaltitle | bltx:booktitle">
    <xsl:call-template name="macros">
      <xsl:with-param name="input" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="bltx:title" mode="quoted">
    <q>
      <xsl:call-template name="macros">
        <xsl:with-param name="input" select="." />
      </xsl:call-template>
    </q>
    <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template match="bltx:note">
    <xsl:apply-templates />
    <xsl:text>.</xsl:text>
  </xsl:template>

  <!-- Names: bltx:namepart elements can be nested; insert space if there is another one after this -->
  <xsl:template match="bltx:namepart">
    <xsl:apply-templates />
    <xsl:if test="not(position()=last())">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="imprint">
    <xsl:param name="location" />
    <xsl:param name="publisher" />
    <xsl:text> </xsl:text>
    <xsl:call-template name="macros">
      <xsl:with-param name="input" select="$location" />
    </xsl:call-template>
    <xsl:if test="$location and $publisher">
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:if test="$publisher">
      <xsl:call-template name="macros">
        <xsl:with-param name="input" select="$publisher" />
      </xsl:call-template>
    </xsl:if>
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

  <!-- Make a link for a single citation without parentheses -->
  <xsl:template match="aac:citation[@type='plain']">
    <xsl:call-template name="in-text-citation" />
  </xsl:template>

  <!-- Make a link for a single citation and enclose in parentheses -->
  <xsl:template match="aac:citation[not(@type='plain')]">
    <xsl:text> (</xsl:text>
    <xsl:call-template name="in-text-citation" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- For multiple citations, make links in semicolon-separated list -->
  <xsl:template name="citation-list" match="aac:citationList[@type='plain']">
    <xsl:for-each select="aac:citation">
      <xsl:call-template name="in-text-citation" />
      <xsl:if test="not(position()=last())">
        <xsl:text>; </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!-- For multiple citations, make links in semicolon-separated list and enclose in parentheses -->
  <xsl:template match="aac:citationList[not(@type='plain')]">
    <xsl:text> (</xsl:text>
    <xsl:call-template name="citation-list" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- Insert Author-Date text as link to reference-list entry -->
  <xsl:template name="in-text-citation">
    <xsl:variable name="ref" select="$references/bltx:entries/bltx:entry[@id=current()/@key]" />
    <xsl:if test="@pre">
      <xsl:value-of select="@pre" />
      <xsl:text> </xsl:text>
    </xsl:if>
    <a class="citation" href="#{@key}">
      <xsl:choose>
        <xsl:when test="$ref">
          <xsl:variable name="names" select="$ref/bltx:names[1]/bltx:name" />
          <xsl:for-each select="$names/bltx:namepart[@type='family']">
            <xsl:apply-templates />
            <xsl:call-template name="and-list">
              <xsl:with-param name="nameCount" select="count($names)" />
              <xsl:with-param name="position" select="position()" />
            </xsl:call-template>
          </xsl:for-each>
          <xsl:if test="$ref/bltx:names[@type='author']/@morenames='1'">
            <xsl:text> et al.</xsl:text>
          </xsl:if>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$ref/bltx:date[not(@type)]" />
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
    <xsl:if test="string()">
      <xsl:text>, </xsl:text>
      <xsl:apply-templates />
    </xsl:if>
  </xsl:template>

  <!-- MODULAR DESIGN (web vs. print) -->

  <xsl:template match="*[@data-medium='print']" />

  <xsl:template match="@data-medium" />

  <!-- TABLE OF CONTENTS -->
  <xsl:template match="aac:tableofcontents">
    <section class="toc">
      <h1>Contents</h1>
      <ul>
        <xsl:apply-templates select="//xhtml:section[not(@class='toc') and not(ancestor::aac:comment)]" mode="toc" />
        <xsl:apply-templates select="../aac:bibliography" mode="toc" />
      </ul>
    </section>
  </xsl:template>

  <xsl:template match="xhtml:section" mode="toc">
    <xsl:if test="xhtml:h1">
    <li>
      <xsl:apply-templates select="xhtml:h1" mode="toc" />
      <xsl:if test="xhtml:section">
        <ul>
          <xsl:apply-templates select="xhtml:section/xhtml:h2" mode="toc" />
        </ul>
      </xsl:if>
    </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xhtml:h1" mode="toc">
    <a href="#{../@id}"><xsl:apply-templates /></a>
  </xsl:template>

  <xsl:template match="xhtml:h2" mode="toc">
    <li><a href="#{../@id}"><xsl:apply-templates /></a></li>
  </xsl:template>

  <xsl:template match="aac:bibliography" mode="toc">
    <xsl:if test="//aac:citation">
      <li><a href="#bibliography">References</a></li>
    </xsl:if>
  </xsl:template>

  <!-- TODO use real accidentals in music font in matrix header -->
  <xsl:template match="aac:pitch_matrix">
    <thead>
      <tr class="pitch-number-head">
        <th></th>
        <th scope="row" class="pitch-head">Pitch</th>
        <th>0</th>
        <th>1</th>
        <th>2</th>
        <th>3</th>
        <th>4</th>
        <th>5</th>
        <th>6</th>
        <th>7</th>
        <th>8</th>
        <th>9</th>
        <th>10</th>
        <th>11</th>
      </tr>
      <tr>
        <th></th>
        <th></th>
        <xsl:for-each select="tokenize(@gamut, '\s+')">
          <th>
            <xsl:choose>
              <xsl:when test="contains(., '♭')">
                <xsl:value-of select="replace(., '♭', '')" />
                <xsl:call-template name="flat" />
              </xsl:when>
              <xsl:when test="contains(., '♯')">
                <xsl:value-of select="replace(., '♯', '')" />
                <xsl:call-template name="sharp" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="." />
              </xsl:otherwise>
            </xsl:choose>
          </th>
        </xsl:for-each>
      </tr>
    </thead>
    <tbody>
      <xsl:apply-templates select="aac:mrow" />
    </tbody>
  </xsl:template>


  <xsl:variable name="pitch_matrix_template">
    <td data-n="0" class="pitch_false"></td>
    <td data-n="1" class="pitch_false"></td>
    <td data-n="2" class="pitch_false"></td>
    <td data-n="3" class="pitch_false"></td>
    <td data-n="4" class="pitch_false"></td>
    <td data-n="5" class="pitch_false"></td>
    <td data-n="6" class="pitch_false"></td>
    <td data-n="7" class="pitch_false"></td>
    <td data-n="8" class="pitch_false"></td>
    <td data-n="9" class="pitch_false"></td>
    <td data-n="10" class="pitch_false"></td>
    <td data-n="11" class="pitch_false"></td>
  </xsl:variable>

  <xsl:template match="aac:mrow">
    <tr data-n="{@n}">
    <xsl:choose>
      <xsl:when test="position()=1">
        <th class="song-head">Song</th>
      </xsl:when>
      <xsl:otherwise>
        <th></th>
      </xsl:otherwise>
    </xsl:choose>
      <th scope="row"><xsl:value-of select="@n" /></th>
      <xsl:apply-templates select="$pitch_matrix_template">
        <xsl:with-param name="pcset" select="tokenize(@pcset, '\s+')" />
      </xsl:apply-templates>
    </tr>
  </xsl:template>

  <xsl:template match="xhtml:td[@class='pitch_false']">
    <xsl:param name="pcset" />
    <xsl:choose>
      <xsl:when test="@data-n = $pcset">
        <td data-n="{@data-n}" class="pitch_true">■</td>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="aac:usd">
    <xsl:text>$</xsl:text>
  </xsl:template>

  <xsl:template match="aac:inlineMusic">
    <xsl:variable name="scale-factor">
      <xsl:choose>
        <xsl:when test="@type='staff' or @type='rhythm-threelines'">3</xsl:when>
        <xsl:when test="@type='rhythm-lyrics' or @type='rhythm-twolines'">2</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <img class="inline" src="{@src}" type="image/png" alt="Music notation">
      <xsl:attribute name="data-scale">
        <xsl:value-of select="$scale-factor" />
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- Move trailing punctuation inside quotation marks -->
  <xsl:template match="xhtml:q[following-sibling::node()[1][self::text()[starts-with(., ',') or starts-with(., '.')]]]">
    <q>
      <xsl:apply-templates />
      <xsl:value-of select="substring(following-sibling::text()[1], 1, 1)" />
    </q>
  </xsl:template>

  <xsl:template match="text()[preceding-sibling::node()[1][self::xhtml:q] and (starts-with(., ',') or starts-with(., '.'))]">
    <xsl:value-of select="substring(., 2)" />
  </xsl:template>

  <xsl:template match="aac:prime">
    <span class="symbol">′</span> <!-- U+2302 -->
  </xsl:template>

  <xsl:template match="aac:repeat">
    <span class="music"></span> <!-- U+E040, start repeat -->
    <xsl:apply-templates />
    <span class="music"></span> <!-- U+E041, end repeat -->
  </xsl:template>
  <!-- NB U+E042 is the end+start repeat sign -->

  <xsl:template match="aac:math">
    <span class="math">
      <xsl:apply-templates />
    </span>
  </xsl:template>

  <xsl:template match="aac:paren">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="aac:dots">
    <xsl:text>[...]</xsl:text>
  </xsl:template>


  <xsl:template match="aac:TODO">
    <span class="TODO">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
    </span>
  </xsl:template>

  <xsl:template match="@note">
    <span class="tooltip">
      <xsl:value-of select="." />
    </span>
  </xsl:template>


</xsl:stylesheet>


