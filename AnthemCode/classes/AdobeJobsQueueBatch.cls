global class AdobeJobsQueueBatch implements Database.batchable<sObject>, Database.Stateful  {
    public EventApi__Event__c event;
    public String eventType;
    global Database.QueryLocator start(Database.BatchableContext info){ 
        String query = 'SELECT Id,Name,Order__c,IsProcessed__c FROM Adobe_Batch__c  WHERE IsProcessed__c=false order by Order__c LIMIT 1';
        return  Database.getQueryLocator(query);
    }     
    global void execute(Database.BatchableContext info, List<Adobe_Batch__c> scope){
        for(Adobe_Batch__c batch:scope)
        {
            if(batch.Name=='Login')
            {
                eventType = batch.Name;
                AdobeUtil.Login();
            }
            else if(batch.Name == 'SearchByName')
            {
                eventType = batch.Name;
                AdobeUtil.searchEventByName('a1Yf4000000dA1N');
            }
            else{
            eventType=null;
            }
            batch.IsProcessed__c= true;
        }
        update scope;
    }     
    global void finish(Database.BatchableContext info){  
    if(eventType != null)
      {

        }
    } 
    
}