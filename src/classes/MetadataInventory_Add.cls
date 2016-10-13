public class MetadataInventory_Add {
    
    public static void insertMetadataInventoryItems ()
    {
       Integer METADATA_API_VERSION = Integer.valueOf(new MetadataService.MetadataPort().endpoint_x.substringAfterLast('/'));

		System.debug('METADATA_API_VERSION: ' + METADATA_API_VERSION);


		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
        //service.SessionHeader.sessionId = UserInfo.getSessionId();                
        service.SessionHeader.sessionId = Utils.getSessionIdFromVFPage(Page.SessionIDGetter);
        MetadataService.DescribeMetadataResult describeResult = service.describeMetadata(METADATA_API_VERSION);
        List<String> metadataTypeNames = new List<String>();

        List<Metadata_Inventory_Item__c> lstInvItems = new List<Metadata_Inventory_Item__c>();
                
        MetadataService.ListMetadataQuery queryLayout = new MetadataService.ListMetadataQuery();
        for(MetadataService.DescribeMetadataObject metadataObject : describeResult.metadataObjects)
        {

            

            metadataTypeNames.add(metadataObject.xmlName);
            queryLayout.type_x = metadataObject.xmlName;
            List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
            queries.add(queryLayout);
            System.debug('metadataObject.xmlName: ' + metadataObject.xmlName);

            MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, METADATA_API_VERSION);
        

            if(fileProperties!=null)
            {
                for(MetadataService.FileProperties fileProperty : fileProperties)
                {
                    Metadata_Inventory_Item__c invItem = new Metadata_Inventory_Item__c();
                    System.debug('fileProperty.fullName: ' + fileProperty.fullName + ' - fileProperty.type_x: ' + fileProperty.type_x);
                    System.debug('fileProperty: ' + fileProperty);
                    invItem.Name = fileProperty.fullName;
                    if ((!String.isBlank(fileProperty.id)))
                    {
                     	invItem.ComponentId__c = fileProperty.id + fileProperty.type_x;   
                    }
                    
                    invItem.Type__c = fileProperty.type_x;
                    invItem.Manageable_State__c = fileProperty.manageableState;
                    invItem.Created_By_User_ID__c = fileProperty.createdById;
                    invItem.Created_By_User__c = fileProperty.createdByName;
                    invItem.Last_Modified_By_User_ID__c = fileProperty.lastModifiedById;
                    invItem.Created_Date__c = fileProperty.createdDate;
                    invItem.Last_Modified_Date__c = fileProperty.lastModifiedDate;
                    if (!String.isBlank(invItem.ComponentId__c))
                    {
                    	lstInvItems.Add(invItem);    
                    }
                    
                }
                

            }  





            // Include child Metadata Types (such as CustomField, ValidationRule etc..)
            if(metadataObject.childXmlNames!=null)
                for(String childXmlName : metadataObject.childXmlNames)
                    if(childXmlName!=null)
                     {
                        metadataTypeNames.add(childXmlName);
                        System.debug('childXmlName: ' + childXmlName);
                        queryLayout.type_x = childXmlName;
                        List<MetadataService.ListMetadataQuery> queries1 = new List<MetadataService.ListMetadataQuery>();
                        queries1.add(queryLayout);

                        MetadataService.FileProperties[] fileProperties1 = service.listMetadata(queries1, METADATA_API_VERSION);
        

                        if(fileProperties1!=null)
                        {
                             for(MetadataService.FileProperties fileProperti : fileProperties1)
                             {
                                 Metadata_Inventory_Item__c invItem2 = new Metadata_Inventory_Item__c();
                                 System.debug('fileProperti.fullName: ' + fileProperti.fullName );
                                 System.debug('fileProperti: ' + fileProperti);
                                 invItem2.Name = fileProperti.fullName;
                                 if ((!String.isBlank(fileProperti.id)))
                                 {
                                     invItem2.ComponentId__c = fileProperti.id + fileProperti.type_x;   
                                 }
                                 invItem2.Type__c = fileProperti.type_x;
                                 invItem2.Manageable_State__c = fileProperti.manageableState;
                                 invItem2.Created_By_User_ID__c = fileProperti.createdById;
                                 invItem2.Created_By_User__c = fileProperti.createdByName;
                                 invItem2.Last_Modified_By_User_ID__c = fileProperti.lastModifiedById;
                                 invItem2.Created_Date__c = fileProperti.createdDate;
                                 invItem2.Last_Modified_Date__c = fileProperti.lastModifiedDate;
                                 if (!String.isBlank(invItem2.ComponentId__c))
                                    {
                                        lstInvItems.Add(invItem2);    
                                    }
                             }
                             
                         }     



                     }
        } 
        Schema.SObjectField externalIdField = Metadata_Inventory_Item__c.Fields.ComponentId__c;
		//Database.Upsert(lstInvItems);
        //Database.Upsert(lstInvItems, externalIdField, true);
        
        Database.UpsertResult[] urList = Database.upsert(lstInvItems, externalIdField, true);
        for (Database.UpsertResult ur : urList) 
        {
            if (ur.isCreated()) {
                //dosomething
                System.debug('ur.getId() record: ' + ur.getId() + 'was created');
            }
		}
        
 
    }
    
    
    public static void CreateWarnings()
    {
        
        List<Partner_Warning__c> lstWarnings = new List<Partner_Warning__c>();        
        List<Metadata_Inventory_Item__c> lstInvItems = new List<Metadata_Inventory_Item__c>();
        
        lstInvItems = [SELECT ComponentId__c,Id,Type__c FROM Metadata_Inventory_Item__c];
        
        if (!lstInvItems.isEmpty())
        {
            for (Metadata_Inventory_Item__c item: lstInvItems)
            {
                System.Debug('##### item.Type__c: ' + item.Type__c);
                integer count = 1;
                // get first warning for MD type
                String mdType = item.Type__c;
                do {
                    MetadataWarning__c cs = MetadataWarning__c.getValues(mdType + String.valueOf(count));
                    System.Debug('##### cs: ' + cs);
                    if (cs != null)
                    {
                        System.Debug('##### cs entered: ' + cs);
                        Partner_Warning__c pw = new Partner_Warning__c();
                        pw.External_ID__c = item.ComponentId__c + count;
                        pw.Metadata_Inventory_Item__c = item.id;
                        pw.Warning_Message__c = cs.Metadata_Warning_Message__c;
                        lstWarnings.add(pw);
                    }

                    count++;
                    } 
                while (MetadataWarning__c.getValues(mdType + String.valueOf(count)) != null);
                    
            }
            
            Schema.SObjectField externalIdField = Partner_Warning__c.Fields.External_ID__c;
            Database.UpsertResult[] urList = Database.upsert(lstWarnings, externalIdField, true);
            
        }
        
        
        
    }
    
    
    

}