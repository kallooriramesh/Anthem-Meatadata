({
    loadEventDetails : function(component) {
        var action = component.get("c.getEventDetails");
        action.setParams({ eventId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.event",response.getReturnValue());
                
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    syncEventDetails : function(component) 
    {
     var action = component.get("c.eventSync");
     action.setParams({ eventId : component.get("v.recordId") });
     action.setCallback(this, function(response) {
         var state = response.getState();
         if (state === "SUCCESS") {
             console.log('resopnse');
             console.log(response.getReturnValue());
             component.set("v.eventSyncResponce",response.getReturnValue());
              if(response.getReturnValue().Status == 'no-access')
                {
                    component.set("v.messageTitle",'ERROR');
                    component.set("v.messageText",'No access');	
                }
                if(response.getReturnValue().Status == 'ok')
                {
                    component.set("v.messageTitle",'SUCCESS');
                    component.set("v.messageText",'Sync has completed successfully.');	
                }
                 if(response.getReturnValue().Status == 'No-Attendies')
                 {
                      component.set("v.messageTitle",'SUCCESS');
                    component.set("v.messageText",'Sync has completed successfully. No Attendies found.!');	
                 }
                
                 if(response.getReturnValue().Status == 'No-SCO-ID')
                 {
                      component.set("v.messageTitle",'INFO');
                    component.set("v.messageText",'No-SCO-ID Found.!');	
                 }
                 
             
         }
         else if (state === "INCOMPLETE") {
             // do something
         }
             else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         console.log("Error message: " + 
                                     errors[0].message);
                     }
                 } else {
                     console.log("Unknown error");
                 }
             }
     });
     $A.enqueueAction(action);
    }    
    
})