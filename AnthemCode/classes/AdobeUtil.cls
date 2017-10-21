/*

Class Name:AdobeUtil
Description: Adobe Utility class
Created BY: KIRAN
Created Date: Sep-08-2017
*/

Public class AdobeUtil{
    
    Public static AdobeResponse Login()
    {
        AdobeResponse adResponse=new AdobeResponse();
        String loginSession;
        try{
            AdobeSession__c adobeSession = AdobeSession__c.getValues('BREEZESESSION');
            if(adobeSession != null )
            {
                String adobeUrl = adobeSession.URL__c;
                String username = adobeSession.UserName__c;
                String password = adobeSession.Password__c;
                
                String action ='/api/xml?action=login';
                
                String loginUrl = adobeUrl+action+'&login='+userName+'&password='+password;
                //'http://example.com/api/xml?action=login&login=kallooriramesh@gmail.com&password=football'
                //
                System.debug('loginUrl'+loginUrl);
                
                // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
                Http h = new Http();
                
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(loginUrl);
                req.setTimeout(120000);
                HttpResponse res = h.send(req);
                //Prepare Adobe Response
                adResponse.StatusCode=res.getStatusCode();
                adResponse.Status=res.getStatus();
                adResponse.Response=res.getBody();
                adResponse.RequestURL=loginUrl;
                if(res.getStatusCode()==200)
                {
                    //res.getStatuuCode
                    System.debug('res'+res.getHeaderKeys());
                    loginSession=res.getHeader('Set-Cookie');
                    loginSession=loginSession.split(';')[0].split('=')[1];
                    if(loginSession != null)
                    {
                        
                        if(adobeSession == null)
                        {
                            adobeSession = new AdobeSession__c();
                            adobeSession.Name = 'BREEZESESSION';
                        }
                        adobeSession.Session__c = loginSession;
                        //adobeSession.URL__c = adobeUrl;
                        //upsert adobeSession;
                        //remoteSiteError = 'Login is successful';
                    }
                }
                
            }
        }
        catch(Exception e){
            adResponse.AdobeExeption = e.getLineNumber()+'---'+e.getTypeName()+'---'+e.getMessage();
        }
        return adResponse;
    }
    
    Public static HttpResponse searchEventByName(String name)
    {
        HttpResponse res;
        AdobeSession__c adobeSession = AdobeSession__c.getValues('BREEZESESSION');
        if(adobeSession != null)
        {
            String url=adobeSession.URL__c+'/api/xml?action=sco-search-by-field&query='+(name).replace(' ','%20')+'&session='+adobeSession.Session__c+'&field=name';
            Http h = new Http();
            System.debug('url'+url);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            // Send the request, and return a response
            res = h.send(req);
        }
        return res;
    }
    
    
    Public static HttpResponse searchEventByUrl(String eventUrl)
    {
        HttpResponse res;
        AdobeSession__c adobeSession = AdobeSession__c.getValues('BREEZESESSION');
        if(adobeSession != null)
        {
            String url=adobeSession.URL__c+'/api/xml?action=sco-by-url&url-path=/'+eventUrl+'/&session='+adobeSession.Session__c;
            Http h = new Http();
            System.debug('url'+url);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            // Send the request, and return a response
            res = h.send(req);
        }
        return res;
        
    }
    
    
    
    Public static HttpResponse getAttendies(String scoid)
    {
        HttpResponse res;
        AdobeSession__c adobeSession = AdobeSession__c.getValues('BREEZESESSION');
        if(adobeSession != null)
        {
            String url=adobeSession.URL__c+'/api/xml?action=report-meeting-attendance&sco-id='+scoid+'&session='+adobeSession.Session__c;
            Http h = new Http();
            System.debug('url'+url);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            // Send the request, and return a response
            res = h.send(req);
        }
        return res;
        
    }
    
    Public static HttpResponse getParticipantsInfoByScoId(String scoid)
    {
        HttpResponse res;
        
        return res;
    }
}