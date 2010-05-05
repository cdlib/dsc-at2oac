<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:ead="urn:isbn:1-931666-22-9"
  xmlns="urn:isbn:1-931666-22-9">

<!-- set strip-namespace to anything other than yes to
     disable default stripping
-->
<xsl:param name="strip-namespace" select="'yes'"/>

<!-- set label-to-physdesc to anything other than '' to 
     disable default removal of mis-labeled container/@label's
     and they will be converted to sibling <physdesc>'s instead
-->
<xsl:param name="label-to-physdesc"/> 

<!-- supply alternate dsc type or use default -->
<xsl:param name="dsc-type" select="'combined'"/>

<!-- supply repositorycode or use default -->
<xsl:param 
	name="repositorycode" 
	select="/ead:ead/ead:eadheader/ead:eadid/@mainagencycode"/>

<!-- supply countrycode or use default -->
<xsl:param 
	name="countrycode" 
	select="translate(
		/ead:ead/ead:eadheader/ead:eadid/@countrycode,
		'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' )" />

<xsl:variable name="namespace">
  <xsl:choose>
    <xsl:when test="$strip-namespace = 'yes'"/>
    <xsl:otherwise>
      <xsl:text>urn:isbn:1-931666-22-9</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:param name="label-to-physdesc"/> 

<!-- root template -->
<xsl:template match="/|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
</xsl:template>

<!-- add dsc/@type -->
<xsl:template match="ead:dsc[parent::ead:archdesc and position()=1]">
  <xsl:element name="{name()}" namespace="{$namespace}">
    <xsl:apply-templates select="@*"/>
    <xsl:if test="not(@type) and $dsc-type!=''">
      <xsl:attribute name="type">
        <xsl:value-of select="$dsc-type"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- copy repositorycode and countrycode from eadid to unitid in
     archdesc/did/unittitle
-->
<xsl:template match="ead:unitid[parent::ead:did and not(ancestor::ead:dsc)]">
  <xsl:element name="{name()}" namespace="{$namespace}">
    <xsl:apply-templates select="@*"/>
    <xsl:if test="not(@repositorycode) and $repositorycode!=''">
      <xsl:attribute name="repositorycode">
        <xsl:value-of select="$repositorycode"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="not(@countrycode) and $countrycode!=''">
      <xsl:attribute name="countrycode">
        <xsl:value-of select="$countrycode"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- upper-case the country code -->
<xsl:template match="@countrycode[parent::ead:eadid]">
  <xsl:attribute name="countrycode">
    <xsl:value-of select="$countrycode"/>
  </xsl:attribute>
</xsl:template>

<!-- copy overloaded container labels to sibling physdesc -->
<xsl:template match="ead:container[@label]">
  <xsl:element name="{name()}" namespace="{$namespace}">
    <xsl:apply-templates select="@*[name()!='label'] | node() "/>
  </xsl:element>
  <xsl:if test="$label-to-physdesc">
    <xsl:element name="physdesc" namespace="{$namespace}">
      <xsl:value-of select="@label"/>
    </xsl:element>
  </xsl:if>
</xsl:template>

<!-- modified identity templates -->

<xsl:template match="*">
  <xsl:choose>
    <xsl:when test="$namespace!=''">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="{local-name()}" namespace="{$namespace}">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@*">
  <xsl:choose>
    <xsl:when test="$namespace!=''">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="{local-name()}">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@xsi:*">
  <xsl:choose>
    <xsl:when test="$namespace!=''">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
<!--

Copyright (c) 2010, Regents of the University of California
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, 
  this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, 
  this list of conditions and the following disclaimer in the documentation 
  and/or other materials provided with the distribution.
- Neither the name of the University of California nor the names of its
  contributors may be used to endorse or promote products derived from this 
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
-->
