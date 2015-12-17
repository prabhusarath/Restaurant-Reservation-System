import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.*;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.Date;
import java.util.*;
import java.text.*;
import javabean.*;

public class Buy extends HttpServlet {
	public void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String loggedInUser=(String)session.getAttribute("userLogged");
	String userRole=null;
	userRole=(String)session.getAttribute("userRole");
	if(userRole==null){
		userRole="Guest";
	}
	String redeemBtn=request.getParameter("redeemBtn");
				if(redeemBtn!=null){
					System.out.println("*******Redeemed");
			
				String Promocode = request.getParameter("promocode");
				
				if(Promocode.equals("12345")){
					System.out.println("*******Applied");
					session.setAttribute("promocode",Promocode);
				}
			
				}
		response.setContentType("text/html");

		PrintWriter out = response.getWriter();
	int sum=0;
int totalCost=0;	
    ShoppingCart cart;
    synchronized(session) {
      cart = (ShoppingCart)session.getAttribute("shoppingCart");
		List itemsOrdered = cart.getItemsOrdered();
      if (itemsOrdered.size() == 0) {
        out.println("<H2><I>No items in your cart...</I></H2>");
      } else {
        // If there is at least one item in cart, show table
        // of items ordered.
   
	
	  

	
	out.println("<!doctype html>");

out.println("<html>");

out.println("<head>");
	out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />");
	out.println("<title> Appetizers - Italian Bistro </title>");
	out.println("<link rel=\"stylesheet\" href=\"css/styles.css\" type=\"text/css\" />");
    out.println("<script type=\"text/javascript\" src=\"http://maps.google.com/maps/api/js?sensor=false\"></script>");
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
		
        out.println("<form method=\"post\" action=\"MyOrders.jsp\">");
		
out.println("<TABLE BORDER=1 ALIGN=\"CENTER\">\n" +
           "<TR BGCOLOR=\"#FFAD00\">\n" +
           "  <TH>Name<TH>Description\n" +
           "  <TH>Unit Cost<TH>Number<TH>Total Cost");
        ItemOrder order;
        // Rounds to two decimal places, inserts dollar
        // sign (or other currency symbol), etc., as
        // appropriate in current Locale.
        
        // For each entry in shopping cart, make
        // table row showing ID, description, per-item
        // cost, number ordered, and total cost.
        // Put number ordered in textfield that user
        // can change, with "Update Order" button next
        // to it, which resubmits to this same page
        // but specifying a different number of items.
        for(int i=0; i<itemsOrdered.size(); i++) {
          order = (ItemOrder)itemsOrdered.get(i);
		  totalCost=order.getTotalCost();
		  
		 if(session.getAttribute("promocode") != null){
			totalCost=totalCost-(1*order.getNumItems());
			
		 }
		 sum=sum+totalCost;
          out.println
            ("<TR>\n" +
             "  <TD>" + order.getFoodName() + "\n" +
             "  <TD>" + order.getDescription() + "\n" +
             "  <TD>" +
             order.getUnitCost() + "\n" +
             "  <TD>" +
                order.getNumItems() + "\n" +


             "  <TD>" +
             totalCost);
        }
		
out.println("</tr></table>");
out.println("<fieldset>");
			out.println("<legend>Total Cost:</legend>");
			out.println("<table>");
			
			out.println("<tr>");
			out.println("<td>Total Cost");
									out.println("</td>");
									out.println("<td>"+sum);
									out.println("</td>");
									out.println("<td>Promo Code");
									out.println("</td>");
									out.println("<td>"); 
										out.println("<input type=\"text\" name=\"promocode\" size=\"5\">");
									out.println("</td>");
									out.println("<td>");
										out.println("<input class = \"submit-button-link\" name=\"redeemBtn\" type=\"submit\" value=\"Redeem\" onclick='this.form.action=\"/ItalianBistro/Buy\"'>");					
									out.println("</td>");
									out.println("</tr>");
								
			out.println("</table>");
			out.println("</fieldset>");
out.println("<fieldset>");
			out.println("<legend>Personal information:</legend>");
			out.println("<table>");
			out.println("<tr>");
			out.println("<td> First name: </td>");
			out.println("<td> <input type=\"text\" name=\"firstName\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Last name: </td>");
			out.println("<td> <input type=\"text\" name=\"lastName\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Address: </td>");
			out.println("<td> <textarea name=\"address\" id=\"address\"></textarea> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Phone: </td>");
			out.println("<td> <input type=\"text\" name=\"phoneNumber\"> </td>");
			out.println("</tr>");
			out.println("</table>");
			out.println("</fieldset>");
			out.println("<fieldset>");
			out.println("<legend>Order information:</legend>");
			out.println("<table>");
			out.println("<tr>");
			out.println("<td><input type=\"radio\" name=\"ordertype\" value=\"pickup\" checked=\"checked\" id=\"pickup\">Pick-up </td>");
			out.println("<td><input type=\"radio\" name=\"ordertype\" value=\"delivery\" onclick=\"onDeliveryClick();\">Home Delivery</td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Expected Date: </td>");
			out.println("<td> <input type=\"date\" name=\"reserveDate\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Expected Time(24 hour format): </td>");
			out.println("<td> <input type=\"text\" name=\"reserveTime\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
								out.println("<td>Special Requests(if any)</td>");
								out.println("<td><textarea type=\"text\" name=\"splrequest\" size=\"35\"></textarea></td>");
								out.println("</tr>");
			out.println("</table>");
			out.println("</fieldset>");
			out.println("<fieldset>");
			out.println("<legend>Payment Information:</legend>");
			out.println("<table>");
			out.println("<tr>");
								out.println("<td>Credit Card Type:</td>");
								out.println("<td>");
								out.println("<select name=\"CreditCardType\">");
									out.println("<option value=\"AmericanExpress\">AmericanExpress</option>");
									out.println("<option value=\"Discover\">Discover</option>");
									out.println("<option value=\"Mastercard\">Mastercard</option>");
									out.println("<option value=\"Visa\">Visa</option>");
								out.println("</select>");
								out.println("</td>");
								out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Credit Card: </td>");
			out.println("<td> <input type=\"text\" name=\"creditCard\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> Expiry Date: </td>");
			out.println("<td> <input type=\"date\" name=\"expiry\"> </td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td> cvv: </td>");
			out.println("<td> <input type=\"password\" name=\"cvv\" size=\"3\"> </td>");
			out.println("</tr>");
			out.println("</table>");
			out.println("<br><br>");
			out.println("<center><input class = \"submit-button-link\" type=\"submit\" name=\"order\"value=\"Place Order\"><center>");
			out.println("</fieldset>");
			out.println("<input id=\"lat\" type=\"text\" name=\"lat\" hidden>");
			out.println("<input id=\"long\" type=\"text\" name=\"long\" hidden>");
			out.println("</form>");
			out.println("</article> \n"+
				      "</section>");

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

                out.println("<tr  align=\"center\">");

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
out.println("<script type=\"text/javascript\">");
out.println("function onDeliveryClick(){");
			out.println("var address = document.getElementById('address').value;");
			out.println("if(address != null && address != ''){");
				out.println("var geocoder = new google.maps.Geocoder();");
				out.println("geocoder.geocode( { 'address': address}, function(results, status) {");
					out.println("if (status == google.maps.GeocoderStatus.OK) {");
						out.println("var lng = results[0].geometry.location.lng();");
						out.println("var lat = results[0].geometry.location.lat();");
						out.println("document.getElementById('lat').value = lat;");
						out.println("document.getElementById('long').value = lng;");
					out.println("} ");
					out.println("else {");
						out.println("alert(\"Invalid Address\");");
						out.println("document.getElementById('lat').value = 0;");
						out.println("document.getElementById('long').value = 0;");
					out.println("}");
				out.println("});");
			out.println("}");
			out.println("else{");
				out.println("alert(\"Enter address for delivery\");");
				out.println("document.getElementById('pickup').checked = true;");
			out.println("}");
		out.println("}");			
	out.println("</script>");
out.println("</body>");

out.println("</html>");
}
}
}
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
		processRequest(request, response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
		processRequest(request, response);
	}
}



