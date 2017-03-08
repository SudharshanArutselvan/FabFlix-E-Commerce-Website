// A servelet to respond to login page


import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class logout extends HttpServlet
{

	public String getServletInfo()
	{
		return "Servlet connected";
	}
	public void doGet(HttpServletRequest request , HttpServletResponse response)
		throws IOException, ServletException
	{
		
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		try
		{
			HttpSession session = request.getSession(true);
			session.invalidate();
			request.setAttribute("logout",true);
    		response.sendRedirect("/fabflix/");
		}
		catch(java.lang.Exception ex)
        {
        	request.setAttribute("logout",false);
        	response.sendRedirect("home.jsp");
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
