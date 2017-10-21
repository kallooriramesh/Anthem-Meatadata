public class InvitetoEventCtrl1 {
    public list<contact> con;
    public String targetField { get; set; }
    public string response{get;set;}
    public EventApi__Attendee__c attendee{get;set;}
    public EventApi__Event__c evnt{get;set;}
    public Integer selectedContactsCount{get;set;}
    public Boolean showPopup{get;set;}
    public Boolean show{get;set;}
    public Boolean showiFrame{get;set;}    
    public String toEmailIds{get;set;}
    public String iframeSrc{get;set;}
    public Boolean showEmailSelection{get;set;}
    public String selectedTemplate{get;set;}
    public String selectedEvent{get;set;}
    public List<Contact> contacts;
    public List<Contact> listViewContacts{get;set;}
    public List<SelectOption> getTemplates() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('US','US'));
        options.add(new SelectOption('CANADA','Canada'));
        options.add(new SelectOption('MEXICO','Mexico'));
        return options;
    }
    
    public List<SelectOption> getEvents() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('null', ' - Select - '));
        for(EventApi__Event__c ev:[SELECT ID,Name,EventApi__Status__c from EventApi__Event__c where EventApi__Status__c !='Closed' ORDER BY NAME])
        {
            options.add(new SelectOption(ev.Id,ev.Name));
        }
        
        
        return options;
    }
    
    private List<EmailTemplate> allEmailTemplates;
    private List<Folder> allEmailTemplateFolders;
    public String selectedEmailTemplateFolder {public get; public set;}
    public String selectedEmailTemplate {public get; public set;}
    public EmailTemplate chosenEmailTemplate {public get; private set;}
    
    public InvitetoEventCtrl1(ApexPages.StandardsetController controller) {
        showPopup = true;  
        showiFrame = false; 
        show= true;
        showEmailSelection = true;
        listViewContacts = new List<Contact>();
        con = (List<contact>) controller.getRecords();//getSelected();
        //listViewContacts = (List<contact>) controller.getRecords();
        
        
        while(controller.getHasNext())
        {
            for(Contact testRecord : (List<Contact>) controller.getRecords())
            {
                listViewContacts.add(testRecord);
            }
            controller.next();
        }
        
        for(Contact testRecord : (List<Contact>) controller.getRecords())
        {
            listViewContacts.add(testRecord);
        }
        
        selectedContactsCount = listViewContacts.size();
        response='';
        allEmailTemplates = [select Id, Name, Subject, Body, HtmlValue ,FolderId,Markup from EmailTemplate order by Name asc ];
        allEmailTemplateFolders = [select Id, Name from Folder where Type = 'Email' order by Name asc];
    }
    list<EventApi__Attendee__c>  attend =new list<EventApi__Attendee__c>();
    public PageReference invite()
    {
        //  PageReference ref;
        try{
            Messaging.reserveSingleEmailCapacity(1000); 
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,e.getMessage()));
        }
        if(targetField != null && targetField!='')
        {
           
        }
        else
        {
            response ='Test';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please select Event'));
            //return null;
        } 
        
        PageReference   ref= new PageReference('/'+selectedEvent);
        ref.setredirect(true);
        return ref;  
        
        
    } 
    
    public Pagereference Backtocontacts()
    {
        PageReference ref = new PageReference('/'+003);  //?fcf={ViewID}
        ref.setredirect(true);
        return ref;
        
    } 
    
    public void rerencer()
    {
        
    }
    public void DisplayIframe()
    {
        selectedTemplate = [Select ID,Name,Invitation_Template_ID__c,Invitation_Template__c 
                            from Event_Templates__c
                            where Event__c = :targetField].Invitation_Template_ID__c;
        List<String> toEmails = new List<String>();
        try{
            Messaging.reserveSingleEmailCapacity(1000); 
            show =false;
            
            if(targetField != null && targetField!='')
            {
                
                for(Integer i=0; i<contacts.size() ; i++)
                {
                    toEmails.add(contacts[i].Email);
                    
                    if(contacts.size() >= 100)
                    {
                        if( toEmails.size() == 100 )
                        {
                            EmailServiceQueue es = new EmailServiceQueue();
                            es.toEmailIds = toEmails;
                            es.emailTemplateId = selectedTemplate;
                            es.eventId = selectedEvent;
                            System.enqueueJob(es);
                            toEmails.clear();
                        }
                        else{
                            if( contacts.size() == i)
                            {
                                
                                EmailServiceQueue es = new EmailServiceQueue();
                                es.toEmailIds = toEmails;
                                es.emailTemplateId = selectedTemplate;
                                es.eventId = selectedEvent;
                                System.enqueueJob(es);
                                toEmails.clear();    
                            }
                        }
                    }
                    else{
                        if( contacts.size() == i)
                        {
                            
                            EmailServiceQueue es = new EmailServiceQueue();
                            es.toEmailIds = toEmails;
                            es.emailTemplateId = selectedTemplate;
                            es.eventId = selectedEvent;
                            System.enqueueJob(es);
                            toEmails.clear();    
                        }
                    }
                }
                
                
                
                
                
                showEmailSelection = true;
                
                showPopup = false;  
                for(integer i=0;i<con.size();i++)
                {
                    attendee = new EventApi__Attendee__c();
                    attendee.EventApi__Full_Name__c=con[i].Name;
                    attendee.EventApi__Event__c=selectedEvent ;
                    attendee.EventApi__Email__c=con[i].email;
                    if(toEmailIds == null)
                    {
                        toEmailIds = con[i].email;
                    }
                    else{
                        toEmailIds = toEmailIds+','+con[i].email;
                    }
                    attendee.EventApi__Account__c=con[i].accountid;
                    attendee.EventApi__Invitation_Status__c='Invited';
                    //attendee.EventApi__Registration_Site_Url__c=    need to discuss
                    attendee.EventApi__Send_Invitation_Email__c=true;
                    attendee.EventApi__Send_Notification__c=true;
                    attend.add(attendee); 
                }
                //insert attend;
                
            }
            else
            {
                response ='Test';
                showPopup = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please select Event'));
                // return null;
            } 
            
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,e.getMessage()));
        }
        
    }
    
    public PageReference ClosePopup()
    {
        showPopup = false;
        PageReference ref = new PageReference('/003');  //?fcf={ViewID}
        ref.setredirect(true);
        return ref;
    }
    
    public List<SelectOption> getEmailTemplateFolderOpts() {
        List<SelectOption> opts = new List<SelectOption>();
        opts.add(new SelectOption('null', ' - Select - '));
        for ( Folder f : allEmailTemplateFolders )
            opts.add(new SelectOption(f.Id, f.Name));
        // add an option for templates in the Unfiled Public folder
        opts.add(new SelectOption(UserInfo.getOrganizationId(), 'Unfiled Public'));
        return opts;
    }
    
    public List<SelectOption> getEmailTemplateOpts() {
        List<SelectOption> opts = new List<SelectOption>();
        //if ( selectedEmailTemplateFolder != null ) 
        {
            opts.add(new SelectOption('null', ' - Select - '));
            Id selectedId = Label.Adobe_Event_FolderId; //(Id) selectedEmailTemplateFolder;
            for ( EmailTemplate et : allEmailTemplates ) {
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
    
    public PageReference refreshEmailTemplateSection() {
        // this is a bit ugly, but a consequence of not being able to set a SelectOption's value to null
        if ( selectedEmailTemplateFolder == null || selectedEmailTemplateFolder == 'null' ) {
            selectedEmailTemplateFolder = null;
            selectedEmailTemplate = null;
        }
        if ( selectedEmailTemplate == null || selectedEmailTemplate == 'null' ) {
            selectedEmailTemplate = null;
            chosenEmailTemplate = null;
        } else {
            Id selectedId = (Id) selectedEmailTemplate;
            for ( EmailTemplate et : allEmailTemplates ) {
                if ( et.Id == selectedId ) {
                    chosenEmailTemplate = et;
                    break;
                }
            }
        }
        return null;
    }
    
    Public PageReference setInviteeContacts()
    {
        List<EventApi__Attendee__c> attendees = [Select ID,Name,EventApi__Email__c,EventApi__Contact__c 
                                                 from EventApi__Attendee__c 
                                                 where EventApi__Event__c=:selectedEvent];
        Set<Id> conIds = new Set<ID>();
        For(EventApi__Attendee__c att:attendees )
        {
            conIds.add(att.EventApi__Contact__c);
        }
        contacts = [Select ID,Lastname 
                    from Contact 
                    Where Id NOT IN :conIds AND Email != null];  
        
        
        
        //selectedContactsCount = contacts.size();
        return null;
    }    
    
}