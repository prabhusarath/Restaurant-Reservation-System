
	
import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.mongodb.MongoClient;
import com.mongodb.MongoException;
import com.mongodb.WriteConcern;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;
import com.mongodb.DBCursor;
import com.mongodb.ServerAddress;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.Date;
import java.util.*;
import java.text.*;
import javax.servlet.http.*;

public class error extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	
	public void init() throws ServletException{
      	
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try{
			HttpSession session = request.getSession();
PrintWriter out=response.getWriter();
response.setContentType("text/html");		

String loggedInUser=(String)session.getAttribute("userLogged");
		
	
	
	String userRole=null;
		
	userRole=(String)session.getAttribute("userRole");
	if(userRole==null){
		userRole="Guest";
	}

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
	
	if((loggedInUser!=null)&&(!loggedInUser.startsWith("Guest"))){
	out.println("<li class=\"header-button\"> <form action=\"index.jsp\"><input type=\"submit\" name=\"logout\" value=\"Logout\"></input></form></li>");
		out.println("<li class=\"header-button\"> <form><input type=\"text\" value=\"Welcome "+loggedInUser+"\" style=\"text-decoration:none\"></input></form></li>");
		
	}else{ 
			 out.println("<li class=\"header-button\"><form action=\"index.jsp\"><input type=\"submit\" name=\"login\" value=\"Login\"></input></form></li>");
			out.println("<li class=\"header-button\"><form action=\"index.jsp\"><input type=\"submit\" name=\"signup\" value=\"SignUP\"></input></form></li>");
		if(!userRole.equals("Manager")&&!userRole.equals("SalesMan")){
       
		 out.println("<li class=\"header-button\"><form action=\"/ItalianBistro/OrderPage\"><input type=\"submit\" name=\"cart\" value=\"Shopping cart\"></input></form></li>");
         out.println("<li class=\"header-button\"><form action=\"MyOrders.jsp\"><input type=\"submit\" name=\"orders\" value=\"My Orders\"></input></form></li>");
		}
		} 
		 out.println("</ul>");
            out.println("</header>");

    out.println("<nav>");
        out.println("<ul>");

            out.println("<li ><a href=\"/ItalianBistro/index.jsp\">HOME</a></li>");
            out.println("<li ><a href=\"/ItalianBistro/DineIn.jsp\">Dine In</a></li>");
            out.println("<li ><a href=\"/ItalianBistro/OnlineOrder.jsp\">Online Order</a></li>");
            out.println("<li ><a href=\"/ItalianBistro/AboutUs.html\">About Us</a></li>");
            out.println("<li ><a href=\"/ItalianBistro/TrackOrders.jsp\">Track Order </a></li>");
            out.println("<li ><a href=\"/ItalianBistro/Map.jsp\">View Location</a></li>");
            
        out.println("</ul>");
    out.println("</nav>");

    out.println("<header>");
        out.println("<img class=\"header-image\" src=\"images/header.jpg\" width = \"50%\" height = \"50%\" alt=\"Index Page Image\" />");
    out.println("</header>");
    
    out.println("<div id=\"body\">");		

	out.println("<section id=\"content\">");

        out.println("<br>");

        out.println("<article class=\"expanded\">");
 out.println("<h2>Error</h2><p>An error occured while performing the search Please try again</p>");        
out.println("<p> CLICK HERE TO GO BACK TO APPLICATION </p>");       
out.println("<p> <a href='index.jsp' class='link'> APPLICATION HOME </a></p>");
    out.println("</article></section>");
out.println("<aside class='sidebar'>");
	
            out.println("<ul>");
               out.println("<li>");
                    out.println("<h4>MENU</h4>");
                    out.println("<ul>");
                       out.println("<li><a href=\"/ItalianBistro/Appetizers\">Appetizers</a></li>");
                        out.println("<li><a href=\"/ItalianBistro/Salads\">Salads</a></li>");
                        out.println("<li><a href=\"/ItalianBistro/Soups\">Soups</a></li>");
                        out.println("<li><a href=\"/ItalianBistro/Pizzas\">Pizzas</a></li>");
                        out.println("<li><a href=\"/ItalianBistro/Pastas\">Pastas</a></li>");
                        out.println("<li><a href=\"/ItalianBistro/Strudels\">Strudels</a></li>");
                        out.println("<li><a href=\"/ItalianBistro/Desserts\">Desserts</a></li>");
                        out.println("<li><a href=\"/ItalianBistro/Beverages\">Beverages</a></li>");
                        
                    
                    out.println("</ul>");
                out.println("</li>");
                
                   
                out.println("<li>");
                    out.println("<h4>Reviews </h4>");
                    out.println("<ul>");
                       out.println(" <li><a href='WriteReviews.jsp' title='premium templates'>Write Reviews</a></li>");
                        out.println("<li><a href='ViewReviews.jsp' title='web hosting'> View Reviews </a></li>");
                    out.println("</ul>");
                out.println("</li>");
                
                
            out.println("</ul></aside>");
    
	out.println("<div class='clear'></div>");
	out.println("</div>");
           
     
    
	out.println("<footer>");
		
        out.println("<div class='footer-bottom'>");

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
            
            
        out.println("</div></footer>");
out.println("</div></div></body>");




}
catch (Exception e) {
			e.printStackTrace();
		}
}
public void destroy()	{
      // do nothing.
	}
	
}
