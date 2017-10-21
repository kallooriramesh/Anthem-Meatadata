({
    syncAttendies : function(component) 
    {
        var action = component.get("c.eventAttendiesSync");
        action.setParams({ eventId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
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
                      component.set("v.messageTitle",'SUCCESS');
                    component.set("v.messageText",'No-SCO-ID Found. Please Sync with Adobe Connect First to get SCO-ID');	
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