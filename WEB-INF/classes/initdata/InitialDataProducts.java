package initdata;

import java.io.*;
import javabean.FoodItem;

public class InitialDataProducts
{
   public static void main(String [] args)
   {
FoodItem st1=new FoodItem("FRIEDBEEF RAVIOLI", "RAVIOLI CLASSIC COMBINATION",12,"Appetizers");
FoodItem st2=new FoodItem("JALAPENO POPPERS","JALAPENO SPRINKLERS",13,"Appetizers");
FoodItem st3=new FoodItem("FRIEDCHEESE MOZZARELLA", "FRIEDCHEESE SPECIAL",10,"Appetizers");
FoodItem st4=new FoodItem("SPINACH STICKS", "SPINACH LOVERS SPECIAL",6,"Appetizers");

FoodItem st13=new FoodItem("CHICKEN SALAD", "CHIKEN LOVERS SPECIAL",9,"Salads");
FoodItem st14=new FoodItem("MUSHROOM SALAD", "VEGGIES SPECIAL",10,"Salads");
FoodItem st15=new FoodItem("MEATLOVERS SALAD", "MEAT CHEF SPECIAL",7,"Salads");
FoodItem st16=new FoodItem("ICEBURG SALAD","ICEBURG WITH RANCH",15,"Salads");

FoodItem st17=new FoodItem("SUPREME GREENS", "SUPREME VEGGIES",9,"Soups");
FoodItem st18=new FoodItem("SPECIALMEAT SOUP", "SPECIALMEAT CHEF SPECIAL",10,"Soups");
FoodItem st19=new FoodItem("MINESTRONE SOUP", "MINESTRONE POPPERS",7,"Soups");
FoodItem st20=new FoodItem("SUPREME CHICKEN SOUP","SUPREME CLASSIC",15,"Soups");

FoodItem st21=new FoodItem("LUIGISUPREME COMBO", "SUPREME VEGGIE TOPPERS",9,"Pizzas");
FoodItem st22=new FoodItem("MEATLOVERS", "MEAT LOVERS SPECIAL",10,"Pizzas");
FoodItem st23=new FoodItem("HAWAIIAN PIZZA", "HAWAII SPECIAL",7,"Pizzas");
FoodItem st24=new FoodItem("GARLICLOVERS","GARLIC SPECIALS",15,"Pizzas"); 

FoodItem st25=new FoodItem("SPAGHETTI WITH MEAT SAUCE", "MEAT SAUCE CHEF SPECIAL",9,"Pastas");
FoodItem st26=new FoodItem("RIGATONI WITH MEAT SAUCE", "MEAT SAUCE MIXTURE",10,"Pastas");
FoodItem st27=new FoodItem("RAVIOLO WITH MEAT BALLS", "SUPREME MEAT BALLS",7,"Pastas");
FoodItem st28=new FoodItem("LINGUINI AL PESTO","CLASSIC LINGUINI",15,"Pastas"); 

FoodItem st29=new FoodItem("WEICHSEL STRUDEL", "WEICHSEL CLASSICS",9,"Strudels");
FoodItem st30=new FoodItem("CASHEWS STRUDEL", "SUPREME CASHEWS",10,"Strudels");
FoodItem st31=new FoodItem("PLUM&RAISIN STRUDEL", "SWEET CANDY SPECIAL",7,"Strudels");
FoodItem st32=new FoodItem("STRAWBERRY STRUDEL","RESTUARANTS SPECIAL",15,"Strudels");   

FoodItem st9=new FoodItem("CHOCLATE CHEESECAKE", " DEATH BY CHOCLATE",9,"Desserts");
FoodItem st10=new FoodItem("TIRAMISU", " SWEET IN A BOWL",10,"Desserts");
FoodItem st11=new FoodItem("PANACOTTA", "CREAMY PANACOTTA",7,"Desserts");
FoodItem st12=new FoodItem("CANNOLI","CANNOLI PIE",15,"Desserts");

FoodItem st5=new FoodItem("LIMONCELLO", "LIMONCELLO - DIET",7,"Beverages");
FoodItem st6=new FoodItem("MARASCHINO", "MARASCHINO - COCKTAILS",10,"Beverages");
FoodItem st7=new FoodItem("CINZANO", "CINZANO - MOCKTAILS",5,"Beverages");
FoodItem st8=new FoodItem("PROSECCO", "PROSECCO SUPREME",6,"Beverages");

FoodItem st33=new FoodItem("ChickenVesuvio", "Christmas Special",7,"SpecialMenu");
FoodItem st34=new FoodItem("ChickenMarsala", "Christmas Special",10,"SpecialMenu");
FoodItem st35=new FoodItem("Panettone", "Christmas Special",5,"SpecialMenu");
FoodItem st36=new FoodItem("Struffoli", "Christmas Special",6,"SpecialMenu");

FoodItem st37=new FoodItem("$10", "Giftcard for $10",10,"GiftCard");
FoodItem st38=new FoodItem("$25", "Giftcard for $25",25,"GiftCard");
FoodItem st39=new FoodItem("$50", "Giftcard for $50",50,"GiftCard");
FoodItem st40=new FoodItem("$100", "Giftcard for $100",100,"GiftCard");
      try
      {
         FileOutputStream fileOut =
         new FileOutputStream("product.txt");
         ObjectOutputStream out = new ObjectOutputStream(fileOut);
         out.writeObject(st1);
         out.writeObject(st2);
         out.writeObject(st3);
         out.writeObject(st4);
         out.writeObject(st5);
         out.writeObject(st6);
         out.writeObject(st7);
         out.writeObject(st8);
         out.writeObject(st9);
         out.writeObject(st10);
         out.writeObject(st11);
         out.writeObject(st12);
         out.writeObject(st13);
         out.writeObject(st14);
         out.writeObject(st15);
         out.writeObject(st16);
         out.writeObject(st17);
         out.writeObject(st18);
         out.writeObject(st19);
         out.writeObject(st20);
         out.writeObject(st21);
         out.writeObject(st22);
         out.writeObject(st23);
         out.writeObject(st24);
         out.writeObject(st25);
         out.writeObject(st26);
         out.writeObject(st27);
         out.writeObject(st28);
         out.writeObject(st29);
         out.writeObject(st30);
         out.writeObject(st31);
         out.writeObject(st32);
		 out.writeObject(st33);
		 out.writeObject(st34);
		 out.writeObject(st35);
		 out.writeObject(st36);
		 out.writeObject(st37);
		 out.writeObject(st38);
		 out.writeObject(st39);
		 out.writeObject(st40);

         out.close();
         fileOut.close();
         System.out.printf("Serialized data is saved in product.txt");
      }catch(IOException i)
      {
          i.printStackTrace();
      }
   }
}