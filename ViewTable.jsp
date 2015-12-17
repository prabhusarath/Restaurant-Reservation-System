<!doctype html>

<!-- INDEX http://localhost/csj/MainOrderPage -->
<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Italian Bistro </title>
	<link rel="stylesheet" href="css/styles.css" type="text/css" />
    
</head>



<body style="background-image:url(images/1.jpg)">
     
        <div class="container">

        <div id="container">

            <header>

                <img class="header-image1" src="images/i.png" width = "50%" height = "50%" alt="Index Page Image" />
				<ul>
<%String loggedInUser=(String)session.getAttribute("userLogged");
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
		    
             <center>		
			 <form method="post" action="ViewReservations.jsp">
                 <h3 style="font-size: 200%"> View Reservations</h3>	
                 <table align="center">				                             
					<tr><td width="50%"><h4 style="font-size: 110%;"> Booking name: </h4></td><td><input type="text" name="bookingName"></td></tr> 
					<tr><td width="50%"><h4 style="font-size: 110%;"> Contact Number: </h4></td><td><input type="text" name="contact1"></td></tr> 
                    <tr><td> <h6 style="color:#ff0000;">(enter the booking name and contact number you gave while reserving, when you want to view all your reservations)</h6></td></tr>	
                    <tr><td colspan='2' align='center'><h4 style="font-size: 110%;">OR</h4></td></tr>                    					
					<tr><td><h4 style="font-size: 110%;"> Booking ID: </h4></td><td><input type="text" name="bookingID"></td></tr> 
					<tr><td width="50%"><h4 style="font-size: 110%;"> Contact Number: </h4></td><td><input type="text" name="contact2"></td></tr> 
                    <tr><td> <h6 style="color:#ff0000;">(enter Booking ID and contact number you gave while reserving, when you want to view a particular reservation)</h6></td></tr>                    					
	            </table>			
                    <center><input type="submit" value="View Reservation Details" name="view_reservation"></center>				
			 </form>
			 <br><br>
								 <a href='DineIn.jsp'> <input type='submit' value='Go to Dine In Page'> </a></center>
             </center>   
            
        </article>
        </section>
        <article class="expanded">

            <h2></h2>
            
        </article>
    </section>

</article class="expanded">
        
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
                        <li><a href="WriteReviews.jsp" title="premium templates">Write Reviews</a></li>
                        <li><a href="ViewReviews.jsp" title="web hosting"> View Reviews </a></li>
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
                    <p>Copyright &copy; 2015 Italian Bistro. All Rights Reserved.</p>
            
            
        </div>
		
    </footer>
</div>
  </div>

</body>

</html>