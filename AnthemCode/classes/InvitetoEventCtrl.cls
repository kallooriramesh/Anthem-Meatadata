public class InvitetoEventCtrl {
    public EventApi__Event__c evnt{get;set;}
    public Integer selectedContactsCount{get;set;}
    public String selectedTemplate{get;set;}
    public String selectedEvent{get;set;}
    public List<Contact> listViewContacts{get;set;}
    public EmailServiceBatch emailService;
    public Set<ID> contactIDs;
    public List<SelectOption> getEvents() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('null', ' - Select - '));
        for(EventApi__Event__c ev:[SELECT ID,Name,EventApi__Status__c from EventApi__Event__c where EventApi__Status__c !='Closed' ORDER BY NAME])
        {
            options.add(new SelectOption(ev.Id,ev.Name));
        }
        
        
        return options;
    }
    
    
    public InvitetoEventCtrl(ApexPages.StandardsetController controller) {
        listViewContacts = new List<Contact>();    
        emailService = new EmailServiceBatch();
        emailService.contactIDs = new Set<ID>();
        contactIDs = new Set<ID>();
        while(controller.getHasNext())
        {
            for(Contact listRecord : (List<Contact>) controller.getRecords())
            {
                listViewContacts.add(listRecord);
                emailService.contactIDs.add(listRecord.ID);
                
            }
            controller.next();
        }
        
        for(Contact listRecord : (List<Contact>) controller.getRecords())
        {
            listViewContacts.add(listRecord);
            emailService.contactIDs.add(listRecord.ID);
        }
        
        selectedContactsCount = listViewContacts.size();
    }
    public PageReference invite()
    {
        //  PageReference ref;
        try{
            Messaging.reserveSingleEmailCapacity(selectedContactsCount); 
            
            try{
                emailService.emailTemplateId = [Select ID from EmailTemplate
                                                WHERE ID=:[Select Invitation_Template_ID__c from Event_Templates__c 
                                                           WHERE Event__c=:selectedEvent].Invitation_Template_ID__c].ID;
                
                emailService.eventId = selectedEvent;
                DataBase.executeBatch(emailService, 100);
                PageReference   ref= new PageReference('/'+selectedEvent);
                ref.setredirect(true);
                return ref;
            }catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Email templates setup is not done for this event'+selectedEvent));
                return null;
            }
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,e.getMessage()));
            return null;
        }
        
        
        
        
    } 
    
    public Pagereference Backtocontacts()
    {
        PageReference ref = new PageReference('/'+003);  //?fcf={ViewID}
        ref.setredirect(true);
        return ref;
        
    } 
    
    
    
    public PageReference ClosePopup()
    {
        PageReference ref = new PageReference('/003');  //?fcf={ViewID}
        ref.setredirect(true);
        return ref;
    }    
    
}