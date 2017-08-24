/**
 * Copyright (c) - Millsapps, Ballinger & Associates (MB&A)
 * All rights reserved.
 * You may only use this code and the application associated with it in conjunction with a valid subscription or license agreement with Millsapps, Ballinger and Associates. 
 * Any use of this code in whole or in part is prohibited including modification, copying in whole or in part or distributing it to any third party.    
 * Please see the full license agreement at http://info.mbaoutcome.com/app-terms-of-service
**/
public with sharing class QuestionnaireFieldsReport{

    public String templateName{get;set;}
    public String sectionId{get;set;}
    public String templateId{get;set;}
    public String groupId{get;set;}
    public String groupName{get;set;}
    public List<Section_Group__c > secgrpList { get; set; }
    public List<Section_Group_Section_Relation__c> group_sectionlist { get; set; }
    public Account acc{get;set;}
    public String accountName{get;set;}
    public List<Section_Template__c > sectionsLists{ get; set; }
    public List<Question_Template__c> questionsLists { get; set; }
    public List<Questionnaire_Response__c> responseLists { get; set; }
    public List<Main_questionaire__c> templateLists { get; set; }
    public List<SectionStatus__c > sectionsStatusLists{ get; set; }
    public QuestionnaireFieldsReport(ApexPages.StandardSetController controller){ 
    
    

             }
     public class Section
     {
         public String name {get; set;} 
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
         public String subquestionname {get; set;} 
     }
       
     public List<Section> sectionList {get; set;} 
           
    public QuestionnaireFieldsReport(){ 
    templateId=System.currentPageReference().getParameters().get('templateid');//to get the school or account id
    groupId=System.currentPageReference().getParameters().get('groupid');
    sectionList = new List<Section>(); 
            //System.debug('!!!!!!!!!!!!!!!!~~~~~~~~~~~~~acct id from diff page :'+accountid);
           if(templateId!=null)
           {
                templateLists = [Select Id, Name,Template_name__c from Main_questionaire__c where id=:templateId];
                
                
                if(templateLists!=NULL && templateLists.size()>=1)
                 {
                     templateName = templateLists.get(0).Template_name__c ;   
                     sectionsLists = [Select Id,Section_label__c,Order_No__c from Section_Template__c where Questionnaire_Section__c=:templateLists.get(0).Id order by Order_No__c];
                     //responseLists=[Select id,Response__c,Question_Template__c,Account_to_Response__c from Questionnaire_Response__c where Account_to_Response__c= :accountId] ;                 
                     //System.debug('!!!!!!!!!!!!!!!!~~~~~~~~~~~~~acct id from diff page :'+accountid+'lllllll'+responseLists);
                     for(Section_Template__c sec: sectionsLists ) 
                     {
                     Section s=new Section();
                     s.name=sec.Section_label__c;
                     s.questionList =new List<Question>(); 
                     questionsLists = [SELECT  Id,Section_Question__r.id,Question_Label__c,Question_Order_No__c,Question_Type__c,HelpText__c,Subquestion_Label__c FROM Question_Template__c where Section_Question__r.id=:sec.id order by Question_Order_No__c]; 
              
                        for(Question_Template__c quest: questionsLists ) 
                         {
                             
                             Question q=new Question();
                             q.name=quest.Question_Label__c;
                             q.subquestionname =quest.Subquestion_Label__c;
                             
                             s.questionList.add(q);
                         }
                         sectionList.add(s);
                     }
                        
                     
                     
                 } 
                 }
                 else
                 {
                  if(groupId!=null)
                  {
                      secgrpList = [Select Id, Name,Group_Name__c from Section_Group__c where id=:groupId ];
                      if(secgrpList !=NULL && secgrpList.size()>0)
                       {
                          groupName=secgrpList[0].Group_Name__c;
                          group_sectionlist = [Select id,Section_Group__c,Default_Section__c,Section_Active__c,Section_Group__r.id,Section_Template__c,Section_Template__r.Section_label__c,Section_Template__r.id from Section_Group_Section_Relation__c where Section_Group__c=:secgrpList[0].id AND Section_Active__c=true];
                            System.debug('!!!!!group_sectionlist '+group_sectionlist.size());
                            for(Section_Group_Section_Relation__c  res: group_sectionlist ) 
                              {
                                 Section s=new Section();System.debug('11!!!!!sec');
                                 s.name=res.Section_Template__r.Section_label__c;System.debug('222!!!!!sec'+s.name);
                                 s.questionList =new List<Question>(); 
                                 System.debug('!!!!!sec'+res.Section_Template__r.Section_label__c);
                                 questionsLists = [SELECT  Id,Section_Question__r.id,Question_Label__c,Question_Order_No__c,Question_Type__c,HelpText__c,Subquestion_Label__c FROM Question_Template__c where Section_Question__r.id=:res.Section_Template__r.id order by Question_Order_No__c]; 
                          
                                    for(Question_Template__c quest: questionsLists ) 
                                     {
                                        
                                         Question q=new Question();
                                         q.name=quest.Question_Label__c;
                                         q.subquestionname =quest.Subquestion_Label__c;
                                         
                                         s.questionList.add(q);
                                         
                                     }System.debug('1111!!!!!question'+s);
                                     sectionList.add(s);System.debug('222!!!!!question');
                                 
                              }  
                              
                              
                              
                              
                              
                      
                       }
                      
                      
                      
                  }
                 }
                 //FROM the force.com site if we want to update data in Account for CCTV etc scores I am adding the code here, as here the responses would be given and data would be added to Main Report DAta object for reports 
             // To set the focus category scores for the account
 //sectionsStatusLists=[Select id,Section_Template__c,Section_Template__r.id,Section_Template__r.Section_Label__c,Section_Template__r.Order_No__c,Account_to_SectionStatus__c,Status__c,User__c from SectionStatus__c where Account_to_SectionStatus__c= :accountId AND (Section_Template__c!=null) order by Section_Template__r.Order_No__c] ;
            
System.debug('---sectionList'+sectionList);
             }
   
   
      public static testMethod void testgetSections()
     {
     
     Test.setCurrentPageReference(new PageReference('Page.QuestionnaireViewReport'));
     Main_questionaire__c maintest=new Main_questionaire__c (Template_name__c ='DOI');
     insert maintest; 
     Section_Group__c maintestg=new Section_Group__c(Group_Name__c ='test');
     upsert maintestg;
     System.currentPageReference().getParameters().put('templateid', maintest.id ); 
    
     Section_Template__c sc= new Section_Template__c(Questionnaire_Section__c=maintest.id,Section_label__c='test section'); 
     insert sc;
     Section_Template__c sc1= new Section_Template__c(Questionnaire_Section__c=maintest.id,Section_label__c='test section 2'); 
     insert sc1;
     Question_Template__c scq= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your name?',Question_Order_No__c=1,Question_Type__c='Text',Focus_category__c='CCTV');     
     Question_Template__c scqp= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your age?',Question_Order_No__c=2,Question_Type__c='RadioPicklist',Subquestion_Label__c='10-30~31-50',Focus_category__c='Perimeter');     
     Question_Template__c scqm= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your qualification?',Question_Order_No__c=3,Question_Type__c='MultiselectPicklist',Subquestion_Label__c='High School~Bachelors~Masters',Focus_category__c='Emergency Response Plan');     
     Question_Template__c scqp1= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your age?',Question_Order_No__c=4,Question_Type__c='RadioPicklist',Subquestion_Label__c='10-30~31-50',Focus_category__c='Adequate Lighting');     
     Question_Template__c scqm1= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your qualification?',Question_Order_No__c=5,Question_Type__c='MultiselectPicklist',Subquestion_Label__c='High School~Bachelors~Masters',Focus_category__c='Adequate Locking System');     
     Question_Template__c scqp2= new Question_Template__c(Section_Question__c=sc.id,Question_Label__c='What is your age?',Question_Order_No__c=6,Question_Type__c='RadioPicklist',Subquestion_Label__c='10-30~31-50',Focus_category__c='Mail Handling');     
  
     insert scq;insert scqp;insert scqm;insert scqp1;insert scqm1;insert scqp2;
     Section_Group_Section_Relation__c  sgrelation=new Section_Group_Section_Relation__c (Section_Group__c=maintestg.id,Default_Section__c=true,Section_Active__c=true,Section_Template__c=sc.id);
     upsert sgrelation;
            
     List<Section> scAlls=new List<Section>();  
     QuestionnaireFieldsReport d= new QuestionnaireFieldsReport();
     System.currentPageReference().getParameters().put('templateid',null ); 
     System.currentPageReference().getParameters().put('groupid', maintestg.id ); 
     Test.startTest();
    
    
     QuestionnaireFieldsReport d1= new QuestionnaireFieldsReport();
     System.assert(d!=null,'Response data with questions not found');
     Test.stopTest();
     } 
        
        
}//end main class