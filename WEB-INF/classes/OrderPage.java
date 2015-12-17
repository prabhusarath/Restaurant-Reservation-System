import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.text.*;
import javabean.*;
import computation.*;


public class OrderPage extends HttpServlet {
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws ServletException, IOException {
		  ServletContext sc = this.getServletContext();
String path = sc.getRealPath("/WEB-INF/classes/product.txt");
		HttpSession session = request.getSession();
		String loggedInUser=(String)session.getAttribute("userLogged");
	String userRole=null;
	userRole=(String)session.getAttribute("userRole");
	if(userRole==null){
		userRole="Guest";
	}
    
ShoppingCart cart;
    synchronized(session) {
      cart = (ShoppingCart)session.getAttribute("shoppingCart");

      if (cart == null) {
        cart = new ShoppingCart();
        session.setAttribute("shoppingCart", cart);
      }

HashMap<String, FoodItem>map=ProductIO.readProduct(path);

String itemID = request.getParameter("itemID");
System.out.println("itemId is ----------"+itemID);
FoodItem itemObj;

if (itemID != null) {
itemObj=map.get(itemID);

        String numItemsString =request.getParameter("numItems");
        if (numItemsString == null) {
             cart.addItem(itemObj);
        } else {
             int numItems;
          try {
            numItems = Integer.parseInt(numItemsString);
          } catch(NumberFormatException nfe) {
            numItems = 1;
          }
		cart.setNumOrdered(itemObj, numItems);
        }
      }
}
    // Whether or not the customer changed the order, show
    // order status.
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

		synchronized(session) {
      List itemsOrdered = cart.getItemsOrdered();
      if (itemsOrdered.size() == 0) {
        out.println("<H2><I>No items in your cart...</I></H2>");
      }
      else {
        // If there is at least one item in cart, show table
        // of items ordered.
        out.println
          ("<TABLE style=\"border:1;\"><TR>\n" +
           "  <TH>Food<TH>Description\n" +
           "  <TH>Cost<TH colspan=\"2\">Quantity<TH>Total Cost<TH>Delete?");
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
          out.println
            ("<TR>\n" +
             "  <TD>" + order.getFoodName() + "</TD>\n" +
             "  <TD>" + order.getDescription() + "</TD>\n" +
             "  <TD>" +
            order.getUnitCost() + "</TD>\n" +
             "  <TD>" +
             "<FORM method = \"get\" action = \"\">\n" +  // Submit to current URL
             "<INPUT TYPE=\"HIDDEN\" NAME=\"itemID\"\n" +
             "       VALUE=\"" + order.getFoodName() + "\">\n" +
             "<INPUT TYPE=\"TEXT\" NAME=\"numItems\"\n" +
             "       SIZE=3 VALUE=\"" +
             order.getNumItems() + "\"></TD>\n" +
             "<TD><SMALL>\n" +
             "<INPUT  size=8 TYPE=\"SUBMIT\"\n "+
             "       VALUE=\"Update\">\n" +
             "</SMALL>\n" +
             "</FORM>\n" +
             " </TD><TD>" +
             order.getTotalCost()+"</TD>"+
              "  <TD>" +
              "<FORM method = \"get\" action = \"/ItalianBistro/DeleteCartItem\">\n" +  // Submit to current URL
             "<INPUT TYPE=\"HIDDEN\" NAME=\"deleteID\"\n" +
             "       VALUE=\"" + order.getFoodName() + "\">\n" +
             "<INPUT class = \"submit-button-link\" TYPE=\"submit\" NAME=\"delete\"\n" +
             "       VALUE=\"delete\"></form></TD></tr>");
        }
        String checkoutURL =
          response.encodeURL("/ItalianBistro/Buy");

        // "Proceed to Checkout" button below table
        out.println
          ("</TABLE>\n" +
           "<br><br><FORM ACTION=\"" + checkoutURL + "\">\n" +
           "<BIG><CENTER>\n" +
           "<INPUT class = \"submit-button-link\" TYPE=\"SUBMIT\"\n" +
           "       VALUE=\"Checkout\">\n" +

           "</CENTER></BIG></FORM>\n"+
           "<FORM ACTION=\"/ItalianBistro/index.jsp\">\n" +
		   "<BIG><CENTER>\n" +
           "<INPUT class = \"submit-button-link\" TYPE=\"SUBMIT\"\n" +
           "       name=\"continue\" VALUE=\"Continue Shopping\"></CENTER></BIG></form>");
      }
      out.println("</article> \n"+
	      "</section> \n");

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
}
