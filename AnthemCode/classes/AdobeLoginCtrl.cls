public class AdobeLoginCtrl {
    public String username{get;set;}
    public String password{get;set;}
    public String adobeUrl{get;set;} 
    public String remoteSiteError{get;set;}
    public string loginSession{get;set;}
    
    public string  userlogin()
    {
        try{
            String status;
          
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
            Dom.Document doc = res.getBodyDocument();
            Dom.XMLNode address = doc.getRootElement();
            for(Dom.XMLNode child : address.getChildElements()) {
                if(child.getName() == 'status')
                {
                    status = child.getAttributeValue('code',null); 
                }
            }
            if(status == 'ok')
            {
                System.debug('res'+res.getHeaderKeys());
                loginSession=res.getHeader('Set-Cookie');
                loginSession=loginSession.split(';')[0].split('=')[1];
                if(loginSession != null)
                {
                    AdobeSession__c adobeSession = AdobeSession__c.getValues('BREEZESESSION');
                    if(adobeSession == null)
                    {
                        adobeSession = new AdobeSession__c();
                        adobeSession.Name = 'BREEZESESSION';
                    }
                    adobeSession.Session__c = loginSession;
                    adobeSession.URL__c = adobeUrl;
                   // upsert adobeSession;
                    remoteSiteError = 'Login is successful';
                    System.debug('resite'+remoteSiteError);
                }
            }
            else {
                remoteSiteError='Please check the credentials.';
            }
        }
        catch(Exception e){
            if(e.getTypeName() == 'System.CalloutException')
            {
                remoteSiteError = 'Please setup the RemoteSite setting details with Domain Url';
            }
        }
        return loginSession;
    }
   
}