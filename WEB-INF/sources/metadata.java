// A servelet to respond to login page


import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class metadata extends HttpServlet
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
			Connection connection  = DriverManager.getConnection(url, user, pw);
			DatabaseMetaData databaseMetaData = connection.getMetaData();
            String   catalog          = null;
            String   schemaPattern    = null;
            String   tableNamePattern = null;
            String[] types            = null;
            ResultSet result = databaseMetaData.getTables(catalog, schemaPattern, tableNamePattern, types );
            out.println("<div>The tables present:</div>");
            while(result.next()) {
                String tableName = result.getString(3);
                System.out.println(tableName);
                String   table_catalog           = null;
                String   table_schemaPattern     = null;
                String   tableNameGiven  = result.getString(3);
                String   columnNamePattern = null;
                out.println("<br><br><div>"+tableNameGiven+"</div>");
                ResultSet result2 = databaseMetaData.getColumns(table_catalog, table_schemaPattern, tableName, columnNamePattern);
                while(result2.next()){
                    String columnName = result2.getString(4);
                    int    columnType = result2.getInt(5);
                    String columnDataType="";
                    if(columnType==4) columnDataType="Integer";
                    else if(columnType==12) columnDataType="String";
                    else if(columnType==91) columnDataType="Date";
                    out.println("<div>Column Name: "+columnName+"  Type: "+columnDataType+"</div>");
                }
            }
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
