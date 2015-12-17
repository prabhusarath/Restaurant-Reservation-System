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

public class ManageRestaurant extends HttpServlet{
	public void doGet(HttpServletRequest request,HttpServletResponse response)throws ServletException, IOException {

	
HttpSession session = request.getSession();		
String loggedInUser=(String)session.getAttribute("userLogged");		
ServletContext sc = this.getServletContext();
String path = sc.getRealPath("/WEB-INF/classes/product.txt");
String delete=request.getParameter("delete");
String update=request.getParameter("update");
String add=request.getParameter("add");
String view=request.getParameter("view");
String addNew=request.getParameter("addNew");
String confirmUpdate=request.getParameter("confirmUpdate");
String submitCategory=request.getParameter("submitCategory");
String message=null;
if(delete!=null){
	String deleteValue=request.getParameter("deleteValue");
	System.out.println("imside delete");
	ProductIO.deleteProduct(deleteValue,path);
}
if(confirmUpdate!=null){
	int pCost=Integer.parseInt(request.getParameter("pCost"));
	FoodItem gItem=new FoodItem(request.getParameter("pID"),request.getParameter("pShort"),pCost,request.getParameter("submitCategory"));
	ProductIO.updateProduct(gItem,request.getParameter("pID"),path);
	submitCategory=null;
	message="Food is Updated";
}
if(addNew!=null){
	int addCost=Integer.parseInt(request.getParameter("addCost"));
	FoodItem gItem=new FoodItem(request.getParameter("addID"),request.getParameter("addShort"),addCost,request.getParameter("category"));
	ProductIO.addProduct(gItem,request.getParameter("addID"),path);
	message="New Product added successfully";
	//submitCategory=request.getParameter("category");
}
 HashMap<String, FoodItem>map = new HashMap<String, FoodItem>();
if((submitCategory!=null)&&(add==null)){
FoodItem e = null;
	 
	  FileInputStream fileIn =null;
	  ObjectInputStream in =null;
      try
      {
          fileIn = new FileInputStream(path);
          in = new ObjectInputStream(fileIn);
		e=(FoodItem)in.readObject();
		 while(e!=null){
			
			 map.put(e.getFoodName(),e);
			e=(FoodItem)in.readObject();
				
			}
		 }
		
        catch(IOException i)
      {
        
      }catch(ClassNotFoundException c)
      {
         
         c.printStackTrace();
         return;
      } finally{
		  in.close();
         fileIn.close();
	  }
}


MongoClient mongo;
mongo = new MongoClient("localhost", 27017);
DB db = mongo.getDB("ItalianBistro");
DBCollection bistroTables = db.getCollection("bistroTables");

String addTable=request.getParameter("addTable");
String viewTable=request.getParameter("viewTable");

String deleteTable=request.getParameter("deleteTable");
if(deleteTable!=null){
String objID=request.getParameter("objID");
BasicDBObject searchById = new BasicDBObject("_id", new ObjectId(objID));
bistroTables.remove(searchById);	
}

String updateTable=request.getParameter("updateTable");
DBCursor cursor1=null;
if(updateTable!=null){
String objID=request.getParameter("objID");
BasicDBObject searchById = new BasicDBObject("_id", new ObjectId(objID));
 cursor1= bistroTables.find(searchById);
}
String confirmUpdateTable=request.getParameter("confirmUpdateTable");
if(confirmUpdateTable!=null){

String tableID = request.getParameter("tableID");
String  strcapacity = request.getParameter("capacity");
double d = Double.parseDouble(strcapacity);
int capacity = (int) d;
//int capacity=Integer.parseInt("strcapacity");
String description = request.getParameter("description");
					     
String objID=request.getParameter("objID");
BasicDBObject searchById = new BasicDBObject("_id", new ObjectId(objID));
BasicDBObject updateQuery = new BasicDBObject();
updateQuery.put("tableID", tableID);
	updateQuery.put("capacity", capacity);
	updateQuery.put("description", description);
	DBObject updateObj = new BasicDBObject("$set", updateQuery);
	bistroTables.update(searchById, updateObj);
	message="Table is Updated";
			                
						 }

String addNewTable=request.getParameter("addNewTable");
if(addNewTable!=null){

String tableID = request.getParameter("tableID");
String  strcapacity = request.getParameter("capacity");
double d = Double.parseDouble(strcapacity);
int capacity = (int) d;
//int capacity=Integer.parseInt("strcapacity");
String description = request.getParameter("description");
					     
							 BasicDBObject doc = new BasicDBObject("title", "bistroTables").
			                 append("tableID", tableID).
			                 append("capacity", capacity).			                 
			                 append("description", description);		                 
			                 
				          
						     bistroTables.insert(doc);				
			                 System.out.println("Document inserted successfully");
				             message = "Table has been added successfully";
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
if(message!=null){
	out.println("<h4>"+message+"</h4>");
}
if((add!=null)){
out.println("<table>");
out.println("<form  method = \"get\" action = \"\">");
out.println("<tr><td colspan=\"2\"><h4 style=\"color:#000000\"><b>Add New Food<b></h4></td></tr>");
out.println("<tr>");	
out.println("<td>Category:");
out.println("</td>");	
out.println("<td> <select name=\"category\" value=\"Category\">");
			
			out.println("<option value=\"Appetizers\">Appetizers</option>");	
			out.println("<option value=\"Salads\">Salads</option>");	
			out.println("<option value=\"Soups\">Soups</option>");	
			out.println("<option value=\"Pizzas\">Pizzas</option>");	
			out.println("<option value=\"Pastas\">Pastas</option>");	
			out.println("<option value=\"Strudels\">Strudels</option>");	
			out.println("<option value=\"Desserts\">Desserts</option>");	
			out.println("<option value=\"Beverages\">Beverages</option>");	
			out.println("</td></tr>");
					
					out.println("<tr><td>Food Name :</td><td> <input type=\"text\" name=\"addID\" value=\"\"></td></tr>");
					out.println("<tr><td>Description :</td><td> <input type=\"text\" name=\"addShort\" value=\"\"></td></tr>");
					out.println("<tr><td> Price :</td><td> <input type=\"text\" name=\"addCost\" value=\"\"></td></tr>"); 
					out.println("<tr><td>");

						out.println("<input class = \"submit-button-link\" type = \"submit\" name = \"addNew\" value = \"Add\"> ");
					out.println("</td></tr><td></td></form>");
					out.println("</table>");
}
if((view!=null) || (submitCategory!=null)&&(add==null)){
	out.println("<form action=\"\">");
	  out.println("<table style=\"border:0;\" >");
	  	out.println("<tr><td colspan=\"2\"><h4 style=\"color:#000000\"><b>View Catalog<b></h4></td></tr>");
out.println("<tr>");	
out.println("<td>Category:");
out.println("</td>");
out.println("<td> <select name=\"submitCategory\">");
			
			out.println("<option value=\"Appetizers\">Appetizers</option>");	
			out.println("<option value=\"Salads\">Salads</option>");	
			out.println("<option value=\"Soups\">Soups</option>");	
			out.println("<option value=\"Pizzas\">Pizzas</option>");	
			out.println("<option value=\"Pastas\">Pastas</option>");	
			out.println("<option value=\"Strudels\">Strudels</option>");	
			out.println("<option value=\"Desserts\">Desserts</option>");	
			out.println("<option value=\"Beverages\">Beverages</option>");	
			out.println("<option value=\"SpecialMenu\">Special Menu</option>");
			out.println("<option value=\"GiftCard\">Gift Cards</option>");
			out.println("</td><td><input class = \"submit-button-link\" type = \"submit\" name = \"submitCategory\" value = \"Select\">");
			out.println("</td></tr>");
			  out.println("</table>");
			  out.println("</form>");
}
	if(submitCategory!=null){
    out.println("<table style=\"border:0;\" >");
			Iterator itd=map.entrySet().iterator();
	  FoodItem item=null;
while(itd.hasNext()){
Map.Entry it= (Map.Entry)itd.next();

item = (FoodItem)it.getValue();
if(submitCategory.equals(item.getCategory()))
{
	String image=item.getFoodName()+".jpg";
                out.println("<tr>");
                out.println("<td>");
				out.println("<dl>");
					out.println("<dt>");
					out.println("<img src =\"images/"+image+"\" onerror=\"this.src='images/default.jpg'\" width =\"200\" height =\"200\" alt =\""+image+"\"></dt>");

					out.println("<dd><h1>"+item.getFoodName()+"</h1></dd>");
					out.println("<dd><h4>"+item.getDescription()+"</h4></dd> ");
					out.println("<dd> $" +item.getCost()+"</dd> ");
					out.println("</dl>");
                   

                out.println("</td>");
				 out.println("<td>");
				out.println("<form class = \"\" method = \"get\" action =\"\"> ");
						out.println("<input class = \"\" type = \"hidden\" name = \"deleteValue\" value = \""+item.getFoodName()+"\">"); 
						out.println("<input class = \"\" type = \"hidden\" name = \"submitCategory\" value =\""+item.getCategory()+"\"> ");
						out.println("<input class = \"submit-button-link\" type = \"submit\" name = \"delete\" value = \"delete\">");
					out.println("</form>");
					out.println("<form class = \"\" method = \"get\" action = \"\">"); 
						out.println("<input class = \"\" type = \"hidden\" name = \"updateValue\" value = \""+ item.getFoodName()+"\">");
						out.println("<input class = \"\" type = \"hidden\" name = \"submitCategory\" value =\""+item.getCategory()+"\"> ");
						out.println("<input class = \"submit-button-link\" type = \"submit\" name = \"update\" value = \"update\"> ");
					out.println("</form>");
					out.println("</td>");
				out.println("</tr>");
if((update!=null)&&((request.getParameter("updateValue")).equals(item.getFoodName()))){
	out.println("<tr>");
	out.println("<center><table>");
	out.println("<tr><td colspan=\"2\"><h4 style=\"color:#000000\"><b>Update Food<b></h4></td></tr>");
					out.println("<form class = \"\" method = \"get\" action = \"\">");
					out.println("<tr><td>Food Name : </td><td><input type=\"text\" name=\"pID\" value =\""+item.getFoodName()+"\"></td></tr>");
					out.println("<tr><td>Description : </td><td><input type=\"text\" name=\"pShort\" value =\""+item.getDescription()+"\"></td></tr>");
					out.println("<tr><td>Price : </td><td><input type=\"text\" name=\"pCost\" value =\""+item.getCost()+"\"></td></tr>");
					out.println("<input class = \"\" type = \"hidden\" name = \"submitCategory\" value =\""+item.getCategory()+"\"> ");
					
					out.println("<tr><td><input class = \"submit-button-link\" type = \"submit\" name = \"confirmUpdate\" value = \"confirm\"> ");
					out.println("</td><td></td></tr></form>");
				out.println("</table></center>");	
					out.println("</tr>");
}     
}
}
            out.println("</table>");    

}
if(addTable!=null){

	out.println("<form action =\"\">");
	out.println("<table>");
	out.println("<tr><td colspan=\"2\"><h4 style=\"color:#000000\"><b>Add A New Table<b></h4></td></tr>");
		out.println("<tr>");
			out.println("<td> TableID: </td>");
			
			out.println("<td> <input type=\"text\" name=\"tableID\"> </td>");
		out.println("</tr>");
		out.println("<tr>");
			out.println("<td> Capacity: </td>");
			out.println("<td> <input type=\"number\" name=\"capacity\"> </td>");
		out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Description: </td>");
			out.println("<td> <input type=\"text\" name=\"description\"> </td>");
			out.println("</tr>");
			
			out.println("</table>");
			out.println("<br><br>");
			
			out.println("<input class = \"submit-button-link\" type=\"submit\" name=\"addNewTable\" value=\"Add New Table\">");
			
			out.println("</form>");
	
}
if(viewTable!=null){ 
 cursor1= bistroTables.find();
out.println("<TABLE style=\"border:0;\">");
           
           
	while (cursor1.hasNext()) {
				BasicDBObject obj = (BasicDBObject) cursor1.next();
				out.println("<tr>");
                out.println("<td>");
				out.println("<dl>");
					out.println("<dt><h1>"+obj.getString("tableID")+"</h1></dt>");
					out.println("<dd><h4> "+obj.getString("description")+"</h4></dd>");
					out.println("<dd>Capacity:"+obj.getString("capacity")+"</dd> ");
					out.println("</dl>");
					out.println("</td>");
				 out.println("<td>");
									
									out.println("<td><form action=\"\">");
									out.println("<input type=\"hidden\" name=\"objID\" value=\""+obj.get("_id").toString()+"\"/>");
									out.println("<input type=\"hidden\" name=\"viewTable\" value=\"Show Tables\"/>");
									out.println("<input class = \"submit-button-link\" type=\"submit\" name=\"deleteTable\" value=\"Delete Table\"/>");
									out.println("</form>");
									
									out.println("<form  action=\"\">");
									out.println("<input type=\"hidden\" name=\"objID\" value=\""+obj.get("_id").toString()+"\"/>");
									out.println("<input class = \"\" type = \"hidden\" name = \"updateValue\" value = \""+ obj.getString("tableID")+"\">");
									out.println("<input type=\"hidden\" name=\"viewTable\" value=\"Show Tables\"/>");
									out.println("<input class =\"submit-button-link\" type=\"submit\" name=\"updateTable\" value=\"Update Table\"/>");
									out.println("</form>");
									
									out.println("</td>");
									out.println("</tr>");
									
if((updateTable!=null)&&((request.getParameter("updateValue")).equals(obj.getString("tableID")))){
	out.println("<tr>");
	out.println("<center><table>");
	out.println("<tr><td colspan=\"2\"><h4 style=\"color:#000000\"><b>Update Table<b></h4></td></tr>");
					out.println("<form class = \"\" method = \"get\" action = \"\">");
					out.println("<tr><td>TableID : </td><td><input type=\"text\" name=\"tableID\" value =\""+obj.getString("tableID")+"\"></td></tr>");
					out.println("<tr><td>Capacity : </td><td><input type=\"text\" name=\"capacity\" value =\""+obj.getString("capacity")+"\"></td></tr>");
					out.println("<tr><td>Description: </td><td><input type=\"text\" name=\"description\" value =\""+obj.getString("description")+"\"></td></tr>");
					out.println("<input type=\"hidden\" name=\"objID\" value=\""+obj.get("_id").toString()+"\"/>");
					out.println("<tr><td><input class =\"submit-button-link\" type = \"submit\" name = \"confirmUpdateTable\" value = \"confirm\"> ");
					out.println("</td><td></td></tr></form>");
}     
				} out.println("</table>");
			
}
out.println("</article>");
    out.println("</section>");
	
		out.println("<aside class=\"sidebar\">");
	
            out.println("<ul>");
               out.println("<li>");
                    out.println("<h4>Manage Foods</h4>");
                    out.println("<ul>");
                       out.println("<li class=\"button-link\"><form action=\"/ItalianBistro/ManageRestaurant\"><input type=\"submit\" name=\"add\" value=\"Add New Food\"></form></li>");
                        out.println("<li class=\"button-link\"><form action=\"/ItalianBistro/ManageRestaurant\"><input type=\"submit\" name=\"view\" value=\"View Catalog\"></form></li>");
			out.println("</ul>");
                out.println("</li>");
		
                out.println("<li>");
                    out.println("<h4>Manage Tables</h4>");
                    out.println("<ul>");
                        out.println("<li class=\"button-link\"><form action=\"/ItalianBistro/ManageRestaurant\"><input type=\"submit\" name=\"addTable\" value=\"Add New Table\"></form></li>");
                        out.println("<li class=\"button-link\"><form action=\"/ItalianBistro/ManageRestaurant\"><input type=\"submit\" name=\"viewTable\" value=\"View Tables\"></form></li>");
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