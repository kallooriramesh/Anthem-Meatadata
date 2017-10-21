public with sharing class Contact_Controller{
    
    public list<contact> con{get;set;}
    public contact con1;
    public string response{get;set;}
    public boolean show{get;set;}
    public string eventname{get;set;}
    
 public Contact_Controller(Apexpages.StandardsetController Controller)
 {
       this.con1=(contact)controller.getRecord(); 
        show=false;
 }
    
    public void send()
    {
        
        show=true;
    }
    
}