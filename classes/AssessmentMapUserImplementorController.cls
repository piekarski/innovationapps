/**
 * Copyright (c) - Millsapps, Ballinger & Associates (MB&A)
 * All rights reserved.
 * You may only use this code and the application associated with it in conjunction with a valid subscription or license agreement with Millsapps, Ballinger and Associates. 
 * Any use of this code in whole or in part is prohibited including modification, copying in whole or in part or distributing it to any third party.    
 * Please see the full license agreement at http://info.mbaoutcome.com/app-terms-of-service
**/
public with sharing class AssessmentMapUserImplementorController
{ 
     public User[] useraccLists { get; set; }
     private String showUsers{get;set;}
     public List<Locations> accounts;
     public List<Account> accLists { get; set; }
     public String GoogleMapsAPIKey {get; set;}
     //public String AssessmentCompletion{get;set;}
    // public String status{get;set;}
     //public String priority{get;set;}
     //public String ColorBy{get;set;}
     //public List<Account> allaccounts=new List<Account>();
     
     //Add new code 
     public String AMStatus { get; set; }
     public String AMPriority { get; set; }
     public String AMAssesmentCompletion { get; set; }
     public String AMAssessmentType { get; set; }
    
    
    public AssessmentMapUserImplementorController()
    {
      Map<String,GoogleMapsAPIKey__c> allKeys = GoogleMapsAPIKey__c.getAll();
      GoogleMapsAPIKey = (allKeys.containskey('GoogleMapsAPIKey')? allKeys.get('GoogleMapsAPIKey').API_Key__c : '');
      showUsers=System.currentPageReference().getParameters().get('showUsers');//if(showUsers==null){showUsers='false';}
      String accountMapGroup = apexpages.currentpage().getparameters().get('AccMapGroup');
      List<String> selectedValuesList = new List<String>();
      
      System.debug(':::mappinggroup::::'+apexpages.currentpage().getparameters().get('AccMapGroup'));
      if( accountMapGroup != null && accountMapGroup != '') {
          selectedValuesList = accountMapGroup.split(';'); 
      }
      System.debug(':::::selectedValuesList ::::'+selectedValuesList);
      
      AMStatus = apexpages.currentpage().getparameters().get('AMStatus');
      AMPriority = apexpages.currentpage().getparameters().get('AMpriority');
      AMAssesmentCompletion = apexpages.currentpage().getparameters().get('AMassessmentCompletion');
      AMAssessmentType = apexpages.currentpage().getparameters().get('AMassessmentType');
      accLists = new List<Account> ();
      
      /*AssessmentCompletion=System.currentPageReference().getParameters().get('AssessmentCompletion');
      if(AssessmentCompletion==null){AssessmentCompletion='false';}
     status=System.currentPageReference().getParameters().get('status');
     if( status==null){ status='false';}
      priority=System.currentPageReference().getParameters().get('priority');if(priority==null){priority='false';}
      ColorBy=System.currentPageReference().getParameters().get('ColorBy');
      System.debug('const---priority'+priority+'AssessmentCompletion:'+AssessmentCompletion+'status:'+status);*/
      accounts= new Locations[]{};
      if(showUsers.equalsIgnoreCase('true'))
      {
          useraccLists=[select id, Email,name,Location__Latitude__s,Location__Longitude__s, isActive from User where isactive = true and Location__Latitude__s!=null];
          
          //accounts.add(new Locations(useraccLists));
      }
        if( selectedValuesList != null && selectedValuesList.size() > 0 ) {
         String QueryStr =  'SELECT id, Main_Questionnaire_Template__r.Template_name__c, Main_Questionnaire_Template__c, '+
                            'BillingStreet, BillingCity, BillingPostalCode, BillingCountry, name, Create_Survey__c, (SELECT Id, '+
                            'name, Facility_Name__c, Status__c, Priority__c, InvestigationType__c, '+
                            'InvestigationType__r.Template_name__c, Assessment_Form_Completion__c, '+
                            'CreatedDate FROM Issue_Request_Life_Cycles__r '+
                            'WHERE InvestigationType__c =\''+AMAssessmentType+'\''; 
        
            if (AMStatus != null && AMStatus != '' && AMStatus != 'All') {
                QueryStr += ' AND Status__c =\''+AMStatus+'\'';
            }
            if (AMPriority != null && AMPriority != '' && AMPriority != 'All') {
                QueryStr += ' AND Priority__c =\''+AMPriority+'\'';
            }
            if (AMAssesmentCompletion != null && AMAssesmentCompletion != '' && AMAssesmentCompletion != 'All') {
                QueryStr += ' AND Assessment_Form_Completion__c =\''+AMAssesmentCompletion+'\'';
            }
            QueryStr += ') FROM Account where (BillingStreet <>NULL OR BillingCity<>NULL) and BillingPostalCode<>NULL AND ';
            QueryStr += 'Create_Survey__c=true AND Mapping_Group__c INCLUDES (';
            Boolean flag = true;                              
              for (String mapGroupStr : selectedValuesList) {
                  if( flag ) {  
                      QueryStr += '\''+mapGroupStr+'\'';  
                      flag = false;  
                  } else {
                      QueryStr += ', \''+mapGroupStr+'\'';
                  } 
              }
              QueryStr += ')';
              System.debug('::::queryStr::::'+QueryStr);
              List<Account> accList = Database.query(QueryStr);
              if( !accList.isEmpty() ) {
         
                             /*for (Account acc : [ SELECT id,Main_Questionnaire_Template__r.Template_name__c,Main_Questionnaire_Template__c,BillingStreet,BillingCity,BillingPostalCode,
                                                      BillingCountry,name,Create_Survey__c,(SELECT Id,name,Facility_Name__c,Status__c,Priority__c,InvestigationType__c,
                                                      InvestigationType__r.Template_name__c,Assessment_Form_Completion__c,CreatedDate FROM Issue_Request_Life_Cycles__r 
                                                      WHERE Status__c =:AMStatus AND Priority__c =:AMPriority AND Assessment_Form_Completion__c =:AMAssesmentCompletion ) 
                                                FROM Account where (BillingStreet <>NULL OR BillingCity<>NULL) and BillingPostalCode<>NULL AND Create_Survey__c=true 
                                                AND Mapping_Group__c includes (:selectedValuesList[0],:selectedValuesList[1]) ]) {
                             
                                 if( acc.Issue_Request_Life_Cycles__r != null && acc.Issue_Request_Life_Cycles__r.size() > 0 ) {
                                     accLists.add(acc);     
                                 }
                             }*/
                 for (Account acc : accList) {
                     if( !acc.Issue_Request_Life_Cycles__r.isEmpty() ) {
                         accLists.add(acc);     
                     }
                 } 
             }
         } else {
            String queryStr = 'SELECT id,Main_Questionnaire_Template__r.Template_name__c,Main_Questionnaire_Template__c,BillingStreet,BillingCity,BillingPostalCode,'+
                'BillingCountry,name,Create_Survey__c,( SELECT Id,name,Facility_Name__c,Status__c,Priority__c,InvestigationType__c,'+
                'InvestigationType__r.Template_name__c,Assessment_Form_Completion__c,CreatedDate FROM Issue_Request_Life_Cycles__r '+ 
                'WHERE InvestigationType__c =:AMAssessmentType ';
            if (AMStatus != null && AMStatus !='' && AMStatus != 'All') {
                queryStr += ' AND Status__c =:AMStatus';
            }
            if (AMPriority != null && AMPriority !='' && AMPriority != 'All') {
                queryStr += ' AND Priority__c =:AMPriority ';
            }
            if (AMAssesmentCompletion != null && AMAssesmentCompletion !='' && AMAssesmentCompletion != 'All') {
                queryStr += ' AND Assessment_Form_Completion__c =:AMAssesmentCompletion';
            }   
            queryStr += ') FROM Account where (BillingStreet <>NULL OR BillingCity<>NULL) and BillingPostalCode<>NULL AND Create_Survey__c=true';
            System.debug('::::queryStr:::'+queryStr);
            List<Account> accList = Database.query(QueryStr);
            
            System.debug(':::::accList::::'+accList);
            for (Account acc : accList) {
                 if( acc.Issue_Request_Life_Cycles__r != null && acc.Issue_Request_Life_Cycles__r.size() > 0 ) {
                     accLists.add(acc);     
                 }
             }
             System.debug(':::accLists::::'+accLists);
         }
         
         if(accLists==null)
         { System.debug('constraccounts-NULLaccLists');}
         else
         {
          
          for (Account a :accLists )
               {  
                 String addr=a.BillingStreet+','+a.BillingCity+','+a.BillingPostalCode+','+a.BillingCountry;
                 System.debug('----'+   a.id+','+a.name+','+a.Issue_Request_Life_Cycles__r);
                 accounts.add(new Locations(a.id,a.name,addr,a.Issue_Request_Life_Cycles__r));
                }
                System.debug('constraccounts----'+accounts); 
          }
       
    }
    
  // Creates section List
   public List<Locations> getlistacc()
    {
    if(accounts!=null){
      System.debug('----1 ----'+accounts);     
      return accounts;
      }
      return null;
    }
    
    // Create an inner class
    public class Locations{
        public String             accountid         {get; set;}
        public String             accountname       {get; set;}
        public String             accountaddress        {get; set;} 
        public Account            accountobj{get;set;}
        public List<IssueRequest_Life_Cycle__c> issueLists { get; set; }
        public List<User> userLists { get; set; }
        public  Locations(String aid,String aname,String aaddress,list<IssueRequest_Life_Cycle__c> ilist)
        {
            accountid=aid;
            accountname=aname;
            accountaddress=aaddress;
            issueLists =new List<IssueRequest_Life_Cycle__c>();
            issueLists =ilist;
                     
        }
        /*public  Locations(list<User> ulist)
        {            
            userLists =new List<User>();
            userLists =ulist;
            System.debug('   userLists '+userLists );      
        }*/
    }
  
 

 public static testMethod void testlistacc()
 {
   
    Test.startTest();
    Main_questionaire__c maintest1=new Main_questionaire__c (Template_name__c ='test2',PublishPlace__c='External Site');
    upsert maintest1;
    Account acc=new Account(BillingStreet='2425 Wilson Blvd',BillingCity='arlington',BillingPostalCode='22209',BillingCountry='United States',name='test account',Create_Survey__c=true);
    acc.Main_Questionnaire_Template__c=maintest1.id;
    upsert acc;
    System.currentPageReference().getParameters().put('showUsers','true');
    IssueRequest_Life_Cycle__c issue=new IssueRequest_Life_Cycle__c(Facility_Name__c=acc.id,Status__c='Open',Priority__c='Emergency',InvestigationType__c=maintest1.id);upsert issue;
    AssessmentMapUserImplementorController d= new AssessmentMapUserImplementorController();
    System.assert(d.getlistacc()!=null);
    Test.stopTest();
     
     
 }
}