/**
 * Copyright (c) - Millsapps, Ballinger & Associates (MB&A)
 * All rights reserved.
 * You may only use this code and the application associated with it in conjunction with a valid subscription or license agreement with Millsapps, Ballinger and Associates. 
 * Any use of this code in whole or in part is prohibited including modification, copying in whole or in part or distributing it to any third party.    
 * Please see the full license agreement at http://info.mbaoutcome.com/app-terms-of-service
**/

public class DecisionTreeConfigController {
    
    //public Questionnaire_Response__c
    
    //Map <string, Schema.SObjectField> answerFieldNameAPIMap = Schema.SObjectType.Questionnaire_Response__c.fields.getMap();
    public String fieldsList {get; set;}
    
    public Map<integer, List<answerFieldDetailClass>> rowwithListOfAnswerMap { get; set; }
    public Map<integer, integer> rowwithSizeofColumn { get; set; }
    
    public Class answerFieldDetailClass {
        public String fieldAPIName { get; set; }
        public String fieldLabelName { get; set; }    
    }
    
    public DecisionTreeConfigController() {
        
        fieldsList = '';
        rowwithListOfAnswerMap = new Map<integer, List<answerFieldDetailClass>>();
        rowwithSizeofColumn = new Map<integer, integer> ();
        
        Map <string, Schema.SObjectField> answerFieldNameAPIMap = Schema.SObjectType.Questionnaire_Response__c.fields.getMap();
        integer rowcount = 1;
        integer columncount = 1;
        for (Schema.SObjectField ansfield : answerFieldNameAPIMap.values()) {
        
            Schema.DescribeFieldResult res = ansfield.getdescribe();
            System.debug(':>:::'+res.getName()+ ':::::'+String.valueOf(res.getType()).touppercase());
           
            if (res.isCustom() && res.getCalculatedFormula() == null && ((String.valueOf(res.getType()).touppercase() == 'STRING' ) ||
                    (String.valueOf(res.getType()).touppercase() == 'TEXTAREA') || (String.valueOf(res.getType()).touppercase() == 'PICKLIST'))) {
                
                answerFieldDetailClass anscls = new answerFieldDetailClass ();
                anscls.fieldAPIName = res.getName();
                anscls.fieldLabelName = res.getLabel();
                
                if( !rowwithListOfAnswerMap.containsKey(rowcount)) {
                    rowwithListOfAnswerMap.put(rowcount, new List<answerFieldDetailClass>());
                }
                rowwithListOfAnswerMap.get(rowcount).add(anscls);
                rowwithSizeofColumn.put(rowcount, columncount);
                
                columncount++;
                if (columncount > 2) {
                    rowcount++;
                    columncount = 1;
                }
                
            } 
        }
        
        answerFieldDetailClass anscls = new answerFieldDetailClass ();
        anscls.fieldAPIName = 'Pictures';
        anscls.fieldLabelName = 'Pictures';
        
        if( !rowwithListOfAnswerMap.containsKey(rowcount)) {
            rowwithListOfAnswerMap.put(rowcount, new List<answerFieldDetailClass>());
        }
        rowwithListOfAnswerMap.get(rowcount).add(anscls);
        rowwithSizeofColumn.put(rowcount, columncount);
        
        System.debug(':::::::rowwithListOfAnswerMap::::'+rowwithListOfAnswerMap);
        
        List<Configuration__c> configurationList = [ SELECT Id, Name, Decision_Tree__c 
                                                       FROM Configuration__c 
                                                       WHERE Name = 'Configuration'];
                                                       
        if (configurationList != null && configurationList.size() > 0 && configurationList[0].Decision_Tree__c != null) {
            fieldsList = configurationList[0].Decision_Tree__c; 
        }
        
        
    }
    
    @RemoteAction
    public static string saveDecisionTreeConfig(String fieldslist) {
        system.debug(':::::fieldslist:::::'+fieldslist);
        String resultMsg = '';
        if (fieldslist != null && fieldslist != '') {
            
            try {
                Configuration__c decisionTreeUpsert = new Configuration__c();
                
                List<Configuration__c> configurationList = [SELECT Id, Name, Decision_Tree__c FROM Configuration__c WHERE Name = 'Configuration'];
                if (configurationList != null && configurationList.size() > 0) {
                    decisionTreeUpsert.Id = configurationList[0].Id;
                }
                decisionTreeUpsert.Name = 'Configuration';
                decisionTreeUpsert.Decision_Tree__c = fieldslist;
                upsert decisionTreeUpsert;
                resultMsg = 'success';
            } catch (Exception e) {
                System.debug(':::e::::'+e.getMessage());
                resultMsg = e.getMessage();
            }
        }        
        return resultMsg;
    }
}