package javabean;

public class ItemOrder {
  private FoodItem item;
  private int numItems;

  public ItemOrder(FoodItem item) {
    setItem(item);
    setNumItems(1);
  }

  public FoodItem getItem() {
    return(item);
  }

  protected void setItem(FoodItem item) {
    this.item = item;
  }

  public String getFoodName() {
    return(getItem().getFoodName());
  }

  public String getDescription() {
    return(getItem().getDescription());
  }

  public int getUnitCost() {
    return(getItem().getCost());
  }

  public int getNumItems() {
    return(numItems);
  }

  public void setNumItems(int n) {
    this.numItems = n;
  }

  public void incrementNumItems() {
    setNumItems(getNumItems() + 1);
  }

  public void cancelOrder() {
    setNumItems(0);
  }

  public int getTotalCost() {
    return(getNumItems() * getUnitCost());
  }
}
