public class ExamFieldEditorController {
    
    @AuraEnabled
    public static sObject updateRecord(String ObjectName, String id, String fieldName, String fieldVal){
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Set<String> objectKeys = gd.keySet();
        sObject sObj;
        if(objectKeys.contains(Objectname.toLowerCase()))
        {   
            //Creating a new sObject
            sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
            sObj.put('id',id);
            sObj.put(fieldName,fieldVal);
            
            try{
                FieldLevelSecurity.checkFieldAccessByCriteria(fieldName, 'update', ObjectName);
                update sObj;
            }
            catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
            
        }
        return sObj;
    }
}