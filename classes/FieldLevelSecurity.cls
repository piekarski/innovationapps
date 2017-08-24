public with sharing class FieldLevelSecurity {
    public static SFDCAccessController access = ExAMUtilClass.AccessController;
    public static String NameSpacePrefix = ExAMUtilClass.getNameSpacePrefix();
    
    public static void checkFieldAccessByCriteria(String fields, String criteria, String sObjectName){
        List<String> fieldsWthNameSpace = new List<String>();
            
        if(fields != null){
            for(String field : fields.split(',')){
                fieldsWthNameSpace.add(NameSpacePrefix+field.trim());
            }
        }
		        
        if(criteria != null){
            
            if(criteria == 'create'){
                access.assertAuthorizedToCreate(Schema.getGlobalDescribe().get(sObjectName), fieldsWthNameSpace);
            }else if(criteria == 'view'){
                access.assertAuthorizedToView(Schema.getGlobalDescribe().get(sObjectName), fieldsWthNameSpace);
            }else if(criteria == 'update'){
                access.assertAuthorizedToUpdate(Schema.getGlobalDescribe().get(sObjectName), fieldsWthNameSpace);
            }
            
        }
    }
    
    public static void checkObjectAccessByDelete(String sObjectName){
        access.isAuthorizedToDelete(Schema.getGlobalDescribe().get(sObjectName));
    }
    
    public static Void checkObjectAccessByCreate(String sObjectName){
        access.isAuthorizedToCreate(Schema.getGlobalDescribe().get(sObjectName));
    }
    public static Void checkObjectAccessByView(String sObjectName){
        access.isAuthorizedToView(Schema.getGlobalDescribe().get(sObjectName));
    }
    public static Void checkObjectAccessByUpdate(String sObjectName){
         access.isAuthorizedToView(Schema.getGlobalDescribe().get(sObjectName));
    }
    
    
    
    
}