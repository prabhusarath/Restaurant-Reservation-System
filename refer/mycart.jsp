<html>
	
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Italian Bistro </title>
	<link rel="stylesheet" href="css/styles.css" type="text/css" />    
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
</head>

<%@ page import= "java.io.*,com.mongodb.MongoClient, com.mongodb.MongoException, com.mongodb.WriteConcern, com.mongodb.DB" %>
<%@ page import="org.bson.types.BasicBSONList, com.mongodb.DBCollection" %>
<%@ page import="com.mongodb.BasicDBObject, com.mongodb.DBObject, com.mongodb.DBCursor" %>
<%@ page import="com.mongodb.ServerAddress, com.mongodb.DuplicateKeyException, java.util.HashMap" %>
<%@ page import="com.mongodb.DBCursor, com.mongodb.ServerAddress" %>
<%@ page import="java.util.Arrays, java.util.List, java.util.Set, java.util.Date" %>
<%@ page import="com.mongodb.QueryBuilder, com.mongodb.bulk.IndexRequest" %>
<%@ page import="java.lang.*, java.util.*, java.text.DateFormat, java.text.SimpleDateFormat, java.util.Calendar" %>

<% PrintWriter output = response.getWriter(); %>

<body style="background-image:url(images/1.jpg)">
     
	<div class="container">

		<div id="container">

			<header>
				<img class="header-image1" src="images/i.png" width = "50%" height = "50%" alt="Index Page Image" />
			</header>

			<nav>
				<ul>
					<li class=""><a href="index.html">HOME</a></li>
					<li class=""><a href="dinein.html">Dine In</a></li>
					<li class=""><a href="onlineorder.html">Online Order</a></li>
					<li class=""><a href="aboutus.jsp">About Us</a></li>
					<li class=""><a href="trackorder.html">Track Order </a></li>
					<li class=""><a href="Access.html">View Location</a></li>
					<li class=""><a href="createaccount.html">Sign Up</a></li>
					<li class=""><a href="login.html">Sign In</a></li>
					<li class=""><a href="mycart.jsp">Cart</a></li>
					
				</ul>
			</nav>
	
			<div id="body">		

				<section id="content" class="float-left full-width">
					<br>
					<article class="expanded float-left full-width">
					
						<%
							try{	
							
								// Retrieve the current session			
								// if user is not logged in redirect to login page
								if(session == null || session.getAttribute("name") == null){
									String site = "login.html";
									response.setStatus(response.SC_MOVED_TEMPORARILY);
									response.setHeader("Location", site);
								}

								// retreive the cart from the session
								ArrayList<String> myCart = (ArrayList<String>)session.getAttribute("cart");
								
								/* Display cart items*/
								if(myCart != null){
								
						%>
		
					<div style="width:600px;">
						<table>
							<tr>
								<td>
									<div class="cartInfo"><b>Name</b></div>
								</td>
								<td> 
									<div class="cartInfo"><b>Price</b></div>
								</td>
								<td>
									<div class="cartInfo"><b>Remove</b></div>
								</td>
							</tr>
							
							<%
							int total = 0;
							int discount = 0;
							for(int i=0; i<myCart.size(); i++){
								String itemId = myCart.get(i);
								
								// Retreive price from Mongo DB
								MongoClient mongo = new MongoClient("localhost", 27017);
								DB db = mongo.getDB("italianbistro");
								DBCollection productsdb = db.getCollection("onlinemenu");
								BasicDBObject searchQuery = new BasicDBObject();
								searchQuery.put("_id", itemId);
								DBObject productobj = productsdb.findOne(searchQuery);					
								String price = (String)productobj.get("price");
								
								// add to total
								if(price.indexOf('$') != -1){
									
									// apply promocode discount if it exists
									if(session != null && session.getAttribute("promocode") != null){
										discount = discount + 1; // $1 discount for each item
									}
									
									total += Integer.parseInt(price.substring(price.indexOf('$')+1));
								} 
							%>	
							
							<tr>
								<td>
									<div class="cartInfo"> <%= itemId %>  </div>
								</td>
								<td>
									<div class="cartInfo"> <%= price  %> </div> 
								</td>
								<td>
									<form class="cartInfo" action="removeCartItem.jsp" method="post">
										<input type="submit" value="Remove" name=<%=itemId  %> > 
									</form>					
								</td>					
							</tr>
							
							<% } %>	
							<tr>
								<td>
									<div class="cartInfo"><b>Total</b></div> 
								</td>
								<td>
									<div class="cartInfo"><b>$<%= total-discount %></b></div>
								</td>
								<% if(discount > 0){ %>
								<td>
									<div class="cartInfo"><b>-$<%= discount  %></b></div>
								</td>
								<% } %>
							</tr>

						</table>
			
						<div style="clear:both;"></div>
						<br/>
						<table>
							<tr>
								<form action="promocode.jsp" method="post">
									<td> 
										<div class="cartInfo"><b>Promo Code</b></div>
									</td>
									<td> 
										<div class="cartInfo"><input id="promo" type="text" name="promocode" size="5"></div>
									</td>
									<td>
										<div class="cartInfo"><input id="redeemBtn" type="submit" value="Redeem"></div>						
									</td>
								</form>
							</tr>
							
						</table>
						<div style="clear:both;"></div>
						<br/>
			
						<%
						}else{ %>
						<div>Cart is empty</div>
						<%}	%>
					</div>
					
					<div style="clear:both;"></div>
					<br/>
					
					<% // buy form %>
				
				<div style=\"clear:both;\"></div>
				<div id="buy">
					<form action="buy.jsp" method="post">
						<fieldset style="width: 720px">
							<legend><h2 style="color:#0099ff">Buy</h2></legend>
							<table>
								<tr>
								<td>First name:</td>
								<td><input type="text" name="Firstname" required></td>
								</tr>
								<tr>
								<td>Last name:</td>
								 <td><input type="text" name="Lastname" required></td>
								</tr>
								<tr>
								<td>Address:</td>
								<td>
									<textarea rows="4" cols="35" id="address" required></textarea>
								</td>
								<form>
								<td><input type="radio" name="ordertype" value="pickup" checked="checked" id="pickup">Pick-up </td>
								<td><input type="radio" name="ordertype" value="delivery" onclick="onDeliveryClick();">Home Delivery</td>
								</form>
								</tr>
								<tr>
								<td>Credit Card Type:</td>
								<td>
								<select name="CreditCardType">
									<option value="AmericanExpress">AmericanExpress</option>
									<option value="Discover">Discover</option>
									<option value="Mastercard">Mastercard</option>
									<option value="Visa">Visa</option>
								</select>
								</td>
								</tr>
								<tr>
								<td>Credit Card Number:</td>
								<td><input type="text" name="CreditCardNumber" required ></td>
								</tr>
								<tr>
								<td>Special Requests(if any)</td>
								<td><input id="splrequest" type="text" name="splrequest" size="35"></td>
								</tr>
								<tr>
								<td><input type="submit" value="Place Order" id="buyBtn"></td>
								</tr>
								
							</table>
							<!--Text fields-->
						<input id="lat" type="text" name="lat" hidden>
						<input id="long" type="text" name="long" hidden>
						</fieldset>
					</form>

				</div>
				<%			
					}catch(Exception e) {
					e.printStackTrace();
				}	
				%>
				</article>
				</section>
				<div class="clear"></div>
			</div>
           
          
       <!-- End footer top area -->
    
		<footer>
			
			<div class="footer-bottom" >

				<table style="border:0;">

					<tr  align="center">

						<td >
						<a href="" style="color:#ffffff">About US</a>
						</td>
						<td>
						<a href=""style="color:#ffffff">FAQ</a>                     
						</td>
						<td>
						<a href=""style="color:#ffffff">Contact Us</a>                     
						</td>
						<td>
						<a href=""style="color:#ffffff">FeedBack</a>                     
						</td>
						<td>
						<a href=""style="color:#ffffff">Site Map</a>                   
						</td>
					</tr>
				</table>
				<p>Copyright © 2015 Italian Bistro. All Rights Reserved.</p>           
				
			</div>
			
		</footer>
		</div>
	</div>

	<script type="text/javascript">
		function onDeliveryClick(){
			var address = document.getElementById('address').value;
			if(address != null && address != ''){
				var geocoder = new google.maps.Geocoder();
				geocoder.geocode( { 'address': address}, function(results, status) {
					if (status == google.maps.GeocoderStatus.OK) {
						var lng = results[0].geometry.location.lng();
						var lat = results[0].geometry.location.lat();
						document.getElementById('lat').value = lat;
						document.getElementById('long').value = lng;
					} 
					else {
						alert("Invalid Address");
						document.getElementById('lat').value = 0;
						document.getElementById('long').value = 0;
					}
				});
			}
			else{
				alert("Enter address for delivery");
				document.getElementById('pickup').checked = true;
			}
		}			
	</script>
	
</body>	
			
</html>