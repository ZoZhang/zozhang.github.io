<?xml version="1.0"?> 
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" indent="yes"/>

	<xsl:variable name="rouge" select="'red'" />
	<xsl:variable name="blanche" select="'white'" />
 	<xsl:variable name="jaune" select="'orange'" />

	<xsl:template match="vector">
		<svg width="{@width}" height="{@height}" version="{@version}">
			<xsl:apply-templates/>
  		</svg>  
	</xsl:template>

	<xsl:template match="layout">
		<rect fill="{@color}" width="{@width}" height="{@height}" y="{@y}" x="{@x}"/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="columns">

	  <g>

	    <xsl:variable name="columnsIndex" select="position() div 2"/>

		<xsl:for-each select="child::circle">

		  <circle cx="{@x}" cy="{@y}" r="{@size}" fill="{@color}"/>

		  <xsl:if test="@color = $jaune or @color = $rouge">
	    		
	    	<xsl:variable name="jeton" select="@color"/>

 			 <!-- Récursif Vertical -->
			 <xsl:call-template name="compteJetonVertical">
				<xsl:with-param name="counter" select="0"/>
			    <xsl:with-param name="jeton" select="$jeton"/>
				<xsl:with-param name="itemIndex" select="position()"/>
			 </xsl:call-template>

			<!-- Récursif Horizontal -->
			 <xsl:call-template name="compteJetonHorizontal">
				<xsl:with-param name="counter" select="1"/>
			    <xsl:with-param name="jeton" select="$jeton"/>
				<xsl:with-param name="itemIndex" select="position()"/>
				<xsl:with-param name="columnIndex" select="$columnsIndex"/>
			 </xsl:call-template>

 			 <!-- Récursif Diagonal -->
			 <xsl:call-template name="compteJetonDiagonalDroit">
				<xsl:with-param name="counter" select="1"/>
			    <xsl:with-param name="jeton" select="$jeton"/>
			    <xsl:with-param name="columnIndex" select="$columnsIndex"/>
				<xsl:with-param name="itemIndex" select="position() - 1"/>
			 </xsl:call-template>

		  </xsl:if>

		</xsl:for-each>
	  </g>
	</xsl:template>

	<!-- Récursif Horizontal -->
	<xsl:template name="compteJetonHorizontal">
	    
	    <xsl:param name="jeton"/>
	    <xsl:param name="counter"/>
		<xsl:param name="itemIndex"/>
		<xsl:param name="columnIndex"/>

		<xsl:variable name="diagonal" select="count(../following-sibling::columns[position() = $counter]/circle[position() = $itemIndex and @color = $jeton])"/>

		<xsl:choose>
			<xsl:when test="$diagonal &gt;= 1 and $counter &lt;= 4">
		        <xsl:call-template name="compteJetonHorizontal">
					<xsl:with-param name="jeton" select="$jeton" />
					<xsl:with-param name="counter" select="$counter + 1" />
		            <xsl:with-param name="itemIndex" select="$itemIndex" />
		            <xsl:with-param name="columnIndex" select="$columnIndex + 1" />
		        </xsl:call-template>
			</xsl:when>
			<xsl:when test="$diagonal &gt;= 0 and $counter &gt;= 4">
	    		<text x="300" y="15" fill="{$jeton}">
	    			<xsl:value-of select="$jeton"/> est gagné.
	    		</text>
			</xsl:when>
	    </xsl:choose> 

	</xsl:template>

	<!-- Récursif Vertical -->
	<xsl:template name="compteJetonVertical">
	    
	    <xsl:param name="jeton"/>
	    <xsl:param name="counter"/>
		<xsl:param name="itemIndex"/>

		<xsl:variable name="diagonal" select="count(../child::circle[position() = $itemIndex and @color = $jeton])"/>

		<xsl:choose>
			<xsl:when test="$diagonal &gt;= 1 and $counter &lt;= 4">
		        <xsl:call-template name="compteJetonVertical">
					<xsl:with-param name="jeton" select="$jeton" />
					<xsl:with-param name="counter" select="$counter + 1" />
		            <xsl:with-param name="itemIndex" select="$itemIndex + 1" />
		        </xsl:call-template>
			</xsl:when>
			<xsl:when test="$diagonal = 0 and $counter &gt;= 4">
	    		<text x="300" y="15" fill="{$jeton}">
	    			<xsl:value-of select="$jeton"/> est gagné.
	    		</text>
			</xsl:when>
	    </xsl:choose> 
	</xsl:template>

 	<!-- Récursif Diagonal Vers en haut à droit -->
	<xsl:template name="compteJetonDiagonalDroit">
	    
	    <xsl:param name="jeton"/>
	    <xsl:param name="counter"/>
		<xsl:param name="direction"/>
		<xsl:param name="itemIndex"/>
	    <xsl:param name="columnIndex"/>

	    <xsl:variable name="diagonal" select="count(../following-sibling::columns[position() = $columnIndex]/circle[position() = $itemIndex and @color = $jeton])"/>

		<xsl:choose>
			<xsl:when test="$diagonal &gt;= 1">
		        <xsl:call-template name="compteJetonDiagonalDroit">
					<xsl:with-param name="jeton" select="$jeton" />
					<xsl:with-param name="counter" select="$counter + 1" />
		            <xsl:with-param name="itemIndex" select="$itemIndex - 1" />
		            <xsl:with-param name="columnIndex" select="$columnIndex + 1" />
		        </xsl:call-template>
			</xsl:when>
			<xsl:when test="$diagonal = 0 and $counter &gt;= 4">
	    		<text x="300" y="15" fill="{$jeton}">
	    			<xsl:value-of select="$jeton"/> est gagné.
	    		</text>
			</xsl:when>
	    </xsl:choose>
	</xsl:template>


</xsl:stylesheet>