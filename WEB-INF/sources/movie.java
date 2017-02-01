// A servelet to respond to movie page


import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class movie extends HttpServlet
{

	public String getServletInfo()
	{
		return "Servlet connected";
	}
	public void doGet(HttpServletRequest request , HttpServletResponse response)
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

			int movieID = Integer.parseInt(request.getParameter("id"));
			String query = "SELECT * from movies where id = "+movieID;
			ResultSet result = statement.executeQuery(query);
			result.next();
			out.println("<HTML>" +
                            "<HEAD><TITLE>" +
                            "MovieDB: Error" +
                            "</TITLE></HEAD>\n<BODY>" +
                            "<P>Movie: " +
                            result.getString("title") + "</P></BODY></HTML>");
			result.close();
			statement.close();
			dbcon.close();
		}
		catch(java.lang.Exception ex)
        {
        	//request.getRequestDispatcher("index.html").include(request,response);
        	response.setContentType("text/html");
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
