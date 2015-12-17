
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
       
		 <li class="header-button"><form action="ShoppingCart.jsp"><input type="submit" name="cart" value="Shopping cart"></input></form></li>
         <li class="header-button"><form action="MyOrders.jsp"><input type="submit" name="orders" value="My Orders"></input></form></li></ul>
		
             </header>

    <nav>
        <ul>

            <li class=""><a href="index.jsp">HOME</a></li>
            <li class=""><a href="DineIn.jsp">Dine In</a></li>
            <li class=""><a href="">Online Order</a></li>
            <li class=""><a href="">About Us</a></li>
            <li class=""><a href="">Track Order </a></li>
            <li class=""><a href="">View Location</a></li>
            
            
        </ul>
    </nav>

    <header>
        <img class="header-image" src="images/header.jpg" width = "50%" height = "50%" alt="Index Page Image" />
    </header>

    
    <div id="body">		

	<section id="content">

        <br>

        <article class="expanded">
                        



<%	MongoClient mongo;
	
		mongo = new MongoClient("localhost", 27017);
	

			DB db = mongo.getDB("ItalianBistro");
			
			DBCollection myReviews = db.getCollection("myReviews");
			
%>

<form class = 'submit-button1' method = 'get' action="ViewReviews.jsp">                        
<%
List cursorProduct = myReviews.distinct("productCategory");
String productCategory = request.getParameter("productModel");

       			  out.println(" <table style='border:0;' >");

			  out.println("<tr>");
                               out.println(" <td> Product Model: </td>");
                               out.println(" <td>");
                                  out.println("  <select name='productModel'>");
		
				out.println("<option value='ALL_PRODUCTS'>All Products</option>");
		        for(int i=0;i<cursorProduct.size();i++)
				{	
					if(productCategory!=null && !productCategory.equals(cursorProduct.get(i)))		
					{out.println("<option value="+cursorProduct.get(i)+">"+cursorProduct.get(i)+"</option>");
					}	
					else
					{out.println("<option selected value="+cursorProduct.get(i)+">"+cursorProduct.get(i)+"  </option>");
					}
					
					
			}
			
		out.println("<input class = 'submit-button1' type = 'submit' name ='submit'  value = 'View Reviews'>");
			out.println("</td></tr>");
        			  out.println("</table>");

%>
</form>
<%

	DBCursor cursor = myReviews.find();

		BasicDBObject searchQuery = new BasicDBObject();
	productCategory = request.getParameter("productModel");
	String searchField="productCategory";
			searchQuery.put(searchField,productCategory);
		cursorProduct = myReviews.distinct("productName",searchQuery);
		String ProductValue="";
int value=0;		
  out.println("<table style='border:0;'>");
        		
	while(cursor.hasNext())
		{
		BasicDBObject obj = (BasicDBObject)cursor.next();
		if(request.getParameter(obj.getString("productName"))!=null)
		{	//out.println("value is"+request.getParameter(obj.getString("productName")));
			ProductValue=obj.getString("productName");
		}
		}
		
				 out.println("<tr>");
	
		out.println(" <td> Product Name: </td>");
                 out.println("</tr>");
		for(int i=0;i<cursorProduct.size();i++)
				{			
		 
	Enumeration en=request.getParameterNames();
 
		while(en.hasMoreElements())
		{
	

		Object objOri=en.nextElement();
			String param=(String)objOri;	
				if(param.equals(cursorProduct.get(i)))
				{	value=1;%>
				<input class = 'submit-button' style='background-image:url(images/a3.jpg)' type = "submit" name='<%=cursorProduct.get(i)%>'>
				<%
				}
			}
		
		}
			if(value==0)
			{
		        for(int i=0;i<cursorProduct.size();i++)
				{			
		  out.println("<tr><td>");

                     
				out.println(cursorProduct.get(i)+"</td>");
 				out.println("<td>");
				%>	
                    <form class = "submit-button" method = "get" action = "ViewReviews.jsp">
		
		  <input class = 'submit-button' style='background-image:url(images/a3.jpg)' type = "submit" name='<%=cursorProduct.get(i)%>'>
  <%    
	out.println("<input type='hidden' name ='productModel' value='"+productCategory+"'>");






 	out.println("</form>");
	out.println("</td>");
						
}	
}
			
%>
<%		
	Enumeration  en=request.getParameterNames();
 
		while(en.hasMoreElements())
		{
	

		Object objOri=en.nextElement();
			String param=(String)objOri;
	
			searchField="productName";
			searchQuery.put(searchField,param);
		cursor = myReviews.find(searchQuery);
		if(cursor!=null)
			break;
	

	}			
	out.println("<td>");
	while(cursor.hasNext())
		{
	out.println("<table>");
	out.println("<tr><td>");
		
		BasicDBObject obj = (BasicDBObject)cursor.next();
		out.println("ProductName: " + obj.get("productName")+"</td>");
	
		out.println("<td>Price: "+obj.get("productPrice")+"</td>");
		out.println("<td>UserName: "+obj.get("userName"));
	out.println("</td><tr>");
	out.println("</table>");
			
	}
%>

<%
out.println("</td></tr>");
out.println("</table>");
     %>
	 <%}
catch (MongoException e) {
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
                    <a href="" style="color:#ffffff">About US</a></td>
                    </td>
                    <td>
                    <a href="\ItalianBistro\FAQ"style="color:#ffffff">FAQ</a></td>
                     
                    </td>
                    <td>
                    <a href="\ItalianBistro\ContactUs"style="color:#ffffff">Contact Us</a></td>
                     
                    </td>
                    <td>
                    <a href="\ItalianBistro\FeedBack"style="color:#ffffff">FeedBack</a></td>
                     
                    </td>

                    <td>
                    <a href=""style="color:#ffffff">Site Map</a></td>
                     
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