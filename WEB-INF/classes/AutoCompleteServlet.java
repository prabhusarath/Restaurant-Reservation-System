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
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import java.util.*;
import java.text.*;
import javabean.*;
import java.io.IOException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;

import java.util.HashMap;
import java.util.*;
import java.util.Iterator;
import java.io.*;
/**
 *
 * @author nbuser
 */
public class AutoCompleteServlet extends HttpServlet {

    private ServletContext context;
    String targetId=null;	

    @Override
    public void init(ServletConfig config) throws ServletException {
        this.context = config.getServletContext();
	    }

    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
	try{	
	String path = context.getRealPath("/WEB-INF/classes/product.txt");
	/*HttpSession session = request.getSession();
	String loggedInUser=(String)session.getAttribute("userLogged");
	String userRole=null;
	userRole=(String)session.getAttribute("userRole");
	if(userRole==null){
		userRole="Guest";
	}*/
	FoodItem e = null;
	  HashMap<String, FoodItem>map = new HashMap<String, FoodItem>();
	  FileInputStream fileIn =null;
	  ObjectInputStream in =null;
      try
      {
          fileIn = new FileInputStream(path);
          in = new ObjectInputStream(fileIn);
		e=(FoodItem)in.readObject();
		 while(e!=null){
		
			 map.put(e.getFoodName(),e);
			e=(FoodItem)in.readObject();
				
			}
		 }
		
        catch(IOException i)
      {
        
      }catch(ClassNotFoundException c)
      {
         System.out.println("Employee class not found");
         c.printStackTrace();
         return;
      } finally{
		  in.close();
         fileIn.close();
	  }

        String action = request.getParameter("action");
         targetId = request.getParameter("id");

        StringBuffer sb = new StringBuffer();

	if (targetId != null) {
            targetId = targetId.trim().toLowerCase();
        } else {
            context.getRequestDispatcher("/error").forward(request, response);
        }

        boolean namesAdded = false;
        if (action.equals("complete")) {

            if (!targetId.equals("")) {

                Iterator it = map.entrySet().iterator();

		
               while (it.hasNext()) {
                    Map.Entry pi = (Map.Entry)it.next();
		
			FoodItem item=(FoodItem)pi.getValue();
		
                   
                    if ( item.getFoodName().toLowerCase().startsWith(targetId) ||
						 item.getDescription().toLowerCase().startsWith(targetId)||
						 item.getCategory().toLowerCase().concat(" ")
                            .concat(item.getCategory().toLowerCase()).startsWith(targetId)) {
	
                        sb.append("<item>");
                        sb.append("<id>" + item.getId() + "</id>");
                        sb.append("<foodName>" + item.getFoodName() + "</foodName>");
                        sb.append("<foodCategory>" + item.getCategory() + "</foodCategory>");
                        sb.append("</item>");
                        namesAdded = true;
                    }
			
                }
            }

           if (namesAdded) {
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write("<items>" + sb.toString() + "</items>");
            } else {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
            }
        }

        if (action.equals("lookup")) {
		
	  if ((targetId != null) && map.containsKey(targetId.toUpperCase().trim())) {
		

		request.setAttribute("FoodDetails",map.get(targetId.toUpperCase().trim()));
               		
		RequestDispatcher rd=context.getRequestDispatcher("/ProductData");
			rd.forward(request,response);
		}
          }
	}
	catch(Exception e)
	{
	}
    }
}
