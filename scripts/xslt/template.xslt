<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0"
	exclude-result-prefixes="xsl xs">
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
	
	
	<xsl:template match="example">
		<div class="example">
			<h2>Příklad <xsl:value-of select="@number"/></h2>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="literature">
		<div class="literature">
			<h2>Literatura</h2>
			<ol>
				<xsl:for-each select="li">
					<li>
						<xsl:if test="title">
							<span class="literature-title"><xsl:value-of select="title/text()"/></span>
							<xsl:if test="reference">
								<span class="literature-reference">(<xsl:value-of select="reference/text()"/>)</span>
							</xsl:if>
						</xsl:if>
						<xsl:if test="author">
							<xsl:if test="title">
								<span> - </span>
							</xsl:if>
							<span class="literature-author"><xsl:value-of select="author/text()"/></span>
						</xsl:if>
					</li>
				</xsl:for-each>
			</ol>
		</div>
	</xsl:template>
	
	<xsl:template match="quiz">
		<ol class="quiz">
			<xsl:apply-templates select="question-answer"/>
		</ol>
	</xsl:template>
	
	<xsl:template match="question-answer">
		<li>
			<div class="quiz-question">
				<xsl:apply-templates select="question/*"/>
			</div>
			
			<div class="quiz-answer">
				<span>Odpověď:</span>
				<div>
					<xsl:apply-templates select="answer/*"/>
				</div>
			</div>
		</li>
	</xsl:template>
	
	<!-- named templates -->
	
	<xsl:template name="club"><span class="suit-clubs">♣</span></xsl:template>
	<xsl:template name="diamond"><span class="suit-diamonds">♦</span></xsl:template>
	<xsl:template name="heart"><span class="suit-hearts">♥</span></xsl:template>
	<xsl:template name="spade"><span class="suit-spades">♠</span></xsl:template>
	
	<xsl:template name="suit-char">
		<xsl:param name="value" />
		<xsl:variable name="value" select='translate($value, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz")'/>
		<xsl:choose>
			<xsl:when test="$value = 'c'"><xsl:call-template name="club"/></xsl:when>
			<xsl:when test="$value = 'd'"><xsl:call-template name="diamond"/></xsl:when>
			<xsl:when test="$value = 'h'"><xsl:call-template name="heart"/></xsl:when>
			<xsl:when test="$value = 's'"><xsl:call-template name="spade"/></xsl:when>
			<xsl:when test="contains($value, 'n')">NT</xsl:when>
			<xsl:otherwise>?</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="contract">
		<xsl:param name="level" />
		<xsl:param name="suit" />
		<xsl:param name="declarer" />
		<xsl:param name="doubled" select="false" />
		<xsl:param name="redoubled" select="false" />
		
		
		<span class="contract">
			<xsl:value-of select='$level'/>
			<xsl:call-template name="suit-char">
				<xsl:with-param name="value" select="$suit"/>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="$doubled = 'true'">
					<span>x</span>
				</xsl:when>
				<xsl:when test="$redoubled = 'true'">
					<span>xx</span>
				</xsl:when>
			</xsl:choose>
			<span class="declarer">
				<xsl:value-of select='$declarer'/>
			</span>
		</span>
	</xsl:template>
	
	<xsl:template name="bid" >
		<xsl:param name="suit"/>
		<xsl:param name="level"/>
		<xsl:param name="value"/>
		
		<span class="bid">
			<xsl:choose>
				<xsl:when test="$value='pass'">
					pass
				</xsl:when>
				<xsl:when test="$value='double' or $value='x' or $value='d'">
					X
				</xsl:when>
				<xsl:when test="$value='redouble' or $value='xx' or $value='rd'">
					XX
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select='$level'/>
					<xsl:call-template name="suit-char">
						<xsl:with-param name="value" select="$suit"/>
					</xsl:call-template>
				</xsl:otherwise>
				
			</xsl:choose>
		</span>
	</xsl:template>
	
	<xsl:template name="card">
		<xsl:param name="value" />
		<xsl:variable name="v1" select='translate($value, "10", "t")'/>
		<xsl:variable name="value" select='translate($v1, "abcdefghijklmnopqrstuvwxyz", "ABCDEFGHIJKLMNOPQRSTUVWXYZ")'/>
		
		<xsl:variable name="card-value">
			<xsl:choose>
				<xsl:when test="contains('SHDC', substring($value, 1,1))">
					<xsl:value-of select="substring($value, 2,1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($value, 1,1)"/>
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="card-suit">
			<xsl:choose>
				<xsl:when test="contains('shcd', substring($value, 1,1))">
					<xsl:value-of select="substring($value, 1,1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($value, 2,1)"/>
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<span class="card">
			<xsl:call-template name="suit-char">
				<xsl:with-param name="value" select="$card-suit"/>
			</xsl:call-template>
			<span><xsl:value-of select='$card-value'/></span>
		</span>
	</xsl:template>
	
	
	<xsl:template name="direction-indicator">
		<div class="direction-indicator" > 
			<table>
				<tr> <td></td> <td>N</td> <td></td> </tr>
				<tr> <td>W</td> <td>+</td> <td>E</td> </tr>
				<tr> <td></td> <td>S</td> <td></td></tr>
			</table>
		</div>
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
	
	<xsl:template match="deal-contract">
		<div class="deal-contract" >
			<span>Závazek: </span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="leadcard">
		<div class="leadcard">
			<span>Výnos: </span>
			<xsl:call-template name="card">
				<xsl:with-param name="value" select="@value"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
	<xsl:template match="bidding-solution">
		<div class="bidding-solution">
			<span>Řešení dražby: </span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="bid">
		<xsl:call-template name="bid">
			<xsl:with-param name="value" select="@value"/>
			<xsl:with-param name="suit" select="@suit"/>
			<xsl:with-param name="level" select="@level"/>
		</xsl:call-template>
	</xsl:template>
	
	
	<xsl:template match="contract">
		<xsl:call-template name="contract">
			<xsl:with-param name="level" select="@level"/>
			<xsl:with-param name="suit" select="@suit"/>
			<xsl:with-param name="declarer" select="@declarer"/>
			<xsl:with-param name="doubled"> 
				<xsl:choose> 
					<xsl:when test="@doubled">
						<xsl:value-of select="true()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="false()"/>
					</xsl:otherwise>
				</xsl:choose> 
			</xsl:with-param>
			<xsl:with-param name="redoubled"> 
				<xsl:choose> <xsl:when test="@redoubled">
						<xsl:value-of select="true()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="false()"/>
					</xsl:otherwise>
				</xsl:choose> 
			</xsl:with-param>
		</xsl:call-template>
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
	<xsl:template match="distribution[ (hand/@position='south' or hand/@position='north') and (hand/@position='east' or hand/@position='west')]">
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
	
	<xsl:template match="distribution[hand[not(@position)]]">
		<div class="distribution distribution-hand"> 
			<xsl:apply-templates mode="dist"/>
		</div>
	</xsl:template>
	
	
	<xsl:template match="distribution[hand/@position='south' and hand/@position='north' and not(hand/@position='east') and not(hand/@position='west')]">
		<div class="distribution distribution-hand-dummy"> 
			
			<div>
				<xsl:apply-templates mode="dist" select="hand[@position='north']"/>
			</div>
			<div>
				<xsl:apply-templates mode="dist" select="hand[@position='south']"/>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="distribution[hand/@position='east' and hand/@position='west' and not(hand/@position='north') and not(hand/@position='south')]">
		<div class="distribution distribution-ew"> 
			<div>
				<xsl:apply-templates mode="dist" select="hand[@position='west']"/>
			</div>
			<div>
				<xsl:apply-templates mode="dist" select="hand[@position='east']"/>
			</div>
		</div>
	</xsl:template>
	
	<!-- suit only distributions -->
	
	<xsl:template match="distribution[suit[not(@position)]]">
		<div class="distribution distribution-suit"> 
			<xsl:apply-templates select="suit" mode="dist"/>
		</div>
	</xsl:template>
	
	<xsl:template match="distribution[suit/@position='south' and suit/@position='north' and not(suit/@position='east') and not(suit/@position='west')]">
		<div class="distribution distribution-suit-hand-dummy"> 
			<div><xsl:apply-templates select="suit[@position='north']" mode="dist"/></div>
			<br/>
			<div><xsl:apply-templates select="suit[@position='south']" mode="dist"/></div>
		</div>
	</xsl:template>
	
	<xsl:template match="distribution[suit/@position='south' and suit/@position='north' and suit/@position='east' and suit/@position='west']">
		
		<table class="distribution distribution-suit-nsew">
			<tr> 
				<td></td>
				<td>
					<xsl:apply-templates select="suit[@position='north']" mode="dist"/>
				</td>
				<td></td>
			</tr>
			<tr>
				<td>
					<xsl:apply-templates select="suit[@position='west']" mode="dist"/>
				</td>
				<td></td> 
				<td>
					<xsl:apply-templates select="suit[@position='east']" mode="dist"/>
				</td>
			</tr>
			<tr> 
				<td></td>
				<td> 
					<xsl:apply-templates select="suit[@position='south']" mode="dist"/>
				</td>
				<td></td>
			</tr> 
		</table>
	</xsl:template>
	
	<!-- distribution partial templates -->
	
	<xsl:template match="suit" mode="dist">
		<xsl:value-of select="text()"/>
	</xsl:template>
	
	
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
	
	<!--Auction partial templates -->
	
	<xsl:template match="bid" mode="auction">
		
		<!-- lower case -->
		<xsl:variable name="value" select='translate(@value, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz")'/>
		
		<div class="auction-bid">
			
			<xsl:call-template name="bid">
				<xsl:with-param name="value" select="$value"/>
				<!-- todo -->
				<xsl:with-param name="suit">
					<xsl:if test="contains('1234567', substring($value,1,1))">
						<xsl:value-of select='substring($value,2,1)'/>
					</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="level">
					<xsl:if test="contains('1234567', substring($value,1,1))">
						<xsl:value-of select='substring($value,1,1)'/>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</div>
	</xsl:template>
	
</xsl:stylesheet>