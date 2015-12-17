<html>

<%@ page import= "java.io.*, java.lang.*, java.util.*" %>
<%@ page import="java.util.Arrays, java.util.List, java.util.Set, java.util.Date" %>

<% PrintWriter output = response.getWriter(); %>

    <%
    try{			
		/* if user is not logged in redirect to login page */
		if(session == null || session.getAttribute("name") == null){
			//redirect to login page
			String site = "login.html";
			response.setStatus(response.SC_MOVED_TEMPORARILY);
			response.setHeader("Location", site);
		}
		
		// retreive the cart from the session
		ArrayList<String> myCart = (ArrayList<String>)session.getAttribute("cart");
		
		/* Display cart items*/
		if(myCart != null){
			
			// retreive the clicked item and remove from session
			if(request.getParameter("cannoli") != null)
				myCart.remove("cannoli");
			if(request.getParameter("friedbeefravioli") != null)
				myCart.remove("friedbeefravioli");
			if(request.getParameter("minestronesoup") != null)
				myCart.remove("minestronesoup");
			if(request.getParameter("chickensalad") != null)
				myCart.remove("chickensalad");
			if(request.getParameter("spaghettiwithmeatsauce") != null)
				myCart.remove("spaghettiwithmeatsauce");
			if (request.getParameter("jalapenopoppers")!=null)
				myCart.remove("jalapenopoppers");
			if (request.getParameter("friedcheesemozzarella")!=null)
				myCart.remove("friedcheesemozzarella");
			if (request.getParameter("friedcheesemushrooms")!=null)
				myCart.remove("friedcheesemushrooms");
			if (request.getParameter("spinachsticks")!=null)
				myCart.remove("spinachsticks");
			if (request.getParameter("chickenalfredo")!=null)
				myCart.remove("chickenalfredo");
			if (request.getParameter("mushroomsalad")!=null)
				myCart.remove("mushroomsalad");
			if (request.getParameter("meatloverssalad")!=null)
				myCart.remove("meatloverssalad");
			if (request.getParameter("iceburgsalad")!=null)
				myCart.remove("iceburgsalad");
			if (request.getParameter("spinachsalad")!=null)
				myCart.remove("spinachsalad");
			if (request.getParameter("supremeveggiesalad")!=null)
				myCart.remove("supremeveggiesalad");
			if (request.getParameter("specialmeatsoup")!=null)
				myCart.remove("specialmeatsoup");
			if (request.getParameter("supremechickensoup")!=null)
				myCart.remove("supremechickensoup");
			if (request.getParameter("eggplantsoup")!=null)
				myCart.remove("eggplantsoup");
			if (request.getParameter("chickengarlicsoup")!=null)
				myCart.remove("chickengarlicsoup");
			if (request.getParameter("luigisupremecombo")!=null)
				myCart.remove("luigisupremecombo");
			if (request.getParameter("meatloverspizza")!=null)
				myCart.remove("meatloverspizza");
			if (request.getParameter("hawaiianpizza")!=null)
				myCart.remove("hawaiianpizza");
			if (request.getParameter("garlicloverspizza")!=null)
				myCart.remove("garlicloverspizza");
			if (request.getParameter("chickenoutpizza")!=null)
				myCart.remove("chickenoutpizza");
			if (request.getParameter("seafoodcombopizza")!=null)
				myCart.remove("seafoodcombopizza");
			if (request.getParameter("rigatoniwithmeatsauce")!=null)
				myCart.remove("rigatoniwithmeatsauce");
			if (request.getParameter("ravioliwithmeatballs")!=null)
				myCart.remove("ravioliwithmeatballs");
			if (request.getParameter("linguinialpesto")!=null)
				myCart.remove("linguinialpesto");
			if (request.getParameter("fettuceineseafood")!=null)
				myCart.remove("fettuceineseafood");
			if (request.getParameter("chickenrisotto")!=null)
				myCart.remove("chickenrisotto");
			if (request.getParameter("weichselstrudel")!=null)
				myCart.remove("weichselstrudel");
			if (request.getParameter("cashewsstrudel")!=null)
				myCart.remove("cashewsstrudel");
			if (request.getParameter("plumraisinstrudel")!=null)
				myCart.remove("plumraisinstrudel");
			if (request.getParameter("strawberrystrudel")!=null)
				myCart.remove("strawberrystrudel");
			if (request.getParameter("spinachstrudel")!=null)
				myCart.remove("spinachstrudel");
			if (request.getParameter("pumpkinstrudel")!=null)
				myCart.remove("pumpkinstrudel");
			if (request.getParameter("chocolatecheesecake")!=null)
				myCart.remove("chocolatecheesecake");
			if (request.getParameter("supremegelato")!=null)
				myCart.remove("supremegelato");
			if (request.getParameter("panacotta")!=null)
				myCart.remove("panacotta");
			if (request.getParameter("tiramisu")!=null)
				myCart.remove("tiramisu");
			if (request.getParameter("cappuccinomoussecake")!=null)
				myCart.remove("cappuccinomoussecake");
			if (request.getParameter("limoncello")!=null)
				myCart.remove("limoncello");
			if (request.getParameter("maraschino")!=null)
				myCart.remove("maraschino");
			if (request.getParameter("cinzano")!=null)
				myCart.remove("cinzano");
			if (request.getParameter("prosecco")!=null)
				myCart.remove("prosecco");
			if (request.getParameter("montgomery")!=null)
				myCart.remove("montgomery");
			if (request.getParameter("garibaldi")!=null)
				myCart.remove("garibaldi");
			if (request.getParameter("giftcard10")!=null)
				myCart.remove("giftcard10");
			if (request.getParameter("giftcard25")!=null)
				myCart.remove("giftcard25");
			if (request.getParameter("giftcard50")!=null)
				myCart.remove("giftcard50");
			if (request.getParameter("giftcard100")!=null)
				myCart.remove("giftcard100");
						
			/*Place the shopping cart inside the session*/
			synchronized (session) {  // synchronized to prevent concurrent updates
				session.setAttribute("cart", myCart);
			}
			
			//Redirect to mycart page
			output.println("<div style=\"color: white\">Item removed from cart</div>");
			request.getRequestDispatcher("mycart.jsp").include(request, response);

		}else{
			//Redirect to mycart page
			request.getRequestDispatcher("mycart.jsp").include(request, response);
		}			
	}catch(Exception e) {
		e.printStackTrace();
	}
	%>
	