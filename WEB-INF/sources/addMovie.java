// A servelet to respond to login page


import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

public class addMovie extends HttpServlet
{

	public String getServletInfo()
	{
		return "Servlet connected";
	}
	public void doGet(HttpServletRequest request , HttpServletResponse response)
		throws IOException, ServletException
	{
		String user = "testuser";
		String pw = "testpass";
		String url = "jdbc:mysql://localhost:3306/moviedb";
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		try
		{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			Connection dbcon  = DriverManager.getConnection(url, user, pw);
			Statement statement = dbcon.createStatement();
			String star_fname=request.getParameter("star_fname");
			if(star_fname.isEmpty()==true){
				star_fname="";
			}
			String star_lname=request.getParameter("star_lname");
			int year = Integer.parseInt(request.getParameter("year"));
			String title = request.getParameter("title");
			String director = request.getParameter("director");
			String b_url = request.getParameter("b_url");
			String t_url = request.getParameter("t_url");
			String genre = request.getParameter("genre");
	        CallableStatement cs = null;
	        try {
	            cs = dbcon.prepareCall("{call add_movie(?,?,?,?,?,?,?,?,?)}");
	            cs.registerOutParameter(1, Types.VARCHAR);
	           	cs.setString(2, title);
	            cs.setInt(3, year);
	            cs.setString(4, director);
	            cs.setString(5, b_url);
	            cs.setString(6, t_url);
	            cs.setString(7, star_fname);
	            cs.setString(8, star_lname);
	            cs.setString(9, genre);
	            boolean result=cs.execute();
	            String str = cs.getString(1);
	            // String str = cs.getString(1);
	            // System.out.println(str);
	            
	            if (str!=null) {
	                System.out.println(result);
	                response.getWriter().write(str);
	            }
	            else {
	                ResultSet rs = cs.getResultSet();
	                ResultSetMetaData metadata = rs.getMetaData();
                    int n=metadata.getColumnCount();
	                while (rs.next()) {
	                	for(int k=1;k<=n;k++) response.getWriter().write(rs.getString(k));
	                    System.out.println("Name : " + rs.getString(2));
	                }
	            }
	        } catch (SQLException e) {
	            System.err.println("SQLException: " + e.getMessage());
	        }
	        finally {
	            if (cs != null) {
	                try {
	                    cs.close();
	                } catch (SQLException e) {
	                    System.err.println("SQLException: " + e.getMessage());
	                }
	            }
	            if (dbcon != null) {
	                try {
	                    dbcon.close();
	                } catch (SQLException e) {
	                    System.err.println("SQLException: " + e.getMessage());
	                }
	            }
	        }
			//response.getWriter().write("title:"+title+" year:"+year+" b_url:"+b_url+" t_url:"+t_url+" star:"+star_fname+" "+star_lname+" genre:"+genre);
            // int rowsUpdated=statement4.executeUpdate();
            // if(rowsUpdated>0) response.getWriter().write("Success");
            // else response.getWriter().write("Failed");
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
