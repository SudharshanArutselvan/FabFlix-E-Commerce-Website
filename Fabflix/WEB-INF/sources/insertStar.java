// A servelet to respond to login page


import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

public class insertStar extends HttpServlet
{

	public String getServletInfo()
	{
		return "Servlet connected";
	}
	public void doGet(HttpServletRequest request , HttpServletResponse response)
		throws IOException, ServletException
	{
		// String user = "testuser";
		// String pw = "testpass";
		// String url = "jdbc:mysql://localhost:3306/moviedb";
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		try
		{
			// Class.forName("com.mysql.jdbc.Driver").newInstance();
			// Connection dbcon  = DriverManager.getConnection(url, user, pw);

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
			String fname=request.getParameter("fname");
			if(fname.isEmpty()==true){
				fname="";
			}
			String lname=request.getParameter("lname");
			String newdate = request.getParameter("DOB");
			PreparedStatement statement4 = dbcon.prepareStatement("Insert into stars values(DEFAULT,?,?,?,?)");
			statement4.setString(1,fname);
            statement4.setString(2,lname);
			if(newdate.isEmpty()==false){
				DateFormat df = new SimpleDateFormat("yyyy-MM-dd"); 
            	java.util.Date startDate = df.parse(newdate);
            	java.sql.Date sqlDate = new java.sql.Date(startDate.getTime());
            	statement4.setDate(3,sqlDate);
			}
			else {
				statement4.setNull(3, java.sql.Types.DATE);
			}
			String p_url=request.getParameter("url");
            if(p_url.isEmpty()==true){
            	p_url="";
            }
            statement4.setString(4,p_url);
            int rowsUpdated=statement4.executeUpdate();
            if(rowsUpdated>0) response.getWriter().write("Success");
            else response.getWriter().write("Failed");
            statement4.close();
            dbcon.close();
		    //request.getRequestDispatcher("cart.jsp").include(request,response);
		}
		catch(java.lang.Exception ex)
        {
        	request.setAttribute("login",false);
        	//request.getRequestDispatcher("index.jsp").include(request,response);
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
