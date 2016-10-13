({
	doInit : function(component, event, helper) {
        
        console.log("InspectorSPAController.doInit: entered");
        
        helper.hideSpinner(component);
		var toggleText = component.find("welcome");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("scanResults");
		$A.util.addClass(toggleText,'toggle');
        //var toggleText = component.find("spinner");
		//$A.util.addClass(toggleText,'toggle');	
        

        console.log("InspectorSPAController.doInit: exit");
        
	},

	StartScan:function(component,event,helper) {
        
        helper.showSpinner(component);
        console.log("InspectorSPAController.StartScan: entered");
        
        var toggleText = component.find("scanBtn");
		$A.util.removeClass(toggleText,'toggle');
        
		//var toggleText = component.find("spinner");
		//$A.util.removeClass(toggleText,'toggle');
        
        helper.scanAndGetWarnings(component);

        
        
        
        console.log("InspectorSPAController.StartScan: exit");
	}
})