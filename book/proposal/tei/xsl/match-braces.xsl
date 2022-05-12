<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:template match="@* | node()" priority="1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()" priority="1.1">
    <xsl:call-template name="match-braces">
      <xsl:with-param name="string" select="string()" />
      <xsl:with-param name="stack" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="match-braces">
    <xsl:param name="string" />
    <xsl:param name="stack" />
    <xsl:choose>
      <xsl:when test="contains($string, '{') and contains($string, '}')">
        <xsl:variable name="after-open-brace" 
        select="substring-after($string, '{')" />
        <xsl:variable name="before-close-brace" 
        select="substring-before($after-open-brace, '}')" />

        <xsl:choose>
          <xsl:when test="contains($after-open-brace, '{')">
            <xsl:call-template name="match-braces">
              <xsl:with-param name="string" select="$after-open-brace" />
              <xsl:with-param name="stack" select="concat($stack, $after-open-brace)" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($stack, $before-close-brace)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>


