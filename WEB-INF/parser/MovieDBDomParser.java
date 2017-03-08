import java.io.*;
import java.net.*;
import java.text.*;
import java.util.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.Reader;
import java.sql.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import com.ibatis.common.jdbc.ScriptRunner;

public class MovieDBDomParser {

    Document actorsdom;
    Document castsdom;
    Document moviesdom;
    PrintWriter actorwriter;
    PrintWriter castwriter;
    PrintWriter moviewriter;

    public void runExample() {

        System.out.println("Parsing the actors63.xml file!");

        //parse the xml file and get the dom object
        parseActorXmlFile("actors63.xml",1);

        //get each employee element and create a Employee object
        parseActorDocument("/var/lib/mysql-files/actors.txt",1);

        System.out.println("\nParsed the actors details and saved in a file to be executed by the SQL script\n\nParsing the casts124.xml file!");
        parseCastXmlFile("casts124.xml",2);

        //get each employee element and create a Employee object
        parseCastDocument("/var/lib/mysql-files/casts.txt",2);

        System.out.println("\nParsed the casts details and saved in a file to be executed by the SQL script\n\nParsing the mains243.xml file!");
        parseMovieXmlFile("mains243.xml",3);

        //get each employee element and create a Employee object
        parseMovieDocument("/var/lib/mysql-files/movies.txt",3);
        System.out.println("\nParsed the movies details and saved in a file to be executed by the SQL script");

    }

    private void parseActorXmlFile(String xmlFile, int type) {
        //get the factory
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

        try {

            //Using factory get an instance of document builder
            DocumentBuilder db = dbf.newDocumentBuilder();
            actorsdom = db.parse(xmlFile);

        } catch (ParserConfigurationException pce) {
            pce.printStackTrace();
        } catch (SAXException se) {
            se.printStackTrace();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }
    }

    private void parseCastXmlFile(String xmlFile, int type) {
        //get the factory
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

        try {

            //Using factory get an instance of document builder
            DocumentBuilder db = dbf.newDocumentBuilder();
            castsdom = db.parse(xmlFile);

        } catch (ParserConfigurationException pce) {
            pce.printStackTrace();
        } catch (SAXException se) {
            se.printStackTrace();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }
    }

    private void parseMovieXmlFile(String xmlFile, int type) {
        //get the factory
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

        try {

            //Using factory get an instance of document builder
            DocumentBuilder db = dbf.newDocumentBuilder();
            moviesdom = db.parse(xmlFile);

        } catch (ParserConfigurationException pce) {
            pce.printStackTrace();
        } catch (SAXException se) {
            se.printStackTrace();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }
    }

    private void parseActorDocument(String outFile, int type) {
        //get the root elememt
        Element docEle = actorsdom.getDocumentElement();
        try{
            actorwriter = new PrintWriter(outFile, "UTF-8");
        }
        catch(IOException e){
            System.out.println("Error:"+e.getMessage());
        }
        //get a nodelist of <employee> elements
        NodeList nl = docEle.getElementsByTagName("actor");
        if (nl != null && nl.getLength() > 0) {
            for (int i = 0; i < nl.getLength(); i++) {

                //get the employee element
                Element el = (Element) nl.item(i);

                getActors(el);
            }
        }
        actorwriter.close();
    }

    private void parseCastDocument(String outFile, int type) {
        //get the root elememt
        Element docEle = castsdom.getDocumentElement();
        try{
            castwriter = new PrintWriter(outFile, "UTF-8");
        }
        catch(IOException e){
            System.out.println("Error:"+e.getMessage());
        }
        //get a nodelist of <employee> elements
        NodeList nl = docEle.getElementsByTagName("dirfilms");
        if (nl != null && nl.getLength() > 0) {
            for (int i = 0; i < nl.getLength(); i++) {

                //get the employee element
                Element el = (Element) nl.item(i);

                getCasts(el);
            }
        }
        castwriter.close();
    }

    private void parseMovieDocument(String outFile, int type) {
        //get the root elememt
        Element docEle = moviesdom.getDocumentElement();
        try{
            moviewriter = new PrintWriter(outFile, "UTF-8");
        }
        catch(IOException e){
            System.out.println("Error:"+e.getMessage());
        }
        //get a nodelist of <employee> elements
        NodeList nl = docEle.getElementsByTagName("directorfilms");
        if (nl != null && nl.getLength() > 0) {
            for (int i = 0; i < nl.getLength(); i++) {

                //get the employee element
                Element el = (Element) nl.item(i);

                getMovies(el);
            }
        }
        moviewriter.close();
    }

    /**
     * I take an employee element and read the values in, create
     * an Employee object and return it
     * 
     * @param empEl
     * @return
     */
    private void getActors(Element empEl) {

        //for each <employee> element get text or int values of 
        //name ,id, age and name
        String fname = getTextValue(empEl, "firstname");
        String lname = getTextValue(empEl, "familyname");
        String dob = getTextValue(empEl, "dob");
        String stagename = getTextValue(empEl, "stagename");
        try{
            lname=lname.trim();
            fname=fname.trim();
            int len=fname.length();
            if(fname.substring(len-1).compareTo("\\")==0){
                // System.out.println("Prev:"+fname+" New:"+fname.substring(0,len-1));
                fname=fname.substring(0,len-1);
            }
        }
        catch(NullPointerException e){}
        dob="\\N";
            if(lname!=null&&lname!=" "&&lname!=""){
                
            }
            else if(fname!=null&&lname!=" "&&fname!=""){
                lname=fname;
                fname="";
            }
            else{
                int co=0;
                lname="";
                for (String retval: stagename.split(" ")) {
                    if(co==0) fname=retval;
                    else lname+=retval;
                    co++;
                }
                if(co==1){
                    lname=fname;
                    fname="";
                }
            }
            actorwriter.println(stagename+"|"+fname+"|"+lname+"|"+dob);
            // System.out.println("Stagename:"+stagename+"Firstname:"+fname+" Lastname:"+lname+" DOB:"+dob);

    }

    private void getCasts(Element empEl) {

        //for each <employee> element get text or int values of 
        //name ,id, age and name
        String dirid = getTextValue(empEl, "dirid");
        String dirname = getTextValue(empEl, "is");
        try{
            dirname=dirname.replace("\n","");
        }
        catch(NullPointerException e){}
        NodeList nodel = empEl.getElementsByTagName("filmc");
        if (nodel != null && nodel.getLength() > 0) {
            for (int j = 0; j < nodel.getLength(); j++) {
                Element ele = (Element) nodel.item(j);
                NodeList nl = ele.getElementsByTagName("m");
                if (nl != null && nl.getLength() > 0) {
                    for (int i = 0; i < nl.getLength(); i++) {

                        //get the employee element
                        Element el = (Element) nl.item(i);
                            String title = getTextValue(el, "t");
                            String actor = getTextValue(el, "a");
                            try{
                                title=title.replace("\n","");
                                actor=actor.trim();
                                int len=actor.length();
                                if(actor.substring(len-1).compareTo("\\")==0){
                                    //System.out.println("Prev:"+actor+" New:"+actor.substring(0,len-1));
                                    actor=actor.substring(0,len-1);
                                }
                                    //System.out.println("Prev:"+actor+" New:"+actor.replace("\n",""));
                            }
                            catch(NullPointerException e){}
                            // System.out.println("Title:"+title+" Director:"+dirname+" Actor:"+actor);
                            castwriter.println(dirid+"|"+dirname+"|"+title+"|"+actor);
                            
                    }
                }
            }
        }
    }


    private void getMovies(Element empEl) {

        //for each <employee> element get text or int values of 
        //name ,id, age and name
        String dirid = getTextValue(empEl, "dirid");
        String dirname = getTextValue(empEl, "dirname");
        NodeList nl = empEl.getElementsByTagName("films");
        if (nl != null && nl.getLength() > 0) {
            for (int i = 0; i < nl.getLength(); i++) {

                //get the employee element
                Element ele = (Element) nl.item(i);
                NodeList l = ele.getElementsByTagName("film");
                if (l != null && l.getLength() > 0) {
                    for (int j = 0; j < l.getLength(); j++) {
                        Element el = (Element) l.item(j);
                        String title = getTextValue(el, "t");
                        int year = getIntValue(el, "year");
                        String genre="";
                        NodeList lists = ele.getElementsByTagName("cats");
                        if (lists != null && lists.getLength() > 0) {
                            Element ment = (Element) lists.item(0);
                            genre=getTextValue(ment,"cat");
                        }
                        // System.out.println("Title:"+title+" Director:"+dirname+" year:"+year+" Genre:"+genre);
                        if(year==0) moviewriter.println(dirid+"|"+dirname+"|"+title+"|\\N|"+genre);
                        else moviewriter.println(dirid+"|"+dirname+"|"+title+"|"+year+"|"+genre);
                    }
                    
                }
            }
        }
    }


    /**
     * I take a xml element and the tag name, look for the tag and get
     * the text content
     * i.e for <employee><name>John</name></employee> xml snippet if
     * the Element points to employee node and tagName is name I will return John
     * 
     * @param ele
     * @param tagName
     * @return
     */
    private String getTextValue(Element ele, String tagName) {
        String textVal = null;
        NodeList nl = ele.getElementsByTagName(tagName);
        if (nl != null && nl.getLength() > 0) {
            Element el = (Element) nl.item(0);
            try{textVal = el.getFirstChild().getNodeValue();}
            catch(NullPointerException e){ }
        }

        return textVal;
    }

    /**
     * Calls getTextValue and returns a int value
     * 
     * @param ele
     * @param tagName
     * @return
     */
    private int getIntValue(Element ele, String tagName) {
        //in production application you would catch the exception
        int x;
        try{
            x=Integer.parseInt(getTextValue(ele, tagName));
        }
        catch(NullPointerException e){
            x=0;
        }
        catch(NumberFormatException e){
            x=0;
        }
        return x;
    }

    public static void main(String[] args) {
        //create an instance
        long startTime = System.currentTimeMillis();

        MovieDBDomParser dpe = new MovieDBDomParser();

        //call run example
        dpe.runExample();
        String aSQLScriptFilePath = "task5.sql";

        // Create MySql Connection
        try{
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "user", "vidhya567");
            Statement stmt = null;

            try {
                // Initialize object for ScripRunner
                ScriptRunner sr = new ScriptRunner(con, false, true);

                // Give the input file to Reader
                Reader reader = new BufferedReader(
                                   new FileReader(aSQLScriptFilePath));
                System.out.println("\n\nStarting to execute the  MySQL statements in the SQL script file!\n\nThe parsing and update may take upto 12-15 mins. Please wait patiently! Thank you.\n\n");
                // Exctute script
                sr.runScript(reader);

                System.out.println("\n\n\nFinished executing the script!");

            } catch (Exception e) {
                System.err.println("Failed to Execute" + aSQLScriptFilePath
                        + " The error is " + e.getMessage());
            }
        }
        catch(java.lang.Exception ex){
            System.out.println("Error connecting to DB:" + ex.getMessage());
        }

        long endTime   = System.currentTimeMillis();
        long totalTime = endTime - startTime;
        long mins=(totalTime/1000)/60;
        long secs=(totalTime/1000)%60;
        System.out.println("\nTotal Time Taken by the time to parse and populate the database: "+mins+"mins "+secs+"secs.");

    }

}