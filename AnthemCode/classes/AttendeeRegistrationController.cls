public class AttendeeRegistrationController{
    Public String Attendeeid{get;set;}
    public EventApi__Event__c evnt{get;set;}
    public EventApi__Attendee__c attnde{get;set;}
    Public AttendeeRegistrationController(Apexpages.StandardController Controller)
    {
    try{
        Attendeeid=apexpages.currentPage().getparameters().get('id');
        if(Attendeeid !=null)
        {
            attnde=[select id,name,EventApi__Preferred_Email__c, EventApi__Status__c,Title__c,Forwarded_Invite__c,State__c,City__c,Practice_Name__c,Ischecked__c,EventApi__Full_Name__c,EventApi__Event__c from EventApi__Attendee__c where id=:Attendeeid];   
            // this.attnde=(EventApi__Attendee__c)Controller.getRecord();
                           attnde.Ischecked__c=true;
 
        }
        
        if(attnde.EventApi__Event__c !=null)
        {
            evnt=[select id,name,EventApi__Attendees__c,EventApi__Start_Date__c,EventApi__End_Date__c,EventApi__Speakers_HTML__c  from EventApi__Event__c where id=:attnde.EventApi__Event__c ]; 

        }
        }catch(Exception e){}
        
    }
    
    public void save()
    {
        try
        {          
            attnde.EventApi__Registration_Date__c=system.today();
            attnde.EventApi__Status__c='Registered';
            update attnde;
        }
        
        catch(exception e)
        {
            ApexPages.addMessages(e);
        }
    }
    
    
}