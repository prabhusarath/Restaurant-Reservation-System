

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Enumeration;
import javabean.*;
import computation.*;
import java.util.Date;
import java.text.SimpleDateFormat;
import com.mongodb.MongoClient;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;
import com.mongodb.DBCursor;
import org.bson.types.ObjectId;
import com.mongodb.AggregationOutput;

public class ManageCustomers extends HttpServlet{
	public void doGet(HttpServletRequest request,HttpServletResponse response)throws ServletException, IOException {

	
HttpSession session = request.getSession();		
String loggedInUser=(String)session.getAttribute("userLogged");		
ServletContext sc = this.getServletContext();
String path = sc.getRealPath("/WEB-INF/classes/user.txt");
String cusAcc=request.getParameter("cusAcc");
String createAccount= request.getParameter("createAccount");
String makeRes=request.getParameter("makeRes");
String viewRes=request.getParameter("viewRes");
String availability=request.getParameter("availability");

String message=null;

if(createAccount!=null){
			String phone=request.getParameter("phoneNo");
			UserAccount userAcc=new UserAccount("Customer",request.getParameter("firstName"),request.getParameter("lastName"),request.getParameter("address"),phone,request.getParameter("userName"),request.getParameter("password"),request.getParameter("eMail"));
			UserIO.addUser(userAcc,request.getParameter("userName"),path);
			message="Customer Account Created";
	}

String cusOrder=request.getParameter("cusOrder");
MongoClient mongo;
mongo = new MongoClient("localhost", 27017);
DB db = mongo.getDB("ItalianBistro");
DBCollection myOrders = db.getCollection("myOrders");

String delete=request.getParameter("delete");
if(delete!=null){
String objID=request.getParameter("objID");
BasicDBObject searchById = new BasicDBObject("_id", new ObjectId(objID));
myOrders.remove(searchById);	
}

String deleteRes=request.getParameter("deleteRes");
if(deleteRes!=null){
	DBCollection bistroReservations = db.getCollection("bistroReservations");
String objID=request.getParameter("objID");
BasicDBObject searchById = new BasicDBObject("_id", new ObjectId(objID));
bistroReservations.remove(searchById);	
}

String createOrder=request.getParameter("createOrder");
String confirmOrder = request.getParameter("confirmOrder");


if(confirmOrder!=null){
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String address = request.getParameter("address");
String phoneNumber = request.getParameter("phoneNumber");
String status = request.getParameter("status");
String user = request.getParameter("user");
String confirmation = request.getParameter("confirmation");
String strPdt=request.getParameter("foodName");
int quantity=Integer.parseInt(request.getParameter("quantity"));
HashMap<String,FoodItem> map1=(HashMap<String,FoodItem>)session.getAttribute("costMap");
FoodItem item1=map1.get(strPdt);
int totCost=quantity*item1.getCost();
session.removeAttribute("costMap");
Date createdDate=new Date();
 
String ordertype=request.getParameter("ordertype");
	String reserveDate=request.getParameter("reserveDate");
	  String reserveTime=request.getParameter("reserveTime");

	
	BasicDBObject doc = new BasicDBObject("title", "myOrders").
	append("foodName", strPdt).
	append("quantity", quantity).
	append("totalPrice", totCost).
	append("firstName", firstName).
	append("lastName", lastName).
	append("user", user).
	append("address", address).
	append("phoneNumber", phoneNumber).
	append("createdDate",createdDate).
	append("status",status).
	append("confirmation",confirmation).
	append("orderType", ordertype).
	append("expectedDate", reserveDate).
	append("expectedTime", reserveTime);
	myOrders.insert(doc);
	message="Order Created";

}

String update=request.getParameter("update");
DBCursor cursor1=null;
if(update!=null){
String objID=request.getParameter("objID");
BasicDBObject searchById = new BasicDBObject("_id", new ObjectId(objID));
 cursor1= myOrders.find(searchById);
}
String updateRes=request.getParameter("updateRes");
DBCursor cursor2=null;
if(updateRes!=null){
	DBCollection bistroReservations = db.getCollection("bistroReservations");
String objID=request.getParameter("objID");
BasicDBObject searchById = new BasicDBObject("_id", new ObjectId(objID));
 cursor2= bistroReservations.find(searchById);
}
String confirmUpdate=request.getParameter("confirmUpdate");
String confirmUpdateRes=request.getParameter("confirmUpdateRes");

if(confirmUpdateRes!=null){
	String userTable = "", reserveDate = "", reserveFrom ="", reserveTo = "", info="", contact="", test="";
 	String searchField = "", searchParameter = "", bookingName="", description="";
	Long bookingID = 10001L, count = 0L;
	
DBCollection bistroReservations = db.getCollection("bistroReservations");	
bookingID = Long.parseLong(request.getParameter("bookingID"));
 bookingName = request.getParameter("bookingName");
					     contact = request.getParameter("contact");
					     userTable = request.getParameter("tableID");
					     reserveDate = request.getParameter("reserveDate");
	                     reserveFrom = request.getParameter("reserveFrom");
						 test = reserveDate+" "+reserveFrom;
	                     reserveTo = request.getParameter("reserveTo");
						 SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
	SimpleDateFormat sdfdate = new SimpleDateFormat("dd-M-yyyy");    
	SimpleDateFormat sdfboth = new SimpleDateFormat("dd-MM-yyyy HH:mm");  
java.util.Date userFrom=null;
java.util.Date userTo=null;
java.util.Date both=null;
	try{
						   userFrom = sdftime.parse(reserveFrom);						 
						  userTo = sdftime.parse(reserveTo);
						  both = sdfboth.parse(test);
	}catch (Exception e){
		e.printStackTrace();
	}						  
						 if(reserveDate.equals("") || (reserveFrom.equals("")) || (reserveTo.equals("")))  {
							 message = "Date and time fields cannot be empty";
						 } else {
							String objID=request.getParameter("objID");
BasicDBObject searchById = new BasicDBObject("_id", new ObjectId(objID));
BasicDBObject updateQuery = new BasicDBObject();
updateQuery.put("bookingID", bookingID);
	updateQuery.put("bookingName", bookingName);
	updateQuery.put("contact", contact);
	updateQuery.put("tableID", userTable);
	updateQuery.put("reserveDate", reserveDate);
	updateQuery.put("reserveFrom", reserveFrom);
	updateQuery.put("reserveTo", reserveTo);
	DBObject updateObj = new BasicDBObject("$set", updateQuery);
	bistroReservations.update(searchById, updateObj);
	message="Reservation is Updated";
			                
						 }
}
if(confirmUpdate!=null){
	
	String foodName=request.getParameter("foodName");
	String strNumItems=request.getParameter("quantity");
	int numItems=Integer.parseInt(strNumItems);
	String strTotCost=request.getParameter("totCost");
	int totCost=Integer.parseInt(strTotCost);
	String firstName=request.getParameter("firstName");
	String lastName=request.getParameter("lastName");
	String userLogged=request.getParameter("user");
	String address=request.getParameter("address");
	String phoneNumber=request.getParameter("phoneNumber");
	
	String strStatus=request.getParameter("status");
	String strConfirmNo=request.getParameter("confirmation");
	
String ordertype=request.getParameter("orderType");
	String reserveDate=request.getParameter("expectedDate");
	  String reserveTime=request.getParameter("expectedTime");
Date createdDate=new Date();

String objID=request.getParameter("objID");
BasicDBObject searchById = new BasicDBObject("_id", new ObjectId(objID));
BasicDBObject updateQuery = new BasicDBObject();
	updateQuery.put("foodName", foodName);
	updateQuery.put("quantity", numItems);
	updateQuery.put("totalPrice", totCost);
	updateQuery.put("firstName", firstName);
	updateQuery.put("lastName", lastName);
	updateQuery.put("user", userLogged);
	updateQuery.put("address", address);
	updateQuery.put("phoneNumber", phoneNumber);
	updateQuery.put("createdDate",createdDate);
	updateQuery.put("status",strStatus);
	updateQuery.put("confirmation",strConfirmNo);
	updateQuery.put("orderType", ordertype);
	updateQuery.put("expectedDate", reserveDate);
	updateQuery.put("expectedTime", reserveTime);
	DBObject updateObj = new BasicDBObject("$set", updateQuery);
	myOrders.update(searchById, updateObj);
	message="Customer Order Updated";
}

if(availability!=null){
String userTable = "", reserveDate = "", reserveFrom ="", reserveTo = "", info="", contact="", test="";
 	String searchField = "", searchParameter = "", bookingName="", description="";
	Long bookingID=10001L, count = 0L;
	
DBCollection bistroReservations = db.getCollection("bistroReservations");	
bookingID = Long.parseLong(request.getParameter("bookingID"));
 bookingName = request.getParameter("bookingName");
					     contact = request.getParameter("contact");
					     userTable = request.getParameter("tableID");
					     reserveDate = request.getParameter("reserveDate");
	                     reserveFrom = request.getParameter("reserveFrom");
						 test = reserveDate+" "+reserveFrom;
	                     reserveTo = request.getParameter("reserveTo");
						 SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
	SimpleDateFormat sdfdate = new SimpleDateFormat("dd-M-yyyy");    
	SimpleDateFormat sdfboth = new SimpleDateFormat("dd-MM-yyyy HH:mm");  
java.util.Date userFrom=null;
java.util.Date userTo=null;
java.util.Date both=null;
	try{
						   userFrom = sdftime.parse(reserveFrom);						 
						  userTo = sdftime.parse(reserveTo);
						  both = sdfboth.parse(test);
	}catch (Exception e){
		e.printStackTrace();
	}						  
						 if(reserveDate.equals("") || (reserveFrom.equals("")) || (reserveTo.equals("")))  {
							 message = "Date and time fields cannot be empty";
						 } else {
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
				             message = "Table has been booked successfully";
						 }
}
response.setContentType("text/html");
    PrintWriter out = response.getWriter();
	
	  

	
	out.println("<!doctype html>");

out.println("<html>");

out.println("<head>");
	out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />");
	out.println("<title> Appetizers - Italian Bistro </title>");
	out.println("<link rel=\"stylesheet\" href=\"css/styles.css\" type=\"text/css\" />");
    
out.println("</head>");



out.println("<body style=\"background-image:url(images/1.jpg)\">");
     
        out.println("<div class=\"container\">");

        out.println("<div id=\"container\">");

            out.println("<header>");

                out.println("<img class=\"header-image1\" src=\"images/i.png\" width = \"50%\" height = \"50%\" alt=\"Index Page Image\" />");
				 out.println("<ul>");
	
	
	out.println("<li class=\"header-button\"> <form action=\"index.jsp\"><input type=\"submit\" name=\"logout\" value=\"Logout\"></input></form></li>");
		out.println("<li class=\"header-button\"> <form><input type=\"text\" value=\"Welcome "+loggedInUser+"\" style=\"text-decoration:none\"></input></form></li>");
	
		 out.println("</ul>");
            out.println("</header>");

    out.println("<nav>");
        out.println("<ul>");

       
            out.println("<li class=\"\"><a href=\"index.jsp\">HOME</a></li>");
            out.println("<li class=\"\"><a href=\"/ItalianBistro/ManageRestaurant\">Tables & Foods</a></li>");
            out.println("<li class=\"\"><a href=\"/ItalianBistro/ManageCustomers\">Customers</a></li>");
               
            
    
            
        out.println("</ul>");
    out.println("</nav>");

    out.println("<header>");
        out.println("<img class=\"header-image\" src=\"images/header.jpg\" width = \"50%\" height = \"50%\" alt=\"Index Page Image\" />");
    out.println("</header>");
    
    out.println("<div id=\"body\">");		

	out.println("<section id=\"content\">");

        out.println("<br>");
out.println("<article class=\"expanded\">");
  if(makeRes!=null){ 
	  
			   // If database doesn't exists, MongoDB will create it for you
			     
			
	           // If the collection does not exists, MongoDB will create it for you
			      DBCollection bistroTables = db.getCollection("bistroTables");		
			
			     DBCursor cursor = bistroTables.find();
	            
			out.println("<form method=\"\" action=\"\">");			
            out.println("<table style=\"border:0;\">  "); 
out.println("<tr><td colspan=\"2\"><h4 style=\"color:#000000\"><b>Table Reservation<b></h4></td></tr>");			
                  out.println("<tr>");
				      out.println("<td style=\"color:#990000; width:30%\"> Select a table: </td>");
					  out.println("<td> &nbsp;<select name=\"tableID\">");
                            while (cursor.hasNext()) {					
			                   BasicDBObject obj = (BasicDBObject) cursor.next(); 
						
                               out.println("<option value=\""+obj.getString("tableID")+"\">"+obj.getString("description")+"</option>");		   
							}  
				           
              
						out.println("</select>");
					  out.println("</td>");
				  out.println("</tr>");
				  out.println("<tr>");
				      out.println("<td style=\"color:#990000; width:40%\"> Booking ID: </td>");
					  out.println("<td> <input type=\"text\" name=\"bookingID\"></td>");
				  out.println("</tr>");
				  out.println("<tr>");
				      out.println("<td style=\"color:#990000; width:40%\"> Name for the Booking: </td>");
					  out.println("<td> <input type=\"text\" name=\"bookingName\"></td>");
				  out.println("</tr>");
				  out.println("<tr>");
				      out.println("<td style=\"color:#990000; width:40%\"> Contact Number: </td>");
					  out.println("<td> <input type=\"text\" name=\"contact\"></td>");
				  out.println("</tr>");
				  out.println("<tr>");
				      out.println("<td style=\"color:#990000; width:40%\"> Reservation Date (dd-mm-yyyy): </td>");
					  out.println("<td> <input type=\"text\" name=\"reserveDate\"></td>");
				 out.println(" </tr>");
				  out.println("<tr>");
				      out.println("<td style=\"color:#990000; width:30%\"> Reservation From Time (24 hr format): </td>");
					  out.println("<td> <input type=\"text\" name=\"reserveFrom\"></td>");
				  out.println("</tr>");
				 out.println(" <tr>");
				      out.println("<td style=\"color:#990000; width:30%\"> Reservation To Time (24 hr format): </td>");
					  out.println("<td> <input type=\"text\" name=\"reserveTo\"></td>");
				  out.println("</tr>");
				  
            out.println("</table>");
			          out.println("<br><br>");
                      out.println("<center>  <input class = \"submit-button-link\" type=\"submit\" value=\"Reserve Table\" name=\"availability\"></form></center>");

	}	
if(createOrder!=null){
	ServletContext sc1 = this.getServletContext();
String path1 = sc1.getRealPath("/WEB-INF/classes/product.txt");
	HashMap<String,FoodItem> map=ProductIO.readProduct(path1);
	session.setAttribute("costMap",map);
	Iterator itd=map.entrySet().iterator();
	FoodItem item=null;
	
	
	out.println("<form action =\"\">");
	out.println("<table>");
	out.println("<tr><td colspan=\"2\"><h4 style=\"color:#000000\"><b>Create Customer Order<b></h4></td></tr>");
	out.println("<tr>");
			out.println("<td> Product Name: </td>");
			out.println("<td> <select name=\"foodName\">");
			while(itd.hasNext()){
				Map.Entry it= (Map.Entry)itd.next();
				item = (FoodItem)it.getValue();
			out.println("<option value=\""+item.getFoodName()+"\">"+item.getFoodName()+"</option>");	
			}		
			out.println("</td>");
		out.println("</tr>");
		out.println("<tr>");
			out.println("<td> Quantity: </td>");
			
			out.println("<td> <input type=\"text\" name=\"quantity\"> </td>");
		out.println("</tr>");
		out.println("<tr>");
			out.println("<td> First name: </td>");
			out.println("<td> <input type=\"text\" name=\"firstName\"> </td>");
		out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Last name: </td>");
			out.println("<td> <input type=\text\" name=\"lastName\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Address: </td>");
			out.println("<td> <input type=\"text\" name=\"address\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Phone: </td>");
			out.println("<td> <input type=\"text\" name=\"phoneNumber\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> User Name: </td>");
			out.println("<td> <input type=\"text\" name=\"user\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td><input type=\"radio\" name=\"ordertype\" value=\"pickup\" checked=\"checked\">Pick-up </td>");
			out.println("<td><input type=\"radio\" name=\"ordertype\" value=\"delivery\">Home Delivery</td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Expected Date: </td>");
			out.println("<td> <input type=\"date\" name=\"reserveDate\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Expected Time(24 hours Format): </td>");
			out.println("<td> <input type=\"text\" name=\"reserveTime\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Order Status: </td>");
			out.println("<td><select name=\"status\">");
			out.println("<option value='Order Confirmed'>Order Confirmed</option>");
			out.println("<option value='Getting Prepared'>Getting Prepared</option>");
			out.println("<option value='Dish Made'>Dish Made</option>");
			out.println("<option value='Order Ready to deliver'>Order Ready to deliver</option>");
			out.println("<option value='In transit'>In transit</option>");
			
			out.println("<option value='Delivered'>Delivered</option>");
			out.println("<option value='Order Cancelled'>Order Ready for pickup</option>");
			
			//out.println("<input type=\"text\" name=\"status\"> </td>");
			
			out.println("</select></td></tr>");
			out.println("<tr>");
			out.println("<td> Confirmation Number: </td>");
			out.println("<td> <input type=\"text\" name=\"confirmation\" > </td>");
			out.println("</tr>");
			out.println("</table>");
			out.println("<br><br>");
			
			out.println("<input class = \"submit-button-link\" type=\"submit\" name=\"confirmOrder\" value=\"Create Order\">");
			
			out.println("</form>");
	
}

if(update!=null){ 
	
	out.println("<form action =\"\">");
	out.println("<table>");
	out.println("<tr><td colspan=\"2\"><h4 style=\"color:#000000\"><b>Update Order<b></h4></td></tr>");
	
while (cursor1.hasNext()) {
			BasicDBObject obj = (BasicDBObject) cursor1.next();		
			out.println("<tr>");
			out.println("<td> Product Name: </td>");
			out.println("<td> <input type=\"text\" name=\"foodName\" value=\""+obj.getString("foodName")+"\">");
			out.println("</td>");
		out.println("</tr>");
		out.println("<tr>");
			out.println("<td> Quantity: </td>");
			
			out.println("<td> <input type=\"text\" name=\"quantity\" value=\""+obj.getString("quantity")+"\"> </td>");
		out.println("</tr>");
		out.println("<tr>");
			out.println("<td> Total Cost: </td>");
			
			out.println("<td> <input type=\"text\" name=\"totCost\" value=\""+obj.getString("totalPrice")+"\"> </td>");
		out.println("</tr>");
		out.println("<tr>");
			out.println("<td> First name: </td>");
			out.println("<td> <input type=\"text\" name=\"firstName\" value=\""+obj.getString("firstName")+"\"> </td>");
		out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Last name: </td>");
			out.println("<td> <input type=\"text\" name=\"lastName\" value=\""+obj.getString("lastName")+"\"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Address: </td>");
			out.println("<td> <input type=\"text\" name=\"address\" value=\""+obj.getString("address")+"\"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Phone: </td>");
			out.println("<td> <input type=\"text\" name=\"phoneNumber\" value=\""+obj.getString("phoneNumber")+"\"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> User Name: </td>");
			out.println("<td> <input type=\"text\" name=\"user\" value=\""+obj.getString("user")+"\"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Order Status: </td>");
			out.println("<td><select name=\"status\">");
			out.println("<option value='Order Confirmed'>Order Confirmed</option>");
			out.println("<option value='Getting Prepared'>Getting Prepared</option>");
			out.println("<option value='Dish Made'>Dish Made</option>");
			out.println("<option value='Order Ready to deliver'>Order Ready to deliver</option>");
			out.println("<option value='In transit'>In transit</option>");
			out.println("<option value='Delivered'>Delivered</option>");
			out.println("<option value='Order Cancelled'>Order Ready for pickup</option>");
			
			//out.println("<input type=\"text\" name=\"status\"> </td>");
			
			out.println("</select></td></tr>");
			out.println("<tr>");
			out.println("<td> Confirmation Number: </td>");
			out.println("<td> <input type=\"text\" name=\"confirmation\" value=\""+obj.getString("confirmation")+"\"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<tr>");
			out.println("<tr>");
			out.println("<td><input type=\"radio\" name=\"orderType\" value=\"pickup\" checked=\"checked\">Pick-up </td>");
			out.println("<td><input type=\"radio\" name=\"orderType\" value=\"delivery\">Home Delivery</td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Created Date: </td>");
			out.println("<td> <input type=\"text\" name=\"createdDate\" value=\""+obj.getString("createdDate")+"\"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Expected Date: </td>");
			out.println("<td> <input type=\"date\" name=\"expectedDate\" value=\""+obj.getString("expectedDate")+"\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Expected Time(24 Hour Format): </td>");
			out.println("<td> <input type=\"text\" name=\"expectedTime\" value=\""+obj.getString("expectedTime")+"\"> </td>");
			out.println("</tr>");
			out.println("<td colspan=\"2\"><center>");
			out.println("<input type=\"hidden\" name=\"objID\" value=\""+obj.get("_id").toString()+"\">");
			out.println("</center></td>");
			out.println("</tr>");
	}
			out.println("</table>");
			
			out.println("<input class = \"submit-button-link\" type=\"submit\" name=\"confirmUpdate\" value=\"Update Order\">");
			
			out.println("</form>");
	
	}
	
if(updateRes!=null){ 
	
	out.println("<form action =\"\">");
	out.println("<table>");
	out.println("<tr><td colspan=\"2\"><h4 style=\"color:#000000\"><b>Update Reservation<b></h4></td></tr>");
	
while (cursor2.hasNext()) {
			BasicDBObject obj = (BasicDBObject) cursor2.next();		
			out.println("<tr>");
			out.println("<td> bookingID: </td>");
			out.println("<td> <input type=\"text\" name=\"bookingID\" value=\""+obj.getLong("bookingID")+"\">");
			out.println("</td>");
		out.println("</tr>");
		out.println("<tr>");
			out.println("<td> bookingName: </td>");
			
			out.println("<td> <input type=\"text\" name=\"bookingName\" value=\""+obj.getString("bookingName")+"\"> </td>");
		out.println("</tr>");
		out.println("<tr>");
			out.println("<td> contact: </td>");
			
			out.println("<td> <input type=\"text\" name=\"contact\" value=\""+obj.getString("contact")+"\"> </td>");
		out.println("</tr>");
		out.println("<tr>");
			out.println("<td> tableID: </td>");
			out.println("<td> <input type=\"text\" name=\"tableID\" value=\""+obj.getString("tableID")+"\"> </td>");
		out.println("</tr>");
			out.println("<tr>");
			out.println("<td> reserveDate: </td>");
			out.println("<td> <input type=\"text\" name=\"reserveDate\" value=\""+obj.getString("reserveDate")+"\"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> reserveFrom: </td>");
			out.println("<td> <input type=\"text\" name=\"reserveFrom\" value=\""+obj.getString("reserveFrom")+"\"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> reserveTo: </td>");
			out.println("<td> <input type=\"text\" name=\"reserveTo\" value=\""+obj.getString("reserveTo")+"\"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td colspan=\"2\"><center>");
			out.println("<input type=\"hidden\" name=\"objID\" value=\""+obj.get("_id").toString()+"\">");
			out.println("</center></td>");
			out.println("</tr>");
	}
			out.println("</table>");
				
			out.println("<input class = \"submit-button-link\" type=\"submit\" name=\"confirmUpdateRes\" value=\"Update Order\">");
			
			out.println("</form>");
	
	}
		
if(message!=null){

out.println("<h4>" +message+ "</h4>");

}
if(cusAcc!=null){

out.println("<form  action=\"\">");
out.println("<table>");
out.println("<tr><td colspan=\"2\"><h4 style=\"color:#000000\"><b>Create New Customer Account<b></h4></td></tr>");
out.println("<tr>");
out.println("<td> First Name</td>");
out.println("<td> <input type=\"text\" name=\"firstName\"> </td>");
out.println("</tr>");
out.println("<tr>");
out.println("<td> Last Name</td>");
out.println("<td> <input type=\"text\" name=\"lastName\"> </td>");
out.println("</tr>");
out.println("<tr>");
out.println("<td> Address</td>");
out.println("<td> <input type=\"text\" name=\"address\"> </td>");
out.println("</tr>");
out.println("<tr>");
out.println("<td> Phone Number</td>");
out.println("<td> <input type=\"text\" name=\"phoneNo\"> </td>");
out.println("</tr>");
out.println("<tr>");
out.println("<td> User Name</td>");
out.println("<td> <input type=\"text\" name=\"userName\"> </td>");
out.println("</tr>");
out.println("<tr>");
out.println("<td> Password</td>");
out.println("<td> <input type=\"password\" name=\"password\"> </td>");
out.println("</tr>");
out.println("<tr>");
out.println("<td> E-Mail Address</td>");
out.println("<td> <input type=\"text\" name=\"eMail\"> </td>");
out.println("</tr>");
out.println("<tr>");
out.println("<td colspan='2'><center><input class = \"submit-button-link\" type=\"submit\" name=\"createAccount\" value=\"Create Account\"></center> </td>");
out.println("</tr>");
out.println("</table>");
out.println("</form>");

}if(cusOrder!=null){ 
DBCursor cursor = myOrders.find();


out.println("<TABLE BORDER=1 ALIGN=\"CENTER\">");
           out.println("<TR BGCOLOR=\"#FFAD00\">");
           // out.println("<TH>Food<TH>Quantity<TH>Total Cost");
           //out.println("<TH>Order Date<TH>Order Status<TH>Order Type<TH>Expected Date<TH>Expected Time");
		   //out.println("<TH>Confirmation Number<TH>Update/Delete? </tr>");
	while (cursor.hasNext()) {
				BasicDBObject obj = (BasicDBObject) cursor.next();
									out.println("<tr>");
									out.println("<TH>Food</th>");
									out.println("<td>"+obj.getString("foodName")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>Quantity</TH>");
									out.println("<td>"+obj.getString("quantity")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>Total Cost</TH>");
									out.println("<td>"+obj.getString("totalPrice")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>Order Date</TH>");
									out.println("<td>"+obj.getString("createdDate")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>Order Status</TH>");
									out.println("<td>"+obj.getString("status")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>Order Type</TH>");
									out.println("<td>"+obj.getString("orderType")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>Expected Date</TH>");
									out.println("<td>"+obj.getString("expectedDate")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>Expected Time</TH>");
									out.println("<td>"+obj.getString("expectedTime")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>Confirmation Number</TH>");
									out.println("<td>"+obj.getString("confirmation")+"</td>");
									out.println("</tr>");
									
									out.println("<tr>");
									out.println("<td colspan=\"2\"> <center><form  action=\"\">");
									out.println("<input type=\"hidden\" name=\"objID\" value=\""+obj.get("_id").toString()+"\"/>");
									out.println("<input type=\"hidden\" name=\"cusOrder\" value=\"Show Orders\"/>");
									out.println("<input class = \"submit-button-link\" type=\"submit\" name=\"delete\" value=\"Delete Order\"/>");
									out.println("</form>");
									
									out.println("<form  action=\"\">");
									out.println("<input type=\"hidden\" name=\"objID\" value=\""+obj.get("_id").toString()+"\"/>");
									out.println("<input class = \"submit-button-link\" type=\"submit\" name=\"update\" value=\"Update Order\"/>");
									out.println("</form>");
									out.println("</center>");
									out.println("</td>");
									out.println("</tr>");
									

			out.println("</tr>");
				} out.println("</table>");
			
}
if(viewRes!=null){ 
DBCollection bistroReservations = db.getCollection("bistroReservations");
DBCursor cursor = bistroReservations.find();


out.println("<TABLE BORDER=1 ALIGN=\"CENTER\">");
           out.println("<TR BGCOLOR=\"#FFAD00\">");
           
	while (cursor.hasNext()) {
				BasicDBObject obj = (BasicDBObject) cursor.next();
									out.println("<tr>");
									out.println("<TH>bookingID</th>");
									out.println("<td>"+obj.getLong("bookingID")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>bookingName</TH>");
									out.println("<td>"+obj.getString("bookingName")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>contact</TH>");
									out.println("<td>"+obj.getString("contact")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>tableID</TH>");
									out.println("<td>"+obj.getString("tableID")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>reserveDate</TH>");
									out.println("<td>"+obj.getString("reserveDate")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>reserveFrom</TH>");
									out.println("<td>"+obj.getString("reserveFrom")+"</td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<TH>reserveTo</TH>");
									out.println("<td>"+obj.getString("reserveTo")+"</td>");
									out.println("</tr>");
																	
									out.println("<tr>");
									out.println("<td colspan=\"2\"> <center><form  action=\"\">");
									out.println("<input type=\"hidden\" name=\"objID\" value=\""+obj.get("_id").toString()+"\"/>");
									out.println("<input type=\"hidden\" name=\"viewRes\" value=\"Show Orders\"/>");
									out.println("<input class = \"submit-button-link\" type=\"submit\" name=\"deleteRes\" value=\"Delete Booking\"/>");
									out.println("</form>");
									
									out.println("<form  action=\"\">");
									out.println("<input type=\"hidden\" name=\"objID\" value=\""+obj.get("_id").toString()+"\"/>");
									out.println("<input class = \"submit-button-link\" type=\"submit\" name=\"updateRes\" value=\"Update Booking\"/>");
									out.println("</form>");
									out.println("</center>");
									out.println("</td>");
									out.println("</tr>");
									

			out.println("</tr>");
				} out.println("</table>");
			
}
out.println("</article>");
    out.println("</section>");
	
		out.println("<aside class=\"sidebar\">");
	
            out.println("<ul>");
               out.println("<li>");
                    out.println("<h4>Manage Customers</h4>");
                    out.println("<ul>");
                       out.println("<li class=\"button-link\"><form action=\"/ItalianBistro/ManageCustomers\"><input type=\"submit\" name=\"cusAcc\" value=\"Create Customer Account\"></form></li>");
                        out.println("<li class=\"button-link\"><form action=\"/ItalianBistro/ManageCustomers\"><input type=\"submit\" name=\"createOrder\" value=\"Create Customer Order\"></form></li>");
                        out.println("<li class=\"button-link\"><form action=\"/ItalianBistro/ManageCustomers\"><input type=\"submit\" name=\"cusOrder\" value=\"View Customer Orders\"></form></li>");
		out.println("</ul>");
                out.println("</li>");
		out.println("<li>");
                    out.println("<h4>Manage Table Reservation </h4>");
                    out.println("<ul>");
                        out.println("<li class=\"button-link\"><form action=\"/ItalianBistro/ManageCustomers\"><input type=\"submit\" name=\"makeRes\" value=\"Make a Reservation\"></form></li>");
                        out.println("<li class=\"button-link\"><form action=\"/ItalianBistro/ManageCustomers\"><input type=\"submit\" name=\"viewRes\" value=\"View Reservations\"></form></li>");
                    out.println("</ul>");
                out.println("</li>");
                
                
            out.println("</ul>");
		
    out.println("</aside>");
out.println("<div class=\"clear\"></div>");
	out.println("</div>");
       
    
	out.println("<footer>");
		
        out.println("<div class=\"footer-bottom\" >");

            out.println("<table style=\"border:0;\">");

                out.println("<tr align=\"center\">");

                    out.println("<td >");
                    out.println("<a href=\"/ItalianBistro/AboutUs.html\" style=\"color:#ffffff\">About US</a></td>");
                    out.println("</td>");
                    out.println("<td>");
                    out.println("<a href=\"/ItalianBistro/FAQs.html\"style=\"color:#ffffff\">FAQ</a></td>");
                     
                    out.println("</td>");
                    out.println("<td>");
                    out.println("<a href=\"/ItalianBistro/ContactUs\"style=\"color:#ffffff\">Contact Us</a></td>");
                     
                    out.println("</td>");
                    out.println("<td>");
                    out.println("<a href=\"/ItalianBistro/FeedBack\"style=\"color:#ffffff\">FeedBack</a></td>");
                     
                    out.println("</td>");

                    out.println("<td>");
                    out.println("<a href=\"/ItalianBistro/SiteMap.jsp\"style=\"color:#ffffff\">Site Map</a></td>");
                     
                    out.println("</td>");
                    out.println("</tr>");
                    out.println("</table>");
                    out.println("<p>Copyright &copy; 2015 Italian Bistro. All Rights Reserved.</p>");
            
            
        out.println("</div>");
		
    out.println("</footer>");
out.println("</div>");
  out.println("</div>");

out.println("</body>");

out.println("</html>");
	
	
	}
}