({
	doInit : function(component, event, helper) {
        
        $A.log("InspectorSPAController.doInit: entered");
        
		var toggleText = component.find("welcome");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("scanResults");
		$A.util.addClass(toggleText,'toggle');
        var toggleText = component.find("spinner");
		$A.util.addClass(toggleText,'toggle');	
        

        $A.log("InspectorSPAController.doInit: exit");
        
	},

	StartScan:function(component,event,helper) {
        
        $A.log("InspectorSPAController.StartScan: entered");
        
        var toggleText = component.find("scanBtn");
		$A.util.removeClass(toggleText,'toggle');
        
		var toggleText = component.find("spinner");
		$A.util.removeClass(toggleText,'toggle');
        
        helper.scanAndGetWarnings(component);

        
        
        
        $A.log("InspectorSPAController.StartScan: exit");
	}
})