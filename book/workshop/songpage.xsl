<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
        <xsl:value-of select="@accid" />
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
    <xsl:value-of select="@accid" />
    <sub>
      <xsl:value-of select="@oct" />
    </sub>
  </xsl:template>



</xsl:stylesheet>


