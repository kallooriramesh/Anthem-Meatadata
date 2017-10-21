public class AdobeEventSyncCtrl {
    public static EventApi__Event__c event; 
    
    @AuraEnabled
    public static EventApi__Event__c getEventDetails(String eventId)
    {
        event = [Select ID, Name, EventApi__Description__c,Event_URL__c, SCO_ID__c  from EventApi__Event__c where Id=:eventId];
        return event;
    }
    
    @AuraEnabled
    public static AdobeResponse eventSync(String eventId)
    {
        String status;
        event = [Select ID, Name, EventApi__Description__c,Event_URL__c, SCO_ID__c  from EventApi__Event__c where Id=:eventId];
        
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
                                            HttpResponse attres = AdobeUtil.getAttendies(event.SCO_ID__c);
                                            adResponse.StatusCode=attres.getStatusCode();
                                            adResponse.Status=attres.getStatus();
                                            adResponse.Response=attres.getBody();
                                            System.debug('attres'+attres.getBody());
                                            //adResponse.RequestURL=url;
                                            //adResponse.HResponse=res;
                                            if(attres.getStatusCode() == 200)
                                            {
                                                Dom.Document attdoc = attres.getBodyDocument();
                                                Dom.XMLNode attroot = attdoc.getRootElement();
                                                for(Dom.XMLNode attchild : attroot.getChildElements()) {
                                                    
                                                    System.debug('****attchild Name******'+attchild.getName());
                                                    System.debug('****attchild Name******'+attchild.getText());
                                                    if(attchild.getName() == 'status')
                                                    {
                                                        status = attchild.getAttributeValue('code',null); 
                                                        adResponse.Status= status;
                                                    }
                                                    if( status == 'ok')
                                                    {
                                                        if(attchild.getName() == 'report-meeting-attendance')
                                                        {
                                                            System.debug('****subchild value******'+attchild.getText());
                                                            if(attchild.getText() != null && attchild.getText() !='')
                                                            {
                                                                System.debug('****report-meeting-attendance******');
                                                                for(Dom.XMLNode attsubchild : attchild.getChildElements())
                                                                {
                                                                    
                                                                    System.debug('****sub Child Name******'+attsubchild.getName());
                                                                    for(Dom.XMLNode subchild1: attsubchild.getChildElements())
                                                                    {
                                                                        EventApi__Attendee__c attendee = new EventApi__Attendee__c();
                                                                        attendee.EventApi__Event__c = eventId; 
                                                                        System.debug('****sub Child Name******'+subchild1.getName());
                                                                        System.debug('****sub Child Name******'+subchild1.getText());
                                                                        if(subchild1.getName() == 'login')
                                                                        {
                                                                            attendee.EventApi__Email__c = subchild1.getText();
                                                                        }
                                                                        if(subchild1.getName() == 'participant-name')
                                                                        {
                                                                            attendee.EventApi__Full_Name__c = subchild1.getText();
                                                                        }
                                                                        attList.add(attendee);
                                                                    }
                                                                }
                                                            }else{
                                                                adResponse.Status= 'No-Attendies';
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                System.debug('res'+res.getBody());
                                            }
                                            upsert event;
                                            insert attList;
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
        
        return adResponse;
    }
    
    @AuraEnabled
    public static AdobeResponse eventSyncByURL(String eventId)
    {
        System.debug('in eventSyncByURL');
        String status;
        AdobeResponse adResponse=new AdobeResponse();
        
        try{
            String scoid;
            event = [Select ID, Name, EventApi__Description__c,Event_URL__c, SCO_ID__c  from EventApi__Event__c where Id=:eventId];
            
            HttpResponse res = AdobeUtil.searchEventByUrl(event.Event_URL__c);
            adResponse.StatusCode=res.getStatusCode();
            //adResponse.Status=res.getStatus();
            adResponse.Response=res.getBody();
            //adResponse.RequestURL=url;
            //adResponse.HResponse=res;
            if(res.getStatusCode() == 200)
            {
                Dom.Document doc = res.getBodyDocument();
                Dom.XMLNode root = doc.getRootElement();
                for(Dom.XMLNode child : root.getChildElements()) {
                    
                    System.debug('****Child Name******'+child.getName());
                    System.debug('****Child text******'+child.getAttributeValue('code',null));
                    if(child.getName() == 'status')
                    {
                        status = child.getAttributeValue('code',null); 
                        adResponse.Status= status;
                    }
                    if( status == 'ok')
                    {
                        if(child.getName() == 'sco')
                        {
                            scoid = child.getAttributeValue('sco-id',null);
                            event.SCO_ID__c = scoid;
                            
                            update event;
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
        return adResponse;
    } 
    
}