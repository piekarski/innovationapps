@isTest(SeeAllData = true)
public class TestITRMSurveyController {        
        private static ITRMSurveyController customer;        
     
        public static void newController() {
            List<ExAM__Main_questionaire__c> lsmq = new List<ExAM__Main_questionaire__c>();            
            ApexPages.currentPage().getParameters().put('feedback','true');
            ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(lsmq);
            customer = new  ITRMSurveyController(stdController);
        }    
        
        @isTest
        public static void TestCommonFunctionality(){
            PageReference pageRef = Page.ITRMSurvey;
            Test.setCurrentPage(pageRef);
    
            List<ExAM__Main_questionaire__c> lsmq = new List<ExAM__Main_questionaire__c>();            
            ApexPages.currentPage().getParameters().put('feedback','true');
            ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(lsmq);
            
            ITRMSurveyController d= new ITRMSurveyController();      
            ApexPages.currentPage().getUrl();
            
            String templateName = System.Label.ITRM_Customer_Feedback_Template_Name;
			system.assert(templateName != null, 'The label ITRM_Customer_Feedback_Template_Name should be definid for testing');
            if(templateName == null) {
                templateName = 'test';
            }
            ExAM__Main_questionaire__c maintest=new ExAM__Main_questionaire__c (ExAM__Template_name__c =templateName);
//KAL - Org10052016            ExAM__Main_questionaire__c maintest=new ExAM__Main_questionaire__c (ExAM__Template_name__c ='test');
            insert maintest; 
            System.currentPageReference().getParameters().put('TemplateName', maintest.ExAM__Template_name__c ); 
            Account ac=new Account(name='test account1',ExAM__Create_Survey__c=true);  
            ac.ExAM__Main_Questionnaire_Template__c=maintest.id;
            Account ac1=new Account(name='test account2',ExAM__Create_Survey__c=true,ExAM__Adequate_Lighting_Score__c=5,ExAM__Adequate_Locking_Score__c=5,ExAM__CCTV_Score__c=5,ExAM__Emergency_Response_Plan__c=5,ExAM__Mail_Handling_Score__c=10); 
            ac1.ExAM__Main_Questionnaire_Template__c=maintest.id;
            Account ac2=new Account(name='test account3'); 
            ac2.ExAM__Main_Questionnaire_Template__c=maintest.id;
            insert ac;insert ac1;insert ac2;
            //KAL - try using class method ExAM__IssueRequest_Life_Cycle__c issuetest=new ExAM__IssueRequest_Life_Cycle__c(ExAM__Facility_Name__c=ac.id,ExAM__InvestigationType__c=maintest.id);
            //insert issuetest;
            d.CreateAssignmentManager();
            String issueTestId = d.issueId;
            // END KAL 

//KAL - use Class issueId            System.currentPageReference().getParameters().put('issueid',issuetest.id);
            System.currentPageReference().getParameters().put('issueid',issueTestId);
            //Test when userSectionstatus is null  when survey is not taken yet or started   
            System.currentPageReference().getParameters().put('accId', ac.id);
            
            ExAM__Section_Template__c sc= new ExAM__Section_Template__c(ExAM__Questionnaire_Section__c=maintest.id,ExAM__Section_label__c='test section'); 
            insert sc;
            ExAM__Section_Template__c sc1= new ExAM__Section_Template__c(ExAM__Questionnaire_Section__c=maintest.id,ExAM__Section_label__c='test section 2'); 
            insert sc1;
            System.currentPageReference().getParameters().put('sectionId', sc.id);
            ExAM__Question_Template__c scq= new ExAM__Question_Template__c(ExAM__Section_Question__c=sc.id,ExAM__Question_Label__c='What is your name?',ExAM__Question_Order_No__c=1,ExAM__Question_Type__c='Text',ExAM__Focus_category__c='CCTV',ExAM__Weight_of_Answer__c='4');     
            ExAM__Question_Template__c scqp= new ExAM__Question_Template__c(ExAM__Section_Question__c=sc.id,ExAM__Question_Label__c='What is your age?',ExAM__Question_Order_No__c=2,ExAM__Question_Type__c='RadioPicklist',ExAM__Subquestion_Label__c='10-30~31-50',ExAM__Focus_category__c='Perimeter',ExAM__Weight_of_Answer__c='2~3');     
            ExAM__Question_Template__c scqm= new ExAM__Question_Template__c(ExAM__Section_Question__c=sc.id,ExAM__Question_Label__c='What is your qualification?',ExAM__Question_Order_No__c=3,ExAM__Question_Type__c='MultiselectPicklist',ExAM__Subquestion_Label__c='High School~Bachelors~Masters',ExAM__Focus_category__c='Emergency Response Plan',ExAM__Weight_of_Answer__c='2~3~4');     
            
            insert scq;insert scqp;insert scqm;
            String q1id=scq.id;
            String q2id=scqp.id;
            String q3id=scqm.id;
            
            System.currentPageReference().getParameters().put(q1id+'row1','Comment: test1');
            System.currentPageReference().getParameters().put(q2id+'row1','Recommendation: test1');
            System.currentPageReference().getParameters().put(q3id+'row1','Comment: test1');      
            
            
            d.sectionsLists=[Select Id, Name,ExAM__status__c,ExAM__Section_label__c,ExAM__Order_No__c from ExAM__Section_Template__c where ExAM__Questionnaire_Section__c=:maintest.id order by ExAM__Order_No__c];
            d.questionsLists = [SELECT  Id,ExAM__Section_Question__r.id,ExAM__Question_Label__c,ExAM__Question_Order_No__c,ExAM__weight_of_Answer__c,ExAM__Question_Type__c,ExAM__HelpText__c,ExAM__Subquestion_Label__c FROM ExAM__Question_Template__c where ExAM__Section_Question__r.id=:sc.id order by ExAM__Question_Order_No__c]; 
            Test.startTest();
            System.currentPageReference().getParameters().put('accid', ac.id);
//KAL - use Class issueId                        System.currentPageReference().getParameters().put('issueid',issuetest.id);
            System.currentPageReference().getParameters().put('issueid',issueTestId);
            d.sectionsStatusLists=null;
            d.setdoRerender(true);
            //KAL Adding to try to get issueid
            d.saveContinue();
            //End KAL
            d.sectionStatus();   
            //d.setdoRerender(true);   
            //d.getquestionsList(); 
            d.currentSectionQuestions(); 
            d.setdoRerenderSave(true);  
            d.save();  d.exit();  
            
            d= new ITRMSurveyController();d.setmyFlag(true);d.DoToggle();
//KAL - use Class issueId             System.currentPageReference().getParameters().put('issueid',issuetest.id);
            System.currentPageReference().getParameters().put('issueid',issueTestId);
            //Test when userSectionstatus is not null,set school to have response    
            System.currentPageReference().getParameters().put('accid', ac.id);
            System.currentPageReference().getParameters().put(q1id+'row1','Comment: test1');
            System.currentPageReference().getParameters().put(q2id+'row1','Recommendation: test1');
            System.currentPageReference().getParameters().put(q3id+'row1','Comment: test1'); 
            d.sectionsLists=[Select Id, Name,ExAM__status__c,ExAM__Section_label__c,ExAM__Order_No__c from ExAM__Section_Template__c where ExAM__Questionnaire_Section__c=:maintest.id order by ExAM__Order_No__c];
            system.assert(d.sectionsLists.size() > 0, 'No sections are defined for this exam questionaire');
            d.questionsLists = [SELECT  Id,ExAM__Section_Question__r.id,ExAM__Question_Label__c,ExAM__Question_Order_No__c,ExAM__Weight_of_Answer__c,ExAM__Question_Type__c,ExAM__HelpText__c,ExAM__Subquestion_Label__c FROM ExAM__Question_Template__c where ExAM__Section_Question__r.id=:sc.id order by ExAM__Question_Order_No__c]; 
            system.assert(d.questionsLists.size() > 0, 'No questions are defined for this exam questionaire');
            
/*KAL - use Class issueId  
            ExAM__Questionnaire_Response__c responseObject=new ExAM__Questionnaire_Response__c(ExAM__Response__c='John',ExAM__Question_Template__c=q2id,ExAM__Account_to_Response__c=ac.id,ExAM__Issue_Request__c=issuetest.id);
            insert responseObject;
            ExAM__Questionnaire_Response__c responseObject1=new ExAM__Questionnaire_Response__c(ExAM__Response__c='Bachelors',ExAM__Question_Template__c=q3id,ExAM__Account_to_Response__c=ac.id,ExAM__Issue_Request__c=issuetest.id);
            insert responseObject1;
            ExAM__Questionnaire_Response__c responseObject2=new ExAM__Questionnaire_Response__c(ExAM__Response__c='10-30',ExAM__Question_Template__c=q2id,ExAM__Account_to_Response__c=ac.id,ExAM__Issue_Request__c=issuetest.id);
            insert responseObject2;
END KAL - use Class issueId  */

			ExAM__Questionnaire_Response__c responseObject=new ExAM__Questionnaire_Response__c(ExAM__Response__c='John',ExAM__Question_Template__c=q2id,ExAM__Account_to_Response__c=ac.id,ExAM__Issue_Request__c=issueTestId);
            insert responseObject;
            ExAM__Questionnaire_Response__c responseObject1=new ExAM__Questionnaire_Response__c(ExAM__Response__c='Bachelors',ExAM__Question_Template__c=q3id,ExAM__Account_to_Response__c=ac.id,ExAM__Issue_Request__c=issueTestId);
            insert responseObject1;
            ExAM__Questionnaire_Response__c responseObject2=new ExAM__Questionnaire_Response__c(ExAM__Response__c='10-30',ExAM__Question_Template__c=q2id,ExAM__Account_to_Response__c=ac.id,ExAM__Issue_Request__c=issueTestId);
            insert responseObject2;
            //Test when userSectionstatus is not null,set school to have response    
            //System.currentPageReference().getParameters().put('sectionId', sc.id);
            d.setdoRerender(true);
            //ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = : templateLists.get(0).Id)

            List < ExAM__Section_Template__c > sectionsLists=[Select Id, Name,ExAM__status__c,ExAM__Section_label__c,ExAM__Order_No__c from ExAM__Section_Template__c where ExAM__Questionnaire_Section__c=:maintest.id order by ExAM__Order_No__c];
            system.assert(sectionsLists.size() > 0, 'No sections are defined for this exam questionaire');

            ExAM__SectionStatus__c[] SectionStatus = [Select id, ExAM__Section_Template__c, ExAM__Section_Template__r.id, ExAM__Section_Template__r.ExAM__Section_Label__c, ExAM__Section_Template__r.ExAM__Order_No__c, ExAM__Section_Template__r.ExAM__Questionnaire_Section__c, ExAM__Status__c, ExAM__User__c, ExAM__Issue_Request__c from ExAM__SectionStatus__c WHERE (ExAM__Section_Template__c != null AND ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = : maintest.Id)];
                //system.assert(SectionStatus.size() > 0, SectionStatus.size() + ' section status records are defined for this exam questionaire');
            if(SectionStatus != null){
            	system.debug('SectionStatus list has ' + SectionStatus.size());
                
                for(ExAM__SectionStatus__c ss : SectionStatus){
             //       system.assert(ss.ExAM__Issue_Request__c == issueTestId, 'IR (' + ss.ExAM__Issue_Request__c + ') != issueTestId(' + issueTestId + '(');
                    //system.debug('ExAM__Issue_Request__c = ' + ss.ExAM__Issue_Request__c + ' ExAM__Section_Template__c = ' + ss.ExAM__Section_Template__c + ' ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = ' + ss.ExAM__Section_Template__r.ExAM__Questionnaire_Section__c) ;               
                }
            }            
            List < ExAM__Main_questionaire__c > templateList = [Select Id, Name, ExAM__Template_name__c from ExAM__Main_questionaire__c where ExAM__Template_name__c = : templateName];
//            system.assert(templateList.size() == 0, 'templateList has ' + templateList.size() + ' records and first one is ' + templateList.get(0).ExAM__Template_name__c);
            
//KAL - use Class issueId              ExAM__SectionStatus__c[] userSectionStatus = [Select id, ExAM__Section_Template__c, ExAM__Section_Template__r.id, ExAM__Section_Template__r.ExAM__Section_Label__c, ExAM__Section_Template__r.ExAM__Order_No__c, ExAM__Section_Template__r.ExAM__Questionnaire_Section__c, ExAM__Status__c, ExAM__User__c, ExAM__Issue_Request__c from ExAM__SectionStatus__c where ExAM__Issue_Request__c = : issuetest.Id AND(ExAM__Section_Template__c != null) AND(ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = : maintest.Id) order by ExAM__Section_Template__r.ExAM__Order_No__c];
            ExAM__Section_Template__c sc3= new ExAM__Section_Template__c(ExAM__Questionnaire_Section__c=maintest.id,ExAM__Section_label__c='test section 4'); 
            insert sc3;
            System.currentPageReference().getParameters().put('sectionId', sc3.id);
            ExAM__Question_Template__c scq3= new ExAM__Question_Template__c(ExAM__Section_Question__c=sc3.id,ExAM__Question_Label__c='What is your name?',ExAM__Question_Order_No__c=1,ExAM__Question_Type__c='Text',ExAM__Focus_category__c='CCTV',ExAM__Weight_of_Answer__c='4');     
            insert scq3;
           
            ExAM__SectionStatus__c[] userSectionStatus = [Select id, ExAM__Section_Template__c, ExAM__Section_Template__r.id, ExAM__Section_Template__r.ExAM__Section_Label__c, ExAM__Section_Template__r.ExAM__Order_No__c, ExAM__Section_Template__r.ExAM__Questionnaire_Section__c, ExAM__Status__c, ExAM__User__c, ExAM__Issue_Request__c from ExAM__SectionStatus__c where ExAM__Issue_Request__c = : issueTestId AND(ExAM__Section_Template__c != null) AND(ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = : maintest.Id) order by ExAM__Section_Template__r.ExAM__Order_No__c];
           	//system.assert(userSectionStatus.size() > 0, 'SectionStatus records should exist at this point');
                        
           	ExAM__Section_Template__c[] sectionList = [Select Id, Name, ExAM__status__c, ExAM__Section_label__c, ExAM__Order_No__c from ExAM__Section_Template__c where ExAM__Questionnaire_Section__c = : templateList.get(0).Id order by ExAM__Order_No__c];
           	//system.assert(userSectionStatus.size() ==0 || userSectionStatus.size() != sectionList.size(), ' user SectionStatus can\'t match sections list count ' + userSectionStatus.size() + ' = ' + sectionList.size());
            
            d.sectionStatus();
            //d.getquestionsList();
            d.currentSectionQuestions(); 
            d.save();
            QuestionnaireFields2.QuestionDisplay qd=new QuestionnaireFields2.QuestionDisplay (d.questionsLists[0]);
            
            d.save();
            ExAM__Section_Template__c sc2= new ExAM__Section_Template__c(ExAM__Questionnaire_Section__c=maintest.id,ExAM__Section_label__c='test section 3'); 
            insert sc2;
            System.currentPageReference().getParameters().put('sectionId', sc2.id);
            ExAM__Question_Template__c scq1= new ExAM__Question_Template__c(ExAM__Section_Question__c=sc2.id,ExAM__Question_Label__c='What is your name?',ExAM__Question_Order_No__c=1,ExAM__Question_Type__c='Text',ExAM__Focus_category__c='CCTV',ExAM__Weight_of_Answer__c='4');     
            insert scq1;
            d.sectionStatus();
            //d.getquestionsList();
            d.currentSectionQuestions(); d.save();
            d.submitForApproval();
            d.message = 'test';
            d.acc = ac;
            d.templateId = 'test';
            d.QuestionResponse = new List < ExAM__Questionnaire_Response__c > {responseObject1};
            Boolean bool1 = d.getdoRerender();
            Boolean bool2 = d.getdoRerenderSave();
            Boolean bool3 = d.ShouldDisplay ;
            Boolean bool4 = d.ShouldDisplayApproval;
            Test.stopTest();        
            //assert results
            System.assert(ac!=null,'Account should not be null');
        }
        
        @isTest
        public static void TestSavefunctionality()
        {
            PageReference pageRef = Page.ITRMSurvey;
            Test.setCurrentPage(pageRef);
            newController();
            Boolean isrender = customer.getdoRerender();
            Boolean isrenderSave = customer.getdoRerenderSave();
            String templateId = customer.templateId;
            String sectionId = customer.sectionId;
            String message = customer.message;
            String templateName =  System.Label.ITRM_Customer_Feedback_Template_Name;
            System.Debug(templateName);
            Account testAcc = customer.acc;
            
            customer.CreateAssignmentManager();         
            customer.currentSectionQuestions();
            customer.sectionStatus();
           
            customer.Save();           
            customer.exit();
 
        }
    	@isTest
    	public static void TestSaveContinuefunctionality()
        {
            PageReference pageRef = Page.ITRMSurvey;
            Test.setCurrentPage(pageRef);
            newController();
            Boolean isrender = customer.getdoRerender();
            Boolean isrenderSave = customer.getdoRerenderSave();
            String templateId = customer.templateId;
            String sectionId = customer.sectionId;
            String message = customer.message;
            String templateName =  System.Label.ITRM_Customer_Feedback_Template_Name;
            System.Debug(templateName);
            Account testAcc = customer.acc;
            
            customer.CreateAssignmentManager();         
            customer.currentSectionQuestions();
            customer.sectionStatus();
           
            customer.savecontinue();           
            customer.exit();     
        }
        
    }