@IsTest(SeeAllData = true)
public cLass  ContactTriggerHelperTest{
      @IsTest(SeeAllData = true)
      public static void testCommunitiesRegistration() {
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            
        // Current Id by Charu 12/2015 = 001t0000003jE4M
        // Replacing with NCA 10/2016 = 00135000002kn0W
        Id AccountId = Id.ValueOf(System.label.Holding_Account_Id); 
            
        System.debug('==== accountID line13: ' + accountID);
        
        //Validate that the holding account Id is valid
        Account tstAcct ;
        try {            
 		        tstAcct = [SELECT Id FROM Account WHERE Id = :AccountId limit 1];
            }
            catch(Exception Ex){
                system.debug('ignoring empty account list to allow assert for test.');
                system.assert(false, 'The label Holding_Account_Id doesn\'t contain a valid account id');
            }
        system.assert(tstAcct.Id == AccountId, 'The label Holding_Account_Id('+AccountId +') doesn\'t contain a valid account id ('+tstAcct.Id+')\n Fix this to continue testing');

        // 2nd account for testing 
        // 
        // 10/2016 - use OIT for 2 account test
        Account secondAccount = [SELECT Id from Account where Id != :AccountId limit 1];
             
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        System.debug('==== tc userRole id: ' + r.Id);
        
        Profile pf = [SELECT Id,Name from profile WHERE name = 'Strategic Community' LIMIT 1];        
        
        Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId= AccountId, email='test@force.com');        
        INSERT con;
        
        User u2 = new User(contactId=con.Id, username=con.Email, firstname=con.FirstName, 
        lastname=con.LastName, email=con.Email, communityNickname = con.Email, 
        alias = string.valueof(con.FirstName.substring(0,1) + con.LastName.substring(0,1)), profileid = pf.Id, 
        //userRoleId = r.id, 
        emailencodingkey='UTF-8',
        //Adding Federation Identifier because it is required on a user.  kd 
        FederationIdentifier = '123456*',                  
        languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles');
        System.debug('==== UserRoleId: ' + u2.UserRoleId);
        System.debug('==== ContactId: ' + u2.ContactId);
            
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail= false;
        Database.saveresult sr = Database.insert(u2, dlo);
            if(!sr.isSuccess()){
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                   
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        system.assert(sr.isSuccess(), 'Failed inserting the new user');
        System.debug('==== dlo line 32: ' + dlo);
            
          
        Account holdac = [SELECT Id, name FROM Account WHERE Id = :AccountId LIMIT 1];
            system.runAs(u2){
                // create an ExAM__IssueRequest_Life_Cycle__c

                ExAM__Main_questionaire__c maintest=new ExAM__Main_questionaire__c (ExAM__Template_name__c =System.Label.X20_Veterans_Benefits_OBPI_Survey_Template_Name);
		        insert maintest; 

                ExAM__IssueRequest_Life_Cycle__c ilc = new ExAM__IssueRequest_Life_Cycle__c(ExAM__Status__c = 'Completed', ExAM__Facility_Name__c=AccountId,ExAM__InvestigationType__c=maintest.id);
                insert(ilc);

                ExAM__Section_Template__c sc= new ExAM__Section_Template__c(ExAM__Questionnaire_Section__c=maintest.id,ExAM__Section_label__c='test section'); 
		        insert sc;
                
                ExAM__Question_Template__c scq= new ExAM__Question_Template__c(ExAM__Section_Question__c=sc.id,ExAM__Question_Label__c='What is your name?',ExAM__Question_Order_No__c=1,ExAM__Question_Type__c='Text',ExAM__Focus_category__c='CCTV',ExAM__Weight_of_Answer__c='4');     
                insert scq;
                
                ExAM__Questionnaire_Response__c responseObject=new ExAM__Questionnaire_Response__c(ExAM__Response__c='John', ExAM_Service_Line__c='313 Baltimore', ExAM_Service_Line_Grouping__c='North Atlantic District',ExAM__Question_Template__c=scq.id,ExAM__Account_to_Response__c=AccountId,ExAM__Issue_Request__c=ilc.id);
		        insert responseObject;
            }
            
		// Switch to second account on 10/2016
//            Account ac = [SELECT Id FROM Account WHERE Id = :AccountId LIMIT 1];
        Account ac = [SELECT Id FROM Account WHERE Id = :secondAccount.Id LIMIT 1];
        System.debug('==== ac: '+ ac);
        if(ac!= null){
            con.AccountId = ac.Id;
            //con.id = u2.ContactId;
            System.debug('==== ac.id: ' + ac.id);
            System.debug('==== u2.Contactid: ' + u2.ContactId);
            System.debug('==== u2.userRoleid: ' + u2.userRoleId);
            UPDATE con;
            
        }
        
      }
    }
}