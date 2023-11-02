<?xml version="1.0"?>

<xsl:stylesheet version="2.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xhtml">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:strip-space elements="*" />

  <!--
    Note: Pandoc reads ballot chars from HTML back to MD - [ ] and - [x], 
    and in time it should also read the task output format of the HTML writer.

    See: https://github.com/jgm/pandoc/issues/9047
  -->

  <xsl:template
    match="xhtml:html | xhtml:body | xhtml:code | xhtml:strong | xhtml:em | xhtml:mark | xhtml:s">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*">
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xhtml:head">
    <xsl:copy>
      <meta charset="UTF-8"></meta>
      <meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
      <meta http-equiv="X-UA-Compatible" content="ie=edge"></meta>
      <link rel="stylesheet" href="styles/sakura.css" type="text/css"></link>
      <xsl:apply-templates select="node()|@*">
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <!-- Bike leaves a lot of empty <span> elements behind; we drop these. -->
  <xsl:template match="xhtml:span">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xhtml:a">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:apply-templates select="node()"/>
    </a>
  </xsl:template>

  <!-- 
  Bike uses <ul> for all lists; the list type is determined not at this level, but rather by each
  individual item's @data-type attribute. To get this data into the HTML list model, we must group
  items that have the same @data-type and wrap them in an appropriate list-forming element.
  
  To do this, we use XSLT 2.0's <xsl:for-each-group> instruction to group adjacent <li> items by
  their @data-type attribute. We must convert @data-type to a string: otherwise, the transformer
  will crash when it encounters an item without a @data-type attribute.
  -->
  <xsl:template match="xhtml:ul">
    <xsl:for-each-group select="xhtml:li" group-adjacent="string(@data-type)">
      <xsl:choose>
        <xsl:when test="@data-type='ordered'">
          <ol>
            <xsl:apply-templates select="current-group()" />
          </ol>
        </xsl:when>
        <xsl:when test="@data-type='unordered' or @data-type='task'">
          <ul>
            <xsl:apply-templates select="current-group()" />
          </ul>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="current-group()" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="xhtml:li">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xhtml:li[@data-type='ordered' or @data-type='unordered']/xhtml:p">
    <li>
      <xsl:apply-templates />
    </li>
  </xsl:template>

  <xsl:template match="xhtml:li[@data-type='task']/xhtml:p">
      <p>
        <xsl:choose>
          <xsl:when test="../@data-done">
            <xsl:text>&#x2611; </xsl:text>
            <xsl:apply-templates />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>&#x2610; </xsl:text>
            <xsl:apply-templates />
          </xsl:otherwise>
        </xsl:choose>
      </p>
  </xsl:template>

  <xsl:template match="xhtml:li[@data-type='heading']/xhtml:p">
    <xsl:element name="h{count(ancestor::xhtml:li[@data-type='heading'])}">
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="xhtml:li[@data-type='quote']/xhtml:p">
    <blockquote>
      <xsl:apply-templates />
    </blockquote>
  </xsl:template>

  <xsl:template match="xhtml:li[@data-type='note']/xhtml:p">
    <p>
      <em>
        <xsl:apply-templates />
      </em>
    </p>
  </xsl:template>

  <xsl:template match="xhtml:li[@data-type='code']/xhtml:p">
      <code>
        <xsl:apply-templates />
      </code>
  </xsl:template>

  <xsl:template match="xhtml:li[not(@data-type)]/xhtml:p">
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>

</xsl:stylesheet>
