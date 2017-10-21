public class CreateEventCtrl {
public String hostURL='https://meet48342685.adobeconnect.com/api/xml?';
public String actionType='sco-update';
public String folderId='1082517140';
public string startdate;
public String enddate;
public String loginSession='na2breez82y3s92evw4ihfc6';
    public String type { get; set; }
    public String eventUrl { get; set; }
    public String eventResponse { get; set; }
    public String description { get; set; }
    public PageReference Save() {
    String url=hostURL+'action='+actionType+'&folder-id='+folderId+'&type='+type+'&session='+loginSession+'&name='+eventName.replace(' ','%20')+'&description='+description.replace(' ','%20');
    eventUrl =url;
    Http h = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        //req.setHeader('Authorization',  loginSession);
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        System.debug(res.getBody());
        eventResponse = res.getBody();
        return null;
    }


    public String eventName { get; set; }
}