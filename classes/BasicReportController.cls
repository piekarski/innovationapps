public with sharing class BasicReportController{

    public String templateName{get;set;}
    public String sectionId{get;set;}
    public String accountId{get;set;}
    public Account acc{get;set;}
    public String accountName{get;set;}
    public String amName{get;set;}
    public String amUser{get;set;}
    public String amType{get;set;}
    public List<ExAM__Section_Template__c > sectionsLists{ get; set; }
    public List<ExAM__Question_Template__c> questionsLists { get; set; }
    public List<ExAM__Questionnaire_Response__c> responseLists { get; set; }
    public List<ExAM__Main_questionaire__c> templateLists { get; set; }
    public List<ExAM__SectionStatus__c > sectionsStatusLists{ get; set; }
    public List<ExAM__IssueRequest_Life_Cycle__c > amInfo{ get; set; }
    public String issueId{get;set;}
    public BasicReportController(ApexPages.StandardSetController controller){ }
    public BasicReportController(){}

    public class Section
     {
         public String name {get; set;}
         public Decimal totalscore{get; set;}
         public Decimal maxtotalscore{get; set;}
         public Decimal scorepercent{get; set;}
         public List<Question> questionList {get; set;}
         public Section()
         {
         }

     }
    public class Question
     {
         public Question()
         {
         }
         public String name {get; set;}
         public String qid{get; set;}
         public String responsename {get; set;}
         public Decimal score{get; set;}
         public ExAM__Questionnaire_Response__c resObj{get;set;}
     }

     public List<Section> sectionList {get; set;}

     public void sectionStatus()
        {
            accountId=System.currentPageReference().getParameters().get('accId');//to get the school or account id
            templateName=System.currentPageReference().getParameters().get('TemplateName');
            accountName=System.currentPageReference().getParameters().get('accName');
        //System.debug('!!!!!!!!!!!!!!!!~~~~~~~~~~~~~acct id from diff page :'+accountid);
       // acc= [SELECT id,name,Main_Questionnaire_Template__c,Main_Questionnaire_Template__r.Template_name__c,Create_Survey__c From Account where id=:accountId];
            issueId= System.currentPageReference().getParameters().get('issueid');
            //System.debug('!!!!!!!!!!!!!!!!~~~~~~~~~~~~~acct id from diff page :'+accountid);
            templateLists = [Select Id, Name,ExAM__Template_name__c from ExAM__Main_questionaire__c where ExAM__Template_name__c=:templateName];
            sectionList = new List<Section>();
            if(templateLists!=NULL && templateLists.size()>=1)
             {
                 //templateName = templateLists.get(0).Name;
                 sectionsLists = [Select Id,ExAM__Section_label__c,ExAM__Order_No__c from ExAM__Section_Template__c where ExAM__Questionnaire_Section__c=:templateLists.get(0).Id order by ExAM__Order_No__c];

                 amInfo = [select ExAM_Name__c, ExAM_User__r.Name, ExAM__Assessment_Template_Type__c from ExAM__IssueRequest_Life_Cycle__c WHERE Id =: issueId];
                 amName = amInfo[0].ExAM_Name__c;
                 amUser = amInfo[0].ExAM_User__r.Name;
                 amType = amInfo[0].ExAM__Assessment_Template_Type__c;

                 //responseLists=[Select id,ExAM__Response__c,ExAM__Question_Template__c,ExAM__Account_to_Response__c,ExAM__Question_Template__r.id,ExAM__Question_Template__r.ExAM__Section_Question__r.id,ExAM__Issue_Request__c,ExAM__Total_Score__c,ExAM__Max_Score__c,(SELECT Id,Title,body,CreatedDate,Owner.FirstName,Owner.LastName FROM Notes order by CreatedDate),(Select Id, Name, LastModifiedDate From Attachments)  from ExAM__Questionnaire_Response__c where ExAM__Account_to_Response__c= :accountId AND ExAM__Issue_Request__c=:issueId] ;
                 responseLists=[Select id,ExAM__Response__c,ExAM__Question_Template__c,ExAM__Account_to_Response__c,ExAM__Question_Template__r.id,ExAM__Question_Template__r.ExAM__Section_Question__r.id,ExAM__Issue_Request__c,ExAM__Total_Score__c,ExAM__Max_Score__c,(SELECT Id,Title,body,CreatedDate,Owner.FirstName,Owner.LastName FROM Notes order by CreatedDate),(Select Id, Name, LastModifiedDate From Attachments)  from ExAM__Questionnaire_Response__c where ExAM__Issue_Request__c=:issueId] ;
                 //[SELECT Id,Name, Response__c,Account_to_Response__c,Question_Template__r.id,Question_Template__r.Section_Question__r.id,Issue_Request__c,Total_Score__c,Max_Score__c FROM Questionnaire_Response__c where Account_to_Response__c= :accountId AND Issue_Request__c=:issueId];
                 System.debug('!!!!!!!!!!!!!!!!~~~~~~~~~~~~~acct id from diff page :'+accountid+'lllllll'+responseLists);
                 for(ExAM__Section_Template__c sec: sectionsLists )
                 {
                 Section s=new Section();
                 s.name=sec.ExAM__Section_label__c;s.maxtotalscore=0;s.totalscore=0;s.scorepercent=0;
                 s.questionList =new List<Question>();
                 questionsLists = [SELECT  Id,name,ExAM__Section_Question__r.id,ExAM__Question_Label__c,ExAM__Question_Order_No__c,ExAM__Question_Type__c,ExAM__HelpText__c,ExAM__Subquestion_Label__c FROM ExAM__Question_Template__c where ExAM__Section_Question__r.id=:sec.id order by ExAM__Question_Order_No__c];

                    for(ExAM__Question_Template__c quest: questionsLists )
                     {
                         //System.debug('!!!!!question'+quest.Question_Label__c);
                         ExAM__Questionnaire_Response__c reponseObject=new ExAM__Questionnaire_Response__c();

                         Question q=new Question();
                         q.name=quest.ExAM__Question_Label__c;
                         q.qid=quest.name;
                         for(ExAM__Questionnaire_Response__c resp: responseLists)
                         {
                         //Questionnaire_Response__c reponseObject=[Select id,Response__c,Question_Template__c,Account_to_Response__c from Questionnaire_Response__c where Account_to_Response__c= :accountId AND Question_Template__c=:quest.id] ;
                         if(resp.ExAM__Question_Template__c==quest.id)
                         {
                            reponseObject=resp;System.debug('!!!!!shouldnt come here if res is 0'+resp);
                            q.score=resp.ExAM__Total_Score__c;
                            s.maxtotalscore+=resp.ExAM__Max_Score__c ;
                            s.totalscore+=resp.ExAM__Total_Score__c;
                            break;
                         }

                         }

                         if(reponseObject==null)
                         {
                             q.responsename='No response';
                         }
                         else
                         {
                             System.debug('!!!!!shouldnt come here if res is 0'+reponseObject);
                             q.responsename=reponseObject.ExAM__Response__c;
                             q.resObj=reponseObject;
                         }

                         s.questionList.add(q);
                     }
                     if((s.totalscore>0)&&(s.maxtotalscore>0))
                         {s.scorepercent=(s.totalscore/s.maxtotalscore)*100;s.scorepercent=(s.scorepercent).SetSCale(2);}

                     sectionList.add(s);
                 }



             }

 }/*
      public static testMethod void testgetSections()
     {
     SafeandHealthySchoolReportController d= new SafeandHealthySchoolReportController();
     Test.setCurrentPageReference(new PageReference('Page.SafeandHealthySchoolReport'));
     Main_questionaire__c maintest=new Main_questionaire__c (Template_name__c ='Coordinated Safe and Healthy School Assessment Practices');
     insert maintest;
     //System.currentPageReference().getParameters().put('TemplateName', maintest.Template_name__c );
     Account ac=new Account(name='test account1',Create_Survey__c=true);
     ac.Main_Questionnaire_Template__c=maintest.id;
     insert ac;
     System.currentPageReference().getParameters().put('accId', ac.id);
     IssueRequest_Life_Cycle__c issuetest=new IssueRequest_Life_Cycle__c(Facility_Name__c=ac.id,Investigation_Type__c='Coordinated Safe and Healthy School Assessment Practices');
     insert issuetest;
     System.currentPageReference().getParameters().put('issueid', issuetest.id);
     System.currentPageReference().getParameters().put('TemplateName',maintest.Template_name__c );
     Section_Template__c sc= new Section_Template__c(Questionnaire_Section__c=maintest.id,Section_label__c='test section');
     insert sc;
     Section_Template__c sc1= new Section_Template__c(Questionnaire_Section__c=maintest.id,Section_label__c='test section 2');
     insert sc1;
     Question_Template__c scq= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your name?',Question_Order_No__c=1,Question_Type__c='Text',Focus_category__c='CCTV');
     Question_Template__c scqp= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your age?',Question_Order_No__c=2,Question_Type__c='RadioPicklist',Weight_Of_Question__c=4,Subquestion_Label__c='10-30~31-50',Focus_category__c='Perimeter');
     Question_Template__c scqm= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your qualification?',Question_Order_No__c=3,Question_Type__c='MultiselectPicklist',Subquestion_Label__c='High School~Bachelors~Masters',Focus_category__c='Emergency Response Plan');
     Question_Template__c scqp1= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your age?',Question_Order_No__c=4,Question_Type__c='RadioPicklist',Weight_Of_Question__c=2,Subquestion_Label__c='10-30~31-50',Focus_category__c='Adequate Lighting');
     Question_Template__c scqm1= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your qualification?',Question_Order_No__c=5,Question_Type__c='MultiselectPicklist',Subquestion_Label__c='High School~Bachelors~Masters',Focus_category__c='Adequate Locking System');
     Question_Template__c scqp2= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your age?',Question_Order_No__c=6,Question_Type__c='RadioPicklist',Weight_Of_Question__c=4,Subquestion_Label__c='10-30~31-50',Focus_category__c='Mail Handling');

     insert scq;insert scqp;insert scqm;insert scqp1;insert scqm1;insert scqp2;

     //sc=[Select id from Section_Template__c limit 1];

     List<Section> scAlls=new List<Section>();

     Test.startTest();

     d.sectionStatus();
     System.assert(ac!=null,'Response data with questions not found');
     Test.stopTest();
     } */

        }