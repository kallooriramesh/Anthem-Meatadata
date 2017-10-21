global class EventParticipationDetails {
    @InvocableMethod(label='EventParticipationDetails' description='Updates the Attendees information')
    public static void eventSync(List<ID> eventIds)
    {
        String eventId = eventIds[0];
        EventApi__Event__c event = [Select ID, Name, EventApi__Description__c,Event_URL__c, SCO_ID__c  
                                    from EventApi__Event__c where Id=:eventId];
        
        
        String status;
        List<EventApi__Attendee__c> attList =new List<EventApi__Attendee__c>();
        AdobeResponse adResponse=new AdobeResponse();
        AdobeSession__c adobeSession = AdobeSession__c.getValues('BREEZESESSION');
        string username= adobeSession.Username__c;
        string password = adobeSession.Password__c;
        string adobeUrl=  adobeSession.URL__c;
        String remoteSiteError;
        AdobeUtil adl = new AdobeUtil(); 
        //adl.username=username;
        //adl.password=password;
        //adl.adobeUrl=adobeUrl;
        adResponse=AdobeUtil.Login();
        
        if(adResponse.Status =='ok')
        { 
            
            try{
                String scoid;
                
                HttpResponse res = AdobeUtil.searchEventByName(event.Name);
                adResponse.StatusCode=res.getStatusCode();
                //adResponse.Status=res.getStatus();
                adResponse.Response=res.getBody();
                //adResponse.RequestURL=url;
                //adResponse.HResponse=res;
                if(res.getStatusCode() == 200)
                {
                    Dom.Document doc = res.getBodyDocument();
                    Dom.XMLNode address = doc.getRootElement();
                    for(Dom.XMLNode child : address.getChildElements()) {
                        
                        System.debug('****Child Name******'+child.getName());
                        System.debug('****Child text******'+child.getAttributeValue('code',null));
                        if(child.getName() == 'status')
                        {
                            status = child.getAttributeValue('code',null); 
                            adResponse.Status= status;
                        }
                        if( status == 'ok')
                        {
                            if(child.getName() == 'sco-search-by-field-info')
                            {
                                System.debug('****Child elements******'+child.getChildElements().size());
                                if(child.getChildElements().size()>0)
                                {
                                    //System.debug('****Child text******'+child.getText());
                                    for(Dom.XMLNode subchild : child.getChildElements())
                                    {
                                        scoid = subchild.getAttributeValue('sco-id',null);
                                        event.SCO_ID__c = scoid;
                                        System.debug('****sub Child Name******'+subchild.getName());
                                        
                                        System.debug('****sub Child Name******'+subchild.getAttributeValue('sco-id',null));
                                        if(event.SCO_ID__c!=null)
                                        {
                                            
                                            checkAndUpdateAttendeeInfo(scoid, AdobeUtil.getParticipantsInfoByScoId(scoid), event.id);
                                        }
                                        else{
                                            adResponse.Status= 'No-SCO-ID';
                                        }
                                        //update event;
                                    }
                                }
                                else
                                {
                                    adResponse.Status= 'No-SCO-ID';
                                }
                            }
                        } 
                        
                    }
                }
                //if(child.getName() == 'common')
                
                System.debug('res'+res.getBody());
                //logoutResponse = res.getBody();
            }
            catch(Exception e)
            {
                adResponse.AdobeExeption = e.getLineNumber()+'---'+e.getTypeName()+'---'+e.getMessage();
            }
            System.debug('adResponse'+adResponse);
            
        }
        else {
            remoteSiteError='Please check the credentials.';
        }  
        
        // return adResponse;
    }
    
    
    Public static AdobeResponse checkAndUpdateAttendeeInfo(String scoid, HttpResponse res, String eventid)
    {
        List<EventApi__Attendee__c> attendees = [Select ID,Name,EventApi__Email__c
                                                 from EventApi__Attendee__c where EventApi__Event__c=:eventid AND
                                                EventApi__Status__c='Registered'];
        List<Attendance_Details__c> attendeeList = new List<Attendance_Details__c>();
        String  status;
        String userfullname;
        String email;
        String filesDownloaded;
        String attendance_status;
        String first_in_time;
        String last_end_time;
        String duration;
        AdobeResponse adResponse=new AdobeResponse();
        Dom.Document doc = res.getBodyDocument();
        Dom.XMLNode root = doc.getRootElement();	
        for(Dom.XMLNode child : root.getChildElements()) {
            System.debug('****Child Name******'+child.getName());
            if(child.getName() == 'status')
            {
                status = child.getAttributeValue('code',null); 
                adResponse.Status= status;
                System.debug('status'+status);
            }
            if( status == 'ok')
            {
                if(child.getName() == 'user_list')
                {
                    for(Dom.XMLNode user : child.getChildElements())
                    {
                        Attendance_Details__c attendee = new Attendance_Details__c();
                        if(user.getName() == 'user')
                        {
                            userfullname = user.getAttributeValue('name',null); 
                            //attendee.Name = userfullname;
                            
                            System.debug('userfullname'+ userfullname);
                            email = user.getAttributeValue('login',null); 
                            //attendee.
                            System.debug('email'+ email);
                            for(Dom.XMLNode files : user.getChildElements())
                            {
                                System.debug('files...'+files.getName());
                                
                                for(Dom.XMLNode file : files.getChildElements())
                                {
                                    System.debug('file name...'+file.getAttributeValue('name',null));
                                    if(filesDownloaded == null)
                                        filesDownloaded = file.getAttributeValue('name',null);
                                    else
                                        filesDownloaded = filesDownloaded + ';'+file.getAttributeValue('name',null);
                                }
                            }
                        }
                    }
                }
            }
            else{
                
            }
        }
     return adResponse;   
    }
}