/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.security.cert.X509Certificate;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.dspace.app.webui.util.Authenticate;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.eperson.EPerson;
import org.dspace.authenticate.OAuthAuthentication;

import org.eurekaclinical.scribeupext.profile.EurekaAttributesDefinition;
import org.eurekaclinical.scribeupext.provider.GlobusProvider;
import org.scribe.up.credential.OAuthCredential;
import org.scribe.up.profile.UserProfile;
import org.scribe.model.Token;

/**
 * oAuth authentication servlet. This is an
 * access point for oAuth that will not be 
 * implicit (i.e. not immediately performed
 * because the resource is being accessed via HTTP
 * 
 * @author Robert Tansley
 * @author Mark Diggory
 * @version $Revision$
 */
public class OAuthServlet extends DSpaceServlet
{
    /** serialization id */
    private static final long serialVersionUID = -3571151231655696793L;
    
    /** log4j logger */
    private static Logger log = Logger.getLogger(OAuthServlet.class);

    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
			


    	String oauth_code = request.getParameter("code");
    	
    	if ((oauth_code == null) || (oauth_code.length() == 0))
        {
    		// if oauth_code = null, construct url and redirect to globus login page here...
            log.info(LogManager.getHeader(context, "no_oauth_code",
                    "type=no-oauth-code-globus-redirect"));
            String globusRedirect = ConfigurationManager
                    .getProperty("authentication-oauth", "oa.globusredirect");
            String globusLogin = ConfigurationManager
                    .getProperty("authentication-oauth", "oa.globuslogin");
            String globusUsername = ConfigurationManager
                    .getProperty("authentication-oauth", "oa.username");
            String contextPath= globusLogin + "&client_id=" + globusUsername + "&redirect_uri=" + globusRedirect;
            response.sendRedirect(response.encodeRedirectURL(contextPath));
        }
    	else
    	{
			OAuthAuthentication authCode = new OAuthAuthentication();
			if (authCode.authenticate(context, null, null, null, request) == 1)
			{
				Context ctx = UIUtil.obtainContext(request);
				
	            EPerson eperson = ctx.getCurrentUser();
		    	System.out.println("Eperson [servlet65]:" + eperson);
	
	            // Do we have an active e-person now?
	            if ((eperson != null) && eperson.canLogIn())
	            {
			    	System.out.println("active eperson = login...?");
	                // Everything OK - they should have already been logged in.
	                // resume previous request
	                Authenticate.resumeInterruptedRequest(request, response);
	
	                return;
	            }
	
	            // If we get to here, no valid cert
	            log.info(LogManager.getHeader(context, "failed_login",
	                    "type=oauth_token-nv-token"));
	            JSPManager.showJSP(request, response, "/login/no-valid-cert.jsp");
			}
			else
			{
	            log.info(LogManager.getHeader(context, "failed_login",
	                    "type=oauth_authCode.authenticate_failure"));
	            JSPManager.showJSP(request, response, "/login/no-valid-cert.jsp");
			}
    	}
    }
}
