public with sharing class ObjServiceAura {

  @AuraEnabled
   public static ExAM__IssueRequest_Life_Cycle__c createNewAObj(ExAM__IssueRequest_Life_Cycle__c AMTemplate, String objApi, String objLabel) {
     system.debug('createNewAObj::::+++++====>' + AMTemplate); //api name

     ExAM__IssueRequest_Life_Cycle__c obj = ObjService.createNewAObj(AMTemplate, objApi, objLabel);

     return obj;

    }

    @AuraEnabled
    public static List<sobject> getObjList(String objApi, String objFields, String objFilter, String objOrder) {

        List<sobject> obList = ObjService.getObjList(objApi, objFields, objFilter, objOrder);

        return obList;
    }
    @AuraEnabled
    public static sObject updateRecord(String ObjectName, String id, String fieldName, String fieldVal){
          sObject obj = ObjService.updateRecord(ObjectName, id, fieldName, fieldVal);
          return obj;
      }
    // @AuraEnabled
    // public static Main_questionaire__c archiveAssessment(Main_questionaire__c selAssessment){
    //
    //     selAssessment = ObjService.archieveAssessment(selAssessment);
    //     return selAssessment;
    // }

   }
