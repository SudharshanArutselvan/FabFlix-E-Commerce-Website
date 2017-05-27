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

public class checkout extends HttpServlet
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
			String lname = request.getParameter("lname");
			String cc_id=request.getParameter("id");
			String newdate = request.getParameter("date");
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd"); 
            java.util.Date startDate = df.parse(newdate);
            java.util.Date date = new java.util.Date();
            String strdate=df.format(date);
            java.util.Date sale=df.parse(strdate);
            java.sql.Date sqlDate = new java.sql.Date(startDate.getTime());
            java.sql.Date saledate = new java.sql.Date(sale.getTime());
			
		    Statement statement2 = dbcon.createStatement();
		    PreparedStatement query1 = dbcon.prepareStatement("Select id from customers where first_name=? and last_name=?");
		    query1.setString(1,fname);
		    query1.setString(2,lname);
		    ResultSet cusresult = query1.executeQuery();	
		    cusresult.next();
		    int cus_id=cusresult.getInt("id");
		    PreparedStatement query = dbcon.prepareStatement("Select id from creditcards where first_name=? and last_name=? and id=? and expiration=?");
		    query.setString(1,fname);
		    query.setString(2,lname);
		    query.setInt(3,cus_id);
		    query.setDate(4,sqlDate);
		    ResultSet result = query.executeQuery();
		    if(result.next()){
		    	String cred=result.getString("id");
		    	String headerCookie=request.getHeader("Cookie");
				String[] items={""};
				int i=0,flag=0;
				for (String retval: headerCookie.split(";")) {
			        if(retval.substring(1,6).compareTo("movie")==0){
			        	if(retval.substring(7).compareTo("")==0){ flag=1; break; }
			        	else items=(retval.substring(7)).replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\s", "").split(",");
			        } 
					i++;
			    }
			    if(flag==1) {} //request.getRequestDispatcher("cart.jsp").include(request,response); }
			    else{
			    	int[] movIDarr = new int[items.length];
					for (i = 0; i < items.length; i++) {
						try{
							movIDarr[i] = Integer.parseInt(items[i]);
					    } catch (NumberFormatException nfe) {
					    	out.println(nfe.getMessage());
					    }
					}
					for(int j=0;j<movIDarr.length;j++){
						PreparedStatement statement4 = dbcon.prepareStatement("Insert into sales values(DEFAULT,?,?,?)");
						statement4.setInt(1,cus_id );
                        statement4.setInt(2,movIDarr[j] );
                        statement4.setDate(3,saledate);
                        int rowsUpdated=statement4.executeUpdate();
                        statement4.close();
					}
			    }
			    response.getWriter().write("Success");
		    }
		    else out.println("Failed");
		    query1.close();
		    cusresult.close();
		    query.close();
		    result.close();
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
