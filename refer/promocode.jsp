<html>	
	
	<%@ page import= "java.io.*,com.mongodb.MongoClient, com.mongodb.MongoException, com.mongodb.WriteConcern, com.mongodb.DB" %>
    <%@ page import="org.bson.types.BasicBSONList, com.mongodb.DBCollection" %>
    <%@ page import="com.mongodb.BasicDBObject, com.mongodb.DBObject, com.mongodb.DBCursor" %>
    <%@ page import="com.mongodb.ServerAddress, com.mongodb.DuplicateKeyException, java.util.HashMap" %>
    <%@ page import="com.mongodb.DBCursor, com.mongodb.ServerAddress" %>
    <%@ page import="java.util.Arrays, java.util.List, java.util.Set, java.util.Date" %>
    <%@ page import="com.mongodb.QueryBuilder, com.mongodb.bulk.IndexRequest" %>
	<%@ page import="java.lang.*, java.util.*, java.text.DateFormat, java.text.SimpleDateFormat, java.util.Calendar" %>
	
	<% PrintWriter output = response.getWriter(); %>
	
	<body>
		<%
			try{	
			
				// check if promo code is applied
				String Promocode = request.getParameter("promocode");
				if(Promocode.equals("12345")){
					session.setAttribute("promocode",Promocode);
					
					output.println("<div style=\"color: white;\" >Promocode applied</div>");			
					request.getRequestDispatcher("/ItalianBistro/Buy").include(request, response);
				}else{
					output.println("<div style=\"color: red;\" >Invalid promocode</div>");			
					request.getRequestDispatcher("/ItalianBistro/Buy").include(request, response);
				}
				
			 }catch(Exception e) {
				e.printStackTrace();
			}	
		%>	
	</body>
				
				
</html>