/**
 * Class containing tests for SurveyParticipantTriggerHelper
 */
@IsTest public class SurveyParticipantTriggerHelperTest{
    @IsTest(SeeAllData=true) static void testCreateSurveyParticipant() {    
        Test.startTest();
        Profile ps = [select id, name from Profile where name = 'System Administrator'];        
        User admin = [SELECT Id FROM user WHERE profileid = :ps.id AND IsActive = true LIMIT 1];
        List<Survey_Particpant__c> lsparts = new List<Survey_Particpant__c>();
        List<Survey_Particpant__c> lsuparts = new List<Survey_Particpant__c>();
        for(Integer i=0; i<20; i++){
            Survey_Particpant__c part = new Survey_Particpant__c();
            part.Survey_Identifier__c = string.valueOf(i);
            lsparts.add(part);
          }
          
        System.runas(admin){
         INSERT lsparts;
         System.Assert(lsparts != null);        
        }
        
        for(Survey_Particpant__c updatePart: lsparts){
            updatePart.Is_A_B_Testing_Toggle_Enabled__c = true;
            updatePart.Office_or_Facility__c = 'Other';
            lsuparts.add(updatePart);
        }
        
        UPDATE lsuparts;
        
       Test.stopTest();
   }
}