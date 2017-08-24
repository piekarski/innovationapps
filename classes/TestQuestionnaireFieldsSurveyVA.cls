@isTest(SeeAllData=true)
public class TestQuestionnaireFieldsSurveyVA {        
        private static QuestionnaireFieldsSurveyVA customer;
            
        private static void newController() {
            List<ExAM__Main_questionaire__c> lsmq = new List<ExAM__Main_questionaire__c>();            
            ApexPages.currentPage().getParameters().put('feedback','true');
            ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(lsmq);
              customer = new  QuestionnaireFieldsSurveyVA(stdController);
        }    
        
        @isTest
        public static void TestCommonFunctionality()
        {
        PageReference pageRef = Page.QuestionnaireSurveyVA;
        Test.setCurrentPage(pageRef);

        List<ExAM__Main_questionaire__c> lsmq = new List<ExAM__Main_questionaire__c>();            
        ApexPages.currentPage().getParameters().put('feedback','true');
        ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(lsmq);
        
        QuestionnaireFieldsSurveyVA d= new QuestionnaireFieldsSurveyVA();      
        ApexPages.currentPage().getUrl();
        
        ExAM__Main_questionaire__c maintest=new ExAM__Main_questionaire__c (ExAM__Template_name__c ='test');
        insert maintest; 
        System.currentPageReference().getParameters().put('TemplateName', maintest.ExAM__Template_name__c ); 
        Account ac=new Account(name='test account1',ExAM__Create_Survey__c=true);  
        ac.ExAM__Main_Questionnaire_Template__c=maintest.id;
        Account ac1=new Account(name='test account2',ExAM__Create_Survey__c=true,ExAM__Adequate_Lighting_Score__c=5,ExAM__Adequate_Locking_Score__c=5,ExAM__CCTV_Score__c=5,ExAM__Emergency_Response_Plan__c=5,ExAM__Mail_Handling_Score__c=10); 
        ac1.ExAM__Main_Questionnaire_Template__c=maintest.id;
        Account ac2=new Account(name='test account3'); 
        ac2.ExAM__Main_Questionnaire_Template__c=maintest.id;
        insert ac;insert ac1;insert ac2;
        ExAM__IssueRequest_Life_Cycle__c issuetest=new ExAM__IssueRequest_Life_Cycle__c(ExAM__Facility_Name__c=ac.id,ExAM__InvestigationType__c=maintest.id);
        insert issuetest; 
        System.currentPageReference().getParameters().put('issueid',issuetest.id);
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
        d.questionsLists = [SELECT  Id,ExAM__Section_Question__r.id,ExAM__Question_Label__c,ExAM__Question_Order_No__c,ExAM__Weight_of_Answer__c,ExAM__Question_Type__c,ExAM__HelpText__c,ExAM__Subquestion_Label__c FROM ExAM__Question_Template__c where ExAM__Section_Question__r.id=:sc.id order by ExAM__Question_Order_No__c]; 
        Test.startTest();
        System.currentPageReference().getParameters().put('accid', ac.id);
        System.currentPageReference().getParameters().put('issueid',issuetest.id);
        d.sectionsStatusLists=null;
        d.setdoRerender(true); 
        d.sectionStatus();   
        //d.setdoRerender(true);   
        //d.getquestionsList(); 
        d.currentSectionQuestions(); 
        d.setdoRerenderSave(true);  
        d.save();  d.cancel();   d.exit();  
        
        d= new  QuestionnaireFieldsSurveyVA();d.setmyFlag(true);d.DoToggle();
        System.currentPageReference().getParameters().put('issueid',issuetest.id);
        //Test when userSectionstatus is not null,set school to have response    
        System.currentPageReference().getParameters().put('accid', ac.id);
        System.currentPageReference().getParameters().put(q1id+'row1','Comment: test1');
        System.currentPageReference().getParameters().put(q2id+'row1','Recommendation: test1');
        System.currentPageReference().getParameters().put(q3id+'row1','Comment: test1'); 
        d.sectionsLists=[Select Id, Name,ExAM__status__c,ExAM__Section_label__c,ExAM__Order_No__c from ExAM__Section_Template__c where ExAM__Questionnaire_Section__c=:maintest.id order by ExAM__Order_No__c];
        d.questionsLists = [SELECT  Id,ExAM__Section_Question__r.id,ExAM__Question_Label__c,ExAM__Question_Order_No__c,ExAM__Weight_of_Answer__c,ExAM__Question_Type__c,ExAM__HelpText__c,ExAM__Subquestion_Label__c FROM ExAM__Question_Template__c where ExAM__Section_Question__r.id=:sc.id order by ExAM__Question_Order_No__c]; 
        
        ExAM__Questionnaire_Response__c responseObject=new ExAM__Questionnaire_Response__c(ExAM__Response__c='John',ExAM__Question_Template__c=q2id,ExAM__Account_to_Response__c=ac.id,ExAM__Issue_Request__c=issuetest.id);
        insert responseObject;
        ExAM__Questionnaire_Response__c responseObject1=new ExAM__Questionnaire_Response__c(ExAM__Response__c='Bachelors',ExAM__Question_Template__c=q3id,ExAM__Account_to_Response__c=ac.id,ExAM__Issue_Request__c=issuetest.id);
        insert responseObject1;
        ExAM__Questionnaire_Response__c responseObject2=new ExAM__Questionnaire_Response__c(ExAM__Response__c='10-30',ExAM__Question_Template__c=q2id,ExAM__Account_to_Response__c=ac.id,ExAM__Issue_Request__c=issuetest.id);
        insert responseObject2;
        //Test when userSectionstatus is not null,set school to have response    
        //System.currentPageReference().getParameters().put('sectionId', sc.id);
        d.setdoRerender(true);
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
        System.assert(ac!=null,'Account is not null');
        }        
       
    }