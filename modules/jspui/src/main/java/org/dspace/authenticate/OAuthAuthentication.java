/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.authenticate;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.security.KeyStore;
import java.security.Principal;
import java.security.PublicKey;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.eurekaclinical.scribeupext.profile.EurekaAttributesDefinition;
import org.eurekaclinical.scribeupext.provider.GlobusProvider;
import org.scribe.up.credential.OAuthCredential;
import org.scribe.up.profile.UserProfile;
import org.scribe.model.Token;

import org.apache.log4j.Logger;
import org.dspace.authenticate.AuthenticationMethod;
import org.dspace.authenticate.AuthenticationManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.Group;

/**
 * Implicit authentication method that gets credentials from the X.509 client
 * certificate supplied by the HTTPS client when connecting to this server. The
 * email address in that certificate is taken as the authenticated user name
 * with no further checking, so be sure your HTTP server (e.g. Tomcat) is
 * configured correctly to accept only client certificates it can validate.
 * <p>
 * See the <code>AuthenticationMethod</code> interface for more details.
 * <p>
 * <b>Configuration:</b>
 * 
 * <pre>
 *   autoregister =
 * <em>
 * &quot;true&quot; if E-Person is created automatically for unknown new users.
 * </em>
 *   groups =
 * <em>
 * comma-delimited list of special groups to add user to if authenticated.
 * </em>
 *   emaildomain =
 * <em>
 * email address domain (after the 'at' symbol) to match before allowing 
 * membership in special groups.
 * </em>
 * </pre>
 * <p>
 * The <code>autoregister</code> configuration parameter determines what the
 * <code>canSelfRegister()</code> method returns. It also allows an EPerson
 * record to be created automatically when the presented certificate is
 * acceptable but there is no corresponding EPerson.
 * 
 * @author Larry Stone
 * @author David Hopkins
 * @version $Revision$
 */
public class OAuthAuthentication implements AuthenticationMethod
{

    /** log4j category */
    private static Logger log = Logger.getLogger(OAuthAuthentication.class);

    private static String loginPageTitle = null;

    private static String loginPageURL = null;

    /**
     * Initialization: Set caPublicKey and/or keystore. This loads the
     * information needed to check if a client cert presented is valid and
     * acceptable.
     */
    static
    {
        /*
         * allow identification of alternative entry points for certificate
         * authentication when selected by the user rather than implicitly.
         */
        loginPageTitle = ConfigurationManager
                .getProperty("authentication-oauth", "chooser.title.key");
        loginPageURL = ConfigurationManager
                .getProperty("authentication-oauth", "chooser.uri");
    }
    
    /**
     * Predicate, can new user automatically create EPerson. Checks
     * configuration value. You'll probably want this to be true to take
     * advantage of a Web certificate infrastructure with many more users than
     * are already known by DSpace.
     */
    public boolean canSelfRegister(Context context, HttpServletRequest request,
            String username) throws SQLException
    {
        return ConfigurationManager
                .getBooleanProperty("authentication-oauth", "autoregister");
    }

    /**
     * Nothing extra to initialize.
     */
    public void initEPerson(Context context, HttpServletRequest request,
            EPerson eperson) throws SQLException
    {
    }

    /**
     * We don't use EPerson password so there is no reason to change it.
     */
    public boolean allowSetPassword(Context context,
            HttpServletRequest request, String username) throws SQLException
    {
        return false;
    }

    /**
     * Returns true, this is an implicit method.
     */
    public boolean isImplicit()
    {
        return true;
    }

    /**
     * Returns a list of group names that the user should be added to upon
     * successful authentication, configured in dspace.cfg.
     * 
     * @return List<String> of special groups configured for this authenticator
     */
    private List<String> getOAuthGroups()
    {
        List<String> groupNames = new ArrayList<String>();

        String oAuthGroupConfig = null;
        oAuthGroupConfig = ConfigurationManager
                .getProperty("authentication-oauth", "groups");

        if (null != oAuthGroupConfig && !"".equals(oAuthGroupConfig))
        {
            String[] groups = oAuthGroupConfig.split("\\s*,\\s*");

            for (int i = 0; i < groups.length; i++)
            {
                groupNames.add(groups[i].trim());
            }
        }

        return groupNames;
    }

    /**
     * Checks for configured email domain required to grant special groups
     * membership. If no email domain is configured to verify, special group
     * membership is simply granted.
     * 
     * @param request -
     *            The current request object
     * @param email -
     *            The email address from the oAuth credential
     */
    private void setSpecialGroupsFlag(HttpServletRequest request, String email)
    {
        String emailDomain = null;
        emailDomain = (String) request
                .getAttribute("authentication.oauth.emaildomain");

        HttpSession session = request.getSession(true);

        if (null != emailDomain && !"".equals(emailDomain))
        {
            if (email.substring(email.length() - emailDomain.length()).equals(
                    emailDomain))
            {
                session.setAttribute("OAuth", Boolean.TRUE);
            }
        }
        else
        {
            // No configured email domain to verify. Just flag
            // as authenticated so special groups are granted.
            session.setAttribute("OAuth", Boolean.TRUE);
        }
    }

    /**
     * Return special groups configured in dspace.cfg for oAuth
     * authentication.
     * 
     * @param context
     * @param request
     *            object potentially containing the cert
     * 
     * @return An int array of group IDs
     * 
     */
    public int[] getSpecialGroups(Context context, HttpServletRequest request)
            throws SQLException
    {
        if (request == null)
        {
            return new int[0];
        }

        Boolean authenticated = false;
        HttpSession session = request.getSession(false);
        authenticated = (Boolean) session.getAttribute("OAuth");
        authenticated = (null == authenticated) ? false : authenticated;

        if (authenticated)
        {
            List<String> groupNames = getOAuthGroups();
            List<Integer> groupIDs = new ArrayList<Integer>();

            if (groupNames != null)
            {
                for (String groupName : groupNames)
                {
                    if (groupName != null)
                    {
                        Group group = Group.findByName(context, groupName);
                        if (group != null)
                        {
                            groupIDs.add(Integer.valueOf(group.getID()));
                        }
                        else
                        {
                            log.warn(LogManager.getHeader(context,
                                    "configuration_error", "unknown_group="
                                            + groupName));
                        }
                    }
                }
            }

            int[] results = new int[groupIDs.size()];
            for (int i = 0; i < groupIDs.size(); i++)
            {
                results[i] = (groupIDs.get(i)).intValue();
            }

            if (log.isDebugEnabled())
            {
                StringBuffer gsb = new StringBuffer();

                for (int i = 0; i < results.length; i++)
                {
                    if (i > 0)
                    {
                        gsb.append(",");
                    }
                    gsb.append(results[i]);
                }

                log.debug(LogManager.getHeader(context, "authenticated",
                        "special_groups=" + gsb.toString()));
            }

            return results;
        }

        return new int[0];
    }

    
    /**
     * Globus oAuth authentication. 
     * <ul>
     * <li>If the access_token is valid, and corresponds to an existing EPerson,
     * and the user is allowed to login, return success.</li>
     * <li>If the user is matched but is not allowed to login, it fails.</li>
     * <li>If the access_token is valid, but there is no corresponding EPerson,
     * the <code>"authentication.oauth.autoregister"</code> configuration
     * parameter is checked (via <code>canSelfRegister()</code>)
     * <ul>
     * <li>If it's true, a new EPerson record is created for the access_token,
     * and the result is success.</li>
     * <li>If it's false, return that the user was unknown.</li>
     * </ul>
     * </li>
     * </ul>
     * 
     * @return One of: SUCCESS, BAD_CREDENTIALS, NO_SUCH_USER, BAD_ARGS
     */
    public int authenticate(Context context, String username, String password,
            String realm, HttpServletRequest request) throws SQLException
    {

    	String oauth_code = (String)request.getSession().getAttribute("oauthcode");

    	if ((oauth_code == null) || (oauth_code.length() == 0))
        {
    		// if oauth_code = null, construct url and redirect to globus login page here...
    		return BAD_ARGS;
        }
    	//String email = (String)request.getSession().getAttribute("oauthemail");
    	
		GlobusProvider provider = OAuthAuthentication.getGlobusOAuthURL(request);
		System.out.println("Get user's OAuth credential...");
		OAuthCredential credential = new OAuthCredential(null, null, oauth_code, provider.getType());
		//System.out.println("CREDENTIAL" + credential);
		
		UserProfile userProfile = new UserProfile();
		String email = null;
		try
        {
			// Now, get the user's profile (access token is retrieved behind the scenes)
			 userProfile = provider.getUserProfile(credential);
			 if(userProfile == null)
			 {
				 System.out.println("userProfile creation failure");
				 log.warn(LogManager
                         .getHeader(context, "authenticate",
                                 "type=access_token, no eperson & cannot auto-register"));
			 }
			 else
             { 
				 log.info(LogManager.getHeader(context, "userProfile",
	                     "from=OAuth, userProfile=" + userProfile));
				 email = userProfile.getAttributes().get(EurekaAttributesDefinition.EMAIL).toString();
				 System.out.println("USER PROFILE: " + userProfile.getAttributes());
             }
	    }
	    catch (Exception ee)
	    {
	    	System.out.println("userProfile creation failure");
			request.getSession().setAttribute("oauthcode", null);
			log.warn(LogManager.getHeader(context, "failed to get user profile & access token",
	                ""), ee);
            return BAD_ARGS;
	    }
		
    	if (email == null || (email.length() == 0))
        {
            log.info(LogManager.getHeader(context, "no_email", "type=no-code_oauthAuth 336"));
            return BAD_ARGS;
        }
    	else
    	{
	    	try
	        {
                EPerson eperson = null;
                if (email != null)
                {
                    eperson = EPerson.findByEmail(context, email);
                }
                if (eperson == null)
                {
                    // email is valid, but no record.
                    if (email != null && canSelfRegister(context, request, null))
                    {
                        // Register the new user automatically
                        log.info(LogManager.getHeader(context, "autoregister",
                                "from=OAuth, email=" + email));

                        // TEMPORARILY turn off authorisation
                        context.setIgnoreAuthorization(true);
                        eperson = EPerson.create(context);
                        eperson.setEmail(email);
                        eperson.setCanLogIn(true);
                        AuthenticationManager.initEPerson(context, request,
                                eperson);
                        eperson.update();
                        context.commit();
                        context.setIgnoreAuthorization(false);
                        context.setCurrentUser(eperson);
                        setSpecialGroupsFlag(request, email);
                        return SUCCESS;
                    }
                    else
                    { 
                        // No auto-registration for valid certs
                        log
                                .warn(LogManager
                                        .getHeader(context, "authenticate",
                                                "type=access_token, no eperson & cannot auto-register"));
                        return NO_SUCH_USER;
                    }
                }

                // make sure this is a login account
                else if (!eperson.canLogIn())
                {
                    log.warn(LogManager.getHeader(context, "authenticate",
                            "type=OAuthcertificate, email=" + email
                                    + ", canLogIn=false, rejecting."));
                    return BAD_ARGS;
                }
                else
                { 
                    context.setCurrentUser(eperson);
                    setSpecialGroupsFlag(request, email);
                    //System.out.println("AUTH SUCCESS [oAuthAuthentication396]: " + eperson);
                    return SUCCESS;
                }
            }
            catch (AuthorizeException ce)
            {
                log.warn(LogManager.getHeader(context, "authorize_exception",
                        ""), ce);
            }
    	}
        return BAD_ARGS;
    }

    public static GlobusProvider getGlobusOAuthURL(HttpServletRequest request){
    	
    	GlobusProvider provider = new GlobusProvider();
        String oAuthUser = ConfigurationManager
                .getProperty("authentication-oauth", "oa.username");
        String oAuthPass = ConfigurationManager
                .getProperty("authentication-oauth", "oa.password");
        String oAuthGlobusRedirect = ConfigurationManager
                .getProperty("authentication-oauth", "oa.globusredirect");
        
    	try {
    		
			provider.setKey(oAuthUser);
			provider.setSecret(oAuthPass);
			
			System.out.println(oAuthGlobusRedirect + " oAuthGlobusRedirect url string");
			provider.setCallbackUrl(oAuthGlobusRedirect);
			
		} catch (Exception e) {
			System.out.println("Error in Globus OAuth URL generation. Message = " + e.getMessage());
		}
		return provider;
    }
    /**
     * Returns URL of password-login servlet.
     * 
     * @param context
     *            DSpace context, will be modified (EPerson set) upon success.
     * 
     * @param request
     *            The HTTP request that started this operation, or null if not
     *            applicable.
     * 
     * @param response
     *            The HTTP response from the servlet method.
     * 
     * @return fully-qualified URL
     */
    public String loginPageURL(Context context, HttpServletRequest request,
            HttpServletResponse response)
    {
        return loginPageURL;
    }

    /**
     * Returns message key for title of the "login" page, to use in a menu
     * showing the choice of multiple login methods.
     * 
     * @param context
     *            DSpace context, will be modified (EPerson set) upon success.
     * 
     * @return Message key to look up in i18n message catalog.
     */
    public String loginPageTitle(Context context)
    {
        return loginPageTitle;
    }
    
}
