public with sharing class ObjService {

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

   public static ExAM__IssueRequest_Life_Cycle__c createNewAObj(ExAM__IssueRequest_Life_Cycle__c AMTemplate, String objApi, String objLabel) {
      system.debug('createNewAM::::+++++====>' +AMTemplate); //api name
       String objFields = 'Assignment_Manager_ID__c, Public_Assessment_URL__c';
       string amDesc = AMTemplate.ExAM__Issue_request__c;
       String amFields = 'ExAM__Issue_request__c, Additional_Status__c';
       String paFields = 'ExAM__Assignment_Manager__c';

        FieldLevelSecurity.checkFieldAccessByCriteria(objFields, 'create', objApi);
        FieldLevelSecurity.checkFieldAccessByCriteria(amFields, 'create', 'ExAM__IssueRequest_Life_Cycle__c');
        FieldLevelSecurity.checkFieldAccessByCriteria(paFields, 'create', 'ExAM__Public_Assessment__c');


       Boolean isAutonumber = true;

       if (!objApi.equalsIgnoreCase('Contact') && !objApi.equalsIgnoreCase('Lead') && !objApi.equalsIgnoreCase('Case')) {

           Map<String, Schema.SObjectField> fldMap = Schema.getGlobalDescribe().get(objApi).getDescribe().fields.getMap();
           Schema.DescribeFieldResult desribeResult = fldMap.get('Name').getDescribe();
           if ( !desribeResult.isNillable() && !desribeResult.isDefaultedOnCreate()) {
               isAutonumber = false;
           }
       }
       system.debug('isAutonumber::::+++++====>' + isAutonumber); //api name
       system.debug('Assignment_Manager_ID__c::::+++++====>' + AMTemplate.Id); //api name

       SObject sob = Schema.getGlobalDescribe().get(objApi).newSObject();

       if (objApi.equalsIgnoreCase('Contact')) {
             sob.put('lastname', 'Contact '+System.now());
           insert sob;
       } else if (objApi.equalsIgnoreCase('Lead')) {
           sob.put('lastname', 'Lead '+System.now());
           sob.put('Company', 'Company '+System.now());
           insert sob;
       } else {

         sob.put('Name', AMTemplate.ExAM__Issue_request__c);
         sob.put('Assessment_Template_Type__c', AMTemplate.ExAM__Assessment_Template_Type__c);

         insert sob;
       }

       ExAM__IssueRequest_Life_Cycle__c am = new ExAM__IssueRequest_Life_Cycle__c();
       am.Additional_Status__c = 'Open';
       am.ExAM__Issue_request__c = AMTemplate.ExAM__Issue_request__c;
       am.ExAM__InvestigationType__c = AMTemplate.ExAM__InvestigationType__c;
       am.put('AM_' + objApi,  sob.Id);
       //am.AM_User__c = user;
       am.ExAM__Issue_request__c = amDesc;
       insert am;
       ExAM__Public_Assessment__c pa = new ExAM__Public_Assessment__c();
       pa.ExAM__Assignment_Manager__c = am.Id;

       insert pa;
       system.debug('amDesc::::+++++====>' + pa.ExAM__Public_Assessment_Link__c);
       // am.Public_Assessment_URL__c = 'hgjhgjhg';
       // upsert am;


       String query = 'SELECT ';
       String fields = 'ExAM__Public_Assessment_URL__c';

       query += fields +' FROM ExAM__Public_Assessment__c WHERE  Id = \'' + pa.Id + '\' ORDER BY CreatedDate DESC LIMIT 100';


       ExAM__Public_Assessment__c pANew = new ExAM__Public_Assessment__c();


       pANew = Database.query(query);

       system.debug('amDesc::::+++++====>' + pANew.ExAM__Public_Assessment_URL__c);
       am.Public_Assessment_URL__c = pANew.ExAM__Public_Assessment_URL__c;
       sob.put('Public_Assessment_URL__c', pANew.ExAM__Public_Assessment_URL__c);
       sob.put('Additional_Status__c', am.Additional_Status__c);
       sob.put('Assignment_Manager_ID__c',  am.Id);
       pANew.put('PA_' + objApi, sob.Id);
       pANew.ExAM__Assignment_Manager__c = am.Id;
       upsert pANew;
       upsert am;
       upsert sob;


       return am;
   }


    public static List<sobject> getObjList (String objApi, String objFields, String objFilter, String objOrder) {

        try{
          List<sobject> objList = new List<sobject>();
          system.debug('obj.objFields::::+++++====>' + objFields);

            if (objApi != null && objFields != null)
              {

                if(objApi == null || objFields == null){
                			throw new AuraHandledException('Malformed parameters');
                		}
                		List<fieldWrapper> fieldList = (List<fieldWrapper>) JSON.deserialize(objFields, List<fieldWrapper>.class);
                		if(fieldList == null){
                			throw new AuraHandledException('No Fields');
                		}
                DescribeSObjectResult describeObj = Schema.getGlobalDescribe().get(objApi).getDescribe();
            		Map<String,Schema.SObjectField> fieldsMap = describeObj.fields.getMap();
            		String objectName = describeObj.getName();
            		String queryFields = '';
                  for(fieldWrapper wrapper: fieldList){
              			String fieldName = wrapper.fieldApi;
              			if(!fieldsMap.containsKey(fieldName)){
              				continue;
              			}
              			queryFields += fieldName+',';
              		}

            		queryFields = queryFields.removeEnd(',');
              String objFieldStr;

              system.debug('obj.for::::+++++====>' + queryFields);
              FieldLevelSecurity.checkFieldAccessByCriteria(queryFields, 'view', objApi);

              String query = 'SELECT ' + queryFields + ' FROM ' + objApi;

              objFilter = objFilter.contains('%currentuser%') ? objFilter.replace('%currentuser%', '\'' + UserInfo.getUserId() + '\''): objFilter;
              query = objFilter != null ? query += ' WHERE ' + objFilter: query;
              query = objOrder != null ? query += ' ORDER BY ' + objOrder : query;

              system.debug('getObjListquery::::+++++====>' + query);
              //ToDo Remove!/////
              // query += ' LIMIT 5';
              ///////////////////


              objList = Database.query(query);
              system.debug('objList::::+++++====>' + objList);

              }

            return objList;

            }

            catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }

    }
    public with sharing class fieldWrapper {
    		public String fieldLabel;
    		public String fieldApi;
        public Boolean fieldDisplay;
        public String fieldValue;
      }

    public class WrapperFieldSet{

        @AuraEnabled
        public String fieldApi;
        @AuraEnabled
        public String fieldDataType;
        @AuraEnabled
        public String fieldLabel;
        @AuraEnabled
        public String sObjectApi;
        @AuraEnabled
        public List<String> options;

        public WrapperFieldSet(String fieldApi, String fieldDataType, List<String> options, String fieldLabel, String sObjectApi){
            this.fieldApi = fieldApi;
            this.fieldDataType = fieldDataType;
            this.options = options;
            this.fieldLabel = fieldLabel;
            this.sObjectApi = sObjectApi;
        }

    }


    public class WrapperAttachment{
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String ContentType;
        public WrapperAttachment(String Name, String Id, String ContentType){
            this.Name = Name;
            this.Id = Id;
            this.ContentType = ContentType;
        }

    }

}
