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

		try
		{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			Connection dbcon  = DriverManager.getConnection(url, user, pw);
			Statement statement = dbcon.createStatement();

			String email = request.getParameter("email");
			String password = request.getParameter("password");
			String query = "SELECT first_name,last_name from customers where email = '"+email+"' and password='"+password+"' ";
			ResultSet result = statement.executeQuery(query);
			result.next();
			String customerfn = result.getString("first_name");
			String customerln = result.getString("last_name");
			
			//getting movie data
			String moviequery = "SELECT title,banner_url from movies";
			ResultSet movieresult = statement.executeQuery(moviequery);
			Vector <String> movielist = new Vector<String>  ();
			Vector <String> imagelist = new Vector<String> ();
			while(movieresult.next())
			{  
				String moviename = movieresult.getString("title");
				String banner_url = movieresult.getString("banner_url");
				movielist.add(moviename);
				imagelist.add(banner_url);

			}
			request.setAttribute("movie",movielist);
			request.setAttribute("images",imagelist);
			request.getRequestDispatcher("home.jsp").include(request,response);
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
