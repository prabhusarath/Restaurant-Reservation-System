package computation;

import java.io.*;
import javabean.FoodItem;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;

public class ProductIO{
	public  static void deleteProduct(String foodName, String path) {
		HashMap<String,FoodItem> map;
		map=readProduct(path);
		map.remove(foodName);
		writeProduct(map,path);
	}
	public  static void updateProduct(FoodItem item,String foodName, String path) {
		HashMap<String,FoodItem> map;
		map=readProduct(path);
		map.remove(foodName);
		map.put(item.getFoodName(),item);
		writeProduct(map,path);
	}
	public  static void addProduct(FoodItem item,String foodName, String path) {
		HashMap<String,FoodItem> map;
		map=readProduct(path);
		map.put(item.getFoodName(),item);
		writeProduct(map,path);
	}
	public static HashMap<String,FoodItem> readProduct(String path){
		System.out.println("inside delete product"+path);
		FoodItem e = null;
	  HashMap<String, FoodItem>map = new HashMap<String, FoodItem>();
	  FileInputStream fileIn =null;
	  ObjectInputStream in =null;
	  try{
          fileIn = new FileInputStream(path);
          in = new ObjectInputStream(fileIn);
		e=(FoodItem)in.readObject();
		 while(e!=null){
			System.out.println("inside while");
			 map.put(e.getFoodName(),e);
			e=(FoodItem)in.readObject();
			System.out.println("inside while"+e.getFoodName());	
			}
			
			 in.close();
         fileIn.close();
		 
	  } catch(IOException i)
      {
        
      }finally{
	  return map;
	  }
	}
	public static void writeProduct(HashMap<String,FoodItem> map, String path){
		FileOutputStream fileOut=null;
	  ObjectOutputStream out=null;
		
			try{
		 fileOut = new FileOutputStream(path);
         out = new ObjectOutputStream(fileOut);
		 Iterator itd=map.entrySet().iterator();

		FoodItem item=null;
		while(itd.hasNext()){
			System.out.println("Inside iterator");
			Map.Entry it= (Map.Entry)itd.next();

			item = (FoodItem)it.getValue();
			out.writeObject(item);
		 }
		
		 out.close();
         fileOut.close();
			}catch(IOException i)
      {
        
      }
		
	}
}