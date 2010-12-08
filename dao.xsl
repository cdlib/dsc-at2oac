<xsl:stylesheet
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- root template -->
  <xsl:template match="/|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="dao[not(parent::did) and not(parent::archdesc)]">
    <xsl:variable name="plusone">
      <xsl:value-of select="number(substring(name(..),2,2))+1"/>
    </xsl:variable>
    <xsl:variable name="cD">
      <xsl:choose>
        <xsl:when test="$plusone &lt; 10">
          <xsl:text>c0</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>c1</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- xsl:element name="{ if ( $pluseone &lt; 10 ) then ('c0') else ('c1')}{$plusone}" -->
    <xsl:element name="{$cD}{number($plusone) mod 10}">
      <did>
        <unittitle><xsl:value-of select="daodesc/p"/></unittitle>
        <dao href="{@href}"/>
      </did>
    </xsl:element>
  </xsl:template>

  <!-- identity -->
  <xsl:template match="node()|@*">
    <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
