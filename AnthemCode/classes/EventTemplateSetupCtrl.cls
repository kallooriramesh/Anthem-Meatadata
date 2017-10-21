public class EventTemplateSetupCtrl {
    public Boolean show{get;set;}
    public String selectedRegistrationTemplate{get;set;}
    public String selectedInvitationTemplate{get;set;}
    public String selectedFollowupTemplate{get;set;}
    public String selectedReminderTemplate{get;set;}
    
    
    public EventApi__Event__c event{get;set;}
    public Event_Templates__c eventTemplate{get;set;}
    Public List<SelectOption> opts;
    Public ApexPages.StandardController controller;
    Public Map<Id,EmailTemplate> allTemplates;
    public EventTemplateSetupCtrl(ApexPages.StandardController controller)
    {
        try{
            this.controller = controller;
            opts = new List<SelectOption>();
            allTemplates = new Map<Id,EmailTemplate>();
            for(EmailTemplate template : [select Id, Name, Subject, Body, HtmlValue ,FolderId,Markup 
                                          from EmailTemplate order by Name asc ])
                allTemplates.put(template.Id, template);
            opts.add(new SelectOption(' - Select - ', ' - Select - '));
            event = (EventApi__Event__c)controller.getRecord();
            eventTemplate = [Select ID,Name,Invitation_Template__c,Invitation_Template_ID__c,
                             Registration_Template__c,Registration_Template_ID__c,
                             Reminder_Template__c,Reminder_Template_ID__c,
                             Thank_you_Id__c,Thank_you_template_id__c,
                             Followup_Template__c,Followup_Template_ID__c
                             from Event_Templates__c where Event__c=:controller.getId() LIMIT 1];
            if(eventTemplate == null)
            {
                eventTemplate = new Event_Templates__c();
            }else{
                selectedInvitationTemplate = eventTemplate.Invitation_Template_ID__c;
                selectedFollowupTemplate = eventTemplate.Followup_Template_ID__c;
                selectedRegistrationTemplate = eventTemplate.Registration_Template_ID__c;
                selectedReminderTemplate = eventTemplate.Reminder_Template_ID__c;
                
            }
        }catch(Exception e){
            
        }
    }
    
    public List<SelectOption> getEmailTemplateOpts() {
        
        //if ( selectedEmailTemplateFolder != null ) 
        {
            
            Id selectedId = Label.Adobe_Event_FolderId; //(Id) selectedEmailTemplateFolder;
            for ( EmailTemplate et : allTemplates.values() ) {
                if( selectedId != null)
                {
                    if ( et.FolderId == selectedId )
                        opts.add(new SelectOption(et.Id, et.Name));
                }
                else{
                    opts.add(new SelectOption(et.Id, et.Name));
                }
            }
        }
        return opts;
    }
    
    public PageReference ClosePopup()
    {
        return new PageReference('/'+controller.getId());
    }
    
    public PageReference Save()
    {
        if(selectedInvitationTemplate != ' - Select - ' &&
           selectedFollowupTemplate != ' - Select - ' &&
           selectedRegistrationTemplate != ' - Select - ' &&
           selectedReminderTemplate != ' - Select - ')
        {
            eventTemplate.Event__c = controller.getId();
            eventTemplate.Invitation_Template_ID__c = selectedInvitationTemplate;
            eventTemplate.Invitation_Template__c = allTemplates.get(selectedInvitationTemplate).Name;
            eventTemplate.Followup_Template_ID__c = selectedFollowupTemplate;
            eventTemplate.Followup_Template__c = allTemplates.get(selectedFollowupTemplate).Name;
            eventTemplate.Registration_Template_ID__c = selectedRegistrationTemplate;
            eventTemplate.Registration_Template__c = allTemplates.get(selectedRegistrationTemplate).Name;
            eventTemplate.Reminder_Template_ID__c = selectedReminderTemplate;
            eventTemplate.Reminder_Template__c = allTemplates.get(selectedReminderTemplate).Name;
            upsert eventTemplate;
            return new PageReference('/'+controller.getId());
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'All Fields are required.'));
            return null;
        }
    }
}