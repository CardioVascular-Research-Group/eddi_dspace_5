<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - fragment JSP to be included in site, community or collection home to show discovery facets
  -
  - Attributes required:
  -    discovery.fresults    - the facets result to show
  -    discovery.facetsConf  - the facets configuration
  -    discovery.searchScope - the search scope 
  --%>

<%@page import="org.dspace.discovery.configuration.DiscoverySearchFilterFacet"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.Map"%>
<%@ page import="org.dspace.discovery.DiscoverResult.FacetResult"%>
<%@ page import="java.util.List"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>

<%
	boolean brefine = false;
	
	Map<String, List<FacetResult>> mapFacetes = (Map<String, List<FacetResult>>) request.getAttribute("discovery.fresults");
	List<DiscoverySearchFilterFacet> facetsConf = (List<DiscoverySearchFilterFacet>) request.getAttribute("facetsConfig");
	String searchScope = (String) request.getAttribute("discovery.searchScope");
	if (searchScope == null)
	{
	    searchScope = "";
	}
	
	if (mapFacetes != null)
	{
	    for (DiscoverySearchFilterFacet facetConf : facetsConf)
		{
		    String f = facetConf.getIndexFieldName();
		    List<FacetResult> facet = mapFacetes.get(f);
		    if (facet != null && facet.size() > 0)
		    {
		        brefine = true;
		        break;
		    }
		    else
		    {
		        facet = mapFacetes.get(f+".year");
			    if (facet != null && facet.size() > 0)
			    {
			        brefine = true;
			        break;
			    }
		    }
		}
	}
	if (brefine) {
%>
<div class="col-md-<%= discovery_panel_cols %>">
<h3 class="facets"><fmt:message key="jsp.search.facet.refine" /></h3>
<div id="facets" class="facetsBox row panel">
<%-- Search Box --%>
	<div id="facet_searchform" class="facet col-md-12">
	<form method="get" action="<%= request.getContextPath() %>/simple-search" class="navbar-form" scope="search">
	    <div class="form-group">
          <input type="text" class="form-control" placeholder="<fmt:message key="jsp.layout.navbar-default.search"/>" name="query" id="" size="47"/>
        </div>
        <button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-search"></span></button>
<%--               <br/><a href="<%= request.getContextPath() %>/advanced-search"><fmt:message key="jsp.layout.navbar-default.advanced"/></a>
<%
			if (ConfigurationManager.getBooleanProperty("webui.controlledvocabulary.enable"))
			{
%>        
              <br/><a href="<%= request.getContextPath() %>/subject-search"><fmt:message key="jsp.layout.navbar-default.subjectsearch"/></a>
<%
            }
%> --%>
	</form>
    </div>
<%
	for (DiscoverySearchFilterFacet facetConf : facetsConf)
	{
    	String f = facetConf.getIndexFieldName();
    	List<FacetResult> facet = mapFacetes.get(f);
 	    if (facet == null)
 	    {
 	        facet = mapFacetes.get(f+".year");
 	    }
 	    if (facet == null)
 	    {
 	        continue;
 	    }
	    String fkey = "jsp.search.facet.refine."+f;
	    int limit = facetConf.getFacetLimit()+1;
	    %><div id="facet_<%= f %>" class="facet col-md-<%= discovery_facet_cols %>">
	    <span class="facetName"><fmt:message key="<%= fkey %>" /></span>
	    <ul class="list-group"><%
	    int idx = 1;
	    int currFp = UIUtil.getIntParameter(request, f+"_page");
	    if (currFp < 0)
	    {
	        currFp = 0;
	    }
	    if (facet != null)
	    {
		    for (FacetResult fvalue : facet)
		    { 
		        if (idx != limit)
		        {
		        %><li class="list-group-item"><span class="badge"><%= fvalue.getCount() %></span> <a href="<%= request.getContextPath()
		            + searchScope
	                + "/simple-search?filterquery="+URLEncoder.encode(fvalue.getAsFilterQuery(),"UTF-8")
	                + "&amp;filtername="+URLEncoder.encode(f,"UTF-8")
	                + "&amp;filtertype="+URLEncoder.encode(fvalue.getFilterType(),"UTF-8") %>"
	                title="<fmt:message key="jsp.search.facet.narrow"><fmt:param><%=fvalue.getDisplayedValue() %></fmt:param></fmt:message>">
	                <%= StringUtils.abbreviate(fvalue.getDisplayedValue(),50) %></a></li><%
		        }
		        idx++;
		    }
		    if (currFp > 0 || idx > limit)
		    {
		        %><li class="list-group-item"><span style="visibility: hidden;">.</span>
		        <% if (currFp > 0) { %>
		        <a class="pull-left" href="<%= request.getContextPath()
		                + searchScope
		                + "?"+f+"_page="+(currFp-1) %>"><fmt:message key="jsp.search.facet.refine.previous" /></a>
	            <% } %>
	            <% if (idx > limit) { %>
	            <a href="<%= request.getContextPath()
		            + searchScope
	                + "?"+f+"_page="+(currFp+1) %>"><span class="pull-right"><fmt:message key="jsp.search.facet.refine.next" /></span></a>
	            <%
	            }
	            %></li><%
		    }
	    }
	    %></ul></div><%
	}
%></div></div><%
	}
%>