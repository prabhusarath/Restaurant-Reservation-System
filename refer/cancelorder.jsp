<html>
	<head>
		<title>GameSpeed - Orders</title>
		<link rel="stylesheet" type="text/css" href="gameSpeed.css">
		
	</head>
	<body>
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
             String cnf1=request.getParameter("confirmationnumber");
			 int confirmationnumber=Integer.parseInt(cnf1);
			 
				// Connect to Mongo DB
			MongoClient mongo = new MongoClient("localhost", 27017);
						
			// If database doesn't exists, MongoDB will create it for you
			DB db = mongo.getDB("italianbistro");
			
			// If the collection does not exists, MongoDB will create it for you
			DBCollection orders = db.getCollection("orders");
			// Find 
			BasicDBObject searchQuery = new BasicDBObject();
			searchQuery.put("_id",confirmationnumber);			
			DBObject obj = orders.findOne(searchQuery);
			if(obj!=null){
					if(obj.get("ordertype").equals("delivery"))
					{
						Date date = new Date();				
						SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
						String dateInString = obj.get("deliverytime").toString();
						Date deliveryDate = formatter.parse(dateInString);
				
						double diff =  deliveryDate.getTime()-date.getTime();
						double diffTime = (diff / (60 * 60 * 1000));
				
						if(diffTime > 1){
							orders.remove(searchQuery);
							//go back to the store.html and show success msg 
							output.println("<div style=\"color:white;\" >" +confirmationnumber+ ":<b>Order cancelled</b></div>");			
							request.getRequestDispatcher("cancelorder.html").include(request, response);	
						} else {			
							output.println("<div style=\"color:red;\" >" +confirmationnumber+":<b>Order cannot be cancelled within 1 hour to delivery</b></div>");		
							request.getRequestDispatcher("cancelorder.html").include(request, response);					
						}
					}
					else { 
						output.println("<div  style=\"color:red;\" >"+confirmationnumber+":<b>Pick-up order cancellation cannot be done online.Contact us on phone.</b></div>");		
						request.getRequestDispatcher("cancelorder.html").include(request, response);				
					}		
				}		
			else{ 
				output.println("<div  style=\"color:red;\" >"+confirmationnumber+":<b> Order not found</b></div>");		
				request.getRequestDispatcher("cancelorder.html").include(request, response);				
			}			
		}catch(MongoException e) {
			e.printStackTrace();
		}
		%>