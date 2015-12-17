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
    String userTable = "", reserveDate = "", reserveFrom ="", reserveTo = "";
 	String searchField = "", message = "", contact = "";
	Long bookingID = 0L, searchParameter = 0L;
	
	SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
	SimpleDateFormat sdfdate = new SimpleDateFormat("dd-M-yyyy");    
	
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
		<%
		String loggedInUser=(String)session.getAttribute("userLogged");
		if((loggedInUser!=null)&&(!loggedInUser.startsWith("Guest"))){
%>		<li class="header-button"> <form action="index.jsp"><input type="submit" name="logout" value="Logout"></input></form></li>
		<li class="header-button"> <form><input type="text" value="Welcome <%=loggedInUser%>" style="text-decoration:none"></input></form></li>
		
		<%} else{%>
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
					     bookingID = Long.parseLong(request.getParameter("bookingID"));
					     
						 if(bookingID == null || bookingID == 0)  {
							 message = "Booking cannot be empty";
						 } else {					   
					      //If database doesn't exists, MongoDB will create it for you
			                 DB db = mongo.getDB("ItalianBistro");
			
	                      // If the collection does not exists, MongoDB will create it for you
			                 DBCollection bistroReservations = db.getCollection("bistroReservations");								  
			
			                 searchField = "bookingID";						 
			                 searchParameter = bookingID;	
                      
                             BasicDBObject query = new BasicDBObject();
                             query.put(searchField, searchParameter);
							 
							 java.util.Date curdate = new Date();
		                     Calendar cal = Calendar.getInstance();		   
		                     curdate = cal.getTime();
							 System.out.println("curdate: "+curdate);
							 String curtime = sdftime.format(curdate);
                             java.util.Date now = sdftime.parse(curtime);							 

                             DBCursor cursor = bistroReservations.find(query);	
                             
                             if(cursor.count() == 0) {
								 message = "Oops!! There are no reservations for this booking ID.. Please enter a correct value"; %>
                                 <br>
						         <center><h3> <%= message%> </h3></center>							   	 
							 <%} else {
								 java.util.Date today = new Date();
								 java.util.Date orderdate;	
		                         Calendar calDate = Calendar.getInstance();		   
		                         today = calDate.getTime();
		                         System.out.println("Current Date :"+today);
								 BasicDBObject obj = (BasicDBObject) cursor.next();
								 java.util.Date checkdate = obj.getDate("reserveDate");
								 reserveDate = sdfdate.format(checkdate);
								 orderdate = sdfdate.parse(reserveDate);
								 System.out.println("Order date: "+orderdate);
								 System.out.println("Subtracting.....   "+orderdate.getTime()+" - "+today.getTime());
								 long diffdate = orderdate.getTime() - today.getTime();			                     
                                 System.out.println("Difference in date: "+diffdate);							 
								 
								 if (diffdate <= 600000) {
									 message = "We are sorry.. As per our cancellation policy you can cancel a table only till 10 minutes before reservation start time";
							     } else {
								    bistroReservations.remove(query);
								    message = "Your Reservation has been cancelled successfully"; 
								 }	%>
								 <br>
						         <center><h3> <%= message%> </h3></center>
								 <center><a href='CancelResv.jsp'> <input type='submit' value='Cancel Another Table'> </a>
                                 <br><br>
								 <a href='DineIn.jsp'> <input type='submit' value='Go to Dine In Page'> </a></center>								 
							<% } %>                            							 
						 						 
					<%	} %>
				          
						  
		
		</article>
		<% 
                        }  catch (MongoException e) {
		                 	e.printStackTrace();
	                    }  
					%>
        </section>
        
    </section>

</article class="expanded">
        
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