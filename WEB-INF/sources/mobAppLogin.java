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
public class mobAppLogin extends HttpServlet
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

		
		String user = "testuser";
		String pw = "testpass";
		String url = "jdbc:mysql://localhost:3306/moviedb";

		try
		{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			Connection dbcon  = DriverManager.getConnection(url, user, pw);
			Statement statement = dbcon.createStatement();

			String email = request.getParameter("email");
			String password = request.getParameter("password");
			String query = "SELECT first_name,last_name from customers where email = '"+email+"' and password='"+password+"' ";
			ResultSet result = statement.executeQuery(query);
			HttpSession session = request.getSession(true);
			if(result.next()){
				out.println("Success");
				result.close();
				statement.close();
				dbcon.close();
			}
			else{
				out.println("Failed");
				result.close();
				statement.close();
				dbcon.close();
			}
			
		}
		catch(java.lang.Exception ex)
        {
        	out.println("Failed");
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
