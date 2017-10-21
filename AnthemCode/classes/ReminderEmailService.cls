global class ReminderEmailService {
    @InvocableMethod
    public static void getAccountIds(List<String> eventIds) {
        EmailServiceBatch emailService = new EmailServiceBatch();
        emailService.eventId=eventIds[0];
        emailService.emailTemplateId = [Select ID from EmailTemplate
                                        WHERE ID=:[Select Reminder_Template_ID__c from Event_Templates__c 
                                                   WHERE Event__c=:eventIds[0]].Reminder_Template_ID__c].ID;
        
        Database.executeBatch(emailService, 100);
        //return accountIds;
    }
}