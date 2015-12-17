<%@ page import="java.io.*,javax.servlet.ServletException"%>
<%@ page import="javax.servlet.annotation.WebServlet"%>
<%@ page import="javax.servlet.http.HttpServlet"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.servlet.http.HttpServletResponse"%>
<%@ page import="com.mongodb.MongoClient"%>
<%@ page import="com.mongodb.MongoException"%>
<%@ page import="com.mongodb.WriteConcern"%>
<%@ page import="com.mongodb.DB"%>
<%@ page import="com.mongodb.DBCollection"%>
<%@ page import="com.mongodb.BasicDBObject"%>
<%@ page import="com.mongodb.DBObject"%>
<%@ page import="com.mongodb.DBCursor"%>
<%@ page import="com.mongodb.ServerAddress"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Set,java.util.Date,javax.servlet.http.*,javax.servlet.RequestDispatcher"%>
<%@ page import="java.util.*,java.text.*"%>
<%@ page import="assign3.*"%>

<%

		try{

	MongoClient mongo= new MongoClient("localhost", 27017);
	
			DB db = mongo.getDB("ItalianBistro");		


			HashMap ShippingStatus=new HashMap();
				ShippingStatus.put(1,"Order Confirmed");
				ShippingStatus.put(2,"Getting Prepared");
				ShippingStatus.put(3,"Dish Made");
				ShippingStatus.put(4,"Order Ready to deliver");
				ShippingStatus.put(5,"In transit");
				ShippingStatus.put(6,"Delivered");
				ShippingStatus.put(7,"Order Cancelled");
				
				
			HashMap ShippingStatus1=new HashMap();
				ShippingStatus1.put(1,"Order Confirmed");
				ShippingStatus1.put(2,"Getting Prepared");
				ShippingStatus1.put(3,"Dish Made");
				ShippingStatus1.put(4,"Order Ready to pickup");
				ShippingStatus1.put(5,"Order Cancelled");


		
out.println("<html><head><link rel='stylesheet' href='css/styles.css' type='text/css'></head>");
%>
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
                        




<form class = 'submit-button1' method = 'get' action="TrackOrders.jsp">                        
<%

       			  out.println(" <table style='border:0;' >");

			  out.println("<tr>");
                               out.println(" <td> Confirmation Number: </td>");
                               out.println(" <td>");
                                 	
					out.println("<input type ='text' name='confirmation'>");						
			
		out.println("<input class = 'submit-button1' type = 'submit' name ='ViewStatus'  value = 'View Order Status'>");
			out.println("</td></tr>");
        			  out.println("</table>");

%>
</form>


	<%		
	if(request.getParameter("ViewStatus")!=null)
	{
	DBCollection  myOrder = db.getCollection("myOrders");
			String  searchField = "confirmation";
			BasicDBObject searchQuery = new BasicDBObject();
			String confirmation = request.getParameter("confirmation");
			searchQuery.put("confirmation",confirmation);
				DBCursor cursor = myOrder.find(searchQuery);
			int OrderNo=0;

					
					if(cursor.count() == 0)
					{%>
			
				<h2 align='center'>There are no Order Placed In your cart.</h2>
			
				<% }	
				else
				{
					int i;
				out.println("<table>");
				while(cursor.hasNext())
				{	
				
				BasicDBObject obj = (BasicDBObject)cursor.next();
				//int OrderId=Integer.parseInt(obj.get("OrderId").toString());
				//int CustId1=Integer.parseInt(obj.get("CustId").toString());
				String foodName = obj.getString("foodName");
				//String status= obj.getString("ShippingStatus");
				//String statusChoose= obj.getString("StatusChoosed");
				
				int Price = Integer.parseInt(obj.get("totalPrice").toString());
				out.println("<tr><td>ProductPrice:  "+Price+"</td></tr>"+"<tr><td>Food Ordered:  "+foodName+"</td>");
				//out.println("<tr><td>OrderStatus:  "+obj.getString("status")+"</td></table>");
				out.println("<tr><td> Order Type: "+obj.getString("orderType")+"</td></tr>");
				out.println("<tr><td> OrderStatus: ");
				
				out.println(obj.getString("status"));
				
				out.println("</td></tr>");
				}
				}
	}	
		%>	
			    </table>         			
		<%
}catch (Exception e) {
				e.printStackTrace();
		}
%>

	 </article></section> 
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
                        <li><a href="WriteReviews.jsp">Write Reviews</a></li>
                        <li><a href="ViewReviews.jsp"> View Reviews </a></li>
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
                    <a href="AboutUs.html" style="color:#ffffff">About US</a></td>
                    </td>
                    <td>
                    <a href="\ItalianBistro\FAQ"style="color:#ffffff">FAQ</a></td>
                     
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