global class MetadataInspectorJob implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                FROM CronTrigger WHERE Id = :ctx.getTriggerId()];

      System.debug(ct.CronExpression);
      System.debug(ct.TimesTriggered);

      RunMetadataInspectorJob();
      
		
        
      
        
        
        
   }
    
   public static void RunMetadataInspectorJob()
   {
       // Try to fetch Metadata Warnings from Heroku
      // MetadataWarningsService.GetLatestWarnings();
        
        
      // Scan the Metadata from the Org
      // 
      MetadataInventory_Add.insertMetadataInventoryItems();
        
        
      // Create the local Warnings for the Developer
      MetadataInventory_Add.CreateWarnings();
        
        
      // Push the Partner Org Warnings to the TE Heroku app
      // MetadataWarningService.UpdsertPartnerOrgWarnings(List<PartnerWarnings>)
      // 
      // 
    
       
       // Fetch List of Warnings to be Deleted from Developer Org from the Heroku Service
      // MetadataWarningService.FetchAndDeleteWarnings(List<PartnerWarnings>)
   }

}