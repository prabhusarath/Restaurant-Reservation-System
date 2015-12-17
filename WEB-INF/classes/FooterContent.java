

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Enumeration;


public class FooterContent extends HttpServlet{
	private String content;
	


   public void init(ServletConfig config)throws ServletException {
    
   super.init(config);
   content = config.getInitParameter("content");
   
   }

	public void doGet(HttpServletRequest request,HttpServletResponse response)throws ServletException, IOException {
		System.out.println(" Footer content " + content);
		HttpSession session = request.getSession();
		String loggedInUser=(String)session.getAttribute("userLogged");
		String message=(String)session.getAttribute("message");
	String userRole=null;
	userRole=(String)session.getAttribute("userRole");
	if(userRole==null){
		userRole="Guest";
	}
response.setContentType("text/html");
    PrintWriter out = response.getWriter();	
	System.out.println("content is "+content);
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
if(userRole.equals("Manager")){
		
		out.println("<nav>");
        out.println("<ul>");

            out.println("<li class=\"\"><a href=\"index.jsp\">HOME</a></li>");
            out.println("<li class=\"\"><a href=\"/ItalianBistro/ManageRestaurant\">Tables & Foods</a></li>");
            out.println("<li class=\"\"><a href=\"/ItalianBistro/ManageCustomers\">Customers</a></li>");
               
            
        out.println("</ul>");
    out.println("</nav>");
	}else{
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
	}
    out.println("<header>");
        out.println("<img class=\"header-image\" src=\"images/header.jpg\" width = \"50%\" height = \"50%\" alt=\"Index Page Image\" />");
    out.println("</header>");
    
    out.println("<div id=\"body\">");		

	out.println("<section id=\"content\">");

        out.println("<br>");
if(content.equals("ContactUs")){
        out.println("<article class=\"expanded\">");
                        
        out.println("<table>");
		out.println("<tr><td colspan=\"2\"> Contact Italian Bistro   </td> </tr>");
		out.println("<tr><td>Address</td><td>: 3201 s.State Street,Chicago,IL 60616</td></tr>");
		out.println("<tr><td>Phone NO</td><td>: (312) 567-3000 </td></tr>");
		out.println("<tr><td>e-mail</td><td>: italianbistro7@gmail.com</td></tr>");
         out.println("</table> ");
        out.println("</article>");
}

else if(content.equals("faq1")){
		
		out.println("<article class=\"expanded\">");
           
			out.println("<h4 style=\"color: #000000;\"> FAQ s </h4>");
            out.println("<h3 style=\"font-size: 120%;\"> 1)&nbsp;&nbsp;&nbsp;Can I order a food online? </h3>");
            out.println("<h5 style=\"color: #799AC0;\"> Yes, you can. We undertake online orders and deliver the food within <u>25 miles</u> from where we are located. </h5>");
            out.println("<h3 style=\"font-size: 120%;\"> 2)&nbsp;&nbsp;&nbsp;Is Home-Delivery the only option to get my food through online order?</h3>");
            out.println("<h5 style=\"color: #799AC0;\"> No, we also provide a pickup from the restaurant option for online orders.  You can choose either home-delivery or pickup from restaurant. </h5> ");           
            out.println("<h3 style=\"font-size: 120%;\"> 3)&nbsp;&nbsp;&nbsp;Can I pick up my order from restaurant at any time? </h3>");
            out.println("<h5 style=\"color: #799AC0;\"> No. You can collect your order only after one hour from the time you placed the order. </h5>");
			out.println("<h3 style=\"font-size: 120%;\"> 4)&nbsp;&nbsp;&nbsp;Is there an option to reserve a table in advance? </h3>");
            out.println("<h5 style=\"color: #799AC0;\"> Yes, we do provide our customers with an option to reserve table in advance. This is provided under the Dine-In section in our website.</h5>");
			out.println("<h3 style=\"font-size: 120%;\"> 5)&nbsp;&nbsp;&nbsp;Can I cancel a reservation that I made? </h3>");
            out.println("<h5 style=\"color: #799AC0;\"> Of course you can. But you can cancel your reservations only till <u>10 minutes before</u> your reservation start time.</h5>");
            out.println("<h3 style=\"font-size: 120%;\"> 6)&nbsp;&nbsp;&nbsp;Is there any special menu provided? </h3>");
            out.println("<h5 style=\"color: #799AC0;\"> We do offer Season special for all the seasons. Please visit our website for more details.</h5>");
            out.println("<h3 style=\"font-size: 120%;\"> 7)&nbsp;&nbsp;&nbsp;Do I get any discounts or offers?</h3>");
            out.println("<h5 style=\"color: #799AC0;\"> Yes, we do provide our customers with promo codes for discounts on each dish served in our restaurant. Just enter the promo code after adding the dish to your cart and you will automatically get your discount.</h5>");    

              
        out.println("</article>");
	}
else if(content.equals("FeedBack")){
	if(message!=null){
	out.println("<article class=\"expanded\">");
	out.println("<p>"+message+" </p>");
	out.println("</article>");
	session.setAttribute("message",null);
}else{
	out.println("<article class=\"expanded\">");
	out.println("<p> Your FeedBack is most valued </p>");
out.println("<form method=\"get\" action=\"/ItalianBistro/SubmitFeedBack\">");
out.println("<table>");
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
out.println("<td> E-Mail Address</td>");
out.println("<td> <input type=\"text\" name=\"eMail\"> </td>");
out.println("</tr>");
out.println("<tr>");
out.println("<tr>");
out.println("<td> Feedback</td>");
out.println("<td> <textarea name=\"feedText\"></textarea> </td>");
out.println("</tr>");
out.println("<td colspan='2'><center><input type=\"submit\" name=\"feedback\" value=\"Submit\"></center> </td>");
out.println("</tr>");
out.println("</table>");
out.println("</form>");
out.println("</article>");
}
	}
        out.println("</section>");
        


        
    out.println("<aside class=\"sidebar\">");
	
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
                        out.println("<li><a href=\"/ItalianBistro/WriteReviews.jsp\" title=\"premium templates\">Write Reviews</a></li>");
                        out.println("<li><a href=\"/ItalianBistro/ViewReviews.jsp\" title=\"web hosting\"> View Reviews </a></li>");
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
