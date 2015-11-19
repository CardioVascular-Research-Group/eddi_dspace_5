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
 * X509 certificate authentication servlet. This is an
 * access point for interactive certificate auth that will
 * not be implicit (i.e. not immediately performed
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
    	String[] oauthParts;
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
            //JSPManager.showJSP(request, response, "/login/no-valid-cert.jsp");
        }
        else
        {
		
			if (oauth_code.contains("|")) {
				oauthParts = oauth_code.split("\\|");
			} else {
			    throw new IllegalArgumentException("String " + oauth_code + " does not contain |");
			}
			for (String s: oauthParts) {
				
			    if (s.startsWith("un=")){
			    	String oauth_un = s.substring(s.lastIndexOf("=") + 1);
			    	System.out.println("oauth_un equals " + oauth_un);
			    }else if (s.startsWith("client_id=")){
			    	String oauth_client_id = s.substring(s.lastIndexOf("=") + 1);
			    	System.out.println("oauth_client_id equals " + oauth_client_id);
			    }else if (s.startsWith("expiry=")){
			    	String oauth_expiry = s.substring(s.lastIndexOf("=") + 1);
			    	System.out.println("oauth_expiry equals " + oauth_expiry);
			    }else if (s.startsWith("SigningSubject=")){
			    	String oauth_SigningSubject = s.substring(s.lastIndexOf("=") + 1);
			    	System.out.println("oauth_SigningSubject equals " + oauth_SigningSubject);
			    }else if (s.startsWith("sig=")){
			    	String oauth_sig = s.substring(s.lastIndexOf("=") + 1);
			    	System.out.println("oauth_sig equals " + oauth_sig);
			    }else{
			    	System.out.println("Non-OAuth String: " + s);
			    }
			    
			} 
			
			
			
			/*log.info(LogManager.getHeader(context, "oauth-codee",
	                oauth_code));*/
			OAuthAuthentication authCode = new OAuthAuthentication();
			authCode.authenticate(context, null, null, null, request);

			Context ctx = UIUtil.obtainContext(request);

            EPerson eperson = ctx.getCurrentUser();
	    	System.out.println("Eperson [servlet116]:" + eperson);

            // Do we have an active e-person now?
            if ((eperson != null) && eperson.canLogIn())
            {
		    	System.out.println("active eperson = login...?");
                // Everything OK - they should have already been logged in.
                // resume previous request
                //Authenticate.resumeInterruptedRequest(request, response);

                return;
            }

            // If we get to here, no valid cert
            log.info(LogManager.getHeader(context, "failed_login",
                    "type=oauth_token-nv-token"));
            JSPManager.showJSP(request, response, "/login/no-valid-cert.jsp");
        }
    }
}
