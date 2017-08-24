@isTest()
private class VAUserSSOHandlerTest {
    
    static testMethod void testCreateAndUpdateUser() {
        
        // set up to run as an administrator user
        // 
        //--------------------------------------------------
        
        // Setup test data
        // This code runs as the system user
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        //UserRole r = [SELECT Id FROM UserRole WHERE Name='Architect'];
        User adminUser = new User(Alias = 'standt', Email='systemadmintestuser@va.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, userroleid = r.Id,
                                  TimeZoneSidKey='America/Los_Angeles', UserName='systemadmintestuser@va.com');
        
        
        System.runAs(adminUser) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            
            
            //--------------------------------------------------
            VAUserSSOHandler handler = new VAUserSSOHandler();
            User u;
            String uid;
            Id myCommunityID;
            
            //global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
            //    String federationIdentifier, Map<String, String> attributes, String assertion)
            try { 
                system.debug('Make sure internal user creation results in error and null u');
                u = handler.createUser(null, null, null,
                                       'testFederationId@va.gov', 
                                       new Map<String, String>{
                                           'User.Email' => 'testFederationId@va.gov',
                                               'User.Username' => 'testFederationId@va.gov',
                                               'User.Alias' => 'testuser',
                                               'User.LastName' =>'testLast',
                                               'User.FirstName' => 'testFirst'}, 
                                       'assertionIsIgnored'); 
                
                //system.debug(System.assertEquals(null, u));
                
            }
            Catch (Exception e) {
                System.assertEquals(null, u);
                System.debug('make sure user is null when test tries to create internal user');
                system.debug(e.getMessage());
                
                
                System.debug('Testing user signing into a community');
                Account tempAccount = new Account();
                //even though this account already exists, this test class cannot see it w/o seeAllData so creating one here
                tempAccount.Name = 'New User Holding Account'; 
                insert tempAccount;
                System.debug('Account created?' + tempAccount.Id);
                try {
                    /*----------------------------------*/
                    /* Test out community user creation */
                    Network myCommunity = [SELECT Id FROM Network WHERE Name = 'My VA'];
                    myCommunityID = myCommunity.Id;
                    system.debug('myCommunityID is' + myCommunityID);
                    
                    u = handler.createUser(null, myCommunityID, null,
                                           'testFederationId@va.gov', 
                                           new Map<String, String>{
                                               'Contact.LastName' => 'testLast',
                                                   'Contact.FirstName' => 'testFirst',
                                                   'Contact.Phone' => '2034441212',
                                                   'Contact.MailingStreet' => 'Test Street',
                                                   'Contact.MailingCity' => 'TestCity',
                                                   'Contact.MailingState' => 'Virginia',
                                                   'Contact.MailingCountry' => 'United States',
                                                   'Contact.MailingPostalCode' => '12345',
                                                   'Contact.Title' => 'Architect',
                                                   'Contact.Office__c' => 'NoOffice', 
                                                   'Contact.Email' => 'testFederationId@va.gov',
                                                   'User.Email' => 'testFederationId@va.gov',
                                                   'User.Username' => 'testFederationId@va.gov',
                                                   'User.Alias' => 'testuser',
                                                   'User.LastName' =>'testLast',
                                                   'User.FirstName' => 'testFirst'}, 
                                           'assertionIsIgnored'); 
                    If (u != null) {
                        
                        system.debug('CREATED User when Community was given');
                        System.assertEquals('testFederationId@va.gov', u.Username);
                        
                        System.assertEquals('testFederationId@va.gov', u.Email);
                        
                        System.assertEquals('testLast', u.LastName);
                        System.assertEquals('testFirst', u.FirstName);
                        System.assertEquals('testuser', u.Alias);
                        insert(u);
                        uid = u.id;
                        System.debug('USER ID CREATED is: ' + u.id);
                    }
                    //----------------------------Creating user again with some different params to hit more test cases
                    u = handler.createUser(null, myCommunityID, null,
                                           'testFederationId2@va.gov', 
                                           new Map<String, String>{
                                               'Contact.LastName' => 'testLast2',
                                                   'Contact.FirstName' => 'testFirst2',
                                                   'Contact.Phone' => '2034441212',
                                                   'Contact.MailingStreet' => 'Test Street',
                                                   'Contact.MailingCity' => 'TestCity',
                                                   'Contact.MailingState' => 'Virginia',
                                                   'Contact.MailingCountry' => 'United States',
                                                   'Contact.MailingPostalCode' => '12345',
                                                   'Contact.Title' => 'Architect',
                                                   'Contact.Office__c' => 'NoOffice', 
                                                   'Contact.Email' => 'testFederationId2@va.gov',
                                                   'User.Email' => 'testFederationId2@va.gov',
                                                   'User.Username' => 'testFederationId2@va.gov',
                                                   'User.IsActive' => 'true',
                                                   'User.ProfileId' => p.Id,
                                                   'User.Phone' => '2034441212',
                                                   'User.Street' => 'Test Street',
                                                   'User.City' => 'TestCity',
                                                   'User.State' => 'Virginia',
                                                   'User.Zip' => '12345',
                                                   'User.Title' => 'Architect',
                                                   'User.ForecastEnabled' => 'true',
                                                   'User.LastName' =>'testLast2',
                                                   'User.FirstName' => 'testFirst2'}, 
                                           'assertionIsIgnored'); 
                    If (u != null) {
                        
                        system.debug('CREATED User when Community was given');
                        System.assertEquals('testFederationId2@va.gov', u.Username);
                        
                        System.assertEquals('testFederationId2@va.gov', u.Email);
                        
                        System.assertEquals('testLast2', u.LastName);
                        System.assertEquals('testFirst2', u.FirstName);
                        //System.assertEquals('testuser2', u.Alias);
                        insert(u);
                        uid = u.id;
                        System.debug('USER ID CREATED is: ' + u.id);
                    }
                    //--------------------------End second user creation testing
                }
                catch (Exception e2) {
                    system.debug('Error testing user creation');
                    //expected error because cannot create internal user
                }
                
                
                
                
                //global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
                //    String federationIdentifier, Map<String, String> attributes, String assertion) 
                try {
                    System.debug('TEST user ID is ' + uid);
                    handler.updateUser(uid, null, myCommunityID, null, 'testFederationId@va.gov', 
                                       new Map<String, String>{
                                           'Contact.LastName' => 'testNewLast',
                                               'Contact.FirstName' => 'testNewFirst',
                                               'Contact.Phone' => '2034441212',
                                               'Contact.MailingStreet' => 'Test Street',
                                               'Contact.MailingCity' => 'TestCity',
                                               'Contact.MailingState' => 'Virginia',
                                               'Contact.MailingCountry' => 'United States',
                                               'Contact.MailingPostalCode' => '12345',
                                               'Contact.Title' => 'Architect',
                                               'Contact.Office__c' => 'NoOffice', 
                                               'Contact.Email' => 'testFederationId@va.gov',
                                               'User.Email' => 'testFederationId@va.gov',
                                               'User.Username' => 'testFederationId@va.gov',
                                               'User.Alias' => 'testuser',
                                               'User.LastName' =>'testNewLast',
                                               'User.FirstName' => 'testNewFirst'}, 
                                       'assertionIsIgnored'); 
                    system.debug('updated user, about to test assertions'); 
                    User updatedUser = [SELECT Username, Email, FirstName, LastName, Alias FROM user WHERE id=:uid];
                    
                    
                    System.assertEquals('testfederationid@va.gov', updatedUser.Username);
                    System.assertEquals('testfederationid@va.gov', updatedUser.Email);
                    System.assertEquals('testNewLast', updatedUser.LastName);
                    System.assertEquals('testNewFirst', updatedUser.FirstName);
                    //System.assertEquals('testnewu', updatedUser.Alias);
                }
                catch (Exception e3) {
                    system.debug('Error testing user update');
                    //expected error because cannot update user
                }
            }
        }
    }
    
}