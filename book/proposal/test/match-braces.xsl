<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:template match="@* | node()" priority="1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <!-- need to recursively look through the whole macro dictionary -->
  <!-- element substitution doesn't work for mkbibparens -->
  <!-- something like this: 
  <dictionary>
    <macro key="mkbibquote" value="q" />
    <macro key="mkbibqemph" value="emph" />
    </dictionary>
  -->

  <xsl:template match="text()" priority="1.1">
    <xsl:call-template name="mkbibquote" />
    <!--    <xsl:call-template name="mkbibemph" /> -->
  </xsl:template>

  <xsl:template name="mkbibemph">
    <xsl:call-template name="tex-command-arg">
      <xsl:with-param name="string" select="string()" />
      <xsl:with-param name="csname">mkbibemph</xsl:with-param>
      <xsl:with-param name="substitute-element">emph</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="mkbibquote">
    <xsl:call-template name="tex-command-arg">
      <xsl:with-param name="string" select="string()" />
      <xsl:with-param name="csname">mkbibquote</xsl:with-param>
      <xsl:with-param name="substitute-element">q</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="tex-command-arg">
    <xsl:param name="string" />
    <xsl:param name="csname" />
    <xsl:param name="substitute-element" />
    <xsl:choose>
      <xsl:when test="contains($string, '\')">
        <xsl:variable name="before-command" select="substring-before($string, '\')" />
        <xsl:variable name="after-slash" select="substring-after($string, '\')" />
        <xsl:variable name="this-csname" select="substring-before($after-slash, '{')" />
        <xsl:variable name="after-command" select="substring-after($after-slash, $this-csname)" />

        <xsl:choose>
          <xsl:when test="$this-csname = $csname">
            <xsl:variable name="argument">
              <xsl:call-template name="within-braces">
                <xsl:with-param name="string" select="$after-command" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:element name="{$substitute-element}">
              <xsl:value-of select="$argument" />
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$string" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="within-braces">
    <xsl:param name="string" />
    <xsl:choose>
      <xsl:when test="contains($string, '{') and contains($string, '}')">
        <xsl:variable name="brace-range">
          <xsl:call-template name="substring-in-braces">
            <xsl:with-param name="string" select="$string" />
            <xsl:with-param name="level" select="0" />
            <xsl:with-param name="index" select="1" />
            <xsl:with-param name="start" select="1" />
            <xsl:with-param name="end" select="1" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="start-index" select="$brace-range/range/start" />
        <xsl:variable name="end-index" select="$brace-range/range/end" />
        <xsl:variable name="substring-length" select="$end-index - $start-index" />

        <xsl:variable name="before-delimited-substring" select="substring($string, 1, $start-index - 1)" />
        <xsl:variable name="delimited-substring" select="substring($string, $start-index, $substring-length)" />
        <xsl:variable name="after-delimited-substring" select="substring($string, $end-index)" />

        <xsl:value-of select="$delimited-substring" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="substring-in-braces">
    <xsl:param name="string" />
    <xsl:param name="level" />
    <xsl:param name="index" />
    <xsl:param name="start" />
    <xsl:param name="end" />

    <xsl:choose>
      <xsl:when test="not($string) and ($level = 0)">
        <range>
          <start><xsl:value-of select="$start" /></start>
          <end><xsl:value-of select="$end" /></end>
        </range>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="thisChar" select="substring($string, 1, 1)" />
        <xsl:choose>
          <xsl:when test="$thisChar = '{'">
            <xsl:variable name="thisStart"> 
              <xsl:choose>
                <xsl:when test="$level = 0">
                  <xsl:value-of select="$index + 1" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$start" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="substring-in-braces">
              <xsl:with-param name="string" select="substring($string, 2)" />
              <xsl:with-param name="level" select="$level + 1" />
              <xsl:with-param name="index" select="$index + 1" />
              <xsl:with-param name="start" select="$thisStart" />
              <xsl:with-param name="end" select="$end" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$thisChar = '}'">
            <xsl:choose>
              <xsl:when test="$level = 1">
                <xsl:call-template name="substring-in-braces">
                  <xsl:with-param name="string" />
                  <xsl:with-param name="level" select="0" />
                  <xsl:with-param name="index" />
                  <xsl:with-param name="start" select="$start" />
                  <xsl:with-param name="end" select="$index" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="substring-in-braces">
                  <xsl:with-param name="string" select="substring($string, 2)" />
                  <xsl:with-param name="level" select="$level - 1" />
                  <xsl:with-param name="index" select="$index + 1" />
                  <xsl:with-param name="start" select="$start" />
                  <xsl:with-param name="end" select="$end" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="substring-in-braces">
              <xsl:with-param name="string" select="substring($string, 2)" />
              <xsl:with-param name="level" select="$level" />
              <xsl:with-param name="index" select="$index + 1" />
              <xsl:with-param name="start" select="$start" />
              <xsl:with-param name="end" select="$end" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>



