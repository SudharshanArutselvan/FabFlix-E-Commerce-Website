import java.io.*;
import java.net.*;
import java.text.*;
import java.util.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.Reader;

public class averageTimeCalculator extends HttpServlet
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
        
        String filePath = "/var/lib/tomcat7/webapps/fabflix/WEB-INF/sources/usertimeLog.txt";

        try{

            BufferedReader in = new BufferedReader(new FileReader(filePath));
            String str;
            long valTS=0,valTJ=0,count=0;
            while ((str = in.readLine()) != null){
                count++;
                int strc=0;
                for (String retval: str.split(">")) {
                    strc++;
                    if(strc==2) out.println("<div>"+retval+"</div>");
                    // System.out.println(retval);    out.println("<div>Parsed"+Integer.parseInt(retval.substring(3))+" NP:"+retval+"</div>"); 
                    if(strc==3){ valTS+=Integer.parseInt(retval.substring(3)); }
                    else if(strc==4) valTJ+=Integer.parseInt(retval.substring(3));
                }  
            }
            out.println("Count:"+count);
            float avgTS=valTS/(count*1000000), avgTJ= valTJ/(count*1000000);
            out.println("Average TS:"+avgTS+"ms Average TJ:"+avgTJ+"ms");
            in.close();
        } catch (IOException e) {
        }

        // long endTime   = System.currentTimeMillis();
        // long totalTime = endTime - startTime;
        // long mins=(totalTime/1000)/60;
        // long secs=(totalTime/1000)%60;
        // System.out.println("\nTotal Time Taken by the time to parse and populate the database: "+mins+"mins "+secs+"secs.");

    }

}