@isTest /*(SeeAllData=false)*/
private class VACI_HA_Status_Tracker_ControllerTEST {
    static testMethod void validate_VACI_HA_Status_Tracker_Controller(){
        
        Profile myProfile = [Select Id From Profile where Name = 'System Administrator'];  
        UserRole myRole = [Select Id From UserRole where Name = 'Architect'];

        User testUser = new User(
            alias             = 'testAlias',
            email             = 'testEmail@test.com',
            emailencodingkey  = 'UTF-8',
            LastName          = 'Testing',
            languagelocalekey = 'en_US',
            LocaleSidKey      = 'en_US',
            profileid         = myProfile.Id, 
            UserRoleId        = myRole.Id,
            timezonesidkey    = 'America/Los_Angeles', 
            username          = 'UserName1');

        VACI_HA_Position__c p = new VACI_HA_Position__c();
            p.Title__c        = 'Test Position';
            p.PD_Number__c    = '1234';
            p.Status__c       = 'Open';
            insert p;

        VACI_HA_Request__c r = new VACI_HA_Request__c ();
            r.Number_of_Vacancies_to_be_Filled__c = 2;
            r.Department__c                       = 'MyVA Veterans Experience';
            r.Position__c                         = p.Id;
            r.Approving_Official__c               = 'Tom Allin';
            r.Hiring_Manager__c                   = testUser.Id;
            r.Liaison__c                          = testUser.Id;
            r.Status__c                           = 'Hiring Action Initiated';
            r.Date_Approved__c                    = date.Today();
            insert r;
        
        PageReference pl = new PageReference('/r.Id');
        pl.getParameters().put('id', r.Id);
        Test.setCurrentPage(pl);

        VACI_HA_Status_Tracker_Controller st = new VACI_HA_Status_Tracker_Controller(new ApexPages.StandardController(r));
            System.assertEquals(r.Id, st.request.Id);
            System.debug('st.request.Id+++++++'+st.request.Id);

            System.assertEquals(0, st.currentStep);
            System.debug('st.currentStep++++++'+st.currentStep);
    }
}