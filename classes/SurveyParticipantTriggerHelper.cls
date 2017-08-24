/**
 * Copyright (c) - Millsapps, Ballinger & Associates (MB&A)
 * All rights reserved.
 * You may only use this code and the application associated with it in conjunction with a valid subscription or license agreement with Millsapps, Ballinger and Associates. 
 * Any use of this code in whole or in part is prohibited including modification, copying in whole or in part or distributing it to any third party.    
 * Please see the full license agreement at http://info.mbaoutcome.com/app-terms-of-service
**/

public class SurveyParticipantTriggerHelper{
    
    private List<Survey_Particpant__c> newItems;
    private Map<Id,Survey_Particpant__c> newMap;
    
    private List<Survey_Particpant__c> oldItems;
    private Map<Id,Survey_Particpant__c> oldMap;
    
    public SurveyParticipantTriggerHelper(List<Survey_Particpant__c> newItems,Map<Id,Survey_Particpant__c> newMap, List<Survey_Particpant__c> oldItems, Map<Id,Survey_Particpant__c> oldMap){
        this.newItems = newItems;
        this.newMap = newMap;
        this.oldItems = oldItems;
        this.oldMap = oldMap;
    }    
    
    
    public void UpdateDistrictVISNMapping(){
        Map<String, District_VISN_Mapping__mdt> mapDistVISN = new Map<String, District_VISN_Mapping__mdt>();
        List<District_VISN_Mapping__mdt> lsMap = [SELECT facility__c, District__C, VISN__c FROM District_VISN_Mapping__mdt];
        
        for(District_VISN_Mapping__mdt dvisn : lsMap){
            mapDistVISN.put(dvisn.facility__c, dvisn);
        }

        for(Survey_Particpant__c  sPart: newItems){  
             System.Debug(sPart);      
             System.Debug(mapDistVISN);
             if(sPart.Office_or_Facility__c != null){
                 System.Debug(sPart.Office_or_Facility__c);
                 District_VISN_Mapping__mdt local = mapDistVISN.get(sPart.Office_or_Facility__c);
                  System.Debug(local);
                 if(local != null){
                     sPart.District__c = local.District__c;
                     sPart.VISN__c = local.VISN__c;
                 }
             }
        }
    }
}