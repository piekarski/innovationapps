@isTest
public class TestBasicReport{

      public static testMethod void testgetSections(){
      
         BasicReportController b= new BasicReportController();
         
         Test.setCurrentPageReference(new PageReference('Page.BasicReport'));
         
         ExAM__Main_questionaire__c maintest = new ExAM__Main_questionaire__c (ExAM__Template_name__c ='Coordinated Safe and Healthy School Assessment Practices');
         insert maintest; 
         //System.currentPageReference().getParameters().put('TemplateName', maintest.Template_name__c ); 
         
         Account ac = new Account(name='test account1',ExAM__Create_Survey__c=true);  
         ac.ExAM__Main_Questionnaire_Template__c = maintest.id; 
         insert ac;
         
         System.currentPageReference().getParameters().put('accId', ac.id); 
         
         ExAM__IssueRequest_Life_Cycle__c issuetest = new ExAM__IssueRequest_Life_Cycle__c(ExAM__Facility_Name__c = ac.id, ExAM__Investigation_Type__c = 'Coordinated Safe and Healthy School Assessment Practices');
         insert issuetest; 
         
         System.currentPageReference().getParameters().put('issueid', issuetest.id);
         System.currentPageReference().getParameters().put('TemplateName',maintest.ExAM__Template_name__c ); 
         
         ExAM__Section_Template__c sc = new ExAM__Section_Template__c(ExAM__Questionnaire_Section__c = maintest.id, ExAM__Section_label__c = 'test section'); 
         insert sc;
         
         ExAM__Section_Template__c sc1 = new ExAM__Section_Template__c(ExAM__Questionnaire_Section__c = maintest.id, ExAM__Section_label__c = 'test section 2'); 
         insert sc1;
         
         ExAM__Question_Template__c scq = new ExAM__Question_Template__c(ExAM__Section_Question__c = sc.id, ExAM__Question_Label__c = 'What is your name?', ExAM__Question_Order_No__c = 1, ExAM__Question_Type__c = 'Text', ExAM__Focus_category__c='CCTV');     
         ExAM__Question_Template__c scqp = new ExAM__Question_Template__c(ExAM__Section_Question__c = sc.id, ExAM__Question_Label__c = 'What is your age?', ExAM__Question_Order_No__c = 2, ExAM__Question_Type__c = 'RadioPicklist', ExAM__Weight_Of_Question__c = 4, ExAM__Subquestion_Label__c='10-30~31-50', ExAM__Focus_category__c = 'Perimeter');     
         ExAM__Question_Template__c scqm = new ExAM__Question_Template__c(ExAM__Section_Question__c = sc.id, ExAM__Question_Label__c = 'What is your qualification?', ExAM__Question_Order_No__c = 3, ExAM__Question_Type__c = 'MultiselectPicklist', ExAM__Subquestion_Label__c = 'High School~Bachelors~Masters', ExAM__Focus_category__c = 'Emergency Response Plan');     
         ExAM__Question_Template__c scqp1 = new ExAM__Question_Template__c(ExAM__Section_Question__c = sc.id, ExAM__Question_Label__c = 'What is your age?', ExAM__Question_Order_No__c = 4, ExAM__Question_Type__c = 'RadioPicklist', ExAM__Weight_Of_Question__c = 2, ExAM__Subquestion_Label__c = '10-30~31-50', ExAM__Focus_category__c = 'Adequate Lighting');     
         ExAM__Question_Template__c scqm1 = new ExAM__Question_Template__c(ExAM__Section_Question__c = sc.id, ExAM__Question_Label__c = 'What is your qualification?', ExAM__Question_Order_No__c = 5, ExAM__Question_Type__c = 'MultiselectPicklist', ExAM__Subquestion_Label__c = 'High School~Bachelors~Masters', ExAM__Focus_category__c = 'Adequate Locking System');     
         ExAM__Question_Template__c scqp2 = new ExAM__Question_Template__c(ExAM__Section_Question__c = sc.id, ExAM__Question_Label__c = 'What is your age?', ExAM__Question_Order_No__c = 6, ExAM__Question_Type__c = 'RadioPicklist', ExAM__Weight_Of_Question__c = 4, ExAM__Subquestion_Label__c = '10-30~31-50', ExAM__Focus_category__c = 'Mail Handling');     
      
         insert scq; insert scqp; insert scqm; insert scqp1; insert scqm1; insert scqp2;
         
         //sc=[Select id from Section_Template__c limit 1];
                
         //List<Section> scAlls = new List<Section>();  
         
         Test.startTest();
         
         b.sectionStatus();
         System.assert(ac != null, 'Response data with questions not found');
         Test.stopTest();
     } 
 }