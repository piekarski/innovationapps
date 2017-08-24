/**
* Copyright (c) - Millsapps, Ballinger & Associates (MB&A)
* All rights reserved.
* You may only use this code and the application associated with it in conjunction with a valid subscription or license agreement with Millsapps, Ballinger and Associates. 
* Any use of this code in whole or in part is prohibited including modification, copying in whole or in part or distributing it to any third party.    
* Please see the full license agreement at http://info.mbaoutcome.com/app-terms-of-service
**/

public class AGPSurveyParticipantHelper {    
    private List<AGPSurveyParticipant__c> newItems;
    private Map<Id,AGPSurveyParticipant__c> newMap;    
    private List<AGPSurveyParticipant__c> oldItems;
    private Map<Id,AGPSurveyParticipant__c> oldMap;
    
    public AGPSurveyParticipantHelper(List<AGPSurveyParticipant__c> newItems,Map<Id,AGPSurveyParticipant__c> newMap, List<AGPSurveyParticipant__c> oldItems, Map<Id,AGPSurveyParticipant__c> oldMap){
        this.newItems = newItems;
        this.newMap = newMap;
        this.oldItems = oldItems;
        this.oldMap = oldMap;
    }
    
    public void CreateAssignments(){
        List<ExAM__IssueRequest_Life_Cycle__c > lsAssignments = new List<ExAM__IssueRequest_Life_Cycle__c>();
        for(AGPSurveyParticipant__c  sPart: newItems){        
            ExAM__IssueRequest_Life_Cycle__c   newAssignment = new ExAM__IssueRequest_Life_Cycle__c();
            newAssignment.AM_AGPSurveyParticipant__c = sPart.Id;
            if(System.Label.Trigger_Assignment_template!= null){
                newAssignment.ExAM__InvestigationType__c = System.Label.AGP_Survey_Trigger_Assignment_template;
            }            
            
            lsAssignments.add(newAssignment);
        }
        
        System.Debug('List of Assignments');
        System.Debug(lsAssignments);
        INSERT lsAssignments;
    }    
    
}