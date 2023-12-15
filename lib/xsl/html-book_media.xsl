<?xml version="1.0" encoding="utf-8"?>
<!-- 
2023/07/12
Produce an HTML page with all the audio and video examples from the book 
-->
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aac="https://www.senecasongs.earth"
  exclude-result-prefixes="aac">

  <xsl:output method="html" version="5.0" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:template match="comment()" priority="1" />

  <xsl:template match="@* | node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xhtml:html">
    <html lang="en">
      <head>
        <title>Songs at the Woods’ Edge: Media</title>
        <link rel="stylesheet" href="css/book-media.css" />
        <meta name="author" content="Bill Crouse, Sr., and Andrew A. Cashner" />
        <meta name="copyright" content="Copyright © 2023 Bill Crouse, Sr., and Andrew A. Cashner" />
        <meta name="publisher" content="Rochester, NY: Peacemaker Press, 2023" />
      </head>
      <body>
        <header>
          <h1 class="title-site">Songs at the Woods’ Edge</h1>
          <h1 class="title-page">Complete Audio and Video Examples</h1>
          <h2 class="author">Bill Crouse, Sr., and Andrew A. Cashner</h2>
          <img class="cover"
                src="media/Huyck_Rd-meadow.jpg"
                alt="A narrow country road passes through a meadow with forest and farmland in the distance under a bright cloudy sky, on Huyck Road near Farmersville Station, NY, in May 2023 (Photo by Andrew Cashner)" />
        </header>
        <main>
          <section class="toc">
            <h1>Contents</h1>
            <ul>
              <xsl:apply-templates select="//xhtml:section[@class='chapter' and not(@class='toc')]" mode="toc" />
            </ul>
          </section>
          <p>
            This page includes all the audio and video examples referenced in the <a href="book.pdf">PDF version</a> of <cite>Songs at the Woods’ Edge</cite>.
          </p>
          <xsl:apply-templates select="//xhtml:section[@class='chapter']" />
        </main>
        <footer>
          <p>
            Copyright © 2023 Bill Crouse, Sr., and Andrew A. Cashner.
          </p>
          <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
        </footer>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="xhtml:section" mode="toc">
    <xsl:if test="xhtml:h1">
      <li>
        <xsl:apply-templates select="." mode="number" />
        <xsl:apply-templates select="xhtml:h1" mode="toc" />
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xhtml:h1" mode="toc">
    <a href="#{../@id}"><xsl:apply-templates /></a>
  </xsl:template>

 

  <xsl:template match="xhtml:section[@class='chapter']">
    <xsl:if test=".//xhtml:figure[@class='audio' or @class='video']">
      <section class="chapter" id="{@id}">
        <xsl:apply-templates select="xhtml:h1" />
        <xsl:apply-templates select=".//xhtml:figure[@class='audio' or @class='video']" />
      </section>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xhtml:h1">
    <h1>
      <xsl:text>Chapter </xsl:text>
      <xsl:apply-templates select="ancestor::xhtml:section[@class='chapter']" mode="number" />
      <xsl:apply-templates />
    </h1>
  </xsl:template>

  <xsl:template match="xhtml:section[@class='chapter']" mode="number">
    <xsl:number count="//xhtml:section[@class='chapter']" format="1. " level="any" />
  </xsl:template>

  <xsl:template match="aac:youtube">
    <iframe 
      src="https://www.youtube.com/embed/{@key}" 
      title="YouTube video player" 
      frameborder="0" 
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
      allowfullscreen="true"></iframe>
  </xsl:template>

  <xsl:template match="xhtml:audio">
    <audio controls="true">
      <xsl:apply-templates />
    </audio>
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

  <xsl:template match="xhtml:figure[@class='video']/xhtml:figCaption">
    <figCaption>
      <xsl:text>Video </xsl:text>
      <xsl:apply-templates select=".." mode="number" />
      <xsl:apply-templates />
    </figCaption>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='audio']/xhtml:figCaption">
    <figCaption>
      <xsl:text>Audio </xsl:text>
      <xsl:apply-templates select=".." mode="number" />
      <xsl:apply-templates />
    </figCaption>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='video']" mode="number">
    <xsl:number count="//xhtml:section[@class='chapter']" level="any" format="1."/>
    <xsl:number count="//xhtml:figure[@class='video']" from="xhtml:article" level="any" format="1. " />
  </xsl:template>
 
  <xsl:template match="xhtml:figure[@class='audio']" mode="number">
    <xsl:number count="//xhtml:section[@class='chapter']" level="any" format="1."/>
    <xsl:number count="//xhtml:figure[@class='audio']" from="xhtml:article" level="any" format="1. " />
  </xsl:template>


  <xsl:template match="*[@data-medium='no-book']" />
 
</xsl:stylesheet>
