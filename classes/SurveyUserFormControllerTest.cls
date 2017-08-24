@IsTest()
public class SurveyUserFormControllerTest {
    
   public static testMethod void testCommUser()
   {
   	 	String newUserName;   
        Account acc= new Account(name='test account');
        Database.insert( acc );
        Contact c=new Contact(AccountId = acc.id, lastname = 'lastname');insert c;

       //Create user
//        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
       Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Strategic Community%' Limit 1];
        newUserName = System.now().millisecond() + 'test12345@test.com';
        
        User user1 = new User(
            Username = newUserName,
            ContactId = c.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            //Adding since Federation ID is a required field on user.
            FederationIdentifier = '123456*'
        );
        Database.insert(user1);
       

       system.assert(user1.contactid == c.Id, 'User doesn\'t have a contact setup');
			User lstUser = [Select Id, Profile.Name, ContactId from User where username = :newUserName];
           system.debug('lstUser ContactId = ' + lstUser.ContactId);
           try{
	           Contact con = [SELECT id from Contact WHERE id = :lstUser.ContactId];
           }
           catch(Exception ex){
               system.assert(false, 'cannot open the user contactid');
           }

       system.runAs(user1){   
           
            ExAM__IssueRequest_Life_Cycle__c lc = new ExAM__IssueRequest_Life_Cycle__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(lc);
            SurveyUserFormController sufc = new SurveyUserFormController(sc);
            
            Main_questionaire__c tem=new Main_questionaire__c(Template_name__c='template1');
            insert tem;
           
          	sufc.save();
            sufc.cancel();
     	}  
     }

    
       public static testMethod void testStdUser()
   {

   	 	String newUserName;   
        Account acc= new Account(name='test account');
        Database.insert( acc );
        Contact c=new Contact(AccountId = acc.id, lastname = 'lastname');insert c;

       //Create user
//        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
       Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%System Administrator%' Limit 1];
        newUserName = System.now().millisecond() + 'test12345@test.com';
        
        User user1 = new User(
            Username = newUserName,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            //Adding since Federation ID is a required field on user.
            FederationIdentifier = '123456*'
        );
        Database.insert(user1);
       

       system.runAs(user1){   
           
            ExAM__IssueRequest_Life_Cycle__c lc = new ExAM__IssueRequest_Life_Cycle__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(lc);
            SurveyUserFormController sufc = new SurveyUserFormController(sc);
            
            Main_questionaire__c tem=new Main_questionaire__c(Template_name__c='template1');
            insert tem;
           
           	sufc.save();
            sufc.cancel();
           
     	}  
     }
}