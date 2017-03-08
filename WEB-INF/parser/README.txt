README for Project 3 - FabFlix

**** Please rename the war file to 'fabflix' without quotes to run the application properly ****

Team ID: 01

Team Members:
Natarajan Chidhambharam
Sudharshan Arutselvan
Vidhyasagar Thirumaraiselvan

Login credentials for manager:
user: admin
password: password

Address of AWS instance "ec2-35-160-136-227.us-west-2.compute.amazonaws.com:8443/"

Created an user named 'testuser' with the password 'testpass' to access the moviedb.

All the java source files required for the web application is already compiled. If you want to compile it though, the commands are:

Compile: sudo javac -cp .:../lib/javax.json-1.0.4.jar:../lib/servlet-api.jar *.java
Move the class file: sudo mv *.class ../classes

The war file can be directly uploaded and the application will run. For the parser you have to run the program in parser folder as per instructions given in Task 5


Task 1: Did not register any domain

Task 2: Recaptcha has been added to both customer login and employee login pages and validated in the server.

Task 3: Changed the application to HTTPS only mode.

Task 4:
	New table employees has been created and classta has been added to the database.
	Created link for employees to login and employee is directed to the dashboard.
	The dashboard has three features.
		1. Enter a new star into the database.
		2. Look at the metadata of the database.
		3. Add a new movie into the database. This has been implemented using the add_movie stored procedure.
	
	Each feature is given a button, clicking each will let the employee choose one option to work on.

Task 5:
	To run the task 5 xml parsing follow the steps given below.
	1. You will find the MovieDBDomParser.java file in the /WEB-APPS/parser/ folder. This will do the parsing and populate the database.
	2. Command to compile and run the java source file is
		Compile - sudo javac -cp .:../lib/ibatis-common-2.jar:../lib/mysql-connector-java.jar MovieDBDomParser.java
		Run     - sudo java -cp .:../lib/ibatis-common-2.jar:../lib/mysql-connector-java.jar MovieDBDomParser
	3. Once the program has started to run it will take around 12-15 mins to complete the parsing and uploading the file.

	Note: If you are moving the parser java file to some other location move all the files in the parser folder to the same location.

Implementation in Task 5 with the data:

	1. Removed duplicates from the data retrieved from the xml parser.
	2. Did not insert movies or actor or genre details which are already present in the moviedb.
	3. actors63.xml had few discrepancies with the data that created problems while inserting. The issue was due to presence of back slash('\') at end of string
	   Handled this by removing the character wherever present.
	4. In casts124.xml there were few data which had new line characters. This was again replaced with empty string to upload proper insert.
	5. Since there was only year present for dob ,we omitted dob of stars and uploaded it as null in DB.
	6. If there was no name in familyname of stars in actors63.xml, the firstname was taken as lastname and firstname was made empty string.
	7. If both firstname and familyname were empty used the stagename, split it and put it as firstname and lastname.
	8. Did not insert any record which had null values against the not null(required) columns.

