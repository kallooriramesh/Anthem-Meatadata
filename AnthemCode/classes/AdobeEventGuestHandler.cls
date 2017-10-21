Public class AdobeEventGuestHandler{
   
    @future(callout=true)
    Public static void addGuestUserToEvent(String attendeeId)
    {
        EventApi__Attendee__c attendee = [Select ID,EventApi__Full_Name__c,SCO_ID__c,Adobe_Response__c,EventApi__Email__c,EventApi__Preferred_Email__c FROM EventApi__Attendee__c WHERE ID=:attendeeId];
        HttpResponse res;
        AdobeSession__c adobeSession = AdobeSession__c.getValues('BREEZESESSION');
        if(adobeSession != null)
        {
            String url=adobeSession.URL__c+'/api/xml?action=event-guest-invite&sco-id='+attendee.SCO_ID__c;
            url = url+'&session='+adobeSession.Session__c;
            url = url+'&guest-details='+attendee.EventApi__Full_Name__c+','+attendee.EventApi__Full_Name__c+','+attendee.EventApi__Preferred_Email__c;
            Http h = new Http();
            System.debug('url'+url);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            // Send the request, and return a response
            res = h.send(req);
            Dom.Document doc = res.getBodyDocument();
            Dom.XMLNode root = doc.getRootElement();
            for(Dom.XMLNode child : root.getChildElements()) {
                
                System.debug('****Child Name******'+child.getName());
                System.debug('****Child Name******'+child.getAttributeValue('code',null));
                attendee.Adobe_Response__c = child.getAttributeValue('code',null);
                CheckRecursive.isRecursive = TRUE;
                UPDATE attendee;
                
            }
        }
    }
}