import java.io.*;
import javax.servlet.http.*;
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

public class SubmitFeedBack extends HttpServlet {

	private static final long serialVersionUID = 1L;
	MongoClient mongo;

	public void init() throws ServletException{
      	// Connect to Mongo DB
		mongo = new MongoClient("localhost", 27017);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			HttpSession session = request.getSession();
		try{
			//Get the values from the form
			String firstName = request.getParameter("firstName");
			String lastName = request.getParameter("lastName");
			
			String address = request.getParameter("address");
			String phoneNo = request.getParameter("phoneNo");
			
			String userName=request.getParameter("userName");
			String eMail=request.getParameter("eMail");
			String feedText=request.getParameter("feedText");
			String message="Thank you for submitting your FeedBack";
			// If database doesn't exists, MongoDB will create it for you
			DB db = mongo.getDB("ItalianBistro");

			// If the collection does not exists, MongoDB will create it for you
			DBCollection feedback = db.getCollection("feedback");
			

			BasicDBObject doc = new BasicDBObject("title", "feedback").
				append("firstName", firstName).
				append("lastName",lastName).
				append("address",address).
				append("phoneNo",phoneNo).
				append("userName",userName).
				append("eMail", eMail).
				append("feedText",feedText);
				

			feedback.insert(doc);
			session.setAttribute("message",message);
			request.getRequestDispatcher(response.encodeURL("/FeedBack")).forward(request, response);
			

		} catch (MongoException e) {
			e.printStackTrace();
		}
	}

	public void destroy()	{
      // do nothing.
	}

}