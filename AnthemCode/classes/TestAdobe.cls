public class TestAdobe {

    public PageReference Search() {
    String url=hostURL+'?action=sco-search-by-field&query='+SearchStr+'&session='+loginSession+'&field=name';
    Http h = new Http();

    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('GET');
    req.setTimeout(120000);
    // Send the request, and return a response
    HttpResponse res = h.send(req);
    logoutResponse = res.getBody();
        return null;
    }


    public String SearchStr { get; set; }
public String loginSession{get;set;}
public String bodyResponse{get;set;}

public String logoutResponse{get;set;}
public String loginResponse{get;set;}
public String loginReqUrl{get;set;}
public String accessToken{get;set;}

public String eventResponse{get;set;}
public String eventURL{get;set;}
public String hostURL='https://meet50336032.adobeconnect.com/api/xml';
public String username='kallooriramesh@gmail.com';
public String password='Sqjjq7b';

public void logout() {
    String url='https://meet50336032.adobeconnect.com/api/xml?action=logout';
    
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    Http h = new Http();

    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('GET');
    req.setTimeout(120000);
    // Send the request, and return a response
    HttpResponse res = h.send(req);
    logoutResponse = res.getBody();
}

public PageReference callAdobe() {
    
    String url = 'https://meet50336032.adobeconnect.com/api/xml?action=login&login=kallooriramesh@gmail.com&password=Sqjjq7b';
    
    
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    Http h = new Http();

    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('GET');
    
    // Send the request, and return a response
    HttpResponse res = h.send(req);
    bodyResponse=res.getBody();
    System.debug(res.getBody());
    createAccessToken();
    return null;
}

public Pagereference login()
{
    //logout();
    String action ='?action=login';
    
    String loginUrl = hostUrl+action+'&login='+userName+'&password='+password;
    //'http://example.com/api/xml?action=login&login=kallooriramesh@gmail.com&password=football'
    //
    
    
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    Http h = new Http();

    HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    req.setEndpoint(loginUrl);
    req.setTimeout(120000);
    HttpResponse res = h.send(req);
    System.debug('res'+res.getHeaderKeys());
    loginSession=res.getHeader('Set-Cookie');
    loginSession=loginSession.split(';')[0].split('=')[1];
     if(loginSession != null)
                    {
                        //createAccessToken();
                        createEvent();
                    }
   
    return null; 
}

public void createAccessToken()
{
    
    String url = 'https://meet50336032.adobeconnect.com/api/xml?action=login&login=kallooriramesh@gmail.com&password=Sqjjq7b&account-id=1262544101&session='+loginSession;
    
    loginReqUrl = url;
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('GET');
    req.setTimeout(120000);
    // Send the request, and return a response
    HttpResponse res = h.send(req);
    loginResponse= res.getBody();
    System.debug('body'+res.getBody());
    System.debug(res.getBody());
    loginToken();
    // return accessToken;
    
}
public void createEvent()
{
    //getRefreshToken(loginSession);
    
    
    System.debug('accessToken'+loginSession);
    String url='https://meet50336032.adobeconnect.com/api/xml?action=sco-update&folder-id=1265694111&account-id=1262544101&description=CreatingFromApex&name=ALL_HANDS_MEETING2231&type=meeting&date-begin=2017-10-16T23:00&date-end=2017-10-16T23:30&session='+loginSession;//
    eventURL = url;
    System.debug(url);
    
    
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    Http h = new Http();

    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('GET');
    //req.setHeader('Authorization',  loginSession);
    
    // Send the request, and return a response
    HttpResponse res = h.send(req);
    System.debug(res.getBody());
    eventResponse = res.getBody();
}

/* public string getRefreshToken(String loginsession) {    
  String loginToken = 
  String endpointUrl2 = '';
 // make http request and get refresh token.
}
*/ 
public Pagereference loginToken()
{
    //logout();
    
    String loginUrl = 'https://meet50336032.adobeconnect.com/api/xml?action=common-info';
    
    
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    Http h = new Http();

    HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    req.setEndpoint(loginUrl);
    req.setTimeout(120000);
    HttpResponse res = h.send(req);
    accessToken = res.getBody();
    System.debug('****HttpResponse ******'+accessToken );
    Dom.Document doc = res.getBodyDocument();
    Dom.XMLNode address = doc.getRootElement();
    for(Dom.XMLNode child : address.getChildElements()) {
        System.debug('****Child Name******'+child.getName());
        if(child.getName() == 'common')
        {
            System.debug(child.getChildElements());
            for(Dom.XMLNode child1 : child.getChildElements())
            {
                System.debug(child1.getName());
                if((child1.getName() == 'cookie'))
                {
                    loginSession = child1.getText();
                     System.debug('****loginSession ******'+loginSession );
                    createEvent();
                   
                }
            }
        }
    }
    return null; 
}
}