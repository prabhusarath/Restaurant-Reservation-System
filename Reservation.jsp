<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.mongodb.MongoClient" %>
<%@ page import="com.mongodb.MongoException" %>
<%@ page import="com.mongodb.WriteConcern" %>
<%@ page import="com.mongodb.DB" %>
<%@ page import="com.mongodb.DBCollection" %>
<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.BasicDBObjectBuilder" %>
<%@ page import="com.mongodb.BasicDBList" %>
<%@ page import="com.mongodb.DBObject" %>
<%@ page import="com.mongodb.DBCursor" %>
<%@ page import="com.mongodb.ServerAddress" %>
<%@ page import="com.mongodb.AggregationOutput" %>

<%!
    String userTable = "", reserveDate = "", reserveFrom ="", reserveTo = "", info="", contact="", test="", dummyfrom = "", dummyto="";
 	String searchField = "", searchParameter = "", message = "", bookingName="", description="", testfrom="", testto="";
	Long bookingID = 0L, count = 0L;;
	
	SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
	SimpleDateFormat sdfdate = new SimpleDateFormat("dd-M-yyyy");    
	SimpleDateFormat sdfboth = new SimpleDateFormat("dd-MM-yyyy HH:mm");    
	
	private static final long serialVersionUID = 1L;
	MongoClient mongo;
	
	public void jspInit() {
      	  // Connect to Mongo DB
		  mongo = new MongoClient("localhost", 27017);		
	}
%>
<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Italian Bistro </title>
	<link rel="stylesheet" href="css/styles.css" type="text/css" />
    
</head>

<body style="background-image:url(images/1.jpg)">
     
        <div class="container">

        <div id="container">

            <header>

                <img class="header-image1" src="images/i.png" width = "50%" height = "50%" alt="Index Page Image" />
				<ul>
				<%String loggedInUser=(String)session.getAttribute("userLogged");
		if((loggedInUser!=null)&&(!loggedInUser.startsWith("Guest"))){
%>		<li class="header-button"> <form action="index.jsp"><input type="submit" name="logout" value="Logout"></input></form></li>
		<li class="header-button"> <form><input type="text" value="Welcome <%=loggedInUser%>" style="text-decoration:none"></input></form></li>
		
		<%} else{ %>
			 <li class="header-button"><form action="index.jsp"><input type="submit" name="login" value="Login"></input></form></li>
			<li class="header-button"><form action="index.jsp"><input type="submit" name="signup" value="SignUP"></input></form></li>
		<%}%>
       
		 <li class="header-button"><form action="\ItalianBistro\OrderPage"><input type="submit" name="cart" value="Shopping cart"></input></form></li>
         <li class="header-button"><form action="MyOrders.jsp"><input type="submit" name="orders" value="My Orders"></input></form></li></ul>
		

            </header>

   <nav>
        <ul>

            <li class=""><a href="index.jsp">HOME</a></li>
            <li class=""><a href="DineIn.jsp">Dine In</a></li>
            <li class=""><a href="OnlineOrder.jsp">Online Order</a></li>
            <li class=""><a href="AboutUs.html">About Us</a></li>
            <li class=""><a href="TrackOrders.jsp">Track Order </a></li>
            <li class=""><a href="Map.jsp">View Location</a></li>
            
            
        </ul>
    </nav>

    <header>
        <img class="header-image" src="images/header.jpg" width = "50%" height = "50%" alt="Index Page Image" />
    </header>
	
	<div id="body">		

	<section id="content">

        <br>
        <article class="expanded">
		        
				<%
				   try{
					     bookingName = request.getParameter("bookingName");
					     contact = request.getParameter("contact");
					     userTable = request.getParameter("tableID");
					     reserveDate = request.getParameter("reserveDate");
	                     reserveFrom = request.getParameter("reserveFrom");
						 testfrom = "00:00";  testto = "23:59"; 
						 test = reserveDate+" "+reserveFrom;
						 dummyfrom = reserveDate+" "+testfrom;
						 dummyto = reserveDate+" "+testto;
	                     reserveTo = request.getParameter("reserveTo");
						 if(reserveDate.equals("") || (reserveFrom.equals("")) || (reserveTo.equals("")))  {
							 message = "Date and time fields cannot be empty";
						 } else {
					   
					   // If database doesn't exists, MongoDB will create it for you
			              DB db = mongo.getDB("ItalianBistro");
			
	                   // If the collection does not exists, MongoDB will create it for you
			              DBCollection bistroReservations = db.getCollection("bistroReservations");								  
			
			             java.util.Date userdate = sdfdate.parse(reserveDate);						 
						 java.util.Date userFrom = sdftime.parse(reserveFrom);						 
						 java.util.Date userTo = sdftime.parse(reserveTo);
                         System.out.println("Value in test: "+test);						 
                         System.out.println("Value in dummyfrom: "+dummyfrom);						 
                         System.out.println("Value in dummyto: "+dummyto);						 
						 java.util.Date both = sdfboth.parse(test);	
						 java.util.Date testStart = sdfboth.parse(dummyfrom);	
						 java.util.Date testEnd = sdfboth.parse(dummyto);	                         	
						 
						 BasicDBObject clause1 = new BasicDBObject();
						 clause1.put("reserveFrom", new BasicDBObject("$gte", userFrom));
						 clause1.put("reserveTo", new BasicDBObject("$lte", userTo));
						 
						 BasicDBObject clause2 = new BasicDBObject();
						 clause2.put("reserveFrom", new BasicDBObject("$lte", userFrom));
						 clause2.put("reserveTo", new BasicDBObject("$gte", userTo));
						 
						 BasicDBObject clause3 = new BasicDBObject();						 
						 clause3.put("reserveFrom", BasicDBObjectBuilder.start("$gte", userFrom).add("$lte", userTo).get());
						 clause3.append("reserveTo", new BasicDBObject("$gte", userTo));						 
						 
						 BasicDBObject clause4 = new BasicDBObject();
						 clause4.put("reserveFrom", new BasicDBObject("$lte", userFrom));
						 clause4.put("reserveTo", BasicDBObjectBuilder.start("$gte", userFrom).add("$lte", userTo).get());						 
						 
						 BasicDBList orList = new BasicDBList();
						 orList.add(clause1);
						 orList.add(clause2);
						 orList.add(clause3);
						 orList.add(clause4);
						 
						 BasicDBObject clause5 = new BasicDBObject();
						 clause5.put("tableID", userTable);
						 BasicDBObject clause6 = new BasicDBObject();
						 clause6.put("reserveDate", both);
						 
						 BasicDBObject queryOr = new BasicDBObject("$or", orList);

                         BasicDBObject query1 = new BasicDBObject();
                         BasicDBObject query2 = new BasicDBObject();
                         BasicDBObject query3 = new BasicDBObject();
						 query1.put("reserveDate", new BasicDBObject("$gte", testStart));
						 query2.append("reserveDate", new BasicDBObject("$lte", testEnd));						 
						 query3.append("tableID", userTable);						 
						 
						 BasicDBList andDummy = new BasicDBList();                        				 
                         andDummy.add(query1);						 
                         andDummy.add(query2);		
                         andDummy.add(query3);		
                         andDummy.add(queryOr);		
          
                         BasicDBObject query = new BasicDBObject("$and", andDummy);
                         DBCursor cursor = bistroReservations.find(query);						 
						 
						 int dummycount = 0;
						 while(cursor.hasNext()) {
							 dummycount++;
							 BasicDBObject obj = (BasicDBObject) cursor.next();
							 System.out.println(obj.getLong("bookingID")+"        "+obj.getDate("reserveDate"));							 
						 }
						 System.out.println("dummycount: "+dummycount);					 	

                         BasicDBList andList = new BasicDBList();
                         andList.add(queryOr);						 
                         andList.add(clause5);						 
                         andList.add(clause6);		         
                         
						 if(cursor.count() == 0) {
							 System.out.println("--------------------------------------------------------------------------");
							 System.out.println("No rows found");						
							 
							 AggregationOutput aggregate = null;
							 DBObject sortField = new BasicDBObject();
							 DBObject limit = new BasicDBObject("$limit", 1);
							 DBObject sortID = new BasicDBObject();
							 sortField.put("bookingID", -1);
							 sortID.put("$sort", sortField);
							 aggregate = bistroReservations.aggregate(sortID, limit);
							 
							 boolean set = false;
							 for(DBObject result : aggregate.results()) {
						         BasicDBObject bobj = (BasicDBObject) result;
								 count = bobj.getLong("bookingID");
								 set = true;
							 }
							 
							 if(set == true)
						          bookingID = count+1;
							  else
								  bookingID = 10001L;
							 
							 BasicDBObject doc = new BasicDBObject("title", "bistroReservations").
			                 append("bookingID", bookingID).
			                 append("bookingName", bookingName).			                 
			                 append("contact", contact).			                 
			                 append("tableID", userTable).
			                 append("reserveDate", both).
				             append("reserveFrom", userFrom).
				             append("reserveTo", userTo);
				          
						     bistroReservations.insert(doc);				
			                 System.out.println("Document inserted successfully");
				             message = "Congratulations!! Your table has been booked successfully";
							 info = "success";
				         } else {
							 System.out.println("--------------------------------------------------------------------------");
							 System.out.println("Rows found: "+cursor.count());
							 message = "We are sorry.. This table is already reserved for the time and day you chose! Please try different table or time";
							 info = "failure";
						 }				  									 
						 						 
						} 
				%>
				          <br>
						  <%
						     if(info.equals("failure")) {
								 
						  %>
						      <center><h3> <%= message%> </h3>
						      <a href='Table.jsp'> <input type='submit' value='Try Again'> </a>
							  <br><br><br>
							  <a href='DineIn.jsp'> <input type='submit' value='Go back to Dine In Page'> </a></center>
							 <% } else {   %>
								 <center><h3> <%= message%> </h3>
								 <h3> Your Reservation Details </h3>
								 <table>
								    <tr>
									   <td></td><td></td><td></td><td width="30%"> Booking ID: </td>
									   <td> <%= bookingID %> </td>
									</tr>
									<tr>
									   <td></td><td></td><td></td><td width="30%"> Booking Name: </td>
									   <td> <%= bookingName %></td>
									</tr>
									<tr>
									   <td></td><td></td><td></td><td width="30%"> Contact Number: </td>
									   <td> <%= contact %></td>
									</tr>
									<tr>
									   <td></td><td></td><td></td><td width="35%"> Reservation Date (dd-MM-yyyy): </td>
									   <td> <%= reserveDate %></td>
									</tr>
									<tr>
									   <td></td><td></td><td></td><td width="30%"> Reservation From: </td>
									   <td> <%= reserveFrom %></td>
									</tr>
									<tr>
									   <td></td><td></td><td></td><td width="30%"> Reservation Till: </td>
									   <td> <%= reserveTo %></td>
									</tr>
								 </table>
								 <br>
								 <a href='Table.jsp'> <input type='submit' value='Reserve Another Table'> </a>
								 <br><br>
								 <a href='DineIn.jsp'> <input type='submit' value='Go back to Dine In Page'> </a></center>
							<% } %>
		
		
		<% 
                        }  catch (MongoException e) {
		                 	e.printStackTrace();
	                    }  
					%>
</article>       
	   </section>
        
    <aside class="sidebar">
	
            <ul>	
               <li>
                    <h4>MENU</h4>
                    <ul>
                        <li><a href="\ItalianBistro\Appetizers">Appetizers</a></li>
                        <li><a href="\ItalianBistro\Salads">Salads</a></li>
                        <li><a href="\ItalianBistro\Soups">Soups</a></li>
                        <li><a href="\ItalianBistro\Pizzas">Pizzas</a></li>
                        <li><a href="\ItalianBistro\Pastas">Pastas</a></li>
                        <li><a href="\ItalianBistro\Strudels">Strudels</a></li>
                        <li><a href="\ItalianBistro\Desserts">Desserts</a></li>
                        <li><a href="\ItalianBistro\Beverages">Beverages</a></li>
                        
                    
                    </ul>
                </li>
                
                   
                <li>
                    <h4>Reviews </h4>
                    <ul>
                        <li><a href="WriteReviews.jsp" title="premium templates">Write Reviews</a></li>
                        <li><a href="ViewReviews.jsp" title="web hosting"> View Reviews </a></li>
                    </ul>
                </li>
                
                
            </ul>
		
    </aside>
    
	<div class="clear"></div>
	</div>
           
          
       <!-- End footer top area -->
    
	<footer>
		
        <div class="footer-bottom" >

            <table style="border:0;">

                <tr  align="center">

                    <td >
                    <a href="AboutUs.html" style="color:#ffffff">About US</a>
                    </td>
                    <td>
                    <a href="FAQs.html"style="color:#ffffff">FAQ</a></td>
                     
                    <td>
                    <a href="\ItalianBistro\ContactUs"style="color:#ffffff">Contact Us</a></td>
                     
                    <td>
                    <a href="\ItalianBistro\FeedBack"style="color:#ffffff">FeedBack</a></td>

                    <td>
                    <a href="SiteMap.jsp"style="color:#ffffff">Site Map</a></td>
                     
                    </tr>
                    </table>
                    <p>Copyright &copy; 2015 Italian Bistro. All Rights Reserved.</p>
            
            
        </div>
		
    </footer>
</div>
  </div>

</body>

</html>