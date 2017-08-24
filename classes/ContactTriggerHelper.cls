/**
 * Copyright (c) - Millsapps, Ballinger & Associates (MB&A)
 * All rights reserved.
 * You may only use this code and the application associated with it in conjunction with a valid subscription or license agreement with Millsapps, Ballinger and Associates. 
 * Any use of this code in whole or in part is prohibited including modification, copying in whole or in part or distributing it to any third party.    
 * Please see the full license agreement at http://info.mbaoutcome.com/app-terms-of-service
**/

public class ContactTriggerHelper{
    
    private List<Contact> newItems;
    private Map<Id,Contact> newMap;
    
    private List<Contact> oldItems;
    private Map<Id,Contact> oldMap;
    
    public ContactTriggerHelper(List<Contact> newItems,Map<Id,Contact> newMap, List<Contact> oldItems, Map<Id,Contact> oldMap){
        this.newItems = newItems;
        this.newMap = newMap;
        this.oldItems = oldItems;
        this.oldMap = oldMap;
    }
    
    public void SendNotificationstoAdmin(){        
        Id holdAccount = Id.valueOf(System.Label.Holding_Account_Id);
        List<Messaging.SingleEmailMessage> lsemails = new List<Messaging.SingleEmailMessage>();
        
            if(newItems != null){
                for( Contact c : newItems){                   
                  System.debug(c.Account);
                  System.debug(c.AccountId);
                   System.debug(holdAccount);
//                   if((c.Account != '' && c.Account != null && c.Account == holdAccount)){
                     if((c.AccountId != null)){
                       /**Account Id of the contact matches to the holding account. Send Notification email to the users**/
                       Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();                        
                       List<String> emailList = new List<String>();
                       emailList = System.Label.Community_Admin_EmaiL.Split(';');
                       if(emailList.size() > 0){
                        mail.setToAddresses(emailList);
                        mail.setSubject('New Community User has signed up in the Holding Account');               
                        String contactURL  = System.Label.Standard_URL +  c.Id;
                        String body = 'Please sign in to assign ' + c.FirstName + ' ' +c.LastName + ' to the right account ';
                        body = body + contactURL;
                        mail.setHtmlBody(body);
                        lsemails.add(mail);                        
                    }
                   }
                }
            }
        
        
        if(lsemails != null && lsemails.size() > 0) { 
            if(System.Label.Send_Account_Email != null && System.Label.Send_Account_Email != '' && System.Label.Send_Account_Email == '1')             
              Messaging.sendEmail(lsemails);
        }
    }
    
    public void updateAccountinAssignmentAndResponse(){
            List<ExAM__IssueRequest_Life_Cycle__c> lsUpAssignments = new List<ExAM__IssueRequest_Life_Cycle__c>();
            Id holdAccount = Id.valueOf(System.Label.Holding_Account_Id);
            Map<Id, Contact> mapUpHoldingContacts = new Map<Id, Contact>();
            Map<Id, Id> mapContactAccountIds = new Map<Id,Id>();
            Map<Id,Id> mapUserContactId = new Map<Id, Id>();
            Map<Id,Id> mapAssignmentAccounts = new Map<Id,Id>();
    
           if(newItems != null){
                for( Contact c : newItems){      
                  Id oldAccountId =  oldMap.get(c.Id).AccountId;
                  if((oldAccountId == holdAccount) && (oldAccountId != c.AccountId))
                  {
                      mapUpHoldingContacts.put(c.Id, c);
                      mapContactAccountIds.put(c.Id, c.AccountId);
                  }                  
                }
        
                     /*Find the assignment managers assigned to the user and update the answers with the correct account*/
                    List<User> lsUser = [Select u.Id,u.ContactId from User u where u.ContactId = :mapUpHoldingContacts.KeySet()];            
                    if( lsUser != null && lsUser.size() > 0 )            
                    {
                       for(User u :lsUser){
                            mapUserContactId.put(u.Id, u.ContactId);
                        }
                        Set<Id> userIds = new Set<Id> (new Map<Id,User>(lsUser).keySet());
                        List<ExAM__IssueRequest_Life_Cycle__c> lsAssignments = new List<ExAM__IssueRequest_Life_Cycle__c>();
                        lsAssignments = [SELECT Id, OwnerId FROM ExAM__IssueRequest_Life_Cycle__c WHERE OwnerId IN : userIds AND ExAM__Facility_Name__c =:holdAccount];
                        for(ExAM__IssueRequest_Life_Cycle__c asm : lsAssignments) {
                            String contactId = mapUserContactId.get(asm.OwnerId);                            
                            String accountId;
                            if(contactId != null){
                                accountId = mapContactAccountIds.get(contactId);
                            }
                            
                            ExAM__IssueRequest_Life_Cycle__c asNew = asm;
                            asNew.ExAM__Facility_Name__c = accountId;
                            lsUpAssignments.add(asNew); 
                            mapAssignmentAccounts.put(asNew.Id, asNew.ExAM__Facility_Name__c);
                        }
                      
                    
                    if(lsUpAssignments.size() > 0 ){
                        UPDATE lsUpAssignments;
                    }
                    
                    List<ExAM__Questionnaire_Response__c> lsUpDateQuestions = new List<ExAM__Questionnaire_Response__c>();
                    List<ExAM__Questionnaire_Response__c> lsQuestions = new List<ExAM__Questionnaire_Response__c>();
     
                     lsQuestions = [SELECT Id, ExAM__Account_to_Response__c,ExAM__Issue_Request__c FROM ExAM__Questionnaire_Response__c WHERE ExAM__Issue_Request__c IN : mapAssignmentAccounts.keyset()];
                     for(ExAM__Questionnaire_Response__c asm : lsQuestions) {
                     String qaccountId;
                      qaccountId = mapAssignmentAccounts.get(asm.ExAM__Issue_Request__c);
                     ExAM__Questionnaire_Response__c asNew = asm;
                     asNew.ExAM__Account_to_Response__c = qaccountId;
                     lsUpDateQuestions.add(asNew); 
                     
                     }
                  
                     if(lsUpDateQuestions.size() > 0 ){
                        UPDATE lsUpDateQuestions;
                    }                    
                 }
           }
    }
}