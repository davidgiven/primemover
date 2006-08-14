<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	
	<xsl:import href="_htmlx.xslt"/>
	<xsl:import href="_contents.xslt"/>
	<xsl:output method="xml"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		indent="yes"
		encoding="UTF-8"/>
	
	<xsl:param name="SRC"/>
	<xsl:param name="DESTURL"/>
	<xsl:variable name="DOCUMENT" select="."/>
	
	<xsl:key name="parentheader"
		match="html/body/*[starts-with(local-name(),'h')]"
		use="generate-id(preceding-sibling::*[local-name()=concat('h', number(substring-after(local-name(current()),'h')) - 1)][1])"/>

	<xsl:template match="/">
		<html>
			<head>
				<title><xsl:value-of select="html/head/title"/></title>
				<link rel="stylesheet" type="text/css" href="{$DESTURL}/global.css"/>
				<link rel="home" type="text/html" href="/"/>
			</head>
			
			<body>
				<table cols="4" rows="1" width="100%" class="top-table">
					<tr>
						<td class="boxed top-logo">
							Prime Mover
						</td>

						<td class="boxed top-maintitle" colspan="2">
							<div class="toc-path"><xsl:call-template name="path-to-page"/></div>
							<h1 class="title"><xsl:value-of select="html/head/title"/></h1>
						</td>

						<td class="boxed top-navigation">
							<xsl:call-template name="navigation-block"/>
						</td>
					</tr>
				</table>
				
				<div class="body">										
					<div class="boxed body-navigation">
						<h4>Navigation</h4>
						<xsl:call-template name="site-contents"/>
					</div>
					
					<xsl:if test="count(html/body/h1) > 0">
						<div class="boxed body-contents">
							<h4>Page Contents</h4>
							<ol class="toclist">
								<xsl:apply-templates select="html/body/h1" mode="toc"/>
							</ol>
						</div>
					</xsl:if>
						
					<xsl:apply-templates select="html/body/*"/>
				</div>
				
				<div class="bottom">
					<div class="center">
						<a href="http://validator.w3.org/check?uri=referer">
						<img src="http://www.w3.org/Icons/valid-xhtml10"
							alt="Valid XHTML 1.0 Strict" height="31" width="88"/>
						</a>
					</div>
					
					<div class="boxed center">
						All content © 2000-2006 David Given unless otherwise
						stated.
					</div>

					<div class="boxed navigation">
						<xsl:call-template name="navigation-block"/>
					</div>
  				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="html/body/*[starts-with(local-name(),'h')]" mode="toc">
		<li>
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:text>#</xsl:text>
					<xsl:value-of select="generate-id(.)"/>
				</xsl:attribute>
				<xsl:value-of select="."/>
			</xsl:element>
		</li>

		<xsl:if test="key('parentheader',generate-id())">
			<ol class="toclist">
				<xsl:apply-templates select="key('parentheader',generate-id())" mode="toc"/>
			</ol>
        </xsl:if>
	</xsl:template>
</xsl:stylesheet>
