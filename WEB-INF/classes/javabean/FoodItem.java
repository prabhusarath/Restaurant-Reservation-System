package javabean;

public class FoodItem implements java.io.Serializable{
  public static int temp=0;
  private int id;
  private String foodName;
  private String description;
  private int cost;
  private String category;


  public FoodItem(String foodName, String description,int cost, String category) {
	temp++;
	setId();
    setFoodName(foodName);
    setDescription(description);
    setCost(cost);
    setCategory(category);
    
  }
public int getId() {
	
    return(id);
  }

  protected void setId() {
	 
    this.id =temp;
	System.out.println("Id "+this.id);
  }
  public String getFoodName() {
    return(foodName);
  }

  protected void setFoodName(String foodName) {
    this.foodName = foodName;
  }

  public String getDescription() {
    return(description);
  }

  protected void setDescription(String description) {
    this.description = description;
  }

  

  public int getCost() {
    return(cost);
  }

  protected void setCost(int cost) {
    this.cost = cost;
  }
public String getCategory() {
    return(category);
  }

  protected void setCategory(String category) {
    this.category = category;
  }

}
