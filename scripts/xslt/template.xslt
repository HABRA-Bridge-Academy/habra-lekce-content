<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ex="http://example.org" version="1.0"
	exclude-result-prefixes="ex xsl xs">
	<xsl:output encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:template match="lesson">
		
		<article>
			<h1>Lekce <xsl:value-of select="@number"/>: <xsl:value-of select="@title"/></h1>
			<xsl:apply-templates/>
		</article>
	</xsl:template>
	<xsl:template match="p">
		<p>
			<xsl:value-of select="text()"/>
		</p>
	</xsl:template>

	<xsl:template match="example">
		<div class="example">
		<h2>Příklad <xsl:value-of select="@number"/></h2>
		<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template name="club"><inline class="suit-clubs">♣</inline></xsl:template>
	<xsl:template name="diamond"><inline class="suit-diamonds">♦</inline></xsl:template>
	<xsl:template name="heart"><inline class="suit-hearts">♥</inline></xsl:template>
	<xsl:template name="spade"><inline class="suit-spades">♠</inline></xsl:template>

	
	<xsl:template name="direction-indicator">
		<div class="direction-indicator" > 
			<table>
				<tr> <td></td> <td>N</td> <td></td> </tr>
				<tr> <td>W</td> <td>+</td> <td>E</td> </tr>
				<tr> <td></td> <td>S</td> <td></td></tr>
			</table>
		</div>
	</xsl:template>
	
	
	<!-- NS Distribution -->
	<xsl:template match="distribution[hand/@position='south' and hand/@position='north' and not(hand/@position='east') and not(hand/@position='west')]">
		<table class="distribution distribution-ns">
			<tr> 
				<td>
					<xsl:apply-templates select="hand[@position='north']" mode="dist"/>
				</td> 
			</tr>
			<tr> <td> <xsl:call-template name="direction-indicator"/> </td> </tr>
			<tr> 
				<td> 
					<xsl:apply-templates select="hand[@position='south']" mode="dist"/>
				</td>
			</tr> 
		</table>
	</xsl:template>
	
	<!-- NSEW -->
	<xsl:template match="distribution">
		<table class="distribution distribution-ns">
			<tr> 
				<td></td>
				<td>
					<xsl:apply-templates select="hand[@position='north']" mode="dist"/>
				</td>
				<td></td>
			</tr>
			<tr>
				<td>
					<xsl:apply-templates select="hand[@position='west']" mode="dist"/>
				</td>
				<td> <xsl:call-template name="direction-indicator"/> </td> 
				<td>
					<xsl:apply-templates select="hand[@position='east']" mode="dist"/>
				</td>
			</tr>
			<tr> 
				<td></td>
				<td> 
					<xsl:apply-templates select="hand[@position='south']" mode="dist"/>
				</td>
				<td></td>
			</tr> 
		</table>
	</xsl:template>
	
	<!-- distribution partial templates -->
	
	<xsl:template match="hand" mode="dist">
		<table>
			<tr> <td><xsl:call-template name="spade"/></td> <td><xsl:value-of select="spades/text()"/> </td> </tr> 
			<tr> <td><xsl:call-template name="heart"/></td> <td><xsl:value-of select="hearts/text()"/> </td> </tr> 
			<tr> <td><xsl:call-template name="diamond"/></td> <td><xsl:value-of select="diamonds/text()"/> </td> </tr> 
			<tr> <td><xsl:call-template name="club"/></td> <td><xsl:value-of select="clubs/text()"/> </td> </tr> 
		</table>
	</xsl:template>
	
	<!-- NS Auction -->
	
	<xsl:template match="auction[@onesided]">
		<div class="auction auction-onesided">
			<xsl:attribute name="data-dealer"> 
				<xsl:value-of select='@dealer'/>
			</xsl:attribute>
			<div class="auction-header"> N </div>
			<div class="auction-header"> S </div>
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
			<xsl:apply-templates  mode="auction"/>
		</div>
	</xsl:template>
	
	<xsl:template match="bid" mode="auction">
		
		<!-- lower case -->
		<xsl:variable name="value" select='translate(@value, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz")'/>
		
		<div class="auction-bid">
			<xsl:choose>
				<xsl:when test="$value='pass'">
					pass
				</xsl:when>
				<xsl:otherwise>
				
				<xsl:value-of select='substring($value,1,1)'/><xsl:choose><xsl:when test="contains($value,'c')"><xsl:call-template name="club"/></xsl:when>
						<xsl:when test="contains($value,'d')"><xsl:call-template name="diamond"/></xsl:when>
						<xsl:when test="contains($value,'h')"><xsl:call-template name="heart"/></xsl:when>
						<xsl:when test="contains($value,'s')"><xsl:call-template name="spade"/></xsl:when>
						<xsl:when test="contains($value,'nt')">NT</xsl:when>
						<xsl:otherwise>?</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
				
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="text()"/>
</xsl:transform>