Project 5 Team Id 01



load balancer  ec2-35-164-203-85.us-west-2.compute.amazonaws.com
master instance ec2-52-40-45-138.us-west-2.compute.amazonaws.com
slave instance ec2-54-70-169-166.us-west-2.compute.amazonaws.com
old instance(one we had for the 4 projects) ec2-35-160-136-227.us-west-2.compute.amazonaws.com


We have used java to read the log file we create during the request made to calculate the TS and TJ.
You can compile this java file using the command javac averageTimeCalculator.java
To run the file it is java averageTimeCalculator

Also we have included this in our project that you can check the values in /fabflix/getAvg url to get the results.

This is used to read the log file created and then extract the times TS and TJ and add all the times of the requests and takes the average.
