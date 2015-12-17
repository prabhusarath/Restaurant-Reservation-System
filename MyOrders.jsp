
<%@ page import="javabean.*, java.util.HashMap, java.util.*,java.util.Iterator, computation.*, java.util.Map,java.io.*,java.util.Date,java.text.SimpleDateFormat" %>
<%@ page import="com.mongodb.MongoClient, com.mongodb.DB,com.mongodb.DBCollection,com.mongodb.BasicDBObject,com.mongodb.DBObject,com.mongodb.DBCursor"%>
<%
			
		%>	
<%	MongoClient mongo;
mongo = new MongoClient("localhost", 27017);
DB db = mongo.getDB("ItalianBistro");
DBCollection myOrders = db.getCollection("myOrders");
String userLogged=(String)session.getAttribute("userLogged");
String order1=request.getParameter("order");
String strConfirmNo=null;
String message=null;
if(userLogged==null){
	userLogged="Guest";
}
if(order1!=null){
	String splrequest=request.getParameter("splrequest");
	String ordertype=request.getParameter("ordertype");
	String reserveDate=request.getParameter("reserveDate");
	  String reserveTime=request.getParameter("reserveTime");
		SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
	  SimpleDateFormat sdfdate = new SimpleDateFormat("yyyy-MM-dd");
	  Date resTime = sdftime.parse(reserveTime);
	  Date resDate= sdfdate.parse(reserveDate);
	  
	  Date expectedDate=null;
	  Date expectedTime=null;

  
	String strDate1=sdfdate.format(new Date());
	String strTime1=sdftime.format(new Date());
	Date date1= sdfdate.parse(strDate1);
	Date time1= sdftime.parse(strTime1);
	Calendar cal1 = Calendar.getInstance();
	Calendar cal2 = Calendar.getInstance();
	Calendar cal3 = Calendar.getInstance();
	Calendar cal4 = Calendar.getInstance();
		 
	cal1.setTime(resDate);
	cal2.setTime(date1);
	cal3.setTime(resTime);
	cal4.setTime(time1);
	
int hours1 = cal4.get(Calendar.HOUR_OF_DAY);
int hours2 = cal3.get(Calendar.HOUR_OF_DAY);	
int minutes1=cal4.get(Calendar.MINUTE);
int minutes2=cal3.get(Calendar.MINUTE);	

if(cal1.before(cal2)){
		message="Choose a correct Date";
		
}
int hours;
double dist=0.0;
if(ordertype.equals("pickup")){
	hours=hours1+1;
}else{
	hours=hours1+2;
	double lat1=Double.parseDouble(request.getParameter("lat"));
				double long1=Double.parseDouble(request.getParameter("long"));
				double lat2=41.833818;
				double long2=-87.628852;
				double theta = long1 - long2;
				dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));
				dist = Math.acos(dist);
				dist = rad2deg(dist);
				dist = dist * 60 * 1.1515;
}%>
<%!
			public double deg2rad(double deg) {
				return (deg * Math.PI / 180.0);
				}
			%>
	   
			<%!
			public double rad2deg(double rad) {
			return (rad * 180 / Math.PI);
				}
			%>
<%if((hours>hours2)&&cal1.equals(cal2)){
	message="Choose a correct time";
}
else{
	if((hours==hours2)&&(cal1.equals(cal2))&&(minutes1>minutes2)){
		message="Choose a correct time";
	}
}
if (ordertype.equals("delivery") && dist>25){
				message="Your order cannot be completed as your address is out of our delivery range ";
				
			}	
System.out.println("current Date"+date1);
System.out.println("res date"+resDate);
System.out.println("current hour  is "+hours1);
System.out.println("expected hour  is "+hours2);
	  
	if(message==null){ 
ShoppingCart cart;
System.out.println("1111111111111111111111111111");
    synchronized(session) {
      cart = (ShoppingCart)session.getAttribute("shoppingCart");
}
	List itemsOrdered = cart.getItemsOrdered();
      if (itemsOrdered.size() != 0) {
		  System.out.println("22222222222222222222222");
	  ItemOrder order;
	  String firstName = request.getParameter("firstName");
	  String lastName = request.getParameter("lastName");
	  String address = request.getParameter("address");
	  
	  
	  System.out.println("date format is "+reserveDate);
	  Random rand = new Random();
	  int  n = rand.nextInt(100) + 1;
	  String phoneNumber = request.getParameter("phoneNumber");
	  
	  StringBuilder sb = new StringBuilder();
	  if(userLogged.equals("Guest")){
	  sb.append("Guest");
	  sb.append(n);
	  userLogged=sb.toString();
	  session.setAttribute("userLogged",userLogged);
	  }
	  StringBuilder sb1 = new StringBuilder();
	  sb1.append("GS");
	  sb1.append(n);
	  strConfirmNo= sb1.toString();
	  String strStatus="Order Placed";
	  
 
for(int i=0; i<itemsOrdered.size(); i++) {
	System.out.println("33333333333333333333333333");
	order = (ItemOrder)itemsOrdered.get(i);
	String foodName=order.getFoodName();
	int productPrice=(order.getUnitCost());
	int numItems=order.getNumItems();
	int totCost=(order.getTotalCost());
	Date createdDate = new Date();
	
	BasicDBObject doc = new BasicDBObject("title", "myOrders").
	append("foodName", foodName).
	append("quantity", numItems).
	append("totalPrice", totCost).
	append("firstName", firstName).
	append("lastName", lastName).
	append("user", userLogged).
	append("address", address).
	append("phoneNumber", phoneNumber).
	append("orderType", ordertype).
	append("expectedDate", reserveDate).
	append("expectedTime", reserveTime).
	append("createdDate",createdDate).
	append("status",strStatus).
	append("confirmation",strConfirmNo).
	append("splrequest",splrequest);
	myOrders.insert(doc);
	
	}
	session.setAttribute("shoppingCart",null);	
} 
else{
	System.out.println("4444444444444444444");
	message="No items/Orders";
}
	}
}%>

<%
String cancel=request.getParameter("cancel");
if(cancel!=null){
	System.out.println("inside cancel");
	String pdtName=request.getParameter("foodName");
	String user=request.getParameter("user");
	String confirmation=request.getParameter("confirmation");
	String ordertype=request.getParameter("orderType");
	
	BasicDBObject searchQuery1 = new BasicDBObject();
	searchQuery1.put("foodName", pdtName);
	searchQuery1.put("user", user);
	searchQuery1.put("confirmation", confirmation);
	
	BasicDBObject updateQuery = new BasicDBObject();
	updateQuery.append("$set", 
		new BasicDBObject().append("status", "Order Cancelled"));
	SimpleDateFormat sdfdate = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
	System.out.println("Befoe Date conversion");
	Date expectedDate=null;
	Date expectedTime=null;
	expectedDate=sdfdate.parse(request.getParameter("expectedDate"));
	expectedTime=sdftime.parse(request.getParameter("expectedTime"));
	
	String strDate1=sdfdate.format(new Date());
	String strTime1=sdftime.format(new Date());
	Date date1= sdfdate.parse(strDate1);
	Date time1= sdftime.parse(strTime1);
	
	Calendar cal1 = Calendar.getInstance();
	Calendar cal2 = Calendar.getInstance();
	Calendar cal3 = Calendar.getInstance();
	Calendar cal4 = Calendar.getInstance();
		 
	cal1.setTime(expectedDate);
	cal2.setTime(date1);
	cal3.setTime(expectedTime);
	cal4.setTime(time1);
	
int hours1 = cal4.get(Calendar.HOUR_OF_DAY);
int hours2 = cal3.get(Calendar.HOUR_OF_DAY);
int minutes1=cal4.get(Calendar.MINUTE);
int minutes2=cal3.get(Calendar.MINUTE);

int hours=hours1+1;

if((hours>hours2)&&(!cal1.before(cal2))){
	message="Order is processed. Sorry Can't Cancel Now!!!";
}else{
	if((hours==hours2)&&(cal1.equals(cal2))&&(minutes1>minutes2)){
		message="Order is processed. Sorry Can't Cancel Now!!!";
	}
	else{
		System.out.println("DateCompare block");
		myOrders.update(searchQuery1, updateQuery);
	}	
}

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
if(message!=null){%>
	<h4> <%=message%></h4>
<%}
if(order1!=null && message!=null){%>

    <TABLE BORDER=1 ALIGN="CENTER">
           <TR BGCOLOR="#FFAD00">
            <TH>Name<TH>Quantity<TH>Total Cost
           <TH>Order Date<TH>Order Status<TH>Expected Date <TH>Expected Time
		   <TH>Confirmation Number <TH>Order Type<TH>Cancel Order?</tr>
<%	BasicDBObject searchQuery = new BasicDBObject();
			searchQuery.put("confirmation", strConfirmNo);
				DBCursor cursor = myOrders.find(searchQuery);
				while (cursor.hasNext()) {
				BasicDBObject obj = (BasicDBObject) cursor.next();
%>
				<tr>
									<td><%=obj.getString("foodName")%></td>
									<td><%=obj.getString("quantity")%></td>
									<td><%=obj.getString("totalPrice")%></td>
									<td><%=obj.getString("createdDate")%></td>
									<td><%=obj.getString("status")%></td>
									<td><%=obj.getString("expectedDate")%></td>
									<td><%=obj.getString("expectedTime")%></td>
									<td><%=obj.getString("confirmation")%></td>
									<td><%=obj.getString("orderType")%></td>
									<td><form method="post" action="MyOrders.jsp">
									<input type="hidden" name="expectedDate" value="<%=obj.getString("expectedDate")%>"/>
									<input type="hidden" name="expectedTime" value="<%=obj.getString("expectedTime")%>"/>
									<input type="hidden" name="orderType" value="<%=obj.getString("orderType")%>"/>
									<input type="hidden" name="foodName" value="<%=obj.getString("foodName")%>"/>
									<input type="hidden" name="user" value="<%=obj.getString("user")%>"/>
									<input type="hidden" name="confirmation" value="<%=obj.getString("confirmation")%>"/>
									<input type="submit" name="cancel" value="Cancel Order"/>
									</form></td>

			</tr>
<%	} %> </table>
			
<%}else {
%>

    <TABLE BORDER=1 ALIGN="CENTER">
           
<%	BasicDBObject searchQuery = new BasicDBObject();
			searchQuery.put("user", userLogged);
				DBCursor cursor = myOrders.find(searchQuery);
				while (cursor.hasNext()) {
				BasicDBObject obj = (BasicDBObject) cursor.next();
%>
				<tr>
									<tr><TH>Name</th><td><%=obj.getString("foodName")%></td></tr>
									<tr><TH>Quantity</th><td><%=obj.getString("quantity")%></td></tr>
									<tr><TH>Total Cost</th><td><%=obj.getString("totalPrice")%></td></tr>
									<tr><TH>Order Date</th><td><%=obj.getString("createdDate")%></td></tr>
									<tr><TH>Order Status</th><td><%=obj.getString("status")%></td></tr>
									<tr><TH>Expected Date</th><td><%=obj.getString("expectedDate")%></td></tr>
									<tr><TH>Expected Time</th><td><%=obj.getString("expectedTime")%></td></tr>
									<tr><TH>Confirmation Number</th><td><%=obj.getString("confirmation")%></td></tr>
									<tr><TH>Order Type</th><td><%=obj.getString("orderType")%></td></tr>
									<tr><td colspan="2"><center><form method="post" action="MyOrders.jsp">
									<input type="hidden" name="expectedDate" value="<%=obj.getString("expectedDate")%>"/>
									<input type="hidden" name="expectedTime" value="<%=obj.getString("expectedTime")%>"/>
									<input type="hidden" name="orderType" value="<%=obj.getString("orderType")%>"/>
									<input type="hidden" name="foodName" value="<%=obj.getString("foodName")%>"/>
									<input type="hidden" name="user" value="<%=obj.getString("user")%>"/>
									<input type="hidden" name="confirmation" value="<%=obj.getString("confirmation")%>"/>
									<input type="submit" name="cancel" value="Cancel Order"/></center>
									</form></td>

			</tr>
<%	} %> </table>
			
<%}%>
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
                        <li><a href="" title="premium templates">Write Reviews</a></li>
                        <li><a href="" title="web hosting"> View Reviews </a></li>
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
                    <a href="" style="color:#ffffff">About US</a></td>
                    </td>
                    <td>
                    <a href=""style="color:#ffffff">FAQ</a></td>
                     
                    </td>
                    <td>
                    <a href="\ItalianBistro\ContactUs"style="color:#ffffff">Contact Us</a></td>
                     
                    </td>
                    <td>
                    <a href="\ItalianBistro\FeedBack"style="color:#ffffff">FeedBack</a></td>
                     
                    </td>

                    <td>
                    <a href="SiteMap.jsp"style="color:#ffffff">Site Map</a></td>
                     
                    </td>
                    </tr>
                    </table>
                    <p>Copyright © 2015 Italian Bistro. All Rights Reserved.</p></td>
            
            
        </div>
		
    </footer>
</div>
  </div>

</body>

</html>
		