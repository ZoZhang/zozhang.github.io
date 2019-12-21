## XML Puissance 4

### Introduction

Valide la règle de Puissance 4 avec XML et XSLT 1.0.

### Démonstration
[Visite Demo Online](https://zozhang.github.io/xml/puissance4/)

### Règle Implémentation
- Horizontal
- Vertical
- Diagonal à droit

### Méthode Utilisé
1. D'abord, bien comprendre la règle du jeu Puissance 4.
2. Définie une structure de svg en XML afin de construire le fichier xslt.
3. Créer le fichier xslt afin de générer dynamique une bonne structure xml au format svg.
4. Construire un fichier xsd afin d'écrire la validation des données de configuration XML.
5. Faire la programmation xlst afin de calculer le vainqueur.
   Pour cette partie, j'ai crée 3 template en récursif. parce qu'il faut éviter de calculer l'emplacement blanche.
   
````
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
````
 Par exmple pour compter en horizontal, chaque fois, je recherche la colonne suivante au première à partir la colonne présente pour compter la même emplacement et la même couleur que la cercle présente.
Si il ne trouve aucun la cercle en même emplacement et la couleur, ça veut dir, les cercles ne sont pas permanent.
Et alors, je mis sur une variable `diagonal` qui signifie l'état permanent avec l'emplacement dans la colonne suivante.

  
````
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
	    		<text x="220"  y="15" fill="{$jeton}">
	    			<xsl:value-of select="$jeton"/> est gagné.
	    		</text>
			</xsl:when>
	    </xsl:choose> 

	</xsl:template>
````
### Remaque
Lorsqu'on utilise la commande`xsltproc` pour générer un svg, il faut enlever les espaces de noms XML suivante.
Sinon le xslt ne fonctione pas correcte.

Par contre, quand on utilise la commande `xmllint` pour valider le fichier xsd, il faut ajouter les espaces de noms XML dans les configurations xml.

```
xmlns="http://xsd.zhangzhao.fr/validation" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="validation.xsd"
```

### Exemple

![Diagonal à droit ](https://imgur.com/CWhxWpf.png)

![Horizontal](https://imgur.com/YWMoy2N.png)

![Vertical](https://imgur.com/EIrqZb3.png)


