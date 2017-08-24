/**
 * Copyright (c) - Millsapps, Ballinger & Associates (MB&A)
 * All rights reserved.
 * You may only use this code and the application associated with it in conjunction with a valid subscription or license agreement with Millsapps, Ballinger and Associates. 
 * Any use of this code in whole or in part is prohibited including modification, copying in whole or in part or distributing it to any third party.    
 * Please see the full license agreement at http://info.mbaoutcome.com/app-terms-of-service
**/
@isTest
public class TestShareAMwithStrategicPMAcctTrigger{

    static testMethod void method1(){
    
         // Setup test data
        // This code runs as the system user
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        Profile pr = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User adminUser = new User(Alias = 'standt', Email='systemadmintestuser@va.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = pr.Id, userroleid = r.Id,
                                  TimeZoneSidKey='America/Los_Angeles', UserName='systemadmintestuser@va.com');
        
        
        System.runAs(adminUser) {
    
            Id p = [select id from profile where UserLicense.Name='Customer Community Plus Login'][0].id;
            
            if( p != NULL ) {            
                Account acct = new Account(name ='Test Account') ;
                insert acct; 
               
                Contact con = new Contact(LastName ='testCon',AccountId = acct.Id);
                insert con;  
                          
                User portalUser = new User(alias = 'test123', email='test123@noemail.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                        ContactId = con.Id,
                        timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
               
                insert portalUser; 
                
                Account acct2 = new Account(name ='Test Account') ;
                insert acct2;    
                
                System.assertEquals('Test Account', acct2.name);
                 
                ExAM__IssueRequest_Life_Cycle__c testAM = new ExAM__IssueRequest_Life_Cycle__c( ExAM__Facility_Name__c = acct2.Id );
                insert testAM;   
                
                Account acct3 = new Account(Id = acct2.Id, Strategic_Partnership_Manager__c = portalUser.Id ) ;
                update acct3; 
                
                System.assertEquals(portalUser.Id, acct3.Strategic_Partnership_Manager__c);
                                                    
            }
       }
    }
}