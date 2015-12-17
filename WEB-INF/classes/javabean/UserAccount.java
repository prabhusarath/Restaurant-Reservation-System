package javabean;


public class UserAccount implements java.io.Serializable{
private String role;
private String userName;
private String password;
private String emailAddress;
  private String firstName;
  private String lastName;
  private String address;
  private String phoneNo;


  public UserAccount(String role,String firstName,String lastName,
                     String address,String phoneNo,String userName,String password,String emailAddress) {
setRole(role);
    setFirstName(firstName);
    setLastName(lastName);
    setAddress(address);
    setPhoneNo(phoneNo);
setUserName(userName);
setPassword(password);
setEmailAddress(emailAddress);

  }
public String getRole() {
    return(role);
  }

  protected void setRole(String role) {
    this.role = role;
  }


  public String getFirstName() {
    return(firstName);
  }

  protected void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  public String getLastName() {
    return(lastName);
  }

  protected void setLastName(String lastName) {
    this.lastName = lastName;
  }

  public String getAddress() {
    return(address);
  }

  protected void setAddress(String address) {
    this.address = address;
  }

  public String getPhoneNo() {
    return(phoneNo);
  }

  protected void setPhoneNo(String phoneNo) {
    this.phoneNo = phoneNo;
  }
public String getEmailAddress(){
return(emailAddress);
}
protected void setEmailAddress(String emailAddress){
this.emailAddress=emailAddress;
}
public String getUserName(){
return(userName);
}
protected void setUserName(String userName){
this.userName=userName;
}
public String getPassword(){
return(password);
}
protected void setPassword(String password){
this.password=password;
}

}
