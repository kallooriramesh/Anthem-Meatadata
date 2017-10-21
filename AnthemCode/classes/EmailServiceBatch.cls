global class EmailServiceBatch implements Database.Batchable<sObject>{
    
    public String query;
    public Set<ID> contactIDs;
    public String emailTemplateId;
    public String eventId;    
    global Iterable<sObject> start(Database.BatchableContext BC){
        
        query = 'Select ID,Email,Name,Accountid from Contact where ID IN :contactIDs';
        System.debug('query'+query);
        //System.debug('result'+Database.query(query));
        return Database.query(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        String [] toEmailIds=new List<String>();
        List<EventApi__Attendee__c> attendees = new List<EventApi__Attendee__c>();
        for(Contact c : scope){
            toEmailIds.add(c.Email); 
        }
        System.debug('toEmailIds'+toEmailIds);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = toEmailIds; 
        //message.optOutPolicy = 'FILTER';
        //message.subject = 'Opt Out Test Message';
        //message.plainTextBody = 'This is the message body.';
        message.TemplateId = emailTemplateId;
        message.setTreatTargetObjectAsRecipient(false);
        Contact conId=scope[0];
        message.settargetObjectId(conId.Id); 
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        for(Messaging.SendEmailResult result :results)
        {
            if (result.success) 
            {
                // attendees creatation
                
                System.debug('The email was sent successfully.');
                
                for(Contact con : scope){           
                    EventApi__Attendee__c attendee = new EventApi__Attendee__c();
                    attendee.EventApi__Full_Name__c=con.Name;
                    attendee.EventApi__Event__c=eventId ;
                    attendee.EventApi__Email__c=con.email;
                    attendee.EventApi__Preferred_Email__c=con.Email;
                    attendee.EventApi__Account__c=con.accountid;
                    attendee.EventApi__Invitation_Status__c='Invited';
                    //attendee.EventApi__Registration_Site_Url__c=    need to discuss
                    attendee.EventApi__Send_Invitation_Email__c=true;
                    attendee.EventApi__Send_Notification__c=true;
                    attendees.add(attendee);
                }
                
            } else 
            {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            } 
        }
        Insert attendees;
    }
    
    global void finish(Database.BatchableContext BC){
    }
}