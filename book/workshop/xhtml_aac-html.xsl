<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml"
  xmlns:aac="https://www.senecasongs.earth">

  <xsl:output method="html" version="5.0" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

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

  <xsl:template match="xhtml:video[@class='youtube']">
    <iframe 
      width="560" height="315" 
      src="https://www.youtube.com/embed/{@src}" 
      title="YouTube video player" 
      frameborder="0" 
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
      allowfullscreen="true"></iframe>
</xsl:template>

  <xsl:template match="xhtml:video[not(@class='youtube')]">
    <video width="560" height="315" controls="true">
      <source src="{@src}" />
    </video>
  </xsl:template>

  <xsl:template match="xhtml:footer">
    <footer>
      <p>
      Copyright © 2024 Bill Crouse, Sr., and Andrew A. Cashner.
      </p>
      <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
    </footer>
  </xsl:template>

  <xsl:template match="aac:pcset">
    <code>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="@n" />
      <xsl:text>/</xsl:text>
    </code>
  </xsl:template>

  <xsl:template match="aac:degree">
    <math>
      <mi>
        <xsl:call-template name="accid">
          <xsl:with-param name="accid" select="@accid" />
        </xsl:call-template>
      </mi>
      <mover>
        <mi>
          <xsl:value-of select="@n" />
        </mi>
        <mi>&#x02c6;</mi>
      </mover>
    </math>
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

  <!-- Automatic references -->
   <xsl:template match="aac:ref">
    <a href="{@href}">
      <xsl:apply-templates />
      <!-- auto number TODO -->
    </a>
  </xsl:template>

  <!-- Bring in the XML bibliography file -->
  <xsl:variable name="bibfile" select="document(concat(environment-variable('PWD'), '/biblio.bltxml'))" />

  <!-- Create a list of in-text citation keys in this document -->
  <xsl:variable name="citations" select="//aac:bibref" />

  <!-- Generate the bibliography/reference list instead of the placeholder -->
  <xsl:template match="aac:bibliography">
    <xsl:apply-templates select="$bibfile/bltx:entries" />
  </xsl:template>
  <!-- TODO deal with colons in ids
    <xsl:if test="@id = $citations/replace(substring(@href, 2), ':', '-')">
  -->

  <!-- Create list of author-date pairs to put inside parenthetical citations -->
  <xsl:template match="aac:bibref">
    <xsl:variable name="bibKey" select="substring(@href, 2)" />
    <xsl:variable name="pages" select="string()" />
    <xsl:variable name="ref" select="$bibfile//bltx:entry[@id=$bibKey]" />

    <xsl:variable name="author-list">
      <xsl:variable name="authors">
        <xsl:value-of select="$ref//bltx:names[@type='author']/bltx:name/bltx:namepart[@type='family']" separator=" and " />
        <!-- TODO spaces between name parts -->
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$authors">
          <xsl:value-of select="$authors" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$ref//bltx:names[@type='editor']/bltx:name/bltx:namepart[@type='family']" separator=" and " />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <a class="citation" href="{@href}">
      <xsl:choose>
        <xsl:when test="$ref">
          <xsl:value-of select="$author-list" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="$ref//bltx:date" />
          <xsl:if test="$pages">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$pages" />
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <strong><xsl:value-of select="$bibKey" /></strong>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>
  
    <!-- TODO sort alphabetically -->
  <!-- Convert the reference list -->
  <xsl:template match="bltx:entries">
    <section id="bibliography">
      <h1>References</h1>
      <ul class="biblio">
        <xsl:apply-templates />
      </ul>
    </section>
  </xsl:template>

  <!-- Convert bibliography entries
    - Select only those entries from the bibliography that have a matching key in the in-text citations.
    - The in-text citations are written in the format `#Author:Keyword` but are converted to the format `Author-Keyword`. TODO
  --> 
  <xsl:template match="bltx:entry[@entrytype='book']">
    <xsl:if test="@id = $citations/substring(@href, 2)">
      <xsl:variable name="authors">
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
      </xsl:variable>
      <li id="{@id}"> <!-- TODO colon -->
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
    </xsl:if>
  </xsl:template>

  <xsl:template match="bltx:entry[@entrytype='article']">
    <xsl:if test="@id = $citations/substring(@href, 2)">
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
        </q>
        <xsl:text>. </xsl:text>
        <cite>
          <xsl:apply-templates select="bltx:journaltitle" />
        </cite>
        <xsl:text> </xsl:text>
        <xsl:if test="bltx:volume">
          <xsl:value-of select="bltx:volume" />
        </xsl:if>
        <xsl:if test="bltx:number">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="bltx:number" />
          <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="bltx:pages" />
        <xsl:text>.</xsl:text>
        <xsl:apply-templates select="bltx:url" />
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="bltx:entry[@entrytype='incollection']">
    <xsl:if test="@id = $citations/substring(@href, 2)">
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
        <q>
          <xsl:apply-templates select="bltx:title" />
        </q>
        <xsl:text>. In </xsl:text>
        <cite>
          <xsl:apply-templates select="bltx:booktitle" />
        </cite>
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
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="bltx:entry" />

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

  <xsl:template match="bltx:title | bltx:journaltitle | bltx:booktitle">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="bltx:namepart">
    <xsl:choose>
      <xsl:when test="bltx:namepart">
        <xsl:value-of select="bltx:namepart" separator=" " />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="bltx:location">
    <xsl:text> </xsl:text>
    <xsl:apply-templates />
    <xsl:text>: </xsl:text>
  </xsl:template>

  <xsl:template match="bltx:publisher">
    <xsl:apply-templates />
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

</xsl:stylesheet>


