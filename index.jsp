<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN''http://www.w3.org/TR/html4/loose.dtd'>
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
<%@ page import="com.mongodb.BasicDBList"%>
<%@ page import="com.mongodb.AggregationOutput"%>
<%@ page import="javabean.*" %>
<%@ page import="computation.*" %>

<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Italian Bistro </title>
	<script type='text/javascript' src='javascript.js'></script>
	<link rel="stylesheet" href="css/styles.css" type="text/css" />
	
    
</head>



<body style="background-image:url(images/1.jpg)" onload="init()">
     <%@ page import="javabean.*, java.util.HashMap, java.util.Iterator, computation.*,java.util.Map,java.io.*" %>
 
 <%
        //get parameters from the request
		ServletContext sc = this.getServletContext();
        String path = sc.getRealPath("/WEB-INF/classes/user.txt");
		String login=request.getParameter("login");
		String logout=request.getParameter("logout");
		String signup= request.getParameter("signup");
		String createAccount= request.getParameter("createAccount");
		String cart= request.getParameter("cart");
		String orders= request.getParameter("orders");
        String console = request.getParameter("console");
        String games = request.getParameter("games");
        String home=request.getParameter("home");
		if(home!=null){
			console=null;
			games=null;
			}
		if(logout!=null){
			session.invalidate();
			session=request.getSession(true);
			session.setAttribute("userLogged","Guest");
			session.setAttribute("userRole","Guest");
		}
		if(createAccount!=null){
			String phone=request.getParameter("phoneNo");
			UserAccount userAcc=new UserAccount("Customer",request.getParameter("firstName"),request.getParameter("lastName"),request.getParameter("address"),phone,request.getParameter("userName"),request.getParameter("password"),request.getParameter("eMail"));
			UserIO.addUser(userAcc,request.getParameter("userName"),path);
			String strMessage="Welcome to Italian Bistro. Thank you for Registering. We hope you enjoy our MENU.";
			//MAIL.sendMail(request.getParameter("eMail"),strMessage);
			session.setAttribute("userLogged",request.getParameter("userName"));
			session.setAttribute("userRole","Customer");
			String customMessage="Thanks for registeration";
			
		}
       
    %>
	<%
       String userlogged=request.getParameter("userlogged");
	   String username = request.getParameter("username");
       String password = request.getParameter("password");
        
		UserAccount uA = null;
	  HashMap<String, UserAccount>map = new HashMap<String, UserAccount>();
	  FileInputStream fileIn =null;
	  ObjectInputStream in =null;
	  if(userlogged!=null){
      try
      {
          fileIn = new FileInputStream(path);
          in = new ObjectInputStream(fileIn);
		 
         uA = (UserAccount)in.readObject();
		 while(uA!=null){
			 map.put(uA.getUserName(),uA);
			uA = (UserAccount)in.readObject(); 
		 }
		in.close();
         fileIn.close();
        
      }catch(IOException i)
      {
         
      }catch(ClassNotFoundException c)
      {
         System.out.println("Employee class not found");
         c.printStackTrace();
         return;
      } 
	  finally{
		  in.close();
         fileIn.close();
	  }
	   }
    %>
	<%
	if(map!=null){
	UserAccount uAobj=(UserAccount)map.get(username);
	if(uAobj!=null){
	if(password.equals(uAobj.getPassword())){
		session.setAttribute("userLogged",uAobj.getUserName());
		session.setAttribute("userRole",uAobj.getRole());
		session.setAttribute("shoppingCart",null);
	}
	}
	}
	%>
	<% String userRole=null;
	userRole=(String)session.getAttribute("userRole");
	if(userRole==null){
		userRole="Guest";
	}%>
        <div class="container">

        <div id="container">

            <header>

                <img class="header-image1" src="images/i.png" width = "50%" height = "50%" alt="Index Page Image" />
				<%
		if(login!=null){
			%>
			     <form method="post" action="index.jsp">

								<ul><li>			  <table>
											    <tr>
											        <td>User Name</td>
											        <td><input type="TEXT" size="15" name="username"></input></td>


											        <td>Password</td>
											        <td><input type="PASSWORD" size="15" name="password"/></td>

											  
											        <td>
											            <input type="submit" name="userlogged" value="Login" />
											        </td>
											    </tr>
											 </table> </li></ul>
 </form>
		<% }else{ %>
		 <ul>
		<%
		String loggedInUser=(String)session.getAttribute("userLogged");
		if((loggedInUser!=null)&&(!loggedInUser.startsWith("Guest"))){
%>		<li class="header-button"> <form action="index.jsp"><input type="submit" name="logout" value="Logout"></input></form></li>
		<li class="header-button"> <form><input type="text" value="Welcome <%=loggedInUser%>" style="text-decoration:none"></input></form></li>
		
		<%} else{ %>
			 <li class="header-button"><form action="index.jsp"><input type="submit" name="login" value="Login"></input></form></li>
			<li class="header-button"><form action="index.jsp"><input type="submit" name="signup" value="SignUP"></input></form></li>
		<%}if(!userRole.equals("Manager")){%>
       
		 <li class="header-button"><form action="\ItalianBistro\OrderPage"><input type="submit" name="cart" value="Shopping cart"></input></form></li>
         <li class="header-button"><form action="MyOrders.jsp"><input type="submit" name="orders" value="My Orders"></input></form></li>
		<%}}%> 
		</ul>
		<%if(!userRole.equals("Manager")){%>
		<form name='autofillform' action='autocomplete'>

	<table border="0" cellpadding="5">
	<tr>
	<td></td>  
    <td></td>
	<td></td>
	<td></td>
	<td></td>
	<tbody><td><strong><center>Food Search: </center></strong></td>
	
	<td ><center><input  type='text' size='40' id='complete-field' onkeyup='doCompletion()'></center>
    </td>
	</tr>
     <tr><td id='auto-row' colspan="2">
     <table id='complete-table' class="popupBox" /></table>
     </td></tr></tbody>
	 </table></form>
		<%}%>
             </header>
<%if(userRole.equals("Manager")){
		%>
		<nav>
        <ul>

            <li class=""><a href="index.jsp">HOME</a></li>
            <li class=""><a href="\ItalianBistro\ManageRestaurant">Tables & Foods</a></li>
            <li class=""><a href="\ItalianBistro\ManageCustomers">Customers</a></li>
               
            
        </ul>
    </nav>
	<%}else{%>
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
	<%}%>
    <header>
        <img class="header-image" src="images/header.jpg" width = "50%" height = "50%" alt="Index Page Image" />
		<%if(userRole.equals("Manager")){
	MongoClient mongo;
	
		mongo = new MongoClient("localhost", 27017);
	
			DB db = mongo.getDB("ItalianBistro");
			
			DBCollection feedback = db.getCollection("feedback");
			DBCursor cursor = feedback.find();
			out.println("<center><TABLE BORDER=1 ALIGN=\"CENTER\" width=\"50px\">");
           out.println("<tr><td colspan=\"2\"><h4 style=\"color:#000000\"><b>Customer FeedBack<b></h4></td></tr>");
			while (cursor.hasNext()) {
				BasicDBObject obj = (BasicDBObject) cursor.next();
									out.println("<tr>");
									out.println("<TH>UserName</th>");
									out.println("<td>"+obj.getString("userName")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>PhoneNo</TH>");
									out.println("<td>"+obj.getString("phoneNo")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>eMail</TH>");
									out.println("<td>"+obj.getString("eMail")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>FeedText</TH>");
									out.println("<td>"+obj.getString("feedText")+"</td>");
									out.println("</tr>");
									out.println("<tr><tr>");
									out.println("<tr><tr>");
									out.println("<tr><tr>");
									out.println("<tr><tr>");
									out.println("<tr><tr>");
									out.println("<tr><tr>");
			}
			out.println("</table></center>");
}
	%>
    </header>
    
    <div id="body">		
<% if(signup!=null) { %>
	
	<section id="content">

<article>
<h2> Sign Up for Italian Bistro</h2>
</article>


<article class="expanded">
<form method="post" action="index.jsp">
<table>
<tr>
<td> First Name</td>
<td> <input type="text" name="firstName"> </td>
</tr>
<tr>
<td> Last Name</td>
<td> <input type="text" name="lastName"> </td>
</tr>
<tr>
<td> Address</td>
<td> <input type="text" name="address"> </td>
</tr>
<tr>
<td> Phone Number</td>
<td> <input type="text" name="phoneNo"> </td>
</tr>
<tr>
<td> User Name</td>
<td> <input type="text" name="userName"> </td>
</tr>
<tr>
<td> Password</td>
<td> <input type="password" name="password"> </td>
</tr>
<tr>
<td> E-Mail Address</td>
<td> <input type="text" name="eMail"> </td>
</tr>
<tr>
<td colspan='2'><center><input type="submit" name="createAccount" value="Create Account"></center> </td>
</tr>
</table>
</form>
</article>
    </section>
<% }else{ %>
	<section id="content">

        <br>
<%if(!userRole.equals("Manager")){%>
        <article class="expanded">
                        
            <table style="border:0;" >

                <tr>
                <td>
                    <form class = "submit-button" method = "get" action = "\ItalianBistro\SpecialMenu">
                        <input class = "submit-button" style="background-image:url(images/img_Christmas.jpg)" type = "submit" name ="Haloween Offers" value = "">
                        <SPAN style="font-size:18px;">Christmas Special</SPAN>
                    </form>

                </td>
                 <td>
                    <form class = "submit-button" method = "get" action = "\ItalianBistro\GiftCard">
                        <input class = "submit-button" style="background-image:url(images/gift_PNG5961.jpg)" type = "submit" name ="Gift Card" value = "">
                        <SPAN style="font-size:18px;"> GIFTCARDS </SPAN>
                    </form>

                </td>
            </tr>

            <tr>
                <td>
                    <form class = "submit-button" method = "get" action = "Favourites.jsp">
                        <input class = "submit-button" style="background-image:url(images/img_fav1.jpg)" type = "submit" name ="Favourites" value = "">
                        <SPAN style="font-size:18px;"> FAVOURITES </SPAN>
                    </form>

                </td>

                 <td>
                    <form class = "submit-button" method = "get" action = "promotions.html">
                        <input class = "submit-button" style="background-image:url(images/img_promotions.jpg)" type = "submit" name ="Chefs Special" value = "">
                        <SPAN style="font-size:18px;"> PROMOTIONS </SPAN>
                    </form>

                </td>
            </tr>

            </table>
            
        </article>
		
<%}%>

				
        </section>
<%}%>
      <%if(!userRole.equals("Manager")){%>
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
                        <li><a href="WriteReviews.jsp" >Write Reviews</a></li>
                        <li><a href="ViewReviews.jsp" > View Reviews </a></li>
                    </ul>
                </li>
                
                
            </ul>
		
    </aside>
	  <%}%>
	<div class="clear"></div>
	</div>
           
          
       <!-- End footer top area -->
    
	<footer>
	<%if(session.getAttribute("siteMap")!=null){%>
	<div class="footer-content">
            <ul>
                <li><h4>Reviews/FeedBack</h4></li>
                <li><a href="ViewReviews.jsp">View Reviews</a></li>
                <li><a href="WriteReviews.jsp">Write Reviews</a></li>
                <li><a href="\ItalianBistro\FeedBack">FeedBack</a></li>
            </ul>
            <ul>
                <li><h4>Table Reservation</h4></li>
                <li><a href="DineIn.jsp">DineIn</a></li>
                <li><a href="Table.jsp">Make Reservation</a></li>
                <li><a href="CancelResv.jsp">Cancel Table Reservation</a></li>
                <li><a href="ViewTable.jsp">View Table</a></li>
            </ul>
            
            <ul>
                <li><h4> Order</h4></li>
                <li><a href="\ItalianBistro\OnlineOrder.jsp">Online Order</a></li>
                <li><a href="\ItalianBistro\OrderPage">Shopping Cart</a></li>
                <li><a href="MyOrders.jsp">MyOrders</a></li>
				<li><a href="TrackOrders.jsp">Track Order</a></li>
            </ul>
            <ul>
                <li><h4>Home Page</h4></li>
				<li><a href="index.jsp">Home Page</a></li>
                <li><a href="\ItalianBistro\SpecialMenu">Special Menu</a></li>
                <li><a href="promotions.html">Promotions</a></li>
                <li><a href="\ItalianBistro\GiftCard">GiftCards</a></li>
				<li><a href="Favourites.jsp">Favourites</a></li>
            </ul>
            <ul>
                <li><h4>About Us</h4></li>
                <li><a href="AboutUs.html">About Us</a></li>
                <li><a href="FAQs.html">Contact Us</a></li>
                <li><a href="Map.jsp">View Location</a></li>
				<li><a href="FAQs.html">FAQs</a></li>
            </ul>
			<ul>
                <li><h4>Login/SignUP</h4></li>
                <li><a href="index.jsp?login=Login">Login</a></li>
                <li><a href="index.jsp?signup=SignUP">SignUp</a></li>
                
            </ul>
            
        <div class="clear"></div>
        </div>
	<%session.removeAttribute("siteMap");}%>
        <div class="footer-bottom" >

            <table style="border:0;">

                <tr  align="center">

                    <td >
                    <a href="AboutUs.html" style="color:#ffffff">About US</a></td>
                    </td>
                    <td>
                    <a href="FAQs.html"style="color:#ffffff">FAQ</a></td>
                     
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