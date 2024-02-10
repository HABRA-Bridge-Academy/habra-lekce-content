<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0" exclude-result-prefixes="xsl xs">
	<xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
	
	
	<xsl:template match="p|b|i|h1|h2|h3|h4|header">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="example">
		<div class="example">
			<h2 class="example-heading">Příklad <xsl:value-of select="@number"/></h2>
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
				<span class="quiz-answer-label">Odpověď:</span>
				<div class="quiz-answer-content">
					<xsl:apply-templates select="answer/*"/>
				</div>
			</div>
		</li>
	</xsl:template>
	
	<!-- Inline -->
	
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
	
	
	
	
	<xsl:template match="sequence">
		<span class="sequence">
			<xsl:for-each select="bid">
				<xsl:apply-templates select="."/>
				<xsl:if test="position() != last()">
					<span>-</span>
				</xsl:if>
			</xsl:for-each>
		</span>
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
	
	<!-- Bidding -->
	
	<xsl:template match="bidding-solution">
		<div class="bidding-solution">
			<span class="solution-label">Řešení dražby: </span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>  
	
	<xsl:template match="bidding">
		<div class="bidding">
			<xsl:if test="header">
				<div>
					<xsl:apply-templates select="header"/>
				</div>
			</xsl:if>
			<div class="bidding-table">
				<xsl:apply-templates select="entry"/>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="entry">
		<div>
			<xsl:if test="not(explanation)">
				<xsl:attribute name="class">action-only</xsl:attribute>
			</xsl:if>
			<div class="action"> <xsl:apply-templates select="action"/></div>
			<div class="explanations"> 
				<xsl:for-each select="explanation">
					<div>
						<xsl:apply-templates/>
					</div>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>	
	
	<xsl:template match="action">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- Named -->
	
	<xsl:template name="club" match="club"><span class="suit-clubs">♣</span></xsl:template>
	<xsl:template name="diamond" match="diamond"><span class="suit-diamonds">♦</span></xsl:template>
	<xsl:template name="heart" match="heart"><span class="suit-hearts">♥</span></xsl:template>
	<xsl:template name="spade" match="spade"><span class="suit-spades">♠</span></xsl:template>
	
	<xsl:template name="suit-char">
		<xsl:param name="value" />
		<xsl:variable name="value" select='translate($value, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz")'/>
		<xsl:choose>
			<xsl:when test="$value = 'c'"><xsl:call-template name="club"/></xsl:when>
			<xsl:when test="$value = 'd'"><xsl:call-template name="diamond"/></xsl:when>
			<xsl:when test="$value = 'h'"><xsl:call-template name="heart"/></xsl:when>
			<xsl:when test="$value = 's'"><xsl:call-template name="spade"/></xsl:when>
			<xsl:when test="contains($value, 'n')">BT</xsl:when>
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
	
	<xsl:template name="bid" match="bid" >
		<xsl:param name="suit" select="@suit"/>
		<xsl:param name="suits" select="@suits"/>
		<xsl:param name="level" select="@level"/>
		<xsl:param name="value" select="@value"/>
		
		<xsl:variable name="v" select='translate($value, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz")'/>
		
		<span class="bid">
			<xsl:choose>
				<xsl:when test="$v='pass'">
					pass
				</xsl:when>
				<xsl:when test="$v='double' or $v='x' or $v='d'">
					X
				</xsl:when>
				<xsl:when test="$v='redouble' or $v='xx' or $v='rd'">
					XX
				</xsl:when>
				<xsl:when test="$v='?'">
					?
				</xsl:when>
				<xsl:when test="$suits">
					<xsl:value-of select='$level'/>
					<xsl:call-template name="suits">
						<xsl:with-param name="value" select="$suits"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$suit">
					<xsl:value-of select='$level'/>
					<xsl:call-template name="suit-char">
						<xsl:with-param name="value" select="$suit"/>
					</xsl:call-template>
				</xsl:when>
				
			</xsl:choose>
		</span>
	</xsl:template>
	
	<xsl:template name="suits">
		<xsl:param name="value" />
		
		<xsl:if  test="string-length($value) &gt; 0">
			
			<xsl:call-template name="suit-char">
				<xsl:with-param name="value" select="substring($value, 1, 1)"/>
			</xsl:call-template>
			<xsl:if test="string-length($value) &gt; 1">
				<span>/</span>
			</xsl:if>
			<xsl:call-template name="suits">
				<xsl:with-param name="value" select="substring($value, 2)"/>
			</xsl:call-template>
		</xsl:if> 
	</xsl:template>
	
	<xsl:template name="card" match="card">
		<xsl:param name="value" select="@value"/>
		<!-- translate should work: 1 to T, 0 to nothing -->
		<xsl:variable name="v1" select='translate($value, "10", "t")'/> 
		<xsl:variable name="v2" select='translate($v1, "abcdefghijklmnopqrstuvwxyz", "ABCDEFGHIJKLMNOPQRSTUVWXYZ")'/>
		
		<xsl:variable name="card-value">
			<xsl:choose>
				<xsl:when test="contains('SHDC', substring($v2, 1,1))">
					<xsl:value-of select="substring($v2, 2,1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($v2, 1,1)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="card-suit">
			<xsl:choose>
				<xsl:when test="contains('shcd', substring($v2, 1,1))">
					<xsl:value-of select="substring($v2, 1,1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($v2, 2,1)"/>
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<span class="card">
			<xsl:call-template name="suit-char">
				<xsl:with-param name="value" select="$card-suit"/>
			</xsl:call-template>
			<span>
				<xsl:choose> 
					<xsl:when test="$card-value = 'T'">10</xsl:when> 
					<xsl:otherwise><xsl:value-of select="$card-value"/></xsl:otherwise>
				</xsl:choose>
			</span>
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
	
	<!-- Distribution -->
	
	<xsl:template match="distribution[hand/@position='south' and hand/@position='north' and not(hand/@position='east') and not(hand/@position='west')]">
		<div class="distribution distribution-ns">
			<table class="distribution-table">
				<tr> 
					<td class="north">
						<xsl:apply-templates select="hand[@position='north']" mode="dist"/>
					</td> 
				</tr>
				<tr> 
					<td class="south"> 
						<xsl:apply-templates select="hand[@position='south']" mode="dist"/>
					</td>
				</tr> 
			</table>
			<xsl:if test="*[not(self::hand)]">
				<div class="side">
					<xsl:apply-templates select="*[not(self::hand)]"/>
				</div>
			</xsl:if>
		</div>
	</xsl:template>
	
	<!-- NSEW -->
	<xsl:template match="distribution[ (hand/@position='south' or hand/@position='north') and (hand/@position='east' or hand/@position='west')]">
		<div class="distribution distribution-nsew">
			<table class="distribution-table">
				<xsl:if test="hand[@position='north']">
					<tr> 
						<td></td>
						<td class="north">
							<xsl:apply-templates select="hand[@position='north']" mode="dist"/>
						</td>
						<td></td>
					</tr>
				</xsl:if>
				<tr>
					<td>
						<xsl:if test="hand[@position='west']">
							<xsl:attribute name="class"> 
								west
							</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="hand[@position='west']" mode="dist"/>
					</td>
					<td> <xsl:call-template name="direction-indicator"/> </td> 
					<td>
						<xsl:if test="hand[@position='east']">
							<xsl:attribute name="class"> 
								east
							</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="hand[@position='east']" mode="dist"/>
					</td>
				</tr>
				<xsl:if test="hand[@position='south']">
					
					<tr> 
						<td></td>
						<td class="south"> 
							<xsl:apply-templates select="hand[@position='south']" mode="dist"/>
						</td>
						<td></td>
					</tr> 
				</xsl:if>
			</table>
			<xsl:if test="*[not(self::hand)]">
				<div class="side">
					<xsl:apply-templates select="*[not(self::hand)]"/>
				</div>
			</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match="distribution[hand[not(@position)]]">
		<div class="distribution distribution-hand"> 
			<xsl:apply-templates mode="dist"/>
		</div>
	</xsl:template>
	
	<!--	<xsl:template match="distribution[hand/@position='south' and hand/@position='north' and not(hand/@position='east') and not(hand/@position='west')]">
						<div class="distribution distribution-hand-dummy"> 
						
						<div >
						<xsl:apply-templates mode="dist" select="hand[@position='north']"/>
						</div>
						<div>
						<xsl:apply-templates mode="dist" select="hand[@position='south']"/>
						</div>
						<xsl:if test="*[not(self::hand)]">
						<div class="side">
						<xsl:apply-templates select="*[not(self::hand)]"/>
						</div>
						</xsl:if>
						</div>
						</xsl:template> -->
	
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
				<td class="north">
					<xsl:apply-templates select="suit[@position='north']" mode="dist"/>
				</td>
				<td></td>
			</tr>
			<tr>
				<td class="west">
					<xsl:apply-templates select="suit[@position='west']" mode="dist"/>
				</td>
				<td></td> 
				<td class="east">
					<xsl:apply-templates select="suit[@position='east']" mode="dist"/>
				</td>
			</tr>
			<tr> 
				<td></td>
				<td class="south"> 
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
		<table class="hand">
			<tr> <td><xsl:call-template name="spade"/></td> <td><xsl:value-of select="spades/text()"/> </td> </tr> 
			<tr> <td><xsl:call-template name="heart"/></td> <td><xsl:value-of select="hearts/text()"/> </td> </tr> 
			<tr> <td><xsl:call-template name="diamond"/></td> <td><xsl:value-of select="diamonds/text()"/> </td> </tr> 
			<tr> <td><xsl:call-template name="club"/></td> <td><xsl:value-of select="clubs/text()"/> </td> </tr> 
		</table>
	</xsl:template>
	
	<xsl:template match="hand">
		<span class="inline-hand">
			<span><xsl:call-template name="spade"/><xsl:value-of select="spades/text()"/></span>
			<span><xsl:call-template name="heart"/><xsl:value-of select="hearts/text()"/></span>
			<span><xsl:call-template name="diamond"/><xsl:value-of select="diamonds/text()"/></span>
			<span><xsl:call-template name="club"/><xsl:value-of select="clubs/text()"/></span>
		</span>
	</xsl:template>
	
	<!--Auction partial templates -->
	
	<xsl:template match="bid" mode="auction">
		
		<!-- lower case -->
		<xsl:variable name="value" select='translate(@value, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz")'/>
		
		<div class="auction-bid">
			<xsl:apply-templates select="."/>
		</div>
	</xsl:template>
	
	
	
	
</xsl:stylesheet>