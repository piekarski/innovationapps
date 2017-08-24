public with sharing class AssignmentManagerAuraController {


  //   @AuraEnabled
  //   public static List<sobject> getAObjsByCurrentUser(String objApi, String objLabel) {
  //
  //     List<sobject> AObjList = new List<sobject>();
  //     String query = 'SELECT ';
  //     String fields = 'ID, Name, Public_Assessment_URL__c, Assignment_Manager_ID__c, Assessment_Template_Type__c, CreatedDate, LastModifiedDate';
  //
  //     query += fields +' FROM '+ objApi + ' WHERE  CreatedBy.Id = \'' + UserInfo.getUserId() + '\' ORDER BY CreatedDate DESC LIMIT 100';
  //
  //     SFDCAccessController accessAObj = ExAMUtilClass.AccessController;
  //     List<string> fieldsListAObj = new List<string>{'Id', 'Name', 'CreatedDate', 'LastModifiedDate', 'Public_Assessment_URL__c', 'Assignment_Manager_ID__c', 'Assessment_Template_Type__c'};
  //     accessAObj.assertAuthorizedToView(Schema.getGlobalDescribe().get(objApi), fieldsListAObj);
  //
  //     AObjList = Database.query(query);
  //
  //     system.debug('assignmentManagerList::::+++++====>' + query); //api name
  //
  //       return AObjList;
  //       // return AMTemp;
  //   }
  //
  //
  //   @AuraEnabled
  //   public static ExAM__IssueRequest_Life_Cycle__c createNewAObj(ExAM__IssueRequest_Life_Cycle__c AMTemplate, String objApi, String objLabel) {
  //       // AMTemplate = AssignmentManagerService.createNewAM(AMTemplate);
  //       system.debug('createNewAM::::+++++====>'); //api name
  //
  //       string status = AMTemplate.ExAM__Status__c;
  //       //string user = AMTemplate.AM_User__c;
  //       string amDesc = AMTemplate.ExAM__Issue_request__c;
  //       SFDCAccessController objAccess = ExAMUtilClass.AccessController;
  //       SFDCAccessController access = ExAMUtilClass.AccessController;
  //       SFDCAccessController paAccess = ExAMUtilClass.AccessController;
  //       List<string> objFieldsListToCreate = new List<string>{'Contact_Email__c', 'Assignment_Manager_ID__c', 'Public_Assessment_URL__c'};
  //       List<string> amFieldsListToCreate = new List<string>{'ExAM__Issue_request__c', 'ExAM__Status__c'};
  //       List<string> paFieldsListToCreate = new List<string>{'ExAM__Assignment_Manager__c'};
  //       objAccess.assertAuthorizedToCreate(Schema.getGlobalDescribe().get(objApi), objFieldsListToCreate);
  //       access.assertAuthorizedToCreate(Schema.getGlobalDescribe().get('ExAM__IssueRequest_Life_Cycle__c'), amFieldsListToCreate);
  //       paAccess.assertAuthorizedToCreate(Schema.getGlobalDescribe().get('ExAM__Public_Assessment__c'), paFieldsListToCreate);
  //
  //
  //       Boolean isAutonumber = true;
  //
  //       if (!objApi.equalsIgnoreCase('Contact') && !objApi.equalsIgnoreCase('Lead') && !objApi.equalsIgnoreCase('Case')) {
  //
  //           Map<String, Schema.SObjectField> fldMap = Schema.getGlobalDescribe().get(objApi).getDescribe().fields.getMap();
  //           Schema.DescribeFieldResult desribeResult = fldMap.get('Name').getDescribe();
  //           if ( !desribeResult.isNillable() && !desribeResult.isDefaultedOnCreate()) {
  //               isAutonumber = false;
  //           }
  //       }
  //       system.debug('isAutonumber::::+++++====>' + isAutonumber); //api name
  //       system.debug('amDesc::::+++++====>' + amDesc); //api name
  //
  //         // sob.put('Name', objLabel+' '+System.now()+' - '+ cnt);
  //       SObject sob = Schema.getGlobalDescribe().get(objApi).newSObject();
  //
  //       if (objApi.equalsIgnoreCase('Contact')) {
  //             sob.put('lastname', 'Contact '+System.now());
  //           insert sob;
  //       } else if (objApi.equalsIgnoreCase('Lead')) {
  //           sob.put('lastname', 'Lead '+System.now());
  //           sob.put('Company', 'Company '+System.now());
  //           insert sob;
  //       } else {
  //           if (!isAutonumber) {
  //             sob.put('Name', objLabel+' '+System.now());
  //
  //           }
  //           sob.put('Assignment_Manager_ID__c',  amDesc);
  //           insert sob;
  //       }
  //
  //       ExAM__IssueRequest_Life_Cycle__c am = new ExAM__IssueRequest_Life_Cycle__c();
  //       am.ExAM__Status__c = status;
  //       am.ExAM__Issue_request__c = AMTemplate.ExAM__Issue_request__c;
  //       am.put('AM_' + objApi,  sob.Id);
  //       //am.AM_User__c = user;
  //       am.ExAM__Issue_request__c = amDesc;
  //       insert am;
  //       ExAM__Public_Assessment__c pa = new ExAM__Public_Assessment__c();
  //       pa.ExAM__Assignment_Manager__c = am.Id;
  //
  //       insert pa;
  //       system.debug('amDesc::::+++++====>' + pa.ExAM__Public_Assessment_Link__c);
  //       // am.Public_Assessment_URL__c = 'hgjhgjhg';
  //       // upsert am;
  //
  //
  //       String query = 'SELECT ';
  //       String fields = 'ExAM__Public_Assessment_URL__c';
  //
  //       query += fields +' FROM ExAM__Public_Assessment__c WHERE  Id = \'' + pa.Id + '\' ORDER BY CreatedDate DESC LIMIT 100';
  //
  //
  //       ExAM__Public_Assessment__c PANew = new ExAM__Public_Assessment__c();
  //
  //       SFDCAccessController accessAObjj = ExAMUtilClass.AccessController;
  //       List<string> fieldsListAObj = new List<string>{'ExAM__Public_Assessment_URL__c'};
  //       accessAObjj.assertAuthorizedToView(Schema.getGlobalDescribe().get('ExAM__Public_Assessment__c'), fieldsListAObj);
  //
  //       PANew = Database.query(query);
  //
  //       system.debug('amDesc::::+++++====>' + PANew.ExAM__Public_Assessment_URL__c);
  //       am.Public_Assessment_URL__c = PANew.ExAM__Public_Assessment_URL__c;
  //       sob.put('Public_Assessment_URL__c', PANew.ExAM__Public_Assessment_URL__c);
  //
  //       upsert am;
  //       upsert sob;
  //
  //
  //       return am;
  //   }
  //
  //   //@AuraEnabled
  //   //public static IssueRequest_Life_Cycle__c archiveAM(IssueRequest_Life_Cycle__c am){
  //   //  system.debug('at:::+++++====>'); //api name
  //
  //   //  List<string> updatefieldList = new List<string> {'isArchive__c'};
  //    // system.debug('at.Id::::+++++====>' + am); //api name
  //     // system.debug('at.isArchive__c::::+++++====>' + am.isArchive__c); //api name
  //
  //   //  SFDCAccessController accessForobj = ExAMUtilClass.AccessController;
  //    // accessForobj.assertAuthorizedToUpdate(Schema.getGlobalDescribe().get('ExAM__IssueRequest_Life_Cycle__c'), updatefieldList );
  //    // ExAM__IssueRequest_Life_Cycle__c atUpdate = new ExAM__IssueRequest_Life_Cycle__c( Id = am.Id); // update answer submit time in "End time" 01-07-2016
  //  //   upsert atUpdate;
  //       // selAM = AMService.archiveAM(selAM);
  //     //return atUpdate;
  // //  }
  //
  //   @AuraEnabled
  //   public static String getRecord(String sObjectName, List<String> fieldSets, String sObjectId) {
  //
  //       Map<String,Object> containWrapObject = new Map<String,Object>();
  //
  //       List<sObject> objList = ExamDescribeHelper.getRecordByFieldSet(sObjectName,fieldSets,sObjectId);
  //       //List<WrapperAttachment> attachments = AttachmentService.getAMAttachmentById(sObjectId);
  //
  //       containWrapObject.put('sobject',objList);
  //       //containWrapObject.put('attachment',attachments);
  //
  //       return JSON.serialize(containWrapObject);
  //   }
  //
  //   @AuraEnabled
  //   public static String getRecordById(String sObjectName, List<String> fieldSets, String sObjectId) {
  //
  //       Map<String,List<WrapperFieldSet>> WrapperFieldSetList = new Map<String,List<WrapperFieldSet>>();
  //
  //       Map<String,Object> containWrapObject = new Map<String,Object>();
  //
  //       for(String fieldSet : fieldSets){
  //           WrapperFieldSetList.put(fieldSet,ExamDescribeHelper.getAObjFieldSetByRecord(fieldSet,sObjectName));
  //       }
  //
  //       List<sObject> objList = ExamDescribeHelper.getRecordByFieldSet(sObjectName,fieldSets,sObjectId);
  //       //List<WrapperAttachment> attachments = AttachmentService.getAObjAttachmentById(sObjectId);
  //       //system.debug('attachments::::+++++====>' + attachments); //api name
  //
  //       containWrapObject.put('fields',WrapperFieldSetList);
  //       containWrapObject.put('sobject',objList);
  //       //containWrapObject.put('attachment',attachments);
  //       system.debug('containWrapObject::::+++++====>' + containWrapObject); //api name
  //
  //       return JSON.serialize(containWrapObject);
  //   }
  //   @AuraEnabled
  //   public static sObject updateRecord(String ObjectName, String id, String fieldName, String fieldVal){
  //       sObject obj = ExamFieldEditorController.updateRecord(ObjectName, id, fieldName, fieldVal);
  //       return obj;
  //   }
  //   // @AuraEnabled
  //   // public static string saveAssignmentmanagerList(string selectedTemplateId, string AssessableObjectApi, string assessmentGroupJunctionFieldApi,
  //   //         string selectedGroupId, string selectedTemplateId, string noofrecords, string AssessableObjectApi,
  //   //         string objLabel, string assessableRecId) {
  //
  //
  //   //
  //   // public static string saveAssignmentmanagerList(string selectedTemplateId, string AssessableObjectApi) {
  //   //
  //   //     try {
  //   //         List<IssueRequest_Life_Cycle__c> insertNewAssignmentManagerList = new List<IssueRequest_Life_Cycle__c>();
  //   //         String responseMsg = '';
  //   //         Integer totalNoOfRecords = 0;
  //   //         Date expDate;
  //   //         String AMApi = 'AM_' + AssessableObjectApi;
  //   //
  //   //         // if (string.isNotBlank(assessmentGroupJunctionFieldApi) && assessmentGroupJunctionFieldApi.contains('@@')) {
  //   //         //     string expDateStr = (assessmentGroupJunctionFieldApi.split('@@').size() > 1) ? assessmentGroupJunctionFieldApi.split('@@')[1] : '';
  //   //         //     if (string.isNotBlank(expDateStr) && expDateStr.contains('/')) {
  //   //         //         expDate = date.parse(expDateStr);
  //   //         //     }
  //   //         //     assessmentGroupJunctionFieldApi = assessmentGroupJunctionFieldApi.split('@@')[0];
  //   //         // }
  //   //
  //   //         if (AMApi != null && selectedTemplateId != null && selectedTemplateId != '') {
  //   //
  //   //             SFDCAccessController accessAM = ExAMUtilClass.AccessController;
  //   //             List<String> fieldsListAM = new List<String>{'InvestigationType__c'};
  //   //             fieldsListAM.add(AMApi);
  //   //             accessAM.assertAuthorizedToCreate(Schema.getGlobalDescribe().get('IssueRequest_Life_Cycle__c'), fieldsListAM);
  //   //
  //   //             if ( AssessableObjectApi != null && AssessableObjectApi != '') {
  //   //                 Integer numberofRecords = 1;
  //   //
  //   //
  //   //                     totalNoOfRecords = numberofRecords;
  //   //                     for (integer cnt = 1; cnt <= numberofRecords; cnt++) {
  //   //                         IssueRequest_Life_Cycle__c am = new IssueRequest_Life_Cycle__c();
  //   //                         am.put('InvestigationType__c', selectedTemplateId);
  //   //                         am.put(AMApi, '');
  //   //                         insertNewAssignmentManagerList.add(am);
  //   //                     }
  //   //                     generateAM(insertNewAssignmentManagerList);
  //   //
  //   //                     // if(insertNewAssignmentManagerList.size() > 0 && insertNewAssignmentManagerList != null) {
  //   //                     //     generateAM(assignmentManagerList);
  //   //                     //     AssignmentManagerGenerator_Batch assManager = new AssignmentManagerGenerator_Batch();
  //   //                     //     assManager.assignmentManagerList = insertNewAssignmentManagerList;
  //   //                     //     assManager.objApi = AssessableObjectApi;
  //   //                     //     // assManager.objLabel = objLabel;
  //   //                     //     assManager.AMApi = AMApi;
  //   //                     //     assManager.templateId = selectedTemplateId;
  //   //                     //     assMAnager.totalNoOfRecords = totalNoOfRecords;
  //   //                     //     assManager.expDate = expDate;
  //   //                     //     Database.executeBatch(assManager,2000);
  //   //                     // }
  //   //
  //   //                 responseMsg = 'success';
  //   //             }
  //   //         }
  //   //         return responseMsg;
  //   //     } catch (Exception ex) {
  //   //         throw new CustomException(ex.getMessage(), null);
  //   //     }
  //   //     return null;
  //   // }
  //   //
  //   //
  //   //
  //   // public static generateAM(List<IssueRequest_Life_Cycle__c> assManagerList) {
  //   //
  //   //     if(assManagerList != null && assManagerList.size() > 0 && AMApi != null && AMApi != '') {
  //   //
  //   //         Savepoint sp = Database.setSavepoint();
  //   //         try {
  //   //             List<Public_Assessment__c> paList = new List<Public_Assessment__c> ();
  //   //
  //   //             if(objApi != null && objApi != '') {
  //   //
  //   //                 Integer numberofRecords = assManagerList.size();
  //   //                 Boolean isAutonumber = true;
  //   //                 List<SObject> sobList = new List<SObject>();
  //   //
  //   //                 if (!objApi.equalsIgnoreCase('Contact') && !objApi.equalsIgnoreCase('Lead') && !objApi.equalsIgnoreCase('Case')) {
  //   //
  //   //                     Map<String, Schema.SObjectField> fldMap = Schema.getGlobalDescribe().get(objApi).getDescribe().fields.getMap();
  //   //                     Schema.DescribeFieldResult desribeResult = fldMap.get('Name').getDescribe();
  //   //                     if ( !desribeResult.isNillable() && !desribeResult.isDefaultedOnCreate()) {
  //   //                         isAutonumber = false;
  //   //                     }
  //   //                 }
  //   //
  //   //                 for (integer cnt = 1; cnt <= numberofRecords; cnt++) {
  //   //                     if (objApi.equalsIgnoreCase('Contact')) {
  //   //                         SObject sob = Schema.getGlobalDescribe().get(objApi).newSObject();
  //   //                         sob.put('lastname', 'Contact '+System.now()+' - '+ cnt);
  //   //                         sobList.add(sob);
  //   //                     } else if (objApi.equalsIgnoreCase('Lead')) {
  //   //                         SObject sob = Schema.getGlobalDescribe().get(objApi).newSObject();
  //   //                         sob.put('lastname', 'Lead '+System.now()+' - '+ cnt);
  //   //                         sob.put('Company', 'Company '+System.now()+' - '+ cnt);
  //   //                         sobList.add(sob);
  //   //                     } else {
  //   //                         SObject sob = Schema.getGlobalDescribe().get(objApi).newSObject();
  //   //                         if (!isAutonumber) {
  //   //                             sob.put('Name', objLabel+' '+System.now()+' - '+ cnt);
  //   //                         }
  //   //                         sobList.add(sob);
  //   //                     }
  //   //                 }
  //   //
  //   //                 if (sobList != null && sobList.size() > 0) {
  //   //
  //   //                     insert sobList;
  //   //
  //   //                     for (Integer i=0; i< sobList.size(); i++) {
  //   //                         assManagerList[i].put(AMApi, sobList[i].Id);
  //   //                     }
  //   //
  //   //                     insert assManagerList;
  //   //                     String PAObjAssessbleField = AMApi;
  //   //                     if (AMApi.startsWithIgnoreCase('AM_')) {
  //   //                         PAObjAssessbleField = AMApi.replaceFirst('AM_','PA_');
  //   //                     }
  //   //                     for (IssueRequest_Life_Cycle__c am :assManagerList) {
  //   //                         Public_Assessment__c pa = new Public_Assessment__c();
  //   //                         pa.put('Assignment_Manager__c',am.Id);
  //   //                         /*comment for PA Object creating via AM Only
  //   //                         pa.put(PAObjAssessbleField,am.get(AMApi));
  //   //                         pa.put('Assessible_Object_ID__c',am.get(AMApi));
  //   //                         pa.put('Assessment_Template__c',am.InvestigationType__c);*/
  //   //                         pa.put('Assignment_Generator_Batch__c',assGenObjId);
  //   //                         pa.put('Expiration_Date__c', expDate);
  //   //                         paList.add(pa);
  //   //                     }
  //   //                     if (paList != null && paList.size() > 0) {
  //   //                         insert paList;
  //   //                     }
  //   //                     noOfRecordProcess =  noOfRecordProcess + assManagerList.size();
  //   //                 }
  //   //             } else {
  //   //
  //   //                 insert assManagerList;
  //   //
  //   //                 String PAObjAssessbleField = AMApi;
  //   //                 if (AMApi.startsWithIgnoreCase('AM_')) {
  //   //                     PAObjAssessbleField = AMApi.replaceFirst('AM_','PA_');
  //   //                 }
  //   //                 for (IssueRequest_Life_Cycle__c am :assManagerList) {
  //   //                     Public_Assessment__c pa = new Public_Assessment__c();
  //   //                     pa.put('Assignment_Manager__c',am.Id);
  //   //                     /*comment for PA Object creating via AM Only
  //   //                     pa.put(PAObjAssessbleField,am.get(AMApi));
  //   //                     pa.put('Assessible_Object_ID__c',am.get(AMApi));
  //   //                     pa.put('Assessment_Template__c',am.InvestigationType__c);*/
  //   //                     pa.put('Assignment_Generator_Batch__c',assGenObjId);
  //   //                     pa.put('Expiration_Date__c', expDate);
  //   //                     paList.add(pa);
  //   //                 }
  //   //                 if (paList != null && paList.size() > 0) {
  //   //                     insert paList;
  //   //                     system.debug('Entering11');
  //   //                 }
  //   //                 noOfRecordProcess =  noOfRecordProcess + assManagerList.size();
  //   //             }
  //   //         } catch(exception e) {
  //   //
  //   //             System.debug('::error::'+e.getMessage());
  //   //             errorMsg = e.getMessage();
  //   //             Database.rollback(sp);
  //   //         }
  //   //
  //   //     }
  //   // }
  //   //
  //
  //
  //
  //
  //
  //
  //   //
  //   // @AuraEnabled
  //   // public static Main_questionaire__c cloneAMTemp(String recordId, String temp_name) {
  //   //     Map<Id,String> AMWthTempName = new Map<Id,String>{recordId => temp_name};
  //   //         List<Main_questionaire__c> AMList = ExamManager.clone(AMWthTempName);
  //   //     return AMList[0];
  //   // }
  //   //
  //   //
  //   // @AuraEnabled
  //   // public static List<Section_Template__c> fetchSecTemplate(String assessementId) {
  //   //
  //   //     List<Section_Template__c> sectionTemplates = SectionService.getSectionsByAM(assessementId);
  //   //     return sectionTemplates;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static String fetchQuesTemplateWthQuestionFieldSetValue(String sObjectName, List<String> fieldSets, String sObjectId) {
  //   //
  //   //
  //   //     Map<String,Object> containWrapObject = new Map<String,Object>();
  //   //     if(!fieldSets.isEmpty()){
  //   //         Map<String,List<WrapperFieldSet>> WrapperFieldSetList = new Map<String,List<WrapperFieldSet>>();
  //   //         for(String fieldSet : fieldSets){
  //   //             WrapperFieldSetList.put(fieldSet,ExamDescribeHelper.getGrantFieldSetByRecord(fieldSet,sObjectName));
  //   //         }
  //   //         containWrapObject.put('fields',WrapperFieldSetList);
  //   //     }
  //   //
  //   //
  //   //     List<sObject> objList = ExamDescribeHelper.getRecordByFieldSet(sObjectName,fieldSets,sObjectId);
  //   //
  //   //     List<Question_Template__c> questionTemplates = (List<Question_Template__c>)objList;
  //   //     containWrapObject.put('sobject',QuestionService.filterGetNonDependentQuestions(questionTemplates));
  //   //     return JSON.serialize(containWrapObject);
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static List<String> getQuestionType(){
  //   //
  //   //     List<String> options = new List<String>();
  //   //     Schema.DescribeFieldResult fieldResult = Question_Template__c.Question_Type__c.getDescribe();
  //   //     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
  //   //
  //   //     for (Schema.PicklistEntry f: ple) {
  //   //         options.add(f.getLabel());
  //   //     }
  //   //
  //   //     return options;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static Map<String, List<Object>> createQuestionWthAnswer(Question_Template__c QuestionTemplate, Integer orderNo, List<Answer_Option__c> answerOptions){
  //   //     System.debug('QuestionTemplate:::'+QuestionTemplate);
  //   //     Map<String, List<Object>> QuestionWthAnswer = new Map<String, List<Object>>();
  //   //     Set<Id> answerOptionIds = new Set<Id>();
  //   //     List<Question_Template__c> questionTemplates = QuestionService.createQuestion(QuestionTemplate, orderNo);
  //   //     for(Answer_Option__c answer : answerOptions){
  //   //         answer.Question_Template__c = questionTemplates[orderNo].Id;
  //   //     }
  //   //
  //   //     insert answerOptions;
  //   //     QuestionWthAnswer.put('questions', QuestionService.filterGetNonDependentQuestions(questionTemplates));
  //   //     // after review this line
  //   //     for(Answer_Option__c ans : answerOptions){
  //   //         answerOptionIds.add(ans.Id);
  //   //     }
  //   //     List<Answer_Option__c> questionOptions = [SELECT Id,Name,Order_No__c,Dependent_Question__r.Name,Help_Text__c,Next_Question__r.Name,Weight__c,Question_Template__c FROM Answer_Option__c WHERE Id IN :answerOptionIds];
  //   //
  //   //     QuestionWthAnswer.put('answers', questionOptions);
  //   //
  //   //     return QuestionWthAnswer;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static List<Section_Template__c> updateSec(Section_Template__c SectionTemplate, Integer orderNo){
  //   //     List<Section_Template__c> sectionTemplates = SectionService.updateSectionTemp(SectionTemplate, orderNo);
  //   //     return sectionTemplates;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static Main_questionaire__c updateAss(Main_questionaire__c AMTemplate) {
  //   //     AMTemplate = AMService.createNewAM(AMTemplate);
  //   //     return AMTemplate;
  //   // }
  //   //
  //   //
  //   // @AuraEnabled
  //   // public static Attachment saveFile(String attachmentId, String parentId, String fileName, String base64Data, String contentType) {
  //   //
  //   //     Attachment attch = AttachmentService.saveAttachment(attachmentId, parentId, fileName, base64Data, contentType);
  //   //     attch.Body = null;
  //   //     return attch;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static String updateAttachFile(String parentId, String fileName, String base64Data, String contentType){
  //   //     String attch = AttachmentService.saveFile(parentId, fileName, base64Data, contentType);
  //   //     return attch;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static List<Attachment> fetchAttachment(String QuesId, List<String> answerOptionsId) {
  //   //
  //   //     List<Attachment> attachments;
  //   //
  //   //     if(!answerOptionsId.isEmpty()){
  //   //         attachments =  [SELECT Id, Name, ContentType, ParentId FROM Attachment WHERE ParentId IN :answerOptionsId];
  //   //     }else if(QuesId != null){
  //   //         attachments = AttachmentService.getAttachmentsByParentId(QuesId);
  //   //     }
  //   //     System.debug('attachments:::::::'+attachments);
  //   //     return attachments;
  //   // }
  //   //
  //
  //   //
  //   // @AuraEnabled
  //   // public static String getFieldSet(String sObjectName, List<String> fieldSets, String sObjectId) {
  //   //
  //   //     Map<String,List<WrapperFieldSet>> WrapperFieldSetList = new Map<String,List<WrapperFieldSet>>();
  //   //
  //   //     Map<String,Object> containWrapObject = new Map<String,Object>();
  //   //
  //   //     for(String fieldSet : fieldSets){
  //   //         WrapperFieldSetList.put(fieldSet,ExamDescribeHelper.getGrantFieldSetByRecord(fieldSet,sObjectName));
  //   //     }
  //   //     containWrapObject.put('fields',WrapperFieldSetList);
  //   //     return JSON.serialize(containWrapObject);
  //   // }
  //   //
  //
  //   //
  //   // @AuraEnabled
  //   // public static List<Section_Template__c> moveSectionUpOrDwn(String AM, Decimal index, String direction){
  //   //
  //   //     List<Section_Template__c> sectionTemplates = SectionService.moveSectionUpOrDown(AM, index, direction);
  //   //
  //   //     return sectionTemplates;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static Map<String, List<Question_Template__c>> moveQuestionToSection(String oldSectionId, String newSectionId, String direction, Decimal index, String recordId){
  //   //
  //   //     Map<String, List<Question_Template__c>> oldToNewQuestion = QuestionService.moveQuestion(oldSectionId, newSectionId, direction, index, recordId);
  //   //     return oldToNewQuestion;
  //   // }
  //   //
  //   //
  //   // @AuraEnabled
  //   // public static Map<String,List<Object>> copyQuestionTemplate(String questionId, String sectionId, String direction, Decimal index){
  //   //     Map<String,List<Object>> copyQuesAndAnswers = new Map<String,List<Object>>();
  //   //     Map<String,object> responseMap = QuestionService.copyQuestion(questionId, sectionId, direction, index);
  //   //     object objectId =  responseMap.get('newQuestionId');
  //   //     String newQuestionId =  String.valueOf(objectId);
  //   //     System.debug('newQuestionId:::::::::'+newQuestionId);
  //   //     Map<String,Answer_Option__c> answerOldIdWthNewAnswer = QuestionService.cloneAnswerOptions(questionId,newQuestionId);
  //   //     List<Question_Template__c> questionTemplates =  (List<Question_Template__c>)responseMap.get('updateRecords');
  //   //     copyQuesAndAnswers.put('copyQuestion',QuestionService.filterGetNonDependentQuestions(questionTemplates));
  //   //     copyQuesAndAnswers.put('copyAnswerOptions',(List<object>)answerOldIdWthNewAnswer.values());
  //   //     return copyQuesAndAnswers;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static sObject updateRecord(String ObjectName, String id, String fieldName, String fieldVal){
  //   //     sObject obj = ExamFieldEditorController.updateRecord(ObjectName, id, fieldName, fieldVal);
  //   //     return obj;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static Map<String,List<object>> upsertAnswer(String answerOptions, List<String> removeOptionIds, Boolean derivedFromQuestion, List<Integer> removedOptionIndices){
  //   //     Map<String,List<object>> answerOptionList = AnswerOptionService.upsertAnswerOptions(answerOptions, removeOptionIds, derivedFromQuestion, removedOptionIndices);
  //   //     System.debug('answerOptionList::::: '+answerOptionList);
  //   //     return answerOptionList;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static Map<String,List<Object>> copyQuestionWithAttachment(String questionId, String sectionId, String direction, Decimal index){
  //   //     Map<String,List<Object>> copyQuesAndAnswerWithAttachment = new Map<String,List<Object>>();
  //   //     Map<String,String> questionOldIdWthNewId;
  //   //     List<Attachment> cloneAttachments;
  //   //     Map<String,object> responseMap = QuestionService.copyQuestion(questionId, sectionId, direction, index);
  //   //     object objectId =  responseMap.get('newQuestionId');
  //   //     String newQuestionId =  String.valueOf(objectId);
  //   //     System.debug('newQuestionId:::::::::'+newQuestionId);
  //   //     Map<String,Answer_Option__c> answerOldIdWthNewAnswer = QuestionService.cloneAnswerOptions(questionId,newQuestionId);
  //   //     if(answerOldIdWthNewAnswer.isEmpty()){
  //   //         questionOldIdWthNewId = new Map<String,String>();
  //   //         questionOldIdWthNewId.put(questionId,newQuestionId);
  //   //         cloneAttachments = AttachmentService.cloneAttachmentByQuestionIds(questionOldIdWthNewId);
  //   //     }else{
  //   //         cloneAttachments = AttachmentService.cloneAttachment(answerOldIdWthNewAnswer);
  //   //     }
  //   //
  //   //     for(Attachment attach : cloneAttachments){
  //   //         attach.Body = null;
  //   //     }
  //   //     System.debug('cloneAttachments:::::::::::'+cloneAttachments);
  //   //     System.debug('responseMap::::::::::::::'+responseMap);
  //   //     List<Question_Template__c> questionTemplates =  (List<Question_Template__c>)responseMap.get('updateRecords');
  //   //     copyQuesAndAnswerWithAttachment.put('copyQuestion',QuestionService.filterGetNonDependentQuestions(questionTemplates));
  //   //     copyQuesAndAnswerWithAttachment.put('copyAnswerOptions',(List<object>)answerOldIdWthNewAnswer.values());
  //   //     copyQuesAndAnswerWithAttachment.put('copyAttachment',cloneAttachments);
  //   //     System.debug('copyQuestionWithAttachment::::::::::::::'+copyQuesAndAnswerWithAttachment);
  //   //     return copyQuesAndAnswerWithAttachment;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static List<Question_Template__c> deleteQuestionTemplate(String questionId){
  //   //     List<Question_Template__c> questionTemplate= QuestionService.deleteQuestion(questionId);
  //   //     return questionTemplate;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static Section_Template__c archiveSection(Section_Template__c section){
  //   //
  //   //     Section_Template__c sectionTemp = SectionService.archieveSection(section);
  //   //     return sectionTemp;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static Map<String, List<Section_Template__c>> moveSection(String oldAM, String newAM, String direction, Integer index, String recordId){
  //   //     System.debug('moveSection Apex Method called');
  //   //     Map<String, List<Section_Template__c>> oldToNewSection = SectionService.moveSection(oldAM, newAM, direction, index, recordId);
  //   //     return oldToNewSection;
  //   // }
  //   //
  //   // @AuraEnabled
  //   // public static Map<String, List<Object>> copySection(String toAM, String direction, Integer index, String recordId){
  //   //     Map<String, List<Object>> copySectionWithQuestionAndAttachment = SectionService.copySectionWithRelatedQuestions(toAM, direction, index, recordId);
  //   //     return copySectionWithQuestionAndAttachment;
  //   // }
}