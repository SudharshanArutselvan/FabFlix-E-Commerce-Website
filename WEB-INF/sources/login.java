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
				String sessionName = (String)session.getAttribute("name");
				String check = (String)session.getAttribute("check");
			    if(check==null){
			    	check="failed";
			    }
			    session.setAttribute("name", sessionName); 
			    session.setAttribute("check", check); 
				request.getRequestDispatcher("index.jsp").include(request,response);
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
        	request.getRequestDispatcher("index.jsp").include(request,response);
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
