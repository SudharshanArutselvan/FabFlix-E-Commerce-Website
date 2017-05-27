// A servelet to respond to login page


import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
 
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.net.ssl.HttpsURLConnection;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

public class login extends HttpServlet
{

	public String getServletInfo()
	{
		return "Servlet connected";
	}
	public static final String SITE_VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify";
    public static final String SECRET_KEY = "6Lf7zRUUAAAAAM4Ni5qepNS5qIBHvld0QOjsoMbz";
    
	public void doPost(HttpServletRequest request , HttpServletResponse response)
		throws IOException, ServletException
	{
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
		//out.println("gRecaptchaResponse=" + gRecaptchaResponse);
		// Verify CAPTCHA.
		boolean valid=true;
		if (gRecaptchaResponse == null || gRecaptchaResponse.length() == 0) {
            valid= false;
        }
 
        try {
            URL verifyUrl = new URL(SITE_VERIFY_URL);
 
            // Open Connection to URL
            HttpsURLConnection conn = (HttpsURLConnection) verifyUrl.openConnection();
 
  
            // Add Request Header
            conn.setRequestMethod("POST");
            conn.setRequestProperty("User-Agent", "Mozilla/5.0");
            conn.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
 
 
            // Data will be sent to the server.
            String postParams = "secret=" + SECRET_KEY + "&response=" + gRecaptchaResponse;
 
            // Send Request
            conn.setDoOutput(true);
            
            // Get the output stream of Connection
            // Write data in this stream, which means to send data to Server.
            OutputStream outStream = conn.getOutputStream();
            outStream.write(postParams.getBytes());
 
            outStream.flush();
            outStream.close();
 
            // Response code return from server.
            int responseCode = conn.getResponseCode();
 
  
            // Get the InputStream from Connection to read data sent from the server.
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String inputLine;
			StringBuffer res = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				res.append(inputLine);
			}
			in.close();

			// out.println("Response JSON:"+res.toString());
 			
            JsonReader jsonReader = Json.createReader(new StringReader(res.toString()));
            JsonObject jsonObject = jsonReader.readObject();
            jsonReader.close();
 
            boolean success = jsonObject.getBoolean("success");
            valid=success;
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error MEssage:"+e.getMessage());
            valid= false;
        }
		if (!valid) {
		    //errorString = "Captcha invalid!";
		    out.println("<HTML>" +
				"<HEAD><TITLE>" +
				"ReCpatcha: Error" +
				"</TITLE></HEAD>\n<BODY>" +
				"<P>Recaptcha WRONG!!!! </P></BODY></HTML>");
		    return;
		}
		String user = "testuser";
		String pw = "testpass";
		String url = "jdbc:mysql://localhost:3306/moviedb";

		try
		{
			Context initCtx = new InitialContext();
            if (initCtx == null)
                out.println("initCtx is NULL");
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            if (envCtx == null)
                out.println("envCtx is NULL");
            // Look up our data source
            DataSource ds = (DataSource) envCtx.lookup("jdbc/moviedb");

            // the following commented lines are direct connections without pooling
            //Class.forName("org.gjt.mm.mysql.Driver");
            //Class.forName("com.mysql.jdbc.Driver").newInstance();
            //Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);

            if (ds == null)
                out.println("ds is null.");
            Connection dbcon = ds.getConnection();
            if (dbcon == null)
                out.println("dbcon is null.");
			Statement statement = dbcon.createStatement();

			String email = request.getParameter("email");
			String password = request.getParameter("password");
			PreparedStatement query = dbcon.prepareStatement("SELECT first_name,last_name from customers where email=? and password=? ");
			query.setString(1,email);
			query.setString(2,password);
			ResultSet result = query.executeQuery();
			HttpSession session = request.getSession(true);
			if(result.next()){
				String customerfn = result.getString("first_name");
				String customerln = result.getString("last_name");
				String sessionName = (String)session.getAttribute("name");
				String check = (String)session.getAttribute("check");
			    if (sessionName == null) {
			      	sessionName = customerfn+" "+customerln;
			      	Cookie cookie = new Cookie("username",sessionName);
					response.addCookie(cookie);
			    }
			    if(check==null){
			    	check="success";
			    }
			    session.setAttribute("name", sessionName); 
			    session.setAttribute("check", check); 
				request.setAttribute("f_name",customerfn);
				request.setAttribute("l_name",customerln);
				request.getRequestDispatcher("/home").include(request,response);
				result.close();
				statement.close();
				dbcon.close();
			}
			else{
				// out.println("login failed");
				String sessionName = (String)session.getAttribute("name");
				String check = (String)session.getAttribute("check");
			    if(check==null){
			    	check="failed";
			    }
			    session.setAttribute("name", sessionName); 
			    session.setAttribute("check", check); 
				request.getRequestDispatcher("/").include(request,response);
				result.close();
				statement.close();
				dbcon.close();
			}
			
		}
		catch(java.lang.Exception ex)
        {
        	HttpSession session = request.getSession(true);
        	String check = (String)session.getAttribute("check");
		    session.setAttribute("check", "failed"); 
        	request.setAttribute("login",false);
        	request.getRequestDispatcher("/").include(request,response);
                // out.println("<HTML>" +
                //             "<HEAD><TITLE>" +
                //             "MovieDB: Error" +
                //             "</TITLE></HEAD>\n<BODY>" +
                //             "<P>SQL error in doPost: " +
                //             ex.getMessage() + "</P></BODY></HTML>");
                // return;
        }
         out.close();
    }
}
