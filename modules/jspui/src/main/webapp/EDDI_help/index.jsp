<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Feedback form JSP
  -
  - Attributes:
  -    feedback.problem  - if present, report that all fields weren't filled out
  -    authenticated.email - email of authenticated user, if any
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>



<dspace:layout titlekey="jsp.feedback.form.title">

<h1>EDDI User Guide</h1>
<h2>Site Structure</h2>
<h3><a href="/community-list">Communities &amp; Collections</a></h3>
<p><a href="/community-list">Communities &amp; Collections</a> is the core element of the EDDI site. There are  currently communities for <a href="/handle/11614/1">ECG</a> and <a href="/handle/11614/1654">Electrophysiology Data.</a> These communities  each contain a collection for datasets and publications which can be accessed  directly from this page.</p>
<h3>Browsing Publications</h3>
<p>The Publications Collection for a Community (e.g. ECG Publications) contains a  complete listing of all publications submitted. The index can be browsed by  Submit Date, Author, or Title order. Individual publication items contain all  metadata for a publication provided by the submitter. The &quot;Referenced  Datasets&quot; field contains a list of all Dataset items within EDDI that the  current publication references. Clicking on any entry will open the dataset in a  new tab of your browser.</p>
<h3>Browsing Datasets</h3>
<p>The Dataset page for a community contains a similar list of all datasets  submitted to a collection which can be sorted using the same criteria as  publications. A brief description of the most important metadata for dataset  entries is listed below. </p>
<ul>
  <li>Title: Name of the dataset resource</li>
  <li>Dataset Description: A brief text description of  the dataset, formats, research, and acquisition techniques. More detailed  descriptions of the resource may also be available below as file attachments to  the dataset by the original poster.</li>
  <li>Data Access URL(s): Permalink/handle/URL pointing to the  archived data resource. (Raw files or webpage for requesting data)</li>
  <li>Globus Shared Endpoint Name &amp; Endpoint Path:  For data stored within Globus, the endpoint name and path will serve as the  location to access the dataset.</li>
  <li>Data Access Restrictions: A brief description of  any access and use restrictions or instructions necessary to obtain the data.</li>
  <li>Data Formats(s): List of file formats the data is  archived with.</li>
  <li>P.I. Name, Email &amp; Affiliation: Contact  information for the principal investigator or the primary contact with  questions regarding the dataset.</li>
  <li>Data Use Citation: Link to publication or other  material which should be cited when using the data. </li>
  <li>Appears in Collections: A list of collections  within EDDI which the item appears in. (Datasets and publications may be  represented in more than one community)</li>
  <li>Files in This Item: Data archived with the  Dataset item in EDDI. This may include sample data files or the full dataset,  as well as an expanded description, published journals referencing the  material, or further documentation (e.g., data acquisition, reuse, or experiment reproducibility).</li>
  <li>Click here to view publications associated with  this database: By means of this link, users can quickly view all archived  publications in EDDI which reference that dataset.</li>
</ul>
<h3>Dataset and  Publication entry. </h3>
<p>For registered users who have been given appropriate permissions to work within  communities, Datasets and Publications can be submitted to the EDDI archive.  Below is a brief description of the submission process.</p>
<ul>
  <li>Dataset entry.</li>
  <li>Entry of journal publications which are paired  with EDDI Dataset(s) during the submission process.</li>
  <li>Publication and Dataset curation and approval by  EDDI administrators.</li>
</ul>
<p><img style="border:2px solid black" src="../image/CVRG_EDDI_Workflow-extended-900px.jpg" /></p>

<h2>Additional Resources</h2>
<h3><a href="/mydspace">Search EDDI</a></h3>
<p>All fields in Data and Publication items are catalogued using a Solr Search  index. The 'Search EDDI' tab allows site users to quickly scan all entries  based on any data or publications documented in EDDI. The search page presents  users with a case-sensitive interface to search all its fields, returning all  items that meet the search criteria. The search results can then be filtered  further, based upon specific values for certain fields. </p>
<h3><a href="/mydspace">My EDDI</a></h3>
<p>The My EDDI page allows authenticated users to view their previous submissions of datasets  and publications and provides a quick link to the EDDI homepage as well as a  link to start new submissions. This page also contains a list of all in-process entries by that  user and items submitted to  the archive with their status in the curation process. Links to other  user management functions (email preferences and edit profile) are available in  the user login dropdown menu located in the top right corner of the page.<strong></strong></p>
<h3><a href="/feedback">Feedback Page</a></h3>
<p>The Feedback page contains a simple method for contacting the EDDI development and administration team directly.<strong></strong></p>
<h3>Privacy Policy</h3>
<p>An up-to-date Privacy Policy for the EDDI Portal is maintained through the CVRG  Wiki site and can be found <a href="http://wiki.cvrgrid.org/index.php/CVRG_EDDI_Privacy_Policy" target="_blank">here.</a></p>
<h3>Terms of Use</h3>
<p>An up-to-date Terms of Use for the EDDI Portal is maintained through the CVRG  Wiki site and can be found <a href="http://wiki.cvrgrid.org/index.php/CVRG_EDDI_Terms_of_Use" target="_blank">here.</a></p>
<h3>DSpace Help</h3>
<p>General help for users of DSpace, the software EDDI is extended from, is available on the help page <a href="/help/" target="_blank">here.</a></p>

</dspace:layout>
