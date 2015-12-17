<html>

<%@ page import= "java.io.*, java.lang.*, java.util.*" %>
<%@ page import="java.util.Arrays, java.util.List, java.util.Set, java.util.Date" %>

	<% PrintWriter output = response.getWriter(); %>
	<%
		try{
			
			// Retrieve the current session		
			// if user is not logged in redirect to login page
			if(session == null || session.getAttribute("name") == null){
				// redirect to login page
				String site = "login.html";
			    response.setStatus(response.SC_MOVED_TEMPORARILY);
                response.setHeader("Location", site);
			}
			
			// retreive the cart from the session
			ArrayList<String> myCart = (ArrayList<String>)session.getAttribute("cart");
			
			// Allocate a shopping cart (assume to be a list of String)
			if(myCart == null){
				myCart = new ArrayList<String>();
			}
		  
			// Populate the shopping cart
			if(request.getParameter("cannoli") != null)
				myCart.add("cannoli");   
			if (request.getParameter("friedbeefravioli")!=null)
				myCart.add("friedbeefravioli");
			if (request.getParameter("chickensalad")!=null)
				myCart.add("chickensalad");
			if (request.getParameter("minestronesoup")!=null)
				myCart.add("minestronesoup");
			if (request.getParameter("spaghettiwithmeatsauce")!=null)
				myCart.add("spaghettiwithmeatsauce");
			if (request.getParameter("jalapenopoppers")!=null)
				myCart.add("jalapenopoppers");
			if (request.getParameter("friedcheesemozzarella")!=null)
				myCart.add("friedcheesemozzarella");
			if (request.getParameter("friedcheesemushrooms")!=null)
				myCart.add("friedcheesemushrooms");
			if (request.getParameter("spinachsticks")!=null)
				myCart.add("spinachsticks");
			if (request.getParameter("chickenalfredo")!=null)
				myCart.add("chickenalfredo");
			if (request.getParameter("mushroomsalad")!=null)
				myCart.add("mushroomsalad");
			if (request.getParameter("meatloverssalad")!=null)
				myCart.add("meatloverssalad");
			if (request.getParameter("iceburgsalad")!=null)
				myCart.add("iceburgsalad");
			if (request.getParameter("spinachsalad")!=null)
				myCart.add("spinachsalad");
			if (request.getParameter("supremeveggiesalad")!=null)
				myCart.add("supremeveggiesalad");
			if (request.getParameter("specialmeatsoup")!=null)
				myCart.add("specialmeatsoup");
			if (request.getParameter("supremechickensoup")!=null)
				myCart.add("supremechickensoup");
			if (request.getParameter("eggplantsoup")!=null)
				myCart.add("eggplantsoup");
			if (request.getParameter("chickengarlicsoup")!=null)
				myCart.add("chickengarlicsoup");
			if (request.getParameter("luigisupremecombo")!=null)
				myCart.add("luigisupremecombo");
			if (request.getParameter("meatloverspizza")!=null)
				myCart.add("meatloverspizza");
			if (request.getParameter("hawaiianpizza")!=null)
				myCart.add("hawaiianpizza");
			if (request.getParameter("garlicloverspizza")!=null)
				myCart.add("garlicloverspizza");
			if (request.getParameter("chickenoutpizza")!=null)
				myCart.add("chickenoutpizza");
			if (request.getParameter("seafoodcombopizza")!=null)
				myCart.add("seafoodcombopizza");
			if (request.getParameter("rigatoniwithmeatsauce")!=null)
				myCart.add("rigatoniwithmeatsauce");
			if (request.getParameter("ravioliwithmeatballs")!=null)
				myCart.add("ravioliwithmeatballs");
			if (request.getParameter("linguinialpesto")!=null)
				myCart.add("linguinialpesto");
			if (request.getParameter("fettuceineseafood")!=null)
				myCart.add("fettuceineseafood");
			if (request.getParameter("chickenrisotto")!=null)
				myCart.add("chickenrisotto");
			if (request.getParameter("weichselstrudel")!=null)
				myCart.add("weichselstrudel");
			if (request.getParameter("cashewsstrudel")!=null)
				myCart.add("cashewsstrudel");
			if (request.getParameter("plumraisinstrudel")!=null)
				myCart.add("plumraisinstrudel");
			if (request.getParameter("strawberrystrudel")!=null)
				myCart.add("strawberrystrudel");
			if (request.getParameter("spinachstrudel")!=null)
				myCart.add("spinachstrudel");
			if (request.getParameter("pumpkinstrudel")!=null)
				myCart.add("pumpkinstrudel");
			if (request.getParameter("chocolatecheesecake")!=null)
				myCart.add("chocolatecheesecake");
			if (request.getParameter("supremegelato")!=null)
				myCart.add("supremegelato");
			if (request.getParameter("panacotta")!=null)
				myCart.add("panacotta");
			if (request.getParameter("tiramisu")!=null)
				myCart.add("tiramisu");
			if (request.getParameter("cappuccinomoussecake")!=null)
				myCart.add("cappuccinomoussecake");
			if (request.getParameter("limoncello")!=null)
				myCart.add("limoncello");
			if (request.getParameter("maraschino")!=null)
				myCart.add("maraschino");
			if (request.getParameter("cinzano")!=null)
				myCart.add("cinzano");
			if (request.getParameter("prosecco")!=null)
				myCart.add("prosecco");
			if (request.getParameter("montgomery")!=null)
				myCart.add("montgomery");
			if (request.getParameter("garibaldi")!=null)
				myCart.add("garibaldi");
			if (request.getParameter("giftcard10")!=null)
				myCart.add("giftcard10");
			if (request.getParameter("giftcard25")!=null)
				myCart.add("giftcard25");
			if (request.getParameter("giftcard50")!=null)
				myCart.add("giftcard50");
			if (request.getParameter("giftcard100")!=null)
				myCart.add("giftcard100");
			
			
			
			
			

			// Place the shopping cart inside the session
		    synchronized (session) {  
				// synchronized to prevent concurrent updates
				session.setAttribute("cart", myCart);
		    }

			//Redirect onlineorders page
			output.println("<div style=\"color: white;\">Item added to cart</div>");
		    request.getRequestDispatcher("index.html").include(request, response);
				 
		}
			
		catch(Exception e){ 
			e.printStackTrace();
			output.println(e);
		}  
	%>
</html>