/**
 * An apex page controller that generates WordDoc from data record
 */
@IsTest 
public with sharing class MyVACommunityControllerExtensionTest {
    @IsTest      
    public static void MyVACommunityControllerExtensionTest() {
        MyVACommunityControllerExtension controller = new MyVACommunityControllerExtension(new ApexPages.StandardController(new MyVA_Community__c()));
     
        PageReference pageRef = controller.records();  
        
        //Beginning of System Asserts, verify pageRef and URL First
        System.assertNotEquals(null,pageRef);
        System.assertEquals('/apex/MyVACommunityPrintView',pageRef.getUrl());
    
        //Verify the pageRef parameters as well
        Map<String,String> pageParameters = pageRef.getParameters();
        System.assertEquals(0,pageParameters.values().size());
       
        // Create and insert an account
        Account acc = new Account(name='TestClient');
        insert acc;

        //Create and insert a contact
        Contact con = new Contact(FirstName = 'TestConFN', LastName = 'TestConLN', Email='test@testing.com', Title='Director', AccountId=acc.Id);
        insert con;
        
        //Create and insert a MyVA Community
        MyVA_Community__c myva = new MyVA_Community__c 
                (Community_Name__c = 'TestCommunity', City__c = 'Los Angeles', 
                 State__c = 'CA', Name_of_Existing_Group__c = 'ExistingGroup', 
                 Georgraphy__c='geography', VA_District__c='Pacific', Milestone_2_Co_Chairs__c='In Progress',
                 Milestone_3_Board_Members__c='In Progress', Milestone_4_1st_Board_Meeting_Scheduled__c = Date.valueOf('2015-10-01'),
                 Milestone_5_1st_public_Forum_Scheduled__c= Date.valueOf('2015-11-20'), Charter__c='Yes', 
                 Collaboration__c='collaboration', State_VA_Office_Engagement__c='No', State_DVA_POC__c='theContact',
                 Next_Steps__c='These are next steps');
        insert myva;
        
        //Create and insert a Community Contact for MyVA Community
        Community_Contacts__c comCont = new Community_Contacts__c (MyVA_Community__c = myva.Id, Contact__c= con.Id, 
                 role__c ='VHA Board Member');
        
        insert comCont;
        
        // Verify that the success page displays
        System.assertEquals('/apex/MyVACommunityPrintView',pageRef.getUrl());
        Community_Contacts__c[] content = [Select c.id, c.name, contact__r.name, contact__r.email, contact__r.title, c.contact__c, c.role__c, c.myva_community__c from community_contacts__c c WHERE c.Id !=NULL];
        

        MyVACommunityControllerExtension controllerTest = new MyVACommunityControllerExtension(new ApexPages.StandardController(myva));     
        pageRef = controllerTest.records();  
        controllerTest.getContent();

        //Test.stopTest();
        
        // Verify
        System.assertEquals('test@testing.com', content[0].contact__r.email);
        System.assertEquals('VHA Board Member', content[0].role__c);
        System.assertEquals('TestConFN TestConLN', content[0].contact__r.name);
        System.assertEquals('Director', content[0].contact__r.title);
        System.assertEquals(content.size() !=0, true);
    }    

}