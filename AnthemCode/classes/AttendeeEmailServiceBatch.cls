global class AttendeeEmailServiceBatch implements Database.Batchable<sObject>{
    public String query;
    public String emailTemplateId;
    public String eventId;    
    global Iterable<sObject> start(Database.BatchableContext BC){
        
        query = 'Select ID,EventApi__Preferred_Email__c,Name from EventApi__Attendee__c where EventApi__Event__c=:eventId AND EventApi__Is_Registered__c=:TRUE';
        System.debug('query'+query);
        System.debug('result'+Database.query(query));
        return Database.query(query);
    }
    
    global void execute(Database.BatchableContext BC, List<EventApi__Attendee__c> scope){
        String [] toEmailIds=new List<String>();
        List<EventApi__Attendee__c> attendees = new List<EventApi__Attendee__c>();
        for(EventApi__Attendee__c c : scope){
            toEmailIds.add(c.EventApi__Preferred_Email__c); 
        }
        System.debug('toEmailIds'+toEmailIds);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = toEmailIds; 
      
        message.TemplateId = emailTemplateId;
        message.setTreatTargetObjectAsRecipient(false);
        Contact conId=[Select ID,Name from Contact Limit 1];
        message.settargetObjectId(conId.Id); 
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        for(Messaging.SendEmailResult result :results)
        {
            if (result.success) 
            {
                for(EventApi__Attendee__c attendee : scope){           
                    attendee.Is_Reminder_Email_Sent__c=TRUE;
                    attendee.Reminder_Email_Sent_On__c=SYSTEM.now();
                }
                
                System.debug('The email was sent successfully.');
            }
            else 
            {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            } 
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext BC){
    }
}