<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="_htmlx.xslt"/>
	<xsl:import href="_contents.xslt"/>
	<xsl:output method="xml"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		indent="no"
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
				<table cols="9" rows="1" width="100%" class="top-table">
					<tr>
						<td class="boxed top-logo" colspan="1">
							Prime Mover
						</td>

						<td class="boxed top-maintitle" colspan="5">
							<div class="toc-path"><xsl:call-template name="path-to-page"/></div>
							<h1 class="title"><xsl:value-of select="html/head/title"/></h1>
						</td>

						<xsl:call-template name="navigation-block"/>
					</tr>
				</table>
				
				<div class="body">										
					<div class="boxed body-navigation">
						<h4>Site Navigation</h4>
						<xsl:call-template name="site-contents"/>
					</div>
					
					<xsl:if test="html/body/h1">
						<div class="body-contents">
							<h4>Page Contents</h4>
							<ol class="toclist">
								<xsl:apply-templates select="html/body/h1" mode="toc"/>
							</ol>
						</div>
					</xsl:if>
						
					<xsl:apply-templates select="html/body/*"/>
				</div>
				
				<table cols="9" rows="1" width="100%" class="top-table">
					<tr>
						<td class="boxed bottom-status" colspan="6">
							All content © 2000-2006 David Given unless otherwise
							stated.
						</td>

						<xsl:call-template name="navigation-block"/>
					</tr>
				</table>
				
				<table cols="3" rows="1" width="100%" class="top-table center">
					<tr>
						<td>
							<a href="http://validator.w3.org/check?uri=referer">
								<img src="http://www.w3.org/Icons/valid-xhtml10"
									alt="Valid XHTML 1.0 Strict" height="31" width="88" border="0"/>
							</a>
						</td>

						<td>
							<a href="http://jigsaw.w3.org/css-validator/">
								<img src="http://jigsaw.w3.org/css-validator/images/vcss"
									alt="Valid CSS" height="31" width="88" border="0"/>
							</a>
						</td>

						<td>
							<a href="http://sourceforge.net">
								<img src="http://sflogo.sourceforge.net/sflogo.php?group_id=157791&amp;type=1"
									width="88" height="31" border="0" alt="SourceForge.net Logo"/>
							</a>
						</td>
					</tr>
  				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="html/body/h1 | html/body/h2 | html/body/h3" mode="toc">
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

	<xsl:template match="html/body/h4" mode="toc"/>
</xsl:stylesheet>
