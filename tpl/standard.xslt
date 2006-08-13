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
				<div class="left">
					<div class="boxed">
						<table width="100%"><tr>
							<td class="center">
								<a href="/"><img src="{$DESTURL}/home.png" alt="Home"/></a>
							</td><td class="center">
								<a href="mailto:dg@cowlark.com"><img src="{$DESTURL}/mailme.png" alt="Mail the author"/></a>
							</td><td class="center">
								<a href="/about.html"><img src="{$DESTURL}/about.png" alt="About the site"/></a>
							</td><td class="center">
								<a href="/index.html"><img src="{$DESTURL}/index.png" alt="Index"/></a>
							</td>
						</tr></table>
					</div>
					
					<div class="boxed">
						<h4>Navigation</h4>
						<xsl:call-template name="site-contents"/>
					</div>
					
					<xsl:if test="count(html/body/h1) > 0">
						<div class="boxed">
							<h4>Page Contents</h4>
							<ol class="toclist">
								<xsl:apply-templates select="html/body/h1" mode="toc"/>
							</ol>
						</div>
					</xsl:if>
						
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
  				</div>
  				
				<div class="right">
					<div class="path"><xsl:call-template name="path-to-page"/></div>
					<h1 class="title"><xsl:value-of select="html/head/title"/></h1>
					<xsl:call-template name="navigation-block"/>
					<xsl:apply-templates select="html/body/*"/>
					<xsl:call-template name="navigation-block"/>
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
