<html>
<head>
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
	
	<%
	   PrintWriter output = response.getWriter();
	 %>
	 
	
<%
   try{	
					/* Retrieve the current session*/
			//HttpSession session = request.getSession(false);
			
			/* if user is not logged in redirect to login page */
			if(session == null || session.getAttribute("name") == null){
				// redirect to login page
				String site = "login.html";
			    response.setStatus(response.SC_MOVED_TEMPORARILY);
                response.setHeader("Location", site);
			}
			
		    
			//Get the values from the form
			String userid=(String)session.getAttribute("name");
			String address= request.getParameter("Address");
			String ordertype=request.getParameter("ordertype");
			String splrequest=request.getParameter("splrequest");
			String products="";
			double confirmationnumber1=Math.random();
			long confirmationnumber=Math.round(confirmationnumber1*1000000);
			double dist=0.0;
			
			if(ordertype.equals("delivery")){
				double lat1=Double.parseDouble(request.getParameter("lat"));
				double long1=Double.parseDouble(request.getParameter("long"));
				double lat2=41.833818;
				double long2=-87.628852;
				double theta = long1 - long2;
				dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));
				dist = Math.acos(dist);
				dist = rad2deg(dist);
				dist = dist * 60 * 1.1515;
			}
			%>
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
			

			<%
			
       // retreive the cart from the session
			ArrayList<String> myCart = (ArrayList<String>)session.getAttribute("cart");
			 for(int i=0; i<myCart.size(); i++)
           {
            products = products+("," + myCart.get(i));
			}
            products=products.substring(products.indexOf(',')+1)  ;
			
			int total1=0;
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
						total1 += Integer.parseInt(price.substring(price.indexOf('$')+1));
					}
			}
							
			if (ordertype.equals("delivery") && dist>25){
				output.println("<div style=\"color: red;\">Your order cannot be completed as your address is out of our delivery range </div>");
				request.getRequestDispatcher("index.html").include(request, response); 
			}	
			else if ((ordertype.equals("delivery") && dist<=25 && total1>=25) || (ordertype.equals("pickup"))){
						
				for(int i=0; i<myCart.size(); i++)
				{
					products = products+("," + myCart.get(i));
				}
				products=products.substring(products.indexOf(',')+1)  ;
			
				int total=0;
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
					if(price.indexOf('$') != -1)
					{
						total += Integer.parseInt(price.substring(price.indexOf('$')+1));
					}
			}
			
			}
			else
			{
				output.println("<div style=\"color: red;\">Your order cannot be delivered as your total order is less than $25. </div>");
				request.getRequestDispatcher("index.html").include(request, response); 
			}
			
			
			//Get system date and time
			DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
            Date dateobj = new Date();
			String ordertime=(String)df.format(dateobj);
			Calendar cal = Calendar.getInstance();
			
			
			//assign the Calendar new Date values
			cal.setTime(dateobj);
			
			
		  //add an HOUR to the Calendar
			cal.add(Calendar.MINUTE,70);
			
			
			
		  //convert back to Date
			dateobj = cal.getTime();
			String deliverytime= (String)df.format(dateobj);
		 
		 
		 	
		
			//Connect to Mongo DB
			MongoClient mongo = new MongoClient("localhost", 27017);
						
			// if database doesn't exists, MongoDB will create it for you
			DB db = mongo.getDB("italianbistro");			
			DBCollection orders = db.getCollection("orders");
			
			BasicDBObject doc = new BasicDBObject().
				append("_id", confirmationnumber).
				append("products",products ).
				append("price", total1).
				append("orderdate", ordertime).
				append("deliverytime",deliverytime).
				append("userid",userid).
				append("address",address).
				append("splrequest",splrequest).
				append("ordertype",ordertype).
				append("status","getting ready");
				
			orders.insert(doc);
			BasicDBObject searchQuery = new BasicDBObject();
			 if(ordertype.equals("pickup")){
				// clear cart
				session.removeAttribute("cart");
			
			output.println("<div style=\"color: white;\">Your order has been successfully placed.Your confirmation number is "+ confirmationnumber +" </div>");
			output.println("<div style=\"color: white;\">Expected pickup time:" + deliverytime + " </div>");
			
		    request.getRequestDispatcher("index.html").include(request, response); 
			 }
			else
			 {
				// clear cart
				session.removeAttribute("cart");
				output.println("<div style=\"color: white;\">Your order has been successfully submitted.Your confirmation number is "+ confirmationnumber +" </div>");
				output.println("<div style=\"color: white;\">Expected Delivery time at your address:" + deliverytime + " </div>");
				
				request.getRequestDispatcher("index.html").include(request, response); 
			 }
			
							
		
		}catch(Exception e) {
			e.printStackTrace();
		}
	%>	
			
</html>
	