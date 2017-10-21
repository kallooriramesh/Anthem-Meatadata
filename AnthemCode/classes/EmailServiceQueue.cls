public class EmailServiceQueue implements Queueable {
    //public List<String> toEmailIds;
    public String [] toEmailIds;
    public String emailTemplateId;
    public String eventId;
    public List<Contact> inviteecotnacts;
    
    public void execute(QueueableContext context) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = toEmailIds; 
        //message.optOutPolicy = 'FILTER';
        //message.subject = 'Opt Out Test Message';
        //message.plainTextBody = 'This is the message body.';
        message.TemplateId = emailTemplateId;
        message.setTreatTargetObjectAsRecipient(false);
        Contact conId=[Select ID,Email from Contact
                       where Id='003f4000005CzrQ'];
        message.settargetObjectId(conId.Id); 
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            // attendeiss creatation
            
            System.debug('The email was sent successfully.');
        } else 
        {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        } 
        
    }
}