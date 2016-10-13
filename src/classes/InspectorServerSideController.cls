public with sharing class InspectorServerSideController {
    
    @AuraEnabled
    public static List<Partner_Warning__c> getLatestWarnings() {
        
        
        MetadataInspectorJob.RunMetadataInspectorJob();
        
        
        List<Partner_Warning__c> lstWarnings = [SELECT Action_Taken__c,External_ID__c,Id,Metadata_Inventory_Item__c,Name,Warning_Message__c 
                                                FROM Partner_Warning__c where Action_Taken__c = 'Not Acknowledged'];
        
        return lstWarnings;
    }

}