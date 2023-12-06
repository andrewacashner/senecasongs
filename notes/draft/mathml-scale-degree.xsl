<xsl:template match="aac:degree">
  <m:math>
    <xsl:if test="@accid">
      <m:mi>
        <xsl:call-template name="accid">
          <xsl:with-param name="accid" select="@accid" />
        </xsl:call-template>
      </m:mi>
    </xsl:if>
    <m:mover>
      <m:mi>
        <xsl:value-of select="@n" />
      </m:mi>
      <m:mi><span class="symbol">&#x02c6;</span></m:mi>
    </m:mover>
  </m:math>
</xsl:template>
