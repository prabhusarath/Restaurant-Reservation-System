
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
    			  MongoClient mongo;
	
		mongo = new MongoClient("localhost", 27017);
	
			DB db = mongo.getDB("ItalianBistro");
			
			DBCollection myReviews = db.getCollection("myReviews");
	

				DBCursor cursor = myReviews.find();


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
					groupFields.put("Price", new BasicDBObject("$first", "$productPrice"));
					groupFields.put("Category", new BasicDBObject("$first", "$productCategory"));
					
				
					limit=new BasicDBObject("$limit",5);
					
					projectFields = new BasicDBObject("_id", 0);
					
					projectFields.put("Rating","$avg");
					projectFields.put("Price", "$Price");
					projectFields.put("RatingCount","$count");
					projectFields.put("Category","$Category");
			
					projectFields.put("value", "$_id");
					group = new BasicDBObject("$group", groupFields);
					project = new BasicDBObject("$project", projectFields);
					sort1.put("RatingCount",-1);
					sort1.put("Rating",-1);
					orderby=new BasicDBObject("$sort",sort1);
					aggregate = myReviews.aggregate(group,project,orderby,limit);

					int rowCount = 0;
				int CountData = 0;
				String tableData = " ";
				String pageContent = " ";

		for (DBObject result : aggregate.results()) {
				
				BasicDBObject bobj = (BasicDBObject) result;
				

			String image="images/"+bobj.getString("value")+".jpg";
			tableData = "<tr><td><img src='"+image+"' height='200' width='200'></td><td>"+bobj.getString("value")+
		"<td>"+bobj.getString("Category")+"<td> Price:"+bobj.getString("Price")+"</td><td>Total Reviews Found:"+bobj.getString("RatingCount")+"</td>"
		+"<td>Average Review Rating: "+bobj.getString("Rating")+"</td></tr>";
				pageContent = "<table class = \"query-table\">"+tableData+"</table>";		
			    out.println(pageContent); 
					
				}
			

	 
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