/**
 * Copyright (c) - Millsapps, Ballinger & Associates (MB&A)
 * All rights reserved.
 * You may only use this code and the application associated with it in conjunction with a valid subscription or license agreement with Millsapps, Ballinger and Associates. 
 * Any use of this code in whole or in part is prohibited including modification, copying in whole or in part or distributing it to any third party.    
 * Please see the full license agreement at http://info.mbaoutcome.com/app-terms-of-service
**/

public with sharing class SurveyUserFormController{

    public ExAM__IssueRequest_Life_Cycle__c issue{get;set;}
    public List<ExAM__Main_questionaire__c> templateList{get;set;}
    public List<SelectOption> tempList{get;set;}
    public List<SelectOption> accList{get;set;}
    public List<Account> accObjs{get;set;}
    public String accname{get;set;}
    public String tempid{get;set;}
    public Account acc{get;set;}
    public String accId{get;set;}


    public SurveyUserFormController(ApexPages.StandardController controller){

        tempList=new List<SelectOption>();
        issue=new ExAM__IssueRequest_Life_Cycle__c();
        issue.ExAM__Assessment_Date_Time__c=system.now();
        //issue.Assessor_Resource__c=UserInfo.getUserId();
        User lstUser = [Select Id, Profile.Name, ContactId from User where Id = :UserInfo.getUserId()];
        System.debug('lstUser.Profile.Name ::: ' + lstUser.Profile.Name);
        if(lstUser.Profile.Name != 'Strategic Community'){

            issue.Exam_User__c  = lstUser.id;
        }
        templateList = new List<ExAM__Main_questionaire__c>();
        
        System.debug('lstUser details'+lstUser+',,,lstUser.ContactId'+lstUser.ContactId);
        accList=new List<SelectOption>();
        accObjs=new List<Account>();
        if(lstUser.ContactId!=null)
        {
            Contact con=[select id,AccountId,Account.Name from Contact where id=:lstUser.ContactId];
            System.debug('contact of user account portal'+con.Account.name);
            accname=con.Account.Name;
            accId = con.AccountId;
            //issue.Facility_Name__c=con.AccountId;

            //One-off developed for Strategic Community profile
            if(lstUser.Profile.Name == 'Strategic Community'){

                issue.ExAM__Facility_Name__c = accId;
            }
        }
        else
        {//it is normal user so get all accounts for which it is the owner
            accObjs=[select id,name,ownerId,Create_Survey__c from Account where ownerId=:UserInfo.getUserId() and Create_Survey__c=false order by name limit 1000];
            System.debug('user id:'+UserInfo.getUserId()+',,,,,'+accObjs);
            for(Account acc:accObjs)
            {
             accList.add(new SelectOption(acc.id,acc.name));
            }
        
        }
        Id loggedInUserProfileId = UserInfo.getProfileId();
        String profileName = [Select Name from Profile where Id = :loggedInUserProfileId limit 1][0].Name;
        System.debug('profileName :::' + profileName );
        //templateList=[select id,Template_name__c,Description__c,Available_in_Portal__c, Available_Profile__c  from Main_questionaire__c WHERE Available_in_Portal__c = true order by Template_name__c limit 1000];
        for ( ExAM__Main_questionaire__c tempAssessment : [select id,ExAM__Template_name__c,ExAM__Description__c,ExAM__Available_in_Portal__c, Available_in_Profile__c from ExAM__Main_questionaire__c WHERE ExAM__Available_in_Portal__c = true order by ExAM__Template_name__c] ){
            
            System.debug('Inside For Loop');
            Set<String> tempSet = new Set<String>();
            if( tempAssessment.Available_in_Profile__c  != NULL){
            
                for (String s : tempAssessment.Available_in_Profile__c .split(';'))
                    tempSet.add(s);
                    
                System.debug('tempSet ::: '+ tempSet);
                if ( tempSet.contains(profileName) ){
                
                    System.debug('Inside if condition');
                    templateList.add(tempAssessment);
                }
            }
            //templateList.add(tempAssessment);
        }
        System.debug('templateList ::: ' + templateList);
    }
    public PageReference cancel(){ 
    
       String urlform=Site.getPathPrefix()+'/home/home.jsp';
       PageReference saveClicked=new PageReference(urlform);
       saveClicked.setRedirect(true);
       return saveClicked;
    }
     public PageReference save()
        { 
        System.debug('in SAVE');
        String templateid=System.currentPagereference().getParameters().get('templat');
        if(templateid!=null)
        {issue.ExAM__InvestigationType__c=templateid;}
        System.debug('in SAVEtemplateid'+templateid);
        System.debug('111111111 isue'+issue);
        upsert issue;
        String urlform='/'+issue.id;
        List<ExAM__IssueRequest_Life_Cycle__c> amList = [SELECT Id, ExAM__Facility_Name__c, ExAM__InvestigationType__c, ExAM__Assessment_Template_Type__c FROM ExAM__IssueRequest_Life_Cycle__c Where id =: issue.id Limit 1];
        if (amList != null && amList.size() > 0) {
            
            urlform = Site.getPathPrefix()+'/apex/QuestionnaireCustom2?issueid='+amList[0].Id+'&templatename='+amList[0].ExAM__Assessment_Template_Type__c;
            /*if (amList[0].Facility_Name__c != null) {
                
                urlform += '&accid='+amList[0].Facility_Name__c;
            }*/
            urlform += '&accid=' +accId;
        }
        
        System.debug('END SAVE');   
        PageReference saveClicked=new PageReference(urlform);
        saveClicked.setRedirect(true);
        return saveClicked;
        }
   }