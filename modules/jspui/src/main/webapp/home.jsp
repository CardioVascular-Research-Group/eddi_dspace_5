<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
  -    recent.submissions - RecetSubmissions
  --%>

<%@page import="org.dspace.core.Utils"%>
<%@page import="org.dspace.content.Bitstream"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.NewsManager" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Metadatum" %>
<%@ page import="org.dspace.content.Item" %>

<%
	// Is anyone logged in?
	EPerson user = (EPerson) request.getAttribute("dspace.current.user");
    Community[] communities = (Community[]) request.getAttribute("communities");

    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);
    String topNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));
    String sideNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-side.html"));

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    }
    
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));

    RecentSubmissions submissions = (RecentSubmissions) request.getAttribute("recent.submissions");
%>

<dspace:layout locbar="nolink" titlekey="jsp.home.title" feedData="<%= feedData %>">



<div class="jumbotron">
  <div style="padding-bottom:25px;" class="row">
  <div class="col-md-6">
	<p>Welcome to the Electrophysiology Data Discovery Index (EDDI)</p>
	<p class="normalPP">EDDI’s purpose is to provide cardiac electrophysiologists with a data repository to share their data.  Through the use of DSpace and Globus, EDDI allows for the annotation, publication and discovery of electrophysiology time-series data.  Users annotate and publish the data by describing details about them and associating them with peer-reviewed publications.  Following publication of this information, EDDI then presents users with a case-sensitive interface to search all its fields, returning all items that meet the search criteria.  The search results can then be filtered further, based upon specific values for certain fields.  As always, we appreciate constructive feedback as we continue to expand and maintain EDDI.</p>
	<%
    if (user == null)
    {
		%>
		<p><a class="button" href="/mydspace"><button type="button" class="btn btn-info">Log In</button></a>&nbsp;&nbsp;
		<a class="button" href="/register"><button type="button" class="btn btn-success">Sign Up</button></a></p>
		<%
    } else {
		%>
	<% } %>  
	
  </div>
  <div style="" class="col-md-6">
    <p>Support for EDDI is provided by:</p>
    
    <div class="row">
    <div style="" class="col-md-6">
    <p><a style="font-size:18px;color:#575a5d;text-decoration:none;" href="http://www.nhlbi.nih.gov/" target="_blank">National Heart, Lung, and Blood Institute</a></p>
  </div>
  <div style="" class="col-md-6">
    <a href="https://biocaddie.org/" target="_blank"><img width="200px" src="image/biocaddie-logo200x84.png"></a>
  </div>
  <div style="" class="col-md-6">
    <a href="http://dspace.org/" target="_blank"><img width="200px" src="image/dspace-logo-200x84px.png"></a>
  </div>
    </div>
    </div>
  </div>
</div>









<div class="row">
        <div class="col-md-12">
        
        
     
     
     
     <%
if (communities != null && communities.length != 0)
{
%>
	<div class="col-md-12 homeCom">		
               <h3><fmt:message key="jsp.home.com1"/></h3>
                <p><fmt:message key="jsp.home.com2"/></p>
				<div class="list-group">
<%
	boolean showLogos = ConfigurationManager.getBooleanProperty("jspui.home-page.logos", true);
    for (int i = 0; i < communities.length; i++)
    {
%><div class="list-group-item row">
<%  
		Bitstream logo = communities[i].getLogo();
		if (showLogos && logo != null) { %>
	<div class="col-md-12">
        <img alt="Logo" class="img-responsive" src="<%= request.getContextPath() %>/retrieve/<%= logo.getID() %>" /> 
	</div>
	<div class="col-md-9">
<% } else { %>
	<div class="col-md-12">
<% }  %>		
		<h4 class="list-group-item-heading"><a href="<%= request.getContextPath() %>/handle/<%= communities[i].getHandle() %>"><%= communities[i].getMetadata("name") %></a>
<%
        if (ConfigurationManager.getBooleanProperty("webui.strengths.show"))
        {
%>
		<span class="badge pull-right"><%= ic.getCount(communities[i]) %></span>
<%
        }

%>
		</h4>
		<p><%= communities[i].getMetadata("short_description") %></p>
    </div>
</div>                            
<%
    }
%>
	</div>
	</div>
     
     
     
     
     
        
        <div class="panel panel-primary">        
        <div id="recent-submissions-carousel" class="panel-heading carousel slide">
          <h3 style="margin:5px 5px 10px 50px;"><fmt:message key="jsp.collection-home.recentsub"/>
              <%
    if(feedEnabled)
    {
	    	String[] fmts = feedData.substring(feedData.indexOf(':')+1).split(",");
	    	String icon = null;
	    	int width = 0;
	    	for (int j = 0; j < fmts.length; j++)
	    	{
	    		if ("rss_1.0".equals(fmts[j]))
	    		{
	    		   icon = "rss1.gif";
	    		   width = 80;
	    		}
	    		else if ("rss_2.0".equals(fmts[j]))
	    		{
	    		   icon = "rss2.gif";
	    		   width = 80;
	    		}
	    		else
	    	    {
	    	       icon = "rss.gif";
	    	       width = 36;
	    	    }
	%>
	    <a href="<%= request.getContextPath() %>/feed/<%= fmts[j] %>/site"><img src="<%= request.getContextPath() %>/image/<%= icon %>" alt="RSS Feed" width="<%= width %>" height="15" style="margin: 3px 0 3px" /></a>
	<%
	    	}
	    }
	%>
          </h3>
          
		  <!-- Wrapper for slides -->
		  <div class="carousel-inner">
		    <%
		    boolean first = true;
		    for (Item item : submissions.getRecentSubmissions())
		    {
		        Metadatum[] dcv = item.getMetadata("dc", "title", null, Item.ANY);
		        String displayTitle = "Untitled";
		        if (dcv != null & dcv.length > 0)
		        {
		            displayTitle = Utils.addEntities(dcv[0].value);
		        }
		        dcv = item.getMetadata("dc", "description", "abstract", Item.ANY);
		        String displayAbstract = "";
		        if (dcv != null & dcv.length > 0)
		        {
		            displayAbstract = Utils.addEntities(dcv[0].value);
		        }
		%>
		    <div style="padding-bottom: 50px; min-height: 110px;" class="item <%= first?"active":""%>">
		      <div style="padding-left: 80px; padding-right: 80px; display: inline-block;"><%= StringUtils.abbreviate(displayTitle, 400) %> 
		      	<a href="<%= request.getContextPath() %>/handle/<%=item.getHandle() %>"> 
		      		<button class="btn btn-success" type="button">See</button>
		      		</a>
                        <p><%= StringUtils.abbreviate(displayAbstract, 125) %></p>
		      </div>
		    </div>
		<%
				first = false;
		     }
		%>
		  </div>

		  <!-- Controls -->
		  <a class="left carousel-control" href="#recent-submissions-carousel" data-slide="prev">
		    <span class="icon-prev"></span>
		  </a>
		  <a class="right carousel-control" href="#recent-submissions-carousel" data-slide="next">
		    <span class="icon-next"></span>
		  </a>

          <ol class="carousel-indicators" style="bottom:5px;">
		    <li data-target="#recent-submissions-carousel" data-slide-to="0" class="active"></li>
		    <% for (int i = 1; i < submissions.count(); i++){ %>
		    <li data-target="#recent-submissions-carousel" data-slide-to="<%= i %>"></li>
		    <% } %>
	      </ol>
     </div></div>
     
<%
}
%>

<%-- <div class="col-md-4">
    <%= sideNews %>
</div> --%>
	
		<div class="container row">

		<%
	    	int discovery_panel_cols = 12;
	    	int discovery_facet_cols = 12;
	    %>
		<%@ include file="discovery/static-sidebar-facet.jsp" %>	
	
		</div>
	</div>
</div>
</dspace:layout>
