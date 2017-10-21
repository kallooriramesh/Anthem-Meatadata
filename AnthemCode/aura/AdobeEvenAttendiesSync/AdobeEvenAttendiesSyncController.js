({
	doInit : function(component, event, helper) {
		//helper.loadEventDetails(component);
		component.set("v.showSpinner",true);
		helper.syncEventDetails(component);
	},
    confirmSync :function(component, event, helper) {
        helper.syncEventDetails(component);
    },
    showSpinner : function (component, event, helper) {
       component.set("v.showSpinner",true);    
    },
     hideSpinner : function (component, event, helper) {
        component.set("v.showSpinner",false);  
         $A.get("e.force:closeQuickAction").fire();
         $A.get('e.force:refreshView').fire();
    }
})