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
import org.dspace.authenticate.AuthenticationMethod;
import org.dspace.authenticate.OAuthAuthentication;

import org.eurekaclinical.scribeupext.profile.EurekaAttributesDefinition;
import org.eurekaclinical.scribeupext.provider.GlobusProvider;
import org.scribe.up.credential.OAuthCredential;
import org.scribe.up.profile.UserProfile;
import org.scribe.model.Token;

/**
 * oAuth authentication servlet. This is an access point
 * for Authenticating users via Globus oAuth authorization. 
 * 
 * @author Robert Tansley
 * @author Mark Diggory
 * @author David Hopkins
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
//			request.getSession().setAttribute("oauthcode", oauth_code);
    		
			GlobusProvider provider = OAuthAuthentication.getGlobusOAuthURL(request);
			System.out.println("Get user's OAuth credential...");
			OAuthCredential credential = new OAuthCredential(null, null, oauth_code, provider.getType());
			System.out.println("CREDENTIAL" + credential);
			
			// Now, get the user's profile (access token is retrieved behind the scenes)
			UserProfile userProfile = provider.getUserProfile(credential);
			System.out.println("USER PROFILE: " + userProfile.getAttributes());
			
            // And it's valid - try and get an e-person
        	String email = userProfile.getAttributes().get(EurekaAttributesDefinition.EMAIL).toString();
			request.getSession().setAttribute("oauthemail", email);
            
//			EPerson eperson = null;
//            if (email != null)
//            {
//                eperson = EPerson.findByEmail(context, email);
//            }
//			
//            if (eperson == null){
//    			Context ctx = UIUtil.obtainContext(request);
//            	eperson = ctx.getCurrentUser();
//            }

            Authenticate.resumeInterruptedRequest(request, response);
            
            return;
    	}
    }
}
