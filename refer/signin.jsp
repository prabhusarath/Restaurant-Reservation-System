<!DOCTYPE html>
<html>
	<head>
		<title>Italian Bistro</title>
	</head>
	<body>
		<%@ page import= "java.io.*,com.mongodb.MongoClient, com.mongodb.MongoException, com.mongodb.WriteConcern, com.mongodb.DB" %>
		<%@ page import="org.bson.types.BasicBSONList, com.mongodb.DBCollection" %>
		<%@ page import="com.mongodb.BasicDBObject, com.mongodb.DBObject, com.mongodb.DBCursor" %>
		<%@ page import="com.mongodb.ServerAddress, com.mongodb.BasicDBObject, com.mongodb.DBObject" %>
		<%@ page import="com.mongodb.DBCursor, com.mongodb.ServerAddress" %>
		<%@ page import="java.util.Arrays, java.util.List, java.util.Set, java.util.Date" %>
		<%@ page import="com.mongodb.QueryBuilder, com.mongodb.bulk.IndexRequest" %>

			
		<% PrintWriter output = response.getWriter(); %>
			
		<%
			try{
			
				String _id = request.getParameter("_id");
				String Password = request.getParameter("password");
				
				//Connect to Mongo DB
				MongoClient mongo = new MongoClient("localhost", 27017);
							
				// if database doesnt exists, MongoDB will create it for you
				DB db = mongo.getDB("italianbistro");			
				DBCollection users = db.getCollection("users");
				
				// Find and display 
				BasicDBObject searchQuery = new BasicDBObject();
				searchQuery.put("_id", _id);			
				DBObject obj = users.findOne(searchQuery);
					
				if(obj != null){			
					if(Password.equals(obj.get("Password")) && (obj.get("Role").equals("Customer"))){
						// Retrieve the current session, creates one if not exists
						session.setAttribute("name",_id);
						session.setAttribute("cart",null);
						
						// go back to the index.html and show the logged in user
						output.println("<div style=\"color: white;\">Hi " + session.getAttribute("name") + "</div>");			
						request.getRequestDispatcher("index.html").include(request, response);
					} 
					else if (Password.equals(obj.get("Password")) && (obj.get("Role").equals("Storemanager"))){
						//Redirect Storemanager	to his/her page
						output.println("<div style=\"color: white;\">Hi " + _id + "</div>");			
						request.getRequestDispatcher("store.html").include(request, response);					
					}
					else{
						// go back to the login.html and show the error msg
						output.println("<div style=\"color:red;\" >UserId Password mismatch</div>");			
						request.getRequestDispatcher("login.html").include(request, response);
					}
				}
				else{
					// go back to the signin.html and show the error msg
					output.println("<div style=\"color:red;\" >User does not exist</div>");			
					request.getRequestDispatcher("login.html").include(request, response);
				}

			} catch (MongoException e) {
				e.printStackTrace();
				output.println(e);
			}
		%>
			

	</body>
</html>