public class AdobeAttendiesSync {
    @AuraEnabled
    public static AdobeResponse eventAttendiesSync(String eventId)
    {
        AdobeResponse adResponse=new AdobeResponse();
        String status;
        EventApi__Event__c event;
        List<EventApi__Attendee__c> attList =new List<EventApi__Attendee__c>();
        try{
            String scoid;
            event = [Select ID, Name, EventApi__Description__c,Event_URL__c, SCO_ID__c  from EventApi__Event__c 
                     where Id=:eventId];
            if(event.SCO_ID__c!=null)
            {
                HttpResponse res = AdobeUtil.getAttendies(event.SCO_ID__c);
                adResponse.StatusCode=res.getStatusCode();
                adResponse.Status=res.getStatus();
                adResponse.Response=res.getBody();
                System.debug('res'+res.getBody());
                //adResponse.RequestURL=url;
                //adResponse.HResponse=res;
                if(res.getStatusCode() == 200)
                {
                    Dom.Document doc = res.getBodyDocument();
                    Dom.XMLNode address = doc.getRootElement();
                    for(Dom.XMLNode child : address.getChildElements()) {
                        
                        System.debug('****Child Name******'+child.getName());
                        System.debug('****Child Name******'+child.getText());
                        if(child.getName() == 'status')
                        {
                            status = child.getAttributeValue('code',null); 
                            adResponse.Status= status;
                        }
                        if( status == 'ok')
                        {
                            if(child.getName() == 'report-meeting-attendance')
                            {
                                System.debug('****subchild value******'+child.getText());
                                if(child.getText() != null && child.getText() !='')
                                {
                                    System.debug('****report-meeting-attendance******');
                                    for(Dom.XMLNode subchild : child.getChildElements())
                                    {
                                        
                                        System.debug('****sub Child Name******'+subchild.getName());
                                        for(Dom.XMLNode subchild1: subchild.getChildElements())
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
                insert attList;
            }
            else{
                adResponse.Status= 'No-SCO-ID';
            }
            //logoutResponse = res.getBody();
        }
        catch(Exception e)
        {
            adResponse.AdobeExeption = e.getLineNumber()+'---'+e.getTypeName()+'---'+e.getMessage();
        }
        return adResponse;
    }
}