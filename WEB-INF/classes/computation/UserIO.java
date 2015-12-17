package computation;

import java.io.*;
import javabean.UserAccount;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;

public class UserIO
{
    public  static void addUser(UserAccount user,String userName, String path) {
		HashMap<String,UserAccount> map;
		map=readUser(path);
		map.put(user.getUserName(),user);
		writeUser(map,path);
	}
	public static HashMap<String,UserAccount> readUser(String path){
		
		UserAccount e = null;
	  HashMap<String, UserAccount>map = new HashMap<String, UserAccount>();
	  FileInputStream fileIn =null;
	  ObjectInputStream in =null;
	  try{
          fileIn = new FileInputStream(path);
          in = new ObjectInputStream(fileIn);
		e=(UserAccount)in.readObject();
		 while(e!=null){
			
			 map.put(e.getUserName(),e);
			e=(UserAccount)in.readObject();
			
			}
			
			 in.close();
         fileIn.close();
		 
	  } catch(IOException i)
      {
        
      }finally{
	  return map;
	  }
	}
	public static void writeUser(HashMap<String,UserAccount> map, String path){
		FileOutputStream fileOut=null;
	  ObjectOutputStream out=null;
		
			try{
		 fileOut = new FileOutputStream(path);
         out = new ObjectOutputStream(fileOut);
		 Iterator itd=map.entrySet().iterator();

		UserAccount e=null;
		while(itd.hasNext()){
			
			Map.Entry it= (Map.Entry)itd.next();

			e = (UserAccount)it.getValue();
			out.writeObject(e);
		 }
		
		 out.close();
         fileOut.close();
			}catch(IOException i)
      {
        
      }
}
}
