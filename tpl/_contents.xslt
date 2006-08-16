<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html"/>
	<xsl:param name="SRC"/>
	
	<xsl:variable name="mytitle" select="/html/head/title"/>
	<xsl:variable name="contentsxml" select="document(concat($SRC, '/contents.xml'))"/>
	
	<xsl:key name="title" match="page"
		use="document(concat($SRC, '/', @src))/html/head/title"/>
	
	<xsl:template match="page" mode="site-contents">
		<xsl:variable name="child" select="document(concat($SRC, '/', @src))"/>
		<xsl:variable name="childtitle">
			<xsl:value-of select="$child/html/head/title"/>
		</xsl:variable>
		
		<xsl:element name="a">
			<xsl:if test="$childtitle = $mytitle">
				<xsl:attribute name="class">
					<xsl:text>selected</xsl:text>
				</xsl:attribute>
			</xsl:if>
			
			<xsl:attribute name="href">
				<xsl:value-of select="$DESTURL"/>
				<xsl:text>/</xsl:text>
				<xsl:choose>
					<xsl:when test="substring(@src, string-length(@src)-1) = '.i'">
						<xsl:value-of select="substring(@src, 1, string-length(@src)-2)"/>
						<xsl:text>.html</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@src"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<xsl:value-of select="$childtitle"/>
		</xsl:element>
	</xsl:template>

	<xsl:template name="site-contents">
		<xsl:variable name="currentnode" select="$contentsxml//page[document(concat($SRC, '/', @src))/html/head/title = $mytitle]"/>
		<xsl:variable name="hierarchy" select="$currentnode/ancestor::*"/>
		
		<div class="toclist">
			<!-- Parents -->
			<xsl:for-each select="$hierarchy">
				<xsl:variable name="child" select="document(concat($SRC, '/', @src))"/>
				<xsl:variable name="childtitle">
					<xsl:value-of select="$child/html/head/title"/>
				</xsl:variable>
				<div class="parent">
					<xsl:apply-templates select="." mode="site-contents"/>
				</div>
			</xsl:for-each>
			
			<xsl:choose>
				<xsl:when test="$currentnode/page">
					<!-- The current page has children. Show the page itself. -->
					<div class="parent">
						<xsl:apply-templates select="$currentnode" mode="site-contents"/>
					</div>
					
					<!-- Children, if any -->
					<xsl:for-each select="$currentnode/page">
						<div class="child">
							<xsl:apply-templates select="." mode="site-contents"/>
						</div>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<!-- The current page has no children, so show siblings instead. -->
					<xsl:for-each select="$currentnode/../page">
						<div class="child">
							<xsl:apply-templates select="." mode="site-contents"/>
						</div>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template name="path-to-page">
		<xsl:variable name="currentnode" select="$contentsxml//page[document(concat($SRC, '/', @src))/html/head/title = $mytitle]"/>
		
		<xsl:for-each select="$currentnode/ancestor::*">
			<xsl:if test="position() > 1">
				<xsl:text> / </xsl:text>
			</xsl:if>
			<xsl:apply-templates select="." mode="site-contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="navigation-block">
		<xsl:variable name="currentnode" select="$contentsxml//page[document(concat($SRC, '/', @src))/html/head/title = $mytitle]"/>
		
		<xsl:variable name="prevnode" select="$currentnode/preceding-sibling::*[1]"/>
		<xsl:variable name="upnode" select="$currentnode/parent::*"/>
		<xsl:variable name="nextnode" select="$currentnode/following-sibling::*[1]"/>
		
		<td class="navigation-cell">
			<xsl:if test="$prevnode">
				<b>Previous</b><br/>
				<xsl:apply-templates select="$prevnode" mode="site-contents"/>
			</xsl:if>
		</td>
		
		<td class="navigation-cell">
			<xsl:if test="$upnode">
				<b>Up</b><br/>
				<xsl:apply-templates select="$upnode" mode="site-contents"/>
			</xsl:if>
		</td>
		
		<td class="navigation-cell">
			<xsl:if test="$nextnode">
				<b>Next</b><br/>
				<xsl:apply-templates select="$nextnode" mode="site-contents"/>
			</xsl:if>
		</td>
	</xsl:template>
	
	<xsl:template match="*" mode="site-contents">
		<xsl:message terminate="yes">
			<xsl:text>Unsupported tag </xsl:text>
			<xsl:value-of select="name(.)"/>
		</xsl:message>
	</xsl:template>
</xsl:stylesheet>
