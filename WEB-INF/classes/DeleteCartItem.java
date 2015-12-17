

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.text.*;
import javabean.*;

/** Shows all items currently in ShoppingCart. Clients
 *  have their own session that keeps track of which
 *  ShoppingCart is theirs. If this is their first visit
 *  to the order page, a new shopping cart is created.
 *  Usually, people come to this page by way of a page
 *  showing catalog entries, so this page adds an additional
 *  item to the shopping cart. But users can also
 *  bookmark this page, access it from their history list,
 *  or be sent back to it by clicking on the "Update Order"
 *  button after changing the number of items ordered.
 *  <P>
 *  Taken from Core Servlets and JavaServer Pages 2nd Edition
 *  from Prentice Hall and Sun Microsystems Press,
 *  http://www.coreservlets.com/.
 *  &copy; 2003 Marty Hall; may be freely used or adapted.
 */

public class DeleteCartItem extends HttpServlet {
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws ServletException, IOException {
    HttpSession session = request.getSession();

    ShoppingCart cart;
   
      cart = (ShoppingCart)session.getAttribute("shoppingCart");

   System.out.println("Before getParameter");
		   	String strDelete=request.getParameter("delete");
		   	System.out.println("After getParameter"+strDelete);
		   	if(strDelete!=null){
		   		System.out.println("In if "+strDelete);
		   		String itemDelete=request.getParameter("deleteID");
		   		List itemsOrdered = cart.getItemsOrdered();
		   		ItemOrder order;
		   		for(int i=0; i<itemsOrdered.size(); i++) {
System.out.println("In for "+itemDelete);
		          order = (ItemOrder)itemsOrdered.get(i);
		          if((order.getFoodName()).equals(itemDelete)){
System.out.println("In if "+order.getFoodName());
		   		cart.getItemsOrdered().remove(order);
System.out.println("After remove");

session.setAttribute("shoppingCart", cart);

response.sendRedirect(response.encodeRedirectURL("/ItalianBistro/OrderPage"));
	
}
}
}
}
}   