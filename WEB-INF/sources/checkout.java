// A servelet to respond to login page


import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class checkout extends HttpServlet
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
			String cc_id=request.getParameter("id");
			String newdate = request.getParameter("date");
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd"); 
            java.util.Date startDate = df.parse(newdate);
            java.util.Date date = new java.util.Date();
            String strdate=df.format(date);
            java.util.Date sale=df.parse(strdate);
            java.sql.Date sqlDate = new java.sql.Date(startDate.getTime());
            java.sql.Date saledate = new java.sql.Date(sale.getTime());
			HttpSession session = request.getSession(true);
			String sessionName = (String)session.getAttribute("name");
			String fname="",lname="";
		    if (sessionName == null) {
		    	//request.getRequestDispatcher("cart.jsp").include(request,response);
		    }
		    else{
		    	fname=sessionName.split(" ")[0];
		    	lname=sessionName.split(" ")[1];
		    }
		    Statement statement2 = dbcon.createStatement();
		    String query1="Select id from customers where first_name='"+fname+"' and last_name='"+lname+"'";
		    ResultSet cusresult = statement.executeQuery(query1);	
		    cusresult.next();
		    int cus_id=cusresult.getInt("id");
		    String query="Select id from creditcards where first_name='"+fname+"' and last_name='"+lname+"' and id='"+cc_id+"' and expiration='"+sqlDate+"'";
		    ResultSet result = statement.executeQuery(query);
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
					}
			    }
			    response.getWriter().write("Success");
		    }
		    else out.println("Failed");
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
