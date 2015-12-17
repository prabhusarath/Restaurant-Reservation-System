
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



<%
					
try{


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
                        



<%	
String category;

      MongoClient mongo;
	
		mongo = new MongoClient("localhost", 27017);
	
			DB db = mongo.getDB("ItalianBistro");
			
			DBCollection myReviews = db.getCollection("myReviews");
	
%>

<form class = 'submit-button1' method = 'get' action="ViewReviews.jsp">                        
<%
		ServletContext sc = this.getServletContext();
String path = sc.getRealPath("/WEB-INF/classes/product.txt");
String productCategory=request.getParameter("productCategory"); 
	FoodItem e =null;
	  HashMap<String, FoodItem>map = new HashMap<String, FoodItem>();
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
         System.out.println("Employee class not found");
         c.printStackTrace();
         return;
      } finally{
		  in.close();
         fileIn.close();
	  }
	FoodItem item=null;


			HashMap Category =new HashMap();
			Category.put("Appetizers","Appetizers");
			Category.put("Pizzas","Pizzas");
			Category.put("Pastas","Pastas");
			Category.put("Strudels","Strudels");
			Category.put("Salads","Salads");
			Category.put("Soups","Soups");
			Category.put("Deserts","Desserts");
			Category.put("Beverages","Beverages");
	
			Iterator itd=Category.entrySet().iterator();
		/*while(itd.hasNext()){
		Map.Entry it= (Map.Entry)itd.next();	
		   out.println("it"+it.getValue());
			}	*/
		       out.println(" <table style='border:0;' >");

			  out.println("<tr>");
                               out.println(" <td> Category: </td>");
                               out.println(" <td>");
                                  out.println("  <select name='productCategory'>");
				
			while(itd.hasNext()){
			Map.Entry it= (Map.Entry)itd.next();	
			
						

		if(productCategory!=null && !productCategory.equals(it.getValue()))		
					{out.println("<option value="+it.getValue()+">"+it.getValue()+"</option>");
					}	
					else
					{out.println("<option selected value="+it.getValue()+">"+it.getValue()+"  </option>");
					}
		}				
		     /*   for(int i=0;i<cursorProduct.size();i++)
				{	
					if(productCategory!=null && !productCategory.equals(cursorProduct.get(i)))		
					{out.println("<option value="+cursorProduct.get(i)+">"+cursorProduct.get(i)+"</option>");
					}	
					else
					{out.println("<option selected value="+cursorProduct.get(i)+">"+cursorProduct.get(i)+"  </option>");
					}
					
									
			}*/
out.println("</td>");
out.println("<td>");
		out.println("<input class = 'submit-button1' type = 'submit' name ='ViewReviews'  value = 'View All Reviews'>");



			out.println("</td></tr>");
        			  out.println("</table>");
%>
</form>
<% 
	if(request.getParameter("productCategory")!=null)
	{

	DBCursor cursor = myReviews.find();

	BasicDBObject searchQuery = new BasicDBObject();
	productCategory = request.getParameter("productCategory");
	String searchField="productCategory";
			searchQuery.put(searchField,productCategory);
	List cursorProduct = myReviews.distinct("productName",searchQuery);
		String ProductValue="";
	int value=0;		
	
	if(cursorProduct.size()==0)
	{ out.println("No Reviews Found for Category"+productCategory);
	}
	else {
		  out.println("<table style='border:0;'>");
			
			while(cursor.hasNext())
		{
        		
		BasicDBObject obj = (BasicDBObject)cursor.next();
		if(request.getParameter(obj.getString("productName"))!=null)
		{	
			ProductValue=obj.getString("productName");
		}
		}
		
		
		out.println("<tr>");
	
		/*out.println(" <td> Product Name: </td>");*/
                 out.println("</tr>");

					

		for(int i=0;i<cursorProduct.size();i++)
		{			
		 
	    Enumeration en=request.getParameterNames();
 
		while(en.hasMoreElements())
		{
	

		Object objOri=en.nextElement();
			String param=(String)objOri;	
				if(param.equals(cursorProduct.get(i)))
				{	value=1;
				}
				if(param.equals(cursorProduct.get(i)))
				{	String image="images/"+cursorProduct.get(i)+".jpg";
		
					%>
				<input class = 'submit-button' style='background-image:url("<%=image%>")' value =""  type = "submit"  name='<%=cursorProduct.get(i)%>'>
				<%
					
				}
			}
		
		}

			

			if(value==0)
			{

			int reviewcount=0;
			itd=map.entrySet().iterator();
			while(itd.hasNext()){
				reviewcount=0;
			Map.Entry it= (Map.Entry)itd.next();
			
				item = (FoodItem)it.getValue();
			
				if(item.getCategory().equals(productCategory))
				{
		        for(int i=0;i<cursorProduct.size();i++)
				{			
				out.println("<tr><td>");

      	     	 if(item.getFoodName().equals(cursorProduct.get(i)))
				{
			String image="images/"+cursorProduct.get(i)+".jpg";
				out.println(cursorProduct.get(i)+"</td>");
 				out.println("<td>");
				%>	
                	    <form class = "submit-button" method = "get" action = "ViewReviews.jsp">
		
			  <input  class = 'submit-button' style='background-image:url("<%=image%>")'  value ="" type = "submit" name='<%=cursorProduct.get(i)%>'>
				<td>
		
				<% cursor = myReviews.find();


				DBObject matchFields=new BasicDBObject();
				DBObject match = new BasicDBObject();
				DBObject limit=new BasicDBObject();
				DBObject orderby=new BasicDBObject();
				DBObject sort1=new BasicDBObject();			
				DBObject groupFields = null;
				DBObject group = null;
				DBObject projectFields = null;
				DBObject project = null;
				AggregationOutput aggregate = null;
				AggregationOutput aggregate1 = null;


					groupFields = new BasicDBObject("_id", 0);
					groupFields.put("_id","$productName");				
					groupFields.put("avg", new BasicDBObject("$avg","$reviewRating"));
					groupFields.put("count", new BasicDBObject("$sum",1));
					groupFields.put("productPrice", new BasicDBObject("$push", "$productPrice"));
					matchFields.put("productCategory",new BasicDBObject("$eq",productCategory));
					matchFields.put("productName",new BasicDBObject("$eq",cursorProduct.get(i)));
					
					projectFields = new BasicDBObject("_id", 0);
					
					projectFields.put("Rating","$avg");
					projectFields.put("productPrice", "$productPrice");
					projectFields.put("RatingCount","$count");
			
					projectFields.put("value", "$_id");
					match=new BasicDBObject("$match",matchFields);
					group = new BasicDBObject("$group", groupFields);
					project = new BasicDBObject("$project", projectFields);
				
					aggregate = myReviews.aggregate(match,group,project);

					int rowCount = 0;
				int CountData = 0;
				String tableData = " ";
				String pageContent = " ";

		for (DBObject result : aggregate.results()) {
				
				BasicDBObject bobj = (BasicDBObject) result;
				BasicDBList productPrice = (BasicDBList) bobj.get("productPrice");
				
			tableData = "<tr><td>Total Reviews Found: "+bobj.getString("RatingCount")+"</td>&nbsp"
						+	"<td>Average Review Rating: "+bobj.getString("Rating")+"</td></tr>";
				pageContent = "<table class = \"query-table\">"+tableData+"</table>";		
			    out.println(pageContent); 
				}
			
			%>	

		</td>

			<br><br>
		
  		<% reviewcount=1;
			break;
		}		
        }
				
		if(reviewcount==0)
		{
			out.println(item.getFoodName()+"<td>No Reviews Found</td>");
			
		}		
		
	}
	out.println("<input type='hidden' name ='productCategory' value='"+productCategory+"'>");
 	out.println("</form>");
	out.println("</td>");
	}	
  }
}
			
%>
<%		
	Enumeration  en=request.getParameterNames();
 DBCursor cursor1=null;
		while(en.hasMoreElements())
		{
	

		Object objOri=en.nextElement();
			String param=(String)objOri;
	String searchField1="productName";
	BasicDBObject searchQuery1 = new BasicDBObject();		
			searchQuery1.put(searchField1,param);
			
		cursor1 = myReviews.find(searchQuery1);
		//out.println(param);
		//out.println(cursor1);
		
		if(cursor1.count()!=0)
			break;
	
	}			
	out.println("<td>");
	while(cursor1.hasNext())
		{ 
	out.println("<table>");
	out.println("<tr><td>");
		
		BasicDBObject obj = (BasicDBObject)cursor1.next();
		out.println("ProductName: " + obj.get("productName")+"</td>");
	
		out.println("<td>Price: "+obj.get("productPrice")+"</td>");

		out.println("<td>Rating: "+obj.get("reviewRating")+"</td>");
		out.println("<td>UserName: "+obj.get("userName")+"</td>");
		out.println("<td>Review: "+obj.get("reviewText"));
	out.println("</td><tr>");
	out.println("</table>");
			
	}
%>

<%
out.println("</td></tr>");
out.println("</table>");
     %>


	 <%}
	 }
catch (Exception e) {
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