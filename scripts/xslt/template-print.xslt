<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0"	exclude-result-prefixes="xsl xs">
	<xsl:import href="commonprint.xslt"/>

	<xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
	
	<xsl:template match="book">
		<html>
			<head>
				<meta charset="UTF-8"/>
				<title>Skripta Havířovské bridžové akademie pro <xsl:value-of select="@year"/>. ročník</title>
			</head>
			<body>
				<xsl:call-template name="coverpage">
					<xsl:with-param name="year-name"  select="@year-name"/>
					<xsl:with-param name="phrase"  select="@phrase"/>
					<xsl:with-param name="number"  select="@year"/>
				</xsl:call-template>
				<xsl:apply-templates/>			
			</body>
		</html>
	</xsl:template>
		
	<xsl:template name="coverpage">
		<xsl:param name="phrase"/>
		<xsl:param name="year-name"/>
		<xsl:param name="number"/>
		<div class="coverpage">
			<div id="c"><xsl:call-template name="club"/></div>
			<div id="d"><xsl:call-template name="diamond"/></div>
			<div id="h"><xsl:call-template name="heart"/></div>
			<div id="s"><xsl:call-template name="spade"/></div>
			<div class="coverpage-container">
				<div id="habra">HABRA</div>
				<div id="habra2">HAvířovská BRridžová Akademie</div>
				<div id="phrase"><xsl:value-of select="$phrase"/></div>
				<div id="name">Stupeň <xsl:value-of select="$year-name"/></div>
				<div id="year"><xsl:value-of select="$number"/>. ročník</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="intro">
		<article class="intro">
			<h1>Úvod</h1>
			<xsl:apply-templates/>
		</article>
	</xsl:template>
	
	<xsl:template match="lesson">
		<article class="lesson">
			<h1>Lekce <xsl:value-of select="@number"/>: <xsl:value-of select="@title"/></h1>
			<xsl:apply-templates/>
		</article>
	</xsl:template>
	
</xsl:stylesheet>