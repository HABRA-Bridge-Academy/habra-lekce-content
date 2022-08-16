<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0"
	exclude-result-prefixes="xsl xs">
	<xsl:import href="common.xslt"/>
	<xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
	

	<xsl:template match="lesson">
		<article>
			<h1>Lekce <xsl:value-of select="@number"/>: <xsl:value-of select="@title"/></h1>
			
			<xsl:if test="@video-id">
				<div class="lesson-video-container">
					<p>Tuto lekci můžete zhlédnout i jako video:</p>
					<div class="lesson-video">
						<iframe width="640" height="360">
							<xsl:attribute name="src">
								https://www.youtube.com/embed/<xsl:value-of select="@video-id"/>
							</xsl:attribute>
						</iframe> 
					</div>
				</div>
			</xsl:if>
			<xsl:if test="@bridgemaster">
				<p>Úlohy z této lekce si zde můžete zkusit sami:</p>
				<div class="bm-container" >
					<iframe  width="640" height="360" src="lekce2/js-dos/index.html"/>			
				</div>		
			</xsl:if>
			
			<xsl:apply-templates/>
		</article>
	</xsl:template>
	
	<!-- ignored elements -->
	
	<xsl:template match="p|h1|h2|h3|h4">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="div|table|inline|ol|li|tr|td|br">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:value-of select="text()"/>
			<xsl:apply-templates select="*" />
		</xsl:copy>
	</xsl:template>

	<!-- NS Auction -->
	
	<xsl:template match="auction[@onesided]">
		<div>
			<xsl:attribute name="data-dealer"> 
				<xsl:value-of select='@dealer'/>
			</xsl:attribute>
			<xsl:attribute name="class">
				auction auction-onesided
				<xsl:if test="@revealable"> revealable</xsl:if>
			</xsl:attribute>
			<div class="auction-header"> N </div>
			<div class="auction-header"> S </div>
			
			<xsl:if test="@dealer = 'S'">
				<div class="auction-bid auction-bid-placeholder"></div> 
			</xsl:if>
			<xsl:apply-templates  mode="auction"/>
		</div>
	</xsl:template>
	
	<xsl:template match="auction[not(@onesided) or @onesided = 'false']">
		<div class="auction auction-nsew">
			<xsl:attribute name="data-dealer"> 
				<xsl:value-of select='@dealer'/>
			</xsl:attribute>
			<div class="auction-header"> W </div>
			<div class="auction-header"> N </div>
			<div class="auction-header"> E </div>
			<div class="auction-header"> S </div>
			<xsl:choose>
				<xsl:when test="@dealer = 'N'">
					<div class="auction-bid auction-bid-placeholder"></div> 
				</xsl:when>
				<xsl:when test="@dealer = 'E'">
					<div class="auction-bid auction-bid-placeholder"></div> 
					<div class="auction-bid auction-bid-placeholder"></div> 
				</xsl:when>
				<xsl:when test="@dealer = 'S'">
					<div class="auction-bid auction-bid-placeholder"></div> 
					<div class="auction-bid auction-bid-placeholder"></div> 
					<div class="auction-bid auction-bid-placeholder"></div> 
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates  mode="auction"/>
		</div>
	</xsl:template>
	


	
</xsl:stylesheet>