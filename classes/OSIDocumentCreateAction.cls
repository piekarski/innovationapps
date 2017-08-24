global class OSIDocumentCreateAction {
  @InvocableMethod(label='Insert OSI documents content' description='Inserts the OSI Documents content source and re-assigns the record type')
  public static void insertOSIDocumentContentAssignment(List<Id> lsDocumentIds) {    
  
   /*Populate the rich text document content based on the document type from static resource*/
    Map<String, String> mapDocumentContent = new Map<String, String>();
    List<String> lsResourceNames = new List<String>{'ProjectCharter'};       
    List<StaticResource> lsResources = [select Body, Name from StaticResource where Name IN : lsResourceNames];
    
    
    /*Identify the record type*/
    RecordType rt = [select Id from RecordType where Name = 'AfterRichText' and SobjectType = 'OSI_Project_Compliance_Documents__c' limit 1];

    for(StaticResource sr : lsResources){    
        Blob projBlob = sr.Body;
        System.debug(projBlob.toString());
        mapDocumentContent.put(sr.Name, projBlob.toString());
    }
    
    List<OSI_Project_Compliance_Documents__c> lsUpdateDocs = new List<OSI_Project_Compliance_Documents__c>();
    for(OSI_Project_Compliance_Documents__c osDoc : [SELECT Id, Name, Document_Content__c, RecordTypeId FROM OSI_Project_Compliance_Documents__c WHERE Id in : lsDocumentIds]){       
       osDoc.Document_Content__c = mapDocumentContent.get('ProjectCharter');
       osDoc.RecordTypeId = rt.Id;    
       System.Debug(osDoc);
       System.Debug(mapDocumentContent);
       lsUpdateDocs.add(osDoc);    
    }
    
    UPDATE lsUpdateDocs;
    
    
  }
}