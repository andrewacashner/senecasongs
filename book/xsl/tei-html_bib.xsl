<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  exclude-result-prefixes="tei">

  <xsl:template match="tei:listBibl">
    <ul class="biblio">
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="tei:biblStruct[@type='book']">
    <xsl:variable name="authors">
      <xsl:choose>
        <xsl:when test="tei:monogr/tei:author">
          <xsl:call-template name="name-list">
            <xsl:with-param name="names" select="tei:monogr/tei:author" />
            <xsl:with-param name="type">lastname-first</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="tei:monogr/tei:editor">
          <xsl:call-template name="name-list">
            <xsl:with-param name="names" select="tei:monogr/tei:editor" />
            <xsl:with-param name="type">lastname-first</xsl:with-param>
          </xsl:call-template>
          <xsl:choose>
            <xsl:when test="count(tei:monogr/tei:editor/tei:persName) > 1">
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
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="tei:monogr/tei:imprint/tei:date/@when" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="tei:monogr/tei:title[@level='m']" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="tei:monogr/tei:imprint" />
      <xsl:call-template name="bib-url">
        <xsl:with-param name="url" select="tei:monogr/tei:ref" />
      </xsl:call-template>
    </li>
  </xsl:template>

  <xsl:template match="tei:biblStruct[@type='article']">
    <xsl:variable name="authors">
      <xsl:call-template name="name-list">
        <xsl:with-param name="names" select="tei:analytic/tei:author" />
        <xsl:with-param name="type">lastname-first</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="tei:monogr/tei:imprint/tei:date/@when" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="tei:analytic/tei:title" />
      <xsl:text>. </xsl:text>
      <xsl:call-template name="journal-imprint">
        <xsl:with-param name="imprint" select="tei:monogr" />
      </xsl:call-template>
      <xsl:text>.</xsl:text>
      <xsl:call-template name="bib-url">
        <xsl:with-param name="url" select="tei:analytic/tei:ref" />
      </xsl:call-template>
    </li>
  </xsl:template>
  
  <xsl:template match="tei:biblStruct[@type='inCollection']">
    <xsl:variable name="authors">
      <xsl:call-template name="name-list">
        <xsl:with-param name="names" select="tei:analytic/tei:author" />
      </xsl:call-template>
    </xsl:variable>
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="tei:monogr/tei:imprint/tei:date/@when" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="tei:analytic/tei:title[@level='a']" />
      <xsl:text>. In </xsl:text>
      <xsl:apply-templates select="tei:monogr/tei:title[@level='m']" />
      <xsl:text>, edited by </xsl:text>
      <xsl:call-template name="name-list">
        <xsl:with-param name="names" select="tei:monogr/tei:editor" />
        <xsl:with-param name="type">firstname-first</xsl:with-param>
      </xsl:call-template>
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="tei:monogr/tei:biblScope[@unit='page']" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="tei:monogr/tei:imprint/tei:pubPlace" />
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="tei:monogr/tei:imprint/tei:publisher" />
      <xsl:text>.</xsl:text>
      <xsl:call-template name="bib-url">
        <xsl:with-param name="url" select="tei:analytic/tei:ref" />
      </xsl:call-template>
    </li>
  </xsl:template>

  <xsl:template name="name-list">
    <xsl:param name="names" />
    <xsl:param name="type" />
    <xsl:variable name="nameCount" select="count($names/tei:persName)" />
    <xsl:for-each select="$names/tei:persName">
      <xsl:if test="$nameCount > 2 and not(position()=1) and not(position()=last())">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:if test="$nameCount > 1 and position()=last()">
        <xsl:text>, and </xsl:text>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="not($type='firstname-first') and position()=1">
          <xsl:apply-templates select="tei:surname" />
          <xsl:if test="tei:forename">
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="tei:forename" />
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="tei:forename">
            <xsl:apply-templates select="tei:forename" />
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="tei:surname" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:title[@level='m' or @level='j']">
    <cite><xsl:apply-templates /></cite>
  </xsl:template>

  <xsl:template match="tei:monogr/tei:imprint">
    <xsl:if test="tei:pubPlace">
      <xsl:apply-templates select="tei:pubPlace" />
      <xsl:if test="tei:publisher">
        <xsl:text>: </xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="tei:publisher">
      <xsl:apply-templates select="tei:publisher" />
    </xsl:if>
    <xsl:if test="tei:pubPlace or tei:publisher">
      <xsl:text>.</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:analytic/tei:title">
    <q><xsl:apply-templates /></q>
  </xsl:template>

  <xsl:template name="journal-imprint">
    <xsl:param name="imprint" />
    <xsl:apply-templates select="$imprint/tei:title[@level='j']" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="$imprint/tei:biblScope[@unit='volume']" />
    <xsl:if test="$imprint/tei:biblScope[@unit='issue']">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="$imprint/tei:biblScope[@unit='issue']" />
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:text>: </xsl:text>
    <xsl:apply-templates select="$imprint/tei:biblScope[@unit='page']" />
  </xsl:template>

  <xsl:template match="tei:biblScope[@unit='page']">
    <xsl:value-of select="@from" />
    <xsl:text>–</xsl:text>
    <xsl:value-of select="@to" />
  </xsl:template>

  <xsl:template name="bib-url">
    <xsl:param name="url" />
    <xsl:if test="$url">
      <a href="{$url/@href}">
        <xsl:value-of select="$url" />
      </a>
      <xsl:text>.</xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

