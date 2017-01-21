// A servelet to respond to login page


import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class login extends HttpServlet
{

	public String getServletInfo()
	{
		return "Servlet connected";
	}
	public void doPost(HttpServletRequest request , HttpServletResponse response)
		throws IOException, ServletException
	{
		String user = "user";
		String pw = "vidhya567";
		String url = "jdbc:mysql://localhost:3306/moviedb";
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		out.println("<HTML><HEAD><TITLE> Welcome to Fablix</TITLE><HEAD></HTML>");

		try
		{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			Connection dbcon  = DriverManager.getConnection(url, user, pw);
			Statement statement = dbcon.createStatement();

			String email = request.getParameter("email");
			String password = request.getParameter("password");
			String query = "SELECT firstname,lastname from stars where email = '"+email+"' and password='"+password+"' ";
			ResultSet result = statement.executeQuery(query);
			String customerfn = result.getString("first_name");
			String customerln = result.getString("last_name");
			out.println("<p>Hai, "+customerfn+" "+customerln+"</p>");
			result.close();
			statement.close();
			dbcon.close();
		}
		catch(java.lang.Exception ex)
            {
                out.println("<HTML>" +
                            "<HEAD><TITLE>" +
                            "MovieDB: Error" +
                            "</TITLE></HEAD>\n<BODY>" +
                            "<P>SQL error in doPost: " +
                            ex.getMessage() + "</P></BODY></HTML>");
                return;
            }
         out.close();
       }
	}
