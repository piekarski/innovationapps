public class AssignmentTriggerHelper 
{
    
    private List<ExAM__IssueRequest_Life_Cycle__c> newItems;
    private Map<Id,ExAM__IssueRequest_Life_Cycle__c> newMap;
    
    private List<ExAM__IssueRequest_Life_Cycle__c> oldItems;
    private Map<Id,ExAM__IssueRequest_Life_Cycle__c> oldMap;
   
    public AssignmentTriggerHelper(List<ExAM__IssueRequest_Life_Cycle__c> newItems,Map<Id,ExAM__IssueRequest_Life_Cycle__c> newMap, List<ExAM__IssueRequest_Life_Cycle__c> oldItems, Map<Id,ExAM__IssueRequest_Life_Cycle__c> oldMap){
        this.newItems = newItems;
        this.newMap = newMap;
        this.oldItems = oldItems;
        this.oldMap = oldMap;
   }
   
   public void UpdateOwner(){   
       for (ExAM__IssueRequest_Life_Cycle__c  objIssue : newItems){
           if (objIssue.ExAM__Assessor_Resource__c!= null)                
           {           
              objIssue.OwnerId= objIssue.ExAM__Assessor_Resource__c;               
           }
       }   
   }
  
    
    public void UpdateLeadScoreAndStatus(){        
          Map<Id,double> mapLeadIdScore = new Map<Id,double>();
          for (ExAM__IssueRequest_Life_Cycle__c assMang : newItems) {
              if((assMang.AM_lead__c != null) && ((assMang.ExAM__Status__c == 'Completed') || (assMang.ExAM__Status__c == 'Closed'))){
                  mapLeadIdScore.put(assMang.AM_lead__c, assMang.ExAM__Total_Score__c);
              }
          }    
        
        Lead[] leadsList = [SELECT Id, Total_Score__c, Pilot_Eligible__c FROM Lead WHERE id IN: mapLeadIdScore.keySet()];
         for (Lead le : leadsList) {
             le.Total_Score__c = mapLeadIdScore.get(le.Id) == NULL ? 0 : mapLeadIdScore.get(le.Id);
             if(le.Total_Score__c>0) {
                 le.Pilot_Eligible__c = 'Ineligible';
             }
             else{
                 le.Pilot_Eligible__c = 'Eligible';
             }
         }        
          upsert leadsList;
        
    }
    
   public void CreatePartnershipStrategicShare(){
        /*Map<Id, String> recIdandUserIdMap = new Map<Id, String>();
        List<ExAM__IssueRequest_Life_Cycle__Share> AMShareList = new List<ExAM__IssueRequest_Life_Cycle__Share>();              
        for( ExAM__IssueRequest_Life_Cycle__c AM : newItems){     
            if( AM.Strategic_Partnership_Manager__c != NULL ){              
                recIdandUserIdMap.put(AM.Id, AM.Strategic_Partnership_Manager__c);
            }
        } 
        
        System.debug('recIdandUserIdMap:::'+ recIdandUserIdMap);
        
        if( recIdandUserIdMap.size() > 0 ){     
            for( Id AMId : recIdandUserIdMap.keySet() ){            
                ExAM__IssueRequest_Life_Cycle__Share AMShare = new ExAM__IssueRequest_Life_Cycle__Share();
                AMShare.ExAM__ParentId = AMId;
                AMShare.ExAM__UserOrGroupId = (Id)( recIdandUserIdMap.get(AMId) );
                AMShare.ExAM__AccessLevel = 'Edit';               
                AMShareList.add( AMShare );        
            }
        }
        
        System.debug('AMShareList:::' + AMShareList )
        
        if( AMShareList.size() > 0 ) {          
            List<Database.SaveResult> SRList = Database.insert( AMShareList, false );           
       }*/
}

public void ValidateCustomLookUpvalue(){    
        Map <string, Schema.SObjectField> M1 = Schema.SObjectType.ExAM__IssueRequest_Life_Cycle__c.fields.getMap();
        
        Map<String, String> fieldAPIFieldLabelMap = new Map<String, String>();
        fieldAPIFieldLabelMap.put('Exam__Facility_Name__c','Account Name');
        
        for (Schema.SObjectField fld : M1.values()) {
            Schema.DescribeFieldResult res = fld.getdescribe();
            if (String.valueOf(res.getType()).touppercase() == 'REFERENCE' && res.isCustom() && res.getName().startsWithIgnoreCase('AM_')) {
                fieldAPIFieldLabelMap.put(res.getName(), res.getLabel());
            }
        }
        
            for (Exam__IssueRequest_Life_Cycle__c assMang : newItems) {
                Integer AMValueFieldcount = 0;
                List<String> fieldsLabel = new List<String>();
                for (String fieldApiName : fieldAPIFieldLabelMap.keySet()) {
                    if (assMang.get(fieldApiName) != NULL) {
                        AMValueFieldcount++;
                        fieldsLabel.add(fieldAPIFieldLabelMap.get(fieldApiName));
                    }         
                }
                if ( AMValueFieldcount > 1 ) {
                    assMang.addError('Can\'t do more than one inspection at a time. Inspection created for '+String.join(fieldsLabel,', ')+' fields.');
                } 
            }
    }


public void UpdateSurveyUrl(){
        Map<Id,Id> mapSurveyAssignment = new Map<Id,Id>();
      Map<Id,Id> mapAGPSurveyAssignment = new Map<Id,Id>();
            for (ExAM__IssueRequest_Life_Cycle__c assMang : newItems) {
                    if(assMang.AM_survey_particpant__c != null)
                        mapSurveyAssignment.put(assMang.AM_survey_particpant__c, assMang.Id);
                  if(assMang.AM_AGPSurveyParticipant__c != null)
                        mapAGPSurveyAssignment.put(assMang.AM_AGPSurveyParticipant__c, assMang.Id);
                }               
                List<Survey_Particpant__c> lsParts = new List<Survey_Particpant__c>();
                List<Survey_Particpant__c> lsUpParts =  new List<Survey_Particpant__c>();               
                lsParts = [SELECT Id, Assignment_URL__c FROM Survey_Particpant__c WHERE Id IN : mapSurveyAssignment.keySet()];
                for(Survey_Particpant__c sp :lsParts){
                    Survey_Particpant__c spUp = sp;
                    String assignmentId = mapSurveyAssignment.get(spUp.Id);            
                    If(assignmentId != null){
                        spUp.Assignment_URL__c = System.Label.Continuous_Survey_URL+assignmentId;
                        lsUpParts.add(spUp);
                    }
            }
            
            System.Debug('Test after update');
            if(lsUpParts.size() > 0){      
                System.Debug(lsUpParts);         
                UPDATE lsUpParts;
            }    
    
        List<AGPSurveyParticipant__c> lsAGParts = new List<AGPSurveyParticipant__c>();
            List<AGPSurveyParticipant__c> lsAGUpParts =  new List<AGPSurveyParticipant__c>();               
            lsAGParts = [SELECT Id, Survey_URL__c FROM AGPSurveyParticipant__c WHERE Id IN : mapAGPSurveyAssignment.keySet()];
            for(AGPSurveyParticipant__c sp :lsAGParts){
                AGPSurveyParticipant__c spUp = sp;
                String assignmentId = mapAGPSurveyAssignment.get(spUp.Id);            
                If(assignmentId != null){
                    spUp.Survey_URL__c = System.Label.Share_your_VA_Experience+assignmentId;
                    lsAGUpParts.add(spUp);
                }
            }

      if(lsAGUpParts.size() > 0){               
                UPDATE lsAGUpParts;
            }

    
}



public void CreateMappingfieldsForAnswers(){    
    List<MapAssessableObjectToAnswers__c> lsMapSurvey = [SELECT Id, CustomObjectName__c, MappingField__c, QuestionId__c,Is_It_Answer_Score__c FROM MapAssessableObjectToAnswers__c WHERE CustomObjectName__c IN ('Survey_Particpant__c','AGPSurveyParticipant__c')];
    Map<String,MapAssessableObjectToAnswers__c> mapFieldToAnswer = new Map<String, MapAssessableObjectToAnswers__c>();
    Map<String,MapAssessableObjectToAnswers__c> mapFieldToAnswerScore = new Map<String, MapAssessableObjectToAnswers__c>();
    Map<Id,Survey_Particpant__c> mapSurveyParts = new Map<Id, Survey_Particpant__c>();      
    Map<Id,AGPSurveyParticipant__c> mapAGPSurveyParts = new Map<Id, AGPSurveyParticipant__c>();      

    
    for(MapAssessableObjectToAnswers__c mSpAns : lsMapsurvey)
      {
        if(mSpAns.Is_It_Answer_Score__c){
            mapFieldToAnswerScore.put(mSpAns.QuestionId__c, mSpAns);        
        }
        else{
            mapFieldToAnswer.put(mSpAns.QuestionId__c, mSpAns);
        }
      }
    
         List<Id> surveyIds = new List<Id>();
         List<Id> agpIds = new List<Id>();
         Map<Id,Id> mapdestAssignment = new Map<Id,Id>();
         for (ExAM__IssueRequest_Life_Cycle__c assMang : newItems) {
             if((assMang.AM_survey_particpant__c != null) && ((assMang.ExAM__Status__c == 'Completed') || (assMang.ExAM__Status__c == 'Closed')))
             {
                surveyIds.add(assMang.AM_survey_particpant__c);                     
             }   
             else if((assMang.AM_AGPSurveyParticipant__c != null) && ((assMang.ExAM__Status__c == 'Completed') || (assMang.ExAM__Status__c == 'Closed')))
             {
               agpIds.add(assMang.AM_AGPSurveyParticipant__c);
             }
         }
            
            
    if (surveyIds.size() > 0){
        List<Survey_Particpant__c> lsUpParticipant = [SELECT Id, Modified_Date__c FROM Survey_Particpant__c WHERE Id in : surveyIds];             
            for(Survey_Particpant__c sp : lsUpParticipant){
                if(sp.Modified_Date__c == null){
                    sp.Modified_Date__c = Date.valueof(System.now());
                }
                mapSurveyParts.put(sp.Id, sp);
            }

            List<ExAM__Questionnaire_Response__c> lsAnswers = [SELECT Id, ExAM__Question_Template__c, ans_survey_particpant__c, ExAM__Answer_Text__c,ExAM__Response__c, ExAM__Total_Score__c  FROM ExAM__Questionnaire_Response__c WHERE ans_survey_particpant__c IN : surveyIds AND ExAM__Question_Template__c IN : mapFieldToAnswer.keySet()];
            for(ExAM__Questionnaire_Response__c qs : lsAnswers){
                Survey_Particpant__c sp = mapSurveyParts.get(qs.ans_survey_particpant__c);
                String questionField = String.valueOf(qs.ExAM__Question_Template__c);
                MapAssessableObjectToAnswers__c mapQuestion = mapFieldToAnswer.get(questionField.left(15)) != null ?mapFieldToAnswer.get(questionField.left(15)) : mapFieldToAnswer.get(questionField) ;                
                MapAssessableObjectToAnswers__c mapQuestionScore = mapFieldToAnswerScore.get(questionField.left(15)) != null ?mapFieldToAnswerScore.get(questionField.left(15)) : mapFieldToAnswerScore.get(questionField) ;
                
                if(mapQuestion != null){
                    String surveyField = mapQuestion.MappingField__c;            
                    if((surveyField != null) && (qs.ExAM__Response__c != null))
                    {                           
                        sp.put(surveyField,qs.ExAM__Response__c);                    
                        mapSurveyParts.put(sp.Id, sp);                        
                    }
                 }
                 
                if(mapQuestionScore != null){
                    String surveyField = mapQuestionScore.MappingField__c;
                    Boolean isScore = mapQuestionScore.Is_It_Answer_Score__c;
                    if((surveyField != null) && (isScore))
                    {            
                        sp.put(surveyField,qs.ExAM__Total_Score__c);
                        mapSurveyParts.put(sp.Id, sp);                        
                    }
                 }            
             
            }               

            if(mapSurveyParts.size() > 0){
            UPDATE mapSurveyParts.values();
            }
        }
    
      if (agpIds.size() > 0){
        List<AGPSurveyParticipant__c> lsAGPParticipant = [SELECT Id FROM AGPSurveyParticipant__c WHERE Id in : agpIds];             
            for(AGPSurveyParticipant__c agp : lsAGPParticipant){
                mapAGPSurveyParts.put(agp.Id, agp);
            }

            List<ExAM__Questionnaire_Response__c> lsAnswers = [SELECT Id, ExAM__Question_Template__c, AGPSurvey_Participant__c, ExAM__Answer_Text__c,ExAM__Response__c, ExAM__Total_Score__c  FROM ExAM__Questionnaire_Response__c WHERE AGPSurvey_Participant__c IN : agpIds AND ExAM__Question_Template__c IN : mapFieldToAnswer.keySet()];
            for(ExAM__Questionnaire_Response__c qs : lsAnswers){
                AGPSurveyParticipant__c sp = mapAGPSurveyParts.get(qs.AGPSurvey_Participant__c);
                String questionField = String.valueOf(qs.ExAM__Question_Template__c);
                MapAssessableObjectToAnswers__c mapQuestion = mapFieldToAnswer.get(questionField.left(15)) != null ?mapFieldToAnswer.get(questionField.left(15)) : mapFieldToAnswer.get(questionField) ;                
                MapAssessableObjectToAnswers__c mapQuestionScore = mapFieldToAnswerScore.get(questionField.left(15)) != null ?mapFieldToAnswerScore.get(questionField.left(15)) : mapFieldToAnswerScore.get(questionField) ;
                
                if(mapQuestion != null){
                    String surveyField = mapQuestion.MappingField__c;            
                    if((surveyField != null) && (qs.ExAM__Response__c != null))
                    {                           
                        sp.put(surveyField,qs.ExAM__Response__c);                    
                        mapAGPSurveyParts.put(sp.Id, sp);                        
                    }
                 }
                 
                if(mapQuestionScore != null){
                    String surveyField = mapQuestionScore.MappingField__c;
                    Boolean isScore = mapQuestionScore.Is_It_Answer_Score__c;
                    if((surveyField != null) && (isScore))
                    {            
                        sp.put(surveyField,qs.ExAM__Total_Score__c);
                        mapAGPSurveyParts.put(sp.Id, sp);                        
                    }
                 }            
             
            }               

            if(mapAGPSurveyParts.size() > 0){
            UPDATE mapAGPSurveyParts.values();
            }
        }
  }
    
}