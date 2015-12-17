package initdata;

import java.io.*;
import javabean.UserAccount;

public class InitialDataUsers
{
   public static void main(String [] args)
   {
UserAccount st1=new UserAccount("customer","abc", "xyz","3210 s state","12345","abc123","xyz123","abc@gmail.com");
UserAccount st2=new UserAccount("customer","def", "lmn","2001 s michigan","67890","def456","lmn456","def@gmail.com");
UserAccount st3=new UserAccount("Manager","Store", "Manager","60 E  michigan","167290","Store","Manager","store@gamespeed.com");
UserAccount st4=new UserAccount("Waiter","Waiter", "Man","35th street","356723","Sales","Man","Waiter@gamespeed.com");
   
      try
      {
         FileOutputStream fileOut =
         new FileOutputStream("user.txt");
         ObjectOutputStream out = new ObjectOutputStream(fileOut);
         out.writeObject(st1);
out.writeObject(st2);
out.writeObject(st3);
out.writeObject(st4);


         out.close();
         fileOut.close();
         System.out.printf("Serialized data is saved in user.txt");
      }catch(IOException i)
      {
          i.printStackTrace();
      }
   }
}