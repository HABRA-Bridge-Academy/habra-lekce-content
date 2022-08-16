<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0"
	exclude-result-prefixes="xsl xs">
	<xsl:import href="commonprint.xslt"/>
	<xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
	
	<xsl:template match="lesson">
		<html>
			<head>
				<meta charset="UTF-8"/>
				<title>Habra lekce test</title>
			</head>
			<body>
				<article>
					<h1>Lekce <xsl:value-of select="@number"/>: <xsl:value-of select="@title"/></h1>
					
					<xsl:if test="@video-id">
						<div class="lesson-video-container">
							<p>Na tuto lekci se můžete podívat i na našem webu na tomto 	
								<a>
									<!-- <xsl:attribute name="href">
										https://www.youtube.com/watch?v=<xsl:value-of select="@video-id"/>
									</xsl:attribute> -->
									<xsl:attribute name="href">
										http://bridzhavirov.zdenektomis.eu/index.php?s=lekce2&amp;rocnik=<xsl:value-of select="@year"/>&amp;lekce=<xsl:value-of select="@number"/>
									</xsl:attribute>
									odkazu</a>.
							</p>
						</div>
					</xsl:if>			
					<xsl:apply-templates/>
				</article>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>