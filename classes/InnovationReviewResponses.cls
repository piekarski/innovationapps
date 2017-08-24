public with sharing class InnovationReviewResponses {

    //this is extension class of Main_questionnaire template
    //TAke questionnaire field from section,question,question response,template
  /*  public String message {
        get;
        set;
    }*/
    //public Id selectedTemplate { get; set; }
    //public Id selectedSection { get; set; }
    public Account acc {
        get;
        set;
    }
    public List < ExAM__Question_Template__c > questionsLists {
        get;
        set;
    }
    public List < ExAM__Section_Template__c > sectionsLists {
        get;
        set;
    }
    public List < ExAM__Main_questionaire__c > templateLists {
        get;
        set;
    }
    public List < ExAM__SectionStatus__c > sectionsStatusLists {
        get;
        set;
    }
    //public Set<Id> sectionIds{get;set;}
    public String templateName {
        get;
        set;
    }
    public String appid {
        get;
        set;
    }
    public String templateId {
        get;
        set;
    }
  /*  public String sectionId {
        get;
        set;
    }*/
    public String accountId {
        get;
        set;
    }
    public List < ExAM__Questionnaire_Response__c > QuestionResponse {
        get;
        set;
    }
    public List < QuestionDisplay > listQuestWithOptions;
    public List < QuestionDisplay > questionsList { get; set; }

    public QuestionDisplay[] listQuestWithText;
    //public PageReference refresh=ApexPages.currentPage();
    //Apexpages.currentPage().getHeaders().put('X-UA-Com​patible', 'IE=8');
    // public PageReference refresh = new PageReference(ApexPages.currentPage().getUrl());
  /*  public Boolean refreshPagePart {
        get;
        set;
    }*/
    private Boolean theToggleVal = true;
    static integer ltoggle = 0;
    private Boolean theToggleValApproval = false;
    static integer ltoggleApproval = 0;
    public Transient Boolean doRerender;
    public Transient Boolean doRerenderSave;
    /*public Boolean getdoRerender() {
        return doRerender;
    }*/
    public Boolean getdoRerenderSave() {
        return doRerenderSave;
    }
    //added for not doing DMl in constructor
    public Boolean myFlag {
        get;
        set;
    }
    public String issueId {
        get;
        set;
    }

    /*public void setmyFlag(Boolean flags) {
        //this.myFlag = flags;
    }*/

  /*  public void setdoRerender(Boolean doRerender) {
        this.doRerender = doRerender;
        System.debug('doRerender should be set here to true: doRerender = ' + this.doRerender);
    }*/
    public void setdoRerenderSave(Boolean doRerenderSave) {
        this.doRerenderSave = doRerenderSave;
        System.debug('doRerender should be set here to true: doRerender = ' + this.doRerenderSave);
    }
  /*  public Boolean ParamToggle {
        get;
        set;
    }*/

  /*  public void DoToggle() {
        theToggleVal = ParamToggle;
    }*/

  /*  public Boolean ShouldDisplay {
        get {
            System.Debug(theToggleVal);
            return theToggleVal;
        }
    }
    public Boolean ShouldDisplayApproval {
        get {
            System.Debug(theToggleValApproval);
            return theToggleValApproval;
        }
    }*/

    public InnovationReviewResponses(ApexPages.StandardSetController controller) {
        //refreshPagePart = false; //sectionStatus();
        questionsList = new List<QuestionDisplay>();
        currentSectionQuestions();
    }
    public InnovationReviewResponses() {}

    public void sectionStatus() {
        myFlag = false;
        theToggleVal = false;
        theToggleValApproval = false; //System.debug('----------initialized in sectionstatus'+initialized);
        if (!myFlag) {
            ExAM__SectionStatus__c[] StatusLists = new ExAM__SectionStatus__c[] {}; //setinitialised(true);
            accountId = System.currentPageReference().getParameters().get('accId'); //to get the school or account id
            accountId = accountId != '' ? accountId : null;
            issueId = System.currentPageReference().getParameters().get('issueid');
            appid = System.currentPageReference().getParameters().get('appid');
            templateName = System.currentPageReference().getParameters().get('templatename');
            //acc= [SELECT id,name,Main_Questionnaire_Template__c,Main_Questionnaire_Template__r.Template_name__c,Adequate_Lighting_Score__c,Adequate_Locking_Score__c,CCTV_Score__c,Emergency_Response_Plan__c,Mail_Handling_Score__c,Overall_Score__c,Perimeter_Score__c,Create_Survey__c From Account where Create_Survey__c=:true AND id=:accountId];
            //Account or facility doesnt have template name on it, it is on the issue/request object
            //acc= [SELECT id,name From Account where id=:accountId];

            System.debug('!!!!!!!!!!!!!!!!~~~~~~~~~~~~status ~acct id from diff page :' + accountid);
            //templateLists = [Select Id, Name,Template_name__c from Main_questionaire__c where Template_name__c=:acc.Main_Questionnaire_Template__r.Template_name__c];
            templateLists = [Select Id, Name, ExAM__Template_name__c from ExAM__Main_questionaire__c where ExAM__Template_name__c = : templateName];
            if (templateLists != NULL && templateLists.size() >= 1) {
                templateName = templateLists.get(0).ExAM__Template_name__c;
                sectionsLists = [Select Id, Name, ExAM__status__c, ExAM__Section_label__c, ExAM__Order_No__c from ExAM__Section_Template__c where ExAM__Questionnaire_Section__c = : templateLists.get(0).Id order by ExAM__Order_No__c];
                //iterate the sectionstatus table and we should remove userinfo check as there will always be 1 survey per account
                //SectionStatus__c[] userSectionStatus=[Select id,Section_Template__c,Section_Template__r.id,Section_Template__r.Section_Label__c,Section_Template__r.Order_No__c,Status__c,Section_Template__r.Questionnaire_Section__c,User__c,Account_to_SectionStatus__c from SectionStatus__c where Account_to_SectionStatus__c= :accountId AND (Section_Template__c!=null) AND (Section_Template__r.Questionnaire_Section__c=:templateLists.get(0).Id) order by Section_Template__r.Order_No__c] ;
                ExAM__SectionStatus__c[] userSectionStatus = [Select id, ExAM__Section_Template__c, ExAM__Section_Template__r.id, ExAM__Section_Template__r.ExAM__Section_Label__c, ExAM__Section_Template__r.ExAM__Order_No__c, ExAM__Section_Template__r.ExAM__Questionnaire_Section__c, ExAM__Status__c, ExAM__User__c, ExAM__Issue_Request__c from ExAM__SectionStatus__c where ExAM__Issue_Request__c = : issueId AND(ExAM__Section_Template__c != null) AND(ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = : templateLists.get(0).Id) order by ExAM__Section_Template__r.ExAM__Order_No__c];


                System.debug('~~~~~~~~11111~sectionstatus~~~~~~~~~~~~' + userSectionStatus.size());
                //System.debug('sectionsLists ----'+sectionsLists.size());
                // System.debug('~~~~~~~~~~~~~size both at top'+userSectionStatus.size()+',,,sec'+sectionsLists.size());

                if ((userSectionStatus == null) || (userSectionStatus.size() == 0)) {
                    System.debug('~~~~~~~~~~~~~COMES IN SECTION STATUS');
                    for (ExAM__Section_Template__c res: sectionsLists) {

                        ExAM__SectionStatus__c stat = new ExAM__SectionStatus__c();
                        stat.ExAM__User__c = UserInfo.getUserId();
                        stat.ExAM__Issue_Request__c = issueId;
                        stat.ExAM__Section_Template__c = res.id;
                        //stat.ExAM__status__c = 'Incomplete';
                        stat.ExAM__Account_to_SectionStatus__c = accountId != '' ? accountId : null;
                        //stat.Section_StatusLabel__c=res.Section_Label__c;
                        System.debug('~~~~~~~~~~~~~default controller------' + stat);
                        StatusLists.add(stat);
                    }
                    try {
                        upsert StatusLists;
                    } catch (DmlException e) {
                        System.debug('~~~~~~~~~~~~~EXCEPTION --' + e);
                    }
                    //sectionsStatusLists=[Select id,Section_Template__c,Section_Template__r.id,Section_Template__r.Section_Label__c,Section_Template__r.Order_No__c,Account_to_SectionStatus__c,Section_Template__r.Questionnaire_Section__c,Status__c,User__c from SectionStatus__c where Account_to_SectionStatus__c= :accountId AND (Section_Template__c!=null) AND (Section_Template__r.Questionnaire_Section__c=:templateLists.get(0).Id) order by Section_Template__r.Order_No__c] ;
                    sectionsStatusLists = [Select id, ExAM__Section_Template__c, ExAM__Section_Template__r.id, ExAM__Section_Template__r.ExAM__Section_Label__c, ExAM__Section_Template__r.ExAM__Order_No__c, ExAM__Section_Template__r.ExAM__Questionnaire_Section__c, ExAM__Issue_Request__c, ExAM__Status__c, ExAM__User__c from ExAM__SectionStatus__c where ExAM__Issue_Request__c = : issueId AND(ExAM__Section_Template__c != null) AND(ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = : templateLists.get(0).Id) order by ExAM__Section_Template__r.ExAM__Order_No__c];

                } else if (userSectionStatus.size() < sectionsLists.size()) {
                    integer i = 0;
                    System.debug('~~~~~~~~~~~~~add new status default' + userSectionStatus.size() + userSectionStatus + ',,,sec' + sectionsLists.size() + sectionsLists);
                    for (ExAM__Section_Template__c res: sectionsLists) {
                        for (ExAM__SectionStatus__c statusobj: userSectionStatus) {
                            if (res.id == statusobj.ExAM__Section_Template__c) {
                                i = 1;
                                System.debug('~~both are equal~~~~~~~~~' + res.id + 'status' + statusobj.ExAM__Section_Template__c);
                                break;
                            }
                        }

                        if (i == 0) {
                            /*SectionStatus__c stat=new SectionStatus__c();
                                        stat.User__c=UserInfo.getUserId();
                                        stat.Section_Template__c= res.id;
                                        stat.Account_to_SectionStatus__c=accountId;
                                        stat.status__c='Incomplete';
                                        StatusLists.add(stat);*/
                            //create new section status
                            ExAM__SectionStatus__c newstat = new ExAM__SectionStatus__c();
                            newstat.ExAM__User__c = UserInfo.getUserId();
                            newstat.ExAM__Issue_Request__c = issueId;
                            newstat.ExAM__Section_Template__c = res.id;
                            //newstat.ExAM__status__c = 'Incomplete';
                            newstat.ExAM__Account_to_SectionStatus__c = accountId != '' ? accountId : null;
                            //stat.Section_StatusLabel__c=res.Section_Label__c;
                            System.debug('~~~~~~~~~~~~~default controller------' + newstat);
                            StatusLists.add(newstat);
                        }
                        i = 0;

                    }
                    try {
                        upsert StatusLists;
                    } catch (DmlException e) {
                        System.debug('~~~~~~~~~~~~~EXCEPTION --' + e);
                    }
                    //sectionsStatusLists=[Select id,Section_Template__c,Section_Template__r.id,Section_Template__r.Section_Label__c,Section_Template__r.Order_No__c,Account_to_SectionStatus__c,Status__c,User__c,Section_Template__r.Questionnaire_Section__c from SectionStatus__c where Account_to_SectionStatus__c= :accountId AND (Section_Template__c!=null) AND (Section_Template__r.Questionnaire_Section__c=:templateLists.get(0).Id) order by Section_Template__r.Order_No__c] ;
                    sectionsStatusLists = [Select id, ExAM__Section_Template__c, ExAM__Section_Template__r.id, ExAM__Section_Template__r.ExAM__Section_Label__c, ExAM__Section_Template__r.ExAM__Questionnaire_Section__c, ExAM__Section_Template__r.ExAM__Order_No__c, ExAM__Issue_Request__c, ExAM__Status__c, ExAM__User__c from ExAM__SectionStatus__c where ExAM__Issue_Request__c = : issueId AND(ExAM__Section_Template__c != null) AND(ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = : templateLists.get(0).Id) order by ExAM__Section_Template__r.ExAM__Order_No__c];

                } else if (userSectionStatus.size() > sectionsLists.size()) { //extra section status
                    integer i = 0;
                    List < ExAM__SectionStatus__c > deleteSectionStatus = new List < ExAM__SectionStatus__c > ();
                    for (ExAM__SectionStatus__c statusobj: userSectionStatus) {
                        for (ExAM__Section_Template__c res: sectionsLists) {
                            if (res.id == statusobj.ExAM__Section_Template__c) {
                                i = 1;
                                break;
                            }
                        }
                        if (i == 0) {

                            //stat.Section_StatusLabel__c=res.Section_Label__c;
                            //System.debug('~~~~~~~~~~~~~default controller------'+statusobj);
                            deleteSectionStatus.add(statusobj);
                        }
                        i = 0;

                    }
                    try {
                        //while(SectionStatus__c statusobj: deleteSectionStatus)
                        integer l = 0;
                        if (deleteSectionStatus.size() == 0) {} else if (deleteSectionStatus.size() == 1) {
                            delete deleteSectionStatus[0];
                        } else {
                            for (ExAM__SectionStatus__c statusdelete: deleteSectionStatus) {
                                delete statusdelete;

                            }
                        }
                    } catch (DmlException e) {
                        System.debug('~~~~~~~~~~~~~EXCEPTION --' + e);
                    }
                    //sectionsStatusLists=[Select id,Section_Template__c,Section_Template__r.id,Section_Template__r.Section_Label__c,Section_Template__r.Order_No__c,Account_to_SectionStatus__c,Status__c,User__c,Section_Template__r.Questionnaire_Section__c from SectionStatus__c where Account_to_SectionStatus__c= :accountId AND (Section_Template__c!=null) AND (Section_Template__r.Questionnaire_Section__c=:templateLists.get(0).Id) order by Section_Template__r.Order_No__c] ;
                    sectionsStatusLists = [Select id, ExAM__Section_Template__c, ExAM__Section_Template__r.id, ExAM__Section_Template__r.ExAM__Section_Label__c, ExAM__Section_Template__r.ExAM__Questionnaire_Section__c, ExAM__Section_Template__r.ExAM__Order_No__c, ExAM__Issue_Request__c, ExAM__Status__c, ExAM__User__c from ExAM__SectionStatus__c where ExAM__Issue_Request__c = : issueId AND(ExAM__Section_Template__c != null) AND(ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = : templateLists.get(0).Id) order by ExAM__Section_Template__r.ExAM__Order_No__c];

                } else { //sectionlist exists so no need for grabbing again
                    // sectionsStatusLists=[Select id,Section_Template__c,Section_Template__r.id,Section_Template__r.Section_Label__c,Status__c,User__c from SectionStatus__c where User__c= :UserInfo.getUserId()] ;
                    //sectionsStatusLists=[Select id,Section_Template__c,Section_Template__r.id,Section_Template__r.Section_Label__c,Section_Template__r.Order_No__c,stat.Account_to_SectionStatus__c,Status__c,User__c from SectionStatus__c where User__c= :UserInfo.getUserId() AND (Section_Template__c!=null) order by Section_Template__r.Order_No__c] ;
                    sectionsStatusLists = userSectionStatus;
                }
                System.debug('~~~~~~~222  section sttus~~~~~~final section list SECTION STATUS LIST----' + sectionsStatusLists);

                // To set the focus category scores for the account
                /* List<aggregateResult> aggr=[
   Select Account__c, Question_Template__r.Focus_category__c focus, SUM(Questionnaire_Response__r.Total_Score__c)total
   from Main_Report_Data__c where Account__c=:accountId
   GROUP BY  Account__c,Question_Template__r.Focus_category__c ];
        if(acc!=null)
         {

           acc.Overall_Score__c=0;

           integer b=0;
           for(SectionStatus__c res: sectionsStatusLists)
              {
                 if(res.status__c.equalsIgnoreCase('complete'))
                        {
                            b++;System.debug('!!!!!!!!!!!!!!!!!!b='+b+','+ res.status__c);
                        }

              }
           if(b==sectionsLists.size())
              {
                  System.debug('!!!!!!!!!!!!!!!!!!b val:'+b);
                  acc.Survey_Completed__c='Complete';}
                  for (AggregateResult ar : aggr)
                   {

                      String focuscat=String.valueOf(ar.get('focus'));
                      System.debug('account id:'+acc.id+'focus category:'+focuscat);
                      acc.Overall_Score__c+=Integer.valueOf(ar.get('total'));
                          if(focuscat.equalsIgnoreCase('CCTV'))
                          {
                          System.debug('ccccccccccctvfocuscat'+focuscat);
                            acc.CCTV_Score__c=Integer.valueOf(ar.get('total'));

                          }
                          else if(focuscat.equalsIgnoreCase('Perimeter'))
                          {

                            acc.Perimeter_Score__c=Integer.valueOf(ar.get('total'));

                          }
                           else if(focuscat.equalsIgnoreCase('Adequate Lighting'))
                          {

                            acc.Adequate_Lighting_Score__c=Integer.valueOf(ar.get('total'));

                          }
                           else if(focuscat.equalsIgnoreCase('Adequate Locking System'))
                          {

                            acc.Adequate_Locking_Score__c=Integer.valueOf(ar.get('total'));

                          }
                           else if(focuscat.equalsIgnoreCase('Emergency Response Plan'))
                          {

                            acc.Emergency_Response_Plan__c=Integer.valueOf(ar.get('total'));

                          }
                           else if(focuscat.equalsIgnoreCase('Mail Handling'))
                          {

                            acc.Mail_Handling_Score__c=Integer.valueOf(ar.get('total'));

                          }
                      }
                 }
                 System.debug('~~~~~~~~~~~~~~~~~~~~~~~ main report data'+acc);

        try{
         if((acc.Overall_Score__c>0))
         {
            upsert acc;
          }
            }catch(Exception e){}*/

            }
            myFlag = true;
        } //if acc!=null
    }


    public PageReference saveAnswers() {
        //System.debug('IN MAIN SAVE METHOD ' + accountId);
        try {
            if ((this.doRerenderSave != null) || (this.doRerenderSave != false)) {
                ExAM__SectionStatus__c[] userSectionStatus = new ExAM__SectionStatus__c[] {};
                /*if(sectionsStatusLists!=null)
             {
                 userSectionStatus=sectionsStatusLists;
             }
             else
             {*/
                //userSectionStatus=[Select id,Section_Template__c,Status__c,Account_to_SectionStatus__c,User__c from SectionStatus__c where Account_to_SectionStatus__c= :accountId AND Section_Template__c =:listQuestWithOptions[0].newquestFormat.Section_Question__r.id] ;
                userSectionStatus = [Select id, ExAM__Section_Template__c, ExAM__Status__c, ExAM__Issue_Request__c, ExAM__User__c from ExAM__SectionStatus__c where ExAM__Issue_Request__c = : issueId AND ExAM__Section_Template__c = : listQuestWithOptions[0].newquestFormat.ExAM__Section_Question__r.id];
                // }
                System.debug('IN MAIN SAVE METHOD section status~~~~~~~~~~~~~' + userSectionStatus);
                if ((userSectionStatus == null) || (userSectionStatus.size() == 0)) {
                    System.debug('!!!!~~~~~~~~~~~~~SHOULD NEVER COME HERE EVER');
                    ExAM__SectionStatus__c stat = new ExAM__SectionStatus__c();
                    stat.ExAM__User__c = UserInfo.getUserId();
                    stat.ExAM__Account_to_SectionStatus__c = accountId != '' ? accountId : null;
                    stat.ExAM__Issue_Request__c = issueId;
                    stat.ExAM__Section_Template__c = listQuestWithOptions[0].newquestFormat.ExAM__Section_Question__r.id;
                    //stat.ExAM__status__c = 'Complete';
                    System.debug('~~~~~~~~~~~~~in save section NEW status------' + stat);
                    upsert stat;

                } else {
                    System.debug('else in~EDIT~~~~~~~~~~~~' + userSectionStatus);
                    //System.debug('~~~~~~~~~~~~~Record already exists put code for edit');
                  //  userSectionStatus[0].ExAM__Status__c = 'Complete';
                    upsert userSectionStatus;
                }
                map < string, string > formparams = ApexPages.currentPage().getParameters();
                map < string, string > formsubparams = new map < string, string > ();
                for (string keyName: formparams.keySet()) {
                    if (keyName.contains('row')) {
                        formsubparams.put(keyName, formparams.get(keyName));
                        System.debug('~~~~~~~~~~in ' + keyName + ': ' + formparams.get(keyName));
                    } else {
                        System.debug('~~~~~~~~~~in ' + keyName + ': ' + formparams.get(keyName));
                    }
                }




                try {
                    //System.debug('---------------- : in SavelistQuestWithOptions : ' + listQuestWithOptions);
                    //System.debug('~~~~---------------- : in Save : ' + listQuestWithOptions[0]);
                    // System.debug('~~~~~~~~~~in save account id:'+accountId);
                    QuestionDisplay l = new QuestionDisplay();
                    //l.innerSave(listQuestWithOptions,accountId);
                    l.innerSave(listQuestWithOptions, accountId, issueId, formsubparams);
                    /* for(QuestionDisplay t: listQuestWithOptions)
                {
                  //   System.debug('~~~~---------------- : in Save : ' +t);
                  //  System.debug('~~~~---------------- : in Save response object from UI'+  t.resObj.Response__c);

                    t.innerSave(accountId,t.resObj,t.multiselectlist);
                }*/

                    System.debug(' ----------------Record saved successfully : ');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Record saved successfully');
                    ApexPages.addMessage(myMsg);
                } catch (Exception e) {
                    System.debug('------------------Error in the main save method : ' + e);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Record could not be saved Error');
                    ApexPages.addMessage(myMsg);
                }
                // refreshPagePart = true;
                theToggleValApproval = true; //myFlag=true;
            } //if dorender is not null
            // refresh.setRedirect(true);
            // return refresh;
        } catch (Exception e) {
            System.debug('Dont hit save for no questions');
        }
        String urlform = '';
      /*  if (accountId != null && accountId != '') {
            urlform = '/apex/QuestionnaireCustom2?accid=' + accountId + '&issueid=' + issueId + '&templatename=' + templateName;
        } else {
            urlform = '/apex/QuestionnaireCustom2?issueid=' + issueId + '&templatename=' + templateName;
        }*/
        urlform = '/apex/InnovationReview?rid=' + issueId + '&saved=1&appid=' + appid;

        PageReference saveClicked = new PageReference(urlform);
        saveClicked.setRedirect(true);
        //return refresh;
        //return saveClicked;

        templateName = System.currentPageReference().getParameters().get('templatename');
        appid = System.currentPageReference().getParameters().get('appid');

        templateLists = [Select Id, Name, ExAM__Template_name__c from ExAM__Main_questionaire__c where ExAM__Template_name__c = : templateName];
        sectionsStatusLists = [Select id, ExAM__Section_Template__c, ExAM__Section_Template__r.id, ExAM__Section_Template__r.ExAM__Section_Label__c, ExAM__Section_Template__r.ExAM__Questionnaire_Section__c, ExAM__Section_Template__r.ExAM__Order_No__c, ExAM__Issue_Request__c, ExAM__Status__c, ExAM__User__c from ExAM__SectionStatus__c where ExAM__Issue_Request__c = : issueId AND(ExAM__Section_Template__c != null) AND(ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = : templateLists.get(0).Id) order by ExAM__Section_Template__r.ExAM__Order_No__c];
        currentSectionQuestions();
        if(System.currentPageReference().getParameters().get('saveType') == 'menu'){

            return null;
        }else {

            return saveClicked;
        }


    }
    /*public PageReference submitForApproval()
    {
          Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
          req1.setComments('Submitting request for approval.');
          System.debug(' SUMIT FOR APPROVAl-----------');
          accountId=System.currentPageReference().getParameters().get('accId');//to get the school or account id
          req1.setObjectId(accountId);
          System.debug(' SUMIT FOR APPROVAl-----------'+accountId);
          ID elect = [select id from user where username='ilsa.lund@mbaoutcome.com' limit 1].id;
          req1.setNextApproverIds(new Id[] {elect});
          Approval.ProcessResult result = Approval.process(req1);
          System.debug(' SUMIT FOR APPROVAl----result -------'+result );
          System.assert(result.isSuccess());
          PageReference cancelClicked=new PageReference('http://EXAM4SCHOOLS.COM/');
          cancelClicked.setRedirect(false);
          return cancelClicked;

    }*/
    public PageReference submitForApproval() {
        System.debug('~~~~~INSIDE SUBMITurl' + issueId);

        try {
            PageReference tempPageRef = saveAnswers();
            issueId = System.currentPageReference().getParameters().get('issueid');
            System.debug('22222~~~~~INSIDE SUBMITurl' + issueId);
            List<ExAM__IssueRequest_Life_Cycle__c> issuerecord = [Select id, ExAM__Assessor_Resource__c, ExAM__Assessment_Form_Completion__c, ExAM__Date_Completed__c, ExAM__Status__c,
                                                                    ExAM__InvestigationType__c, ExAM__InvestigationType__r.Redirect_to__c//, ExAM__InvestigationType__r.Override_URL__c, ExAM__InvestigationType__r.Quiz_Completed_URL_Page__c
                                                            FROM ExAM__IssueRequest_Life_Cycle__c where id = : issueId];
            if (issuerecord != null && issuerecord.size() > 0) {
                issuerecord[0].ExAM__Assessment_Form_Completion__c = 'Complete';
                System.debug('=====urlissuerecord' + issuerecord);
                //issuerecord.Status__c ='Closed';
                issuerecord[0].ExAM__Status__c = 'Completed';
                upsert issuerecord;

                //Page redirects once assessments completes-if value available in Redirect to field, it will redirect to that page
                if ( issuerecord[0].ExAM__InvestigationType__r.Redirect_to__c != NULL ){

                    //String redirectURLto = 'https://' + issuerecord[0].ExAM__InvestigationType__r.Redirect_to__c;
                    String redirectURLto =  issuerecord[0].ExAM__InvestigationType__r.Redirect_to__c;
                    PageReference redirctAfterComplete = new PageReference( redirectURLto );
                    redirctAfterComplete.setRedirect(true);
                    return redirctAfterComplete;
                }
            }/*
            if (issuerecord != null && issuerecord.size() > 0 && issuerecord[0].ExAM__InvestigationType__r.Override_URL__c == true
                    && issuerecord[0].ExAM__InvestigationType__r.Quiz_Completed_URL_Page__c != null ) {

                PageReference pref1 = new PageReference(issuerecord[0].ExAM__InvestigationType__r.Quiz_Completed_URL_Page__c+'?issueid='+issuerecord[0].Id);
                pref1.setRedirect(true);
                return pref1;
            } */
            /*Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
          req1.setComments('Submitting request for approval.');
          System.debug(' SUMIT FOR APPROVAl-----------');
          accountId=System.currentPageReference().getParameters().get('accid');//to get the school or account id
          req1.setObjectId(accountId);
          System.debug(' SUMIT FOR APPROVAl-----------'+accountId);
          Id syadmin=[select id from profile where name='System Administrator'].id;
          if(syadmin!=null)
          {
          ID elect = [select id,ProfileId from user where ProfileId=:syadmin].id;
          req1.setNextApproverIds(new Id[] {elect});
          Approval.ProcessResult result = Approval.process(req1);
          System.debug(' SUMIT FOR APPROVAl----result -------'+result );
          System.assert(result.isSuccess());
          }*/

        } catch (Exception e) {}
        String hostVal = ApexPages.currentPage().getHeaders().get('Host');
        String urlVal = Apexpages.currentPage().getUrl();
        String URLL = 'https://' + hostVal + urlVal;
        String urls = '/' + issueId;
        System.debug('=====url ' + urls);
        PageReference cancelClicked = new PageReference(urls);
        //System.debug('=====url page ref'+cancelClicked);
        cancelClicked.setRedirect(true);
        return cancelClicked;
    }
    public PageReference cancel() {
        String urlform = '';
        /*if (accountId != null && accountId != '') {
            urlform = '/apex/QuestionnaireCustom2?accid=' + accountId + '&issueid=' + issueId + '&templatename=' + templateName;
        } else {
            urlform = '/apex/QuestionnaireCustom2?issueid=' + issueId + '&templatename=' + templateName;
        }*/
        urlform = '/apex/InnovationReview?rid=' + issueId + '&saved=1&appid=' + appid;

        PageReference saveClicked = new PageReference(urlform);
        saveClicked.setRedirect(true);
        return saveClicked;
    }
    public PageReference cancelRemove1() {
        String urlform = '';
        /*if (accountId != null && accountId != '') {
            urlform = '/apex/QuestionnaireCustom2?accid=' + accountId + '&issueid=' + issueId + '&templatename=' + templateName;
        } else {
            urlform = '/apex/QuestionnaireCustom2?issueid=' + issueId + '&templatename=' + templateName;
        }*/
        urlform = '/apex/InnovationReview?rid=' + issueId + '&saved=1&appid=' + appid;

        PageReference saveClicked = new PageReference(urlform);
        saveClicked.setRedirect(true);
        return saveClicked;
    }
    public PageReference cancelRemove2() {
        String urlform = '';
        /*if (accountId != null && accountId != '') {
            urlform = '/apex/QuestionnaireCustom2?accid=' + accountId + '&issueid=' + issueId + '&templatename=' + templateName;
        } else {
            urlform = '/apex/QuestionnaireCustom2?issueid=' + issueId + '&templatename=' + templateName;
        }*/
        urlform = '/apex/InnovationReview?rid=' + issueId + '&saved=1&appid=' + appid;

        PageReference saveClicked = new PageReference(urlform);
        saveClicked.setRedirect(true);
        return saveClicked;
    }
    public PageReference cancelRemove3() {
        String urlform = '';
        /*if (accountId != null && accountId != '') {
            urlform = '/apex/QuestionnaireCustom2?accid=' + accountId + '&issueid=' + issueId + '&templatename=' + templateName;
        } else {
            urlform = '/apex/QuestionnaireCustom2?issueid=' + issueId + '&templatename=' + templateName;
        }*/
        urlform = '/apex/InnovationReview?rid=' + issueId + '&saved=1&appid=' + appid;

        PageReference saveClicked = new PageReference(urlform);
        saveClicked.setRedirect(true);
        return saveClicked;
    }
  /*  public PageReference exit() {
        PageReference cancelClicked = new PageReference('/home/home.jsp');
        cancelClicked.setRedirect(true);
        return cancelClicked;
    }*/
    //create a new inner class so that we can add the flags for each record and display/create the questions as checklist/text/piclist etc.
    public class QuestionDisplay {
        //each record is sent to the visualforce frontend page iteratively through class vaiable.
        //SELECT  Id,Question_Label__c,Question_Order_No__c,Question_Type__c,Subquestion_Label__c FROM Question_Template__c where Section_Question__r.id=:id order by Question_Order_No__c];
        public ExAM__Question_Template__c newquestFormat {
            get;
            set;
        }
        public ExAM__Questionnaire_Response__c resObj {
            get;
            set;
        }
        public String questionFlag {
            get;
            set;
        } //default
        public List < SelectOption > optionsList {
            get;
            set;
        }
        public String sectionLabel {
            get;
            set;
        }
        public String[] multiselectlist {
            get;
            set;
        }
        public String acctId {
            get;
            set;
        }
        public String issueId {
            get;
            set;
        }
        public Boolean decisionTreeFlag { get; set; }

        public QuestionDisplay(ExAM__Question_Template__c question, List < SelectOption > subQuestionOption, ExAM__Questionnaire_Response__c responseObj, String[] multi) {
            newquestFormat = new ExAM__Question_Template__c();
            optionsList = new List < SelectOption > ();
            resObj = new ExAM__Questionnaire_Response__c();
            this.newquestFormat = question;
            this.resObj = responseObj;
            //this.sectionLabel=sectionLabels;
            this.optionsList = subQuestionOption;
            this.multiselectlist = multi;


        }
        public QuestionDisplay(ExAM__Question_Template__c question, List < SelectOption > subQuestionOption, ExAM__Questionnaire_Response__c responseObj, String[] multi, Boolean decisionTreeFlagParam) {
            newquestFormat = new ExAM__Question_Template__c();
            optionsList = new List < SelectOption > ();
            resObj = new ExAM__Questionnaire_Response__c();
            this.newquestFormat = question;
            this.resObj = responseObj;
            //this.sectionLabel=sectionLabels;
            this.optionsList = subQuestionOption;
            this.multiselectlist = multi;
            this.decisionTreeFlag = decisionTreeFlagParam != null ? decisionTreeFlagParam : false;
        }
        
        public QuestionDisplay(ExAM__Question_Template__c question) {
            this.newquestFormat = question;
        }
        public QuestionDisplay() {

        }

      /*  public Note[] createNotes(ExAM__Questionnaire_Response__c[] responseLists, map < string, string > formsubparams) {
            Note[] attachnotes = new Note[] {};
            for (ExAM__Questionnaire_Response__c r: responseLists) {
                for (string keyName: formsubparams.keySet()) {

                    if ((keyName.startsWith(r.ExAM__Question_Template__c)) && (keyName.contains('row'))) {
                        System.debug('-------NOTES IFformsubparams.get(keyName):' + formsubparams.get(keyName));
                        if ((formsubparams.get(keyName) != null) && (formsubparams.get(keyName) != '')) {
                            note n = new note();
                            n.parentId = r.id;
                            n.body = formsubparams.get(keyName); // body of the note. this should be populated from the notes field that you have shown in the screenshot
                            if ((n.body.startsWith('Recommendation')) || (n.body.startsWith('recommendation'))) {
                                n.title = 'Recommendation' + System.now(); // the title of the note
                            } else {
                                n.title = 'Comment' + System.now();
                            }
                            n.isPrivate = false; // if private it will be visible only for the owner and any user with modify all permission
                            //insert n;
                            attachnotes.add(n);
                            System.debug('~~~NOTES~~~~~~~in ' + keyName + ': ' + n.parentId);
                        }
                    }
                }
            }
            return attachnotes;
        }
*/
        /*public void innerSave(List<QuestionDisplay> qdisplist,String accountId,String issueid,map<string, string> formsubparams) {

            try {
                //Section_Template__c =:listQuestWithOptions[0].newquestFormat.Section_Question__r.id
                acctId=accountId;
                Questionnaire_Response__c[] responseLists=new Questionnaire_Response__c[]{};
                //Give all responses for this section and account
                Questionnaire_Response__c[] reponseObjects=[Select id,Response__c,Question_Template__r.Section_Question__r.id,Question_Template__c,Account_to_Response__c,Questionnaire_Taker_user__c from Questionnaire_Response__c where Account_to_Response__c= :accountId AND Question_Template__r.Section_Question__r.id=:qdisplist[0].newquestFormat.Section_Question__r.id];


                  //   System.debug('~~~~---------------- : in Save : ' +t);
                  //  System.debug('~~~~---------------- : in Save response object from UI'+  t.resObj.Response__c);

                   // t.innerSave(accountId,t.resObj,t.multiselectlist);

                //logic to either create a new record or update if it alraedy exists,if question id and user id same than update elase create new
                //Questionnaire_Response__c[] reponseObject=[Select id,Response__c,Question_Template__c,Account_to_Response__c,Questionnaire_Taker_user__c from Questionnaire_Response__c where Account_to_Response__c= :accountId AND Question_Template__c=:newquestFormat.id];
               // System.debug('INNER SAVE,'+robj);
               if((reponseObjects==null)||(reponseObjects.size()==0))
                        {

                             for(QuestionDisplay t: qdisplist)
                                {
                                    Questionnaire_Response__c respRecord=new Questionnaire_Response__c();
                                    System.debug('create new record');
                                    respRecord.Question_Template__c = t.newquestFormat.id;
                                    respRecord.Questionnaire_Taker_user__c=UserInfo.getUserId();
                                    System.debug('!!!!!!!!!!!~~~~~~~~~~!!!!!!!!!!!new record account'+accountId);
                                    respRecord.Account_to_Response__c=accountId;
                                    respRecord.Weight_Response__c=1;//put some logic for future
                                    //for multilist
                                     //if its mutiselect is not null than put logic to store with tilde sign
                                     String[] str=t.multiselectlist;
                                     String s='';
                                     if(str!=null)
                                        {
                                            for(integer i = 0; i < str.size(); i++)
                                            {
                                            s=str[i]+'~'+s;
                                            }

                                            if(s.endsWithIgnoreCase('~'))
                                            {
                                                s=s.substring(0,s.length()-1);
                                               // s=s.trim();
                                                System.debug('qqqqqqqq SAVING RECORDnewSetStr ============ ' + s);
                                                respRecord.Response__c=s;


                                            }
                                        }
                                        else
                                        {
                                                 System.debug('qqqqqqqq SAVING RECORDnewSetStr ============ ' +t.resObj.Response__c);
                                                 respRecord.Response__c=t.resObj.Response__c;
                                                // System.debug('qqqqqqqq SAVING RECORD BELOW ============ ' +respRecord.Response__c);

                                        }
                                    responseLists.add(respRecord); System.debug('!!!'+respRecord);
                                  }//end for loop
                                  System.debug('-------ALL RECORD TO BE UPSERTED!!!'+responseLists);
                                   if(responseLists.size()>0)
                                   {System.debug('-------ALL RECORD TO BE UPSERTEDresponseLists.size()>0!!!'+responseLists);
                                   upsert responseLists;}
                       }
                       else
                       {
                       //all objects exists so edit only
                        for(QuestionDisplay t: qdisplist)
                                {
                                    for(Questionnaire_Response__c res: reponseObjects)
                                    {
                                        if(t.newquestFormat.id==res.Question_Template__c)
                                        {
                                            //for multilist
                                             //if its mutiselect is not null than put logic to store with tilde sign
                                             String[] str=t.multiselectlist;
                                             String s='';
                                             if(str!=null)
                                                {
                                                    for(integer i = 0; i < str.size(); i++)
                                                    {
                                                    s=str[i]+'~'+s;
                                                    }

                                                    if(s.endsWithIgnoreCase('~'))
                                                    {
                                                        s=s.substring(0,s.length()-1);
                                                        System.debug(' newSetStr ============ ' + s);
                                                        res.Response__c=s;


                                                    }
                                                }
                                             else
                                                 {
                                                   res.Response__c=t.resObj.Response__c;
                                                 }


                                            responseLists.add(res);
                                            break;
                                        }
                                    }//for(Questionnaire_Response__c res


                                  }//end for loop for(QuestionDisplay t: qdisplist)
                                  if(responseLists.size()>0)
                                   {upsert responseLists;}
                          // upsert responseLists;

                }//else

            } catch(Exception e ) {
                System.debug('----------------Exception in saving the records :  ' + e);
            }

        }
        public void innerSave(String accountId,Questionnaire_Response__c robj,String[] str) {
            try {

                acctId=accountId;
                //logic to either create a new record or update if it alraedy exists,if question id and user id same than update elase create new
                Questionnaire_Response__c[] reponseObject=[Select id,Response__c,Question_Template__c,Account_to_Response__c,Questionnaire_Taker_user__c from Questionnaire_Response__c where Account_to_Response__c= :accountId AND Question_Template__c=:newquestFormat.id];
                System.debug('INNER SAVE,'+robj);

                 String s='';
                 if(str!=null)
                    {
                        for(integer i = 0; i < str.size(); i++)
                        {
                        s=str[i]+'~'+s;
                        }

                        if(s.endsWithIgnoreCase('~'))
                        {
                            s=s.substring(0,s.length()-1);
                            System.debug(' newSetStr ============ ' + s);
                            resObj.Response__c=s;


                        }
                    }
                if((reponseObject==null)||(reponseObject.size()==0))
                {
                    System.debug('create new record');
                    resObj.Question_Template__c = newquestFormat.id;
                    resObj.Questionnaire_Taker_user__c=UserInfo.getUserId();
                    System.debug('!!!!!!!!!!!~~~~~~~~~~!!!!!!!!!!!new record account'+accountId);
                    resObj.Account_to_Response__c=accountId;
                    resObj.Weight_Response__c=1;//put some logic for future

                    upsert resObj;
                }
                else
                {

                        if(str!=null)
                        {
                           reponseObject[0].Response__c=s;
                           System.debug('******** str:'+s);

                        }
                        else
                        {
                            reponseObject[0].Response__c=resObj.Response__c;


                        }
                        System.debug('~~~~~~~~~~~~~~~~~~reponseObject[0]:-- '+reponseObject[0]);
                        upsert reponseObject;

                }


            } catch(Exception e ) {
                System.debug('----------------Exception in saving the records :  ' + e);
            }

        }*/

        public void innerSave(List < QuestionDisplay > qdisplist, String accountId, String issueid, map < string, string > formsubparams) {
            try {
                //Section_Template__c =:listQuestWithOptions[0].newquestFormat.Section_Question__r.id
                acctId = accountId != '' ? accountId : null;
                issueId = issueid;
                ExAM__Questionnaire_Response__c[] responseLists = new ExAM__Questionnaire_Response__c[] {};
                //Give all responses for this section and account
                ExAM__Questionnaire_Response__c[] reponseObjects = new ExAM__Questionnaire_Response__c[] {};
                if (acctId != null && acctId != '') {
                    reponseObjects = [Select id, ExAM__Response__c, ExAM__Question_Template__r.ExAM__Section_Question__r.id, ExAM__Question_Template__r.ExAM__Weight_of_Answer__c, ExAM__Question_Template__c, ExAM__Account_to_Response__c, ExAM__Issue_Request__c, ExAM__Weight_Response__c, ExAM__Questionnaire_Taker_user__c, (SELECT Id, Title, body, CreatedDate, Owner.FirstName, Owner.LastName FROM Notes order by CreatedDate) from ExAM__Questionnaire_Response__c where ExAM__Issue_Request__c = : issueId AND ExAM__Account_to_Response__c = : acctId AND ExAM__Question_Template__r.ExAM__Section_Question__r.id = : qdisplist[0].newquestFormat.ExAM__Section_Question__r.id];
                } else {
                    reponseObjects = [Select id, ExAM__Response__c, ExAM__Question_Template__r.ExAM__Section_Question__r.id, ExAM__Question_Template__r.ExAM__Weight_of_Answer__c, ExAM__Question_Template__c, ExAM__Account_to_Response__c, ExAM__Issue_Request__c, ExAM__Weight_Response__c, ExAM__Questionnaire_Taker_user__c, (SELECT Id, Title, body, CreatedDate, Owner.FirstName, Owner.LastName FROM Notes order by CreatedDate) from ExAM__Questionnaire_Response__c where ExAM__Issue_Request__c = : issueId AND ExAM__Question_Template__r.ExAM__Section_Question__r.id = : qdisplist[0].newquestFormat.ExAM__Section_Question__r.id];
                }

                //TO get both notes and attachments--- List<CombinedAttachMent> n=oo.CombinedAttachments;
                Note[] attachnotes = new Note[] {};
                //List<Note> reponsenotes=reponseObjects.Note;
                //   System.debug('~~~~---------------- : in Save : ' +t);
                //  System.debug('~~~~---------------- : in Save response object from UI'+  t.resObj.Response__c);

                // t.innerSave(accountId,t.resObj,t.multiselectlist);

                //logic to either create a new record or update if it alraedy exists,if question id and user id same than update elase create new
                //Questionnaire_Response__c[] reponseObject=[Select id,Response__c,Question_Template__c,Account_to_Response__c,Questionnaire_Taker_user__c from Questionnaire_Response__c where Account_to_Response__c= :accountId AND Question_Template__c=:newquestFormat.id];
                // System.debug('INNER SAVE,'+robj);
                if ((reponseObjects == null) || (reponseObjects.size() == 0)) {
                    /*for(Questionnaire_Response__c res: reponseObjects)
                                {
                                    if(quest.id==res.Question_Template__c)
                                    {
                                        resp=res;break;
                                    }
                                }*/
                    for (QuestionDisplay t: qdisplist) {
                        ExAM__Questionnaire_Response__c respRecord = new ExAM__Questionnaire_Response__c();
                        System.debug('create new record');
                        respRecord.ExAM__Question_Template__c = t.newquestFormat.id;
                        respRecord.ExAM__Questionnaire_Taker_user__c = UserInfo.getUserId();
                        //System.debug('!!!!!!!!!!!~~~~~~~~~~!!!!!!!!!!!new record account'+accountId);
                        respRecord.ExAM__Account_to_Response__c = accountId != '' ? accountId : null;
                        respRecord.ExAM__Issue_Request__c = issueId;
                        //For taking the weights from the question table and assigning the appropriate one to response field of weight
                        String qoption = t.newquestFormat.ExAM__Subquestion_Label__c;
                        List < String > qoptionvalue = new List < String > {};
                        if (qoption != null) {
                            qoptionvalue = qoption.split('~');
                        }
                        String wtoption = t.newquestFormat.ExAM__Weight_of_Answer__c;
                        List < String > wtoptionvalue = new List < String > {};
                        if (wtoption != null) {
                            wtoptionvalue = wtoption.split('~');
                        }

                        //respRecord.Weight_Response__c=0;//added logic below
                        //for multilist
                        //if its mutiselect is not null than put logic to store with tilde sign
                        String[] str = t.multiselectlist;
                        String s = '';

                        double multireswt = 0;
                        if (str != null) {
                            if (t.newquestFormat.ExAM__Question_Type__c.equalsIgnoreCase('MultiselectPicklist')) {
                                respRecord.ExAM__Weight_Response__c = -1;

                            }
                            for (integer i = 0; i < str.size(); i++) {
                                s = str[i] + '~' + s;
                                //for multiselect weight
                                /*if(wtoptionvalue.size()>0)
                                            {
                                            for(integer i1 = 0; i1< qoptionvalue.size(); i1++)
                                                {
                                                    if((str[i]).equalsIgnoreCase(qoptionvalue.get(i1)))
                                                    {
                                                        multireswt+=Double.valueOf(wtoptionvalue.get(i1).trim());  break;
                                                    }
                                                }

                                            respRecord.Weight_Response__c=multireswt;
                                            }*/
                            }
                            if (s.endsWithIgnoreCase('~')) {
                                s = s.substring(0, s.length() - 1);
                                // s=s.trim();
                                // System.debug('qqqqqqqq SAVING RECORDnewSetStr ============ ' + s);
                                respRecord.ExAM__Response__c = s;

                            }
                        } else {
                            //System.debug('qqqqqqqq SAVING RECORDnewSetStr ============ ' +t.resObj.Response__c);
                            respRecord.ExAM__Response__c = t.resObj.ExAM__Response__c;
                            // System.debug('qqqqqqqq SAVING RECORD BELOW ============ ' +respRecord.Response__c);
                            //List<String> qoptionvalue=qoption.split('~');
                            //List<String> wtoptionvalue=wtoption.split('~');
                            if ((respRecord.ExAM__Response__c != null)) {
                                if (t.newquestFormat.ExAM__Question_Type__c.equalsIgnoreCase('RadioPicklist')) {
                                    for (integer i = 0; i < qoptionvalue.size(); i++) {
                                        if ((respRecord.ExAM__Response__c).equalsIgnoreCase(qoptionvalue.get(i))) {
                                            if ((respRecord.ExAM__Response__c).equalsIgnoreCase('N/A') || (respRecord.ExAM__Response__c).equalsIgnoreCase('NA')) {
                                                respRecord.ExAM__Weight_Response__c = -1;
                                            } else {
                                                if (wtoptionvalue.size() > 0) {
                                                    respRecord.ExAM__Weight_Response__c = Double.valueOf(wtoptionvalue.get(i).trim());
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    respRecord.ExAM__Weight_Response__c = -1;
                                }
                                /*else if((t.newquestFormat.Question_Type__c.equalsIgnoreCase('Text'))&&(respRecord.Response__c!=''))
                                                    {
                                                        if(t.newquestFormat.Weight_of_Answer__c!=null)
                                                                {
                                                                    respRecord.Weight_Response__c=Double.valueOf(t.newquestFormat.Weight_of_Answer__c.trim());
                                                                }
                                                    }*/
                            }
                        }


                        responseLists.add(respRecord); //System.debug('!!!'+respRecord);
                    } //end for loop
                    //System.debug('-------ALL RECORD TO BE UPSERTED!!!'+responseLists);
                    if (responseLists.size() > 0) {
                        System.debug('-------ALL RECORD TO BE UPSERTEDresponseLists.size()>0!!!' + responseLists);
                        upsert responseLists;

                        //to call create notes and get existing notes
                      //  attachnotes = createNotes(responseLists, formsubparams);
                    }
                } else {
                    //all objects exists so edit only
                    for (QuestionDisplay t: qdisplist) {
                        integer flagnewquestion = 0; //if a question is later added to assessmnet to a section than response record is created using this logic
                        String qoption = t.newquestFormat.ExAM__Subquestion_Label__c;
                        List < String > qoptionvalue = new List < String > {};
                        if (qoption != null) {
                            qoptionvalue = qoption.split('~');
                        }
                        String wtoption = t.newquestFormat.ExAM__Weight_of_Answer__c;
                        List < String > wtoptionvalue = new List < String > {};
                        if (wtoption != null) {
                            wtoptionvalue = wtoption.split('~');
                        }
                        system.debug('reponseObjects======================'+reponseObjects);
                        for (ExAM__Questionnaire_Response__c res: reponseObjects) {

                            //System.debug('1----- in edit else section t.multiselectlist'+t.multiselectlist+'qtype:'+t.newquestFormat.Question_Type__c);
                            // System.debug('2----- in edit else section response form database'+res);
                            if (t.newquestFormat.id == res.ExAM__Question_Template__c) { //res.Weight_Response__c=0;
                                flagnewquestion = 1; //both reospone object and UI contains that record
                                //if its mutiselect is not null than put logic to store with tilde sign
                                String[] str = t.multiselectlist;
                                String s = '';
                                double multireswt = 0;
                                if (str != null) {
                                    if (t.newquestFormat.ExAM__Question_Type__c.equalsIgnoreCase('MultiselectPicklist')) {
                                        res.ExAM__Weight_Response__c = -1;

                                    }
                                    for (integer i = 0; i < str.size(); i++) {
                                        s = str[i] + '~' + s;

                                        //for multiselect weights
                                        /* if(wtoptionvalue.size()>0)
                                                        {
                                                        for(integer i1 = 0; i1< qoptionvalue.size(); i1++)
                                                        {

                                                            if((str[i]).equalsIgnoreCase(qoptionvalue.get(i1)))
                                                            {
                                                                //System.debug('3 ----- multiselect add weight');
                                                                multireswt+=Double.valueOf(wtoptionvalue.get(i1).trim());  break;
                                                            }
                                                        }
                                                        }*/
                                    }
                                    /* if(wtoptionvalue.size()>0)
                                                        {res.Weight_Response__c=multireswt;
                                                        //System.debug('4 ----- multiselect add weight if option>0');
                                                        }*/

                                    if (s.endsWithIgnoreCase('~')) {
                                        s = s.substring(0, s.length() - 1);
                                        //System.debug(' newSetStr ============ ' + s);
                                        res.ExAM__Response__c = s;

                                    }
                                } else {
                                    res.ExAM__Response__c = t.resObj.ExAM__Response__c;
                                    //System.debug('5 -------else-not multiselectres.Response__c'+res.Response__c);
                                    if ((res.ExAM__Response__c != null)) {
                                        if (t.newquestFormat.ExAM__Question_Type__c.equalsIgnoreCase('RadioPicklist')) {
                                            if (wtoptionvalue.size() > 0) {
                                                for (integer i = 0; i < qoptionvalue.size(); i++) {

                                                    if ((res.ExAM__Response__c).equalsIgnoreCase(qoptionvalue.get(i))) {
                                                        if ((res.ExAM__Response__c).equalsIgnoreCase('N/A') || (res.ExAM__Response__c).equalsIgnoreCase('NA')) {
                                                            res.ExAM__Weight_Response__c = -1;
                                                        } else {
                                                            if (wtoptionvalue.size() > 0) {
                                                                res.ExAM__Weight_Response__c = Double.valueOf(wtoptionvalue.get(i).trim());
                                                                break;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            res.ExAM__Weight_Response__c = -1;
                                        }
                                        /*else if((t.newquestFormat.Question_Type__c.equalsIgnoreCase('Text'))&&(res.Response__c!=''))
                                                        {
                                                           //System.debug(' 8---TEXT-----should not come here if response text blank'+res.Response__c);
                                                           if(t.newquestFormat.Weight_of_Answer__c!=null)
                                                           {
                                                           //System.debug(' 9---TEXT----- response text not blank so assign wtres.Response__c:'+res.Response__c);
                                                           res.Weight_Response__c=Double.valueOf(t.newquestFormat.Weight_of_Answer__c.trim());
                                                           }
                                                        }*/
                                    }

                                }

                                System.debug(res);
                                responseLists.add(res);
                                break;
                            }
                        } //for(Questionnaire_Response__c res
                        if (flagnewquestion == 0) { //its a new question enterd later so create a new response record for it

                            ExAM__Questionnaire_Response__c respRecord = new ExAM__Questionnaire_Response__c();
                            System.debug('create new record');
                            respRecord.ExAM__Question_Template__c = t.newquestFormat.id;
                            respRecord.ExAM__Questionnaire_Taker_user__c = UserInfo.getUserId();
                            //System.debug('!!!!!!!!!!!~~~~~~~~~~!!!!!!!!!!!new record account'+accountId);
                            respRecord.ExAM__Account_to_Response__c = accountId != null ? accountId : null;
                            respRecord.ExAM__Issue_Request__c = issueId;

                            //respRecord.Weight_Response__c=0;//added logic below
                            //for multilist
                            //if its mutiselect is not null than put logic to store with tilde sign
                            String[] str = t.multiselectlist;
                            String s = '';

                            double multireswt = 0;
                            if (str != null) {
                                if (t.newquestFormat.ExAM__Question_Type__c.equalsIgnoreCase('MultiselectPicklist')) {
                                    respRecord.ExAM__Weight_Response__c = -1;

                                }
                                for (integer i = 0; i < str.size(); i++) {
                                    s = str[i] + '~' + s;
                                    //for multiselect weights
                                    /*if(wtoptionvalue.size()>0)
                                                {
                                                for(integer i1 = 0; i1< qoptionvalue.size(); i1++)
                                                    {
                                                        if((str[i]).equalsIgnoreCase(qoptionvalue.get(i1)))
                                                        {
                                                            multireswt+=Double.valueOf(wtoptionvalue.get(i1).trim());  break;
                                                        }
                                                    }

                                                respRecord.Weight_Response__c=multireswt;
                                                }*/
                                }
                                if (s.endsWithIgnoreCase('~')) {
                                    s = s.substring(0, s.length() - 1);
                                    // s=s.trim();
                                    // System.debug('qqqqqqqq SAVING RECORDnewSetStr ============ ' + s);
                                    respRecord.ExAM__Response__c = s;

                                }
                            } else {
                                //System.debug('qqqqqqqq SAVING RECORDnewSetStr ============ ' +t.resObj.Response__c);
                                respRecord.ExAM__Response__c = t.resObj.ExAM__Response__c;
                                // System.debug('qqqqqqqq SAVING RECORD BELOW ============ ' +respRecord.Response__c);
                                //List<String> qoptionvalue=qoption.split('~');
                                //List<String> wtoptionvalue=wtoption.split('~');
                                if ((respRecord.ExAM__Response__c != null)) {
                                    if (t.newquestFormat.ExAM__Question_Type__c.equalsIgnoreCase('RadioPicklist')) {
                                        for (integer i = 0; i < qoptionvalue.size(); i++) {
                                            if ((respRecord.ExAM__Response__c).equalsIgnoreCase(qoptionvalue.get(i))) {
                                                if ((respRecord.ExAM__Response__c).equalsIgnoreCase('N/A') || (respRecord.ExAM__Response__c).equalsIgnoreCase('NA')) {
                                                    respRecord.ExAM__Weight_Response__c = -1;
                                                } else {
                                                    if (wtoptionvalue.size() > 0) {
                                                        respRecord.ExAM__Weight_Response__c = Double.valueOf(wtoptionvalue.get(i).trim());
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        respRecord.ExAM__Weight_Response__c = -1;
                                    }
                                    /*else if((t.newquestFormat.Question_Type__c.equalsIgnoreCase('Text'))&&(respRecord.Response__c!=''))
                                                        {
                                                            if(t.newquestFormat.Weight_of_Answer__c!=null)
                                                                    {
                                                                        respRecord.Weight_Response__c=Double.valueOf(t.newquestFormat.Weight_of_Answer__c.trim());
                                                                    }
                                                        }*/
                                }
                            }




                            responseLists.add(respRecord);


                        } // if(flagnewquestion==0)

                    } //end for loop for(QuestionDisplay t: qdisplist)
                    //System.debug('final responseLists:'+responseLists);
                    if (responseLists.size() > 0) {
                        upsert responseLists;
                    /*    for (ExAM__Questionnaire_Response__c r: responseLists)
                        //to call create notes and get existing notes
                        attachnotes = createNotes(responseLists, formsubparams);
*/
                    }
                    // upsert responseLists;

                } //else

                if (attachnotes.size() > 0) {
                    upsert attachnotes;
                }
            } catch (Exception e) {
                System.debug('----------------Exception in saving the records :  ' + e);
            } finally { //allFileList =null;
            }

        }
    } //end inner class

    /*Delete this metod*/
    /*public List < QuestionDisplay > getquestionsList() {

        return listQuestWithOptions;
    }*/

    //public List < QuestionDisplay > getquestionsList() {
    public void currentSectionQuestions() {
        //String accountId=System.currentPageReference().getParameters().get('accId'); //accId=accountId;
        String accountId = System.currentPageReference().getParameters().get('accid'); //accId=accountId;
        String issueId = System.currentPageReference().getParameters().get('issueid');
        String appid = System.currentPageReference().getParameters().get('appid');
        String templateName = System.currentPageReference().getParameters().get('templatename');
        System.debug('doRerender = ' + this.doRerender);
        Integer i = 0; //theToggleVal =true;
        if (ltoggleApproval == 0) {
            theToggleValApproval = true;
        } else {

        }
        ltoggleApproval++;
        if (ltoggle == 0) {
            theToggleVal = true;
        } else {

        }
        ltoggle++;
        if (this.doRerender == null) {
            List<ExAM__SectionStatus__c> sectionStatusList = [ SELECT Id, ExAM__Issue_Request__c, ExAM__status__c
                                                               FROM ExAM__SectionStatus__c
                                                               WHERE ExAM__status__c ='Complete'
                                                               AND ExAM__Issue_Request__c =:issueId];
            if (sectionStatusList != NULL && sectionStatusList.size() > 0) {
            } else {
                this.doRerender = false;
            }

        }
        if (this.doRerender != null) {

            listQuestWithOptions = new QuestionDisplay[] {};
            listQuestWithText = new QuestionDisplay[] {};
            Id id = System.currentPageReference().getParameters().get('sectionId');

            System.debug('::this.doRerender::::'+this.doRerender+'::::id:::'+id);
            if (!this.doRerender && (id == null )) {
                List<ExAM__IssueRequest_Life_Cycle__c> amList = [SELECT Id, ExAM__InvestigationType__c FROM ExAM__IssueRequest_Life_Cycle__c WHERE Id =:issueId AND ExAM__InvestigationType__c != NULL];
                if (amList != NULL && amList.size() > 0) {
                    List<ExAM__Section_Template__c> secTempList = [SELECT Id, ExAM__Questionnaire_Section__c, ExAM__Order_No__c FROM ExAM__Section_Template__c WHERE ExAM__Questionnaire_Section__c =:amList[0].ExAM__InvestigationType__c Order by ExAM__Order_No__c];
                    if (secTempList != null && secTempList.size() > 0) {
                        id = secTempList[0].id;
                    }
                }
            }
            //sectionId = id;
            System.debug('!!!!!! id of accountId in get quetsion list:' + accountId);
            System.debug('~~~~~~~~333 start  getquestionlist');
            if (id == null) {} else {
                //this returns all questions list in that section
                //questionsLists = [SELECT Id, ExAM__Section_Question__r.id, ExAM__Question_Label__c, ExAM__Question_Order_No__c, ExAM__Weight_of_Answer__c, ExAM__Question_Type__c, ExAM__HelpText__c, ExAM__Subquestion_Label__c, Is_Mandatory__c FROM ExAM__Question_Template__c where ExAM__Section_Question__r.id = : id order by ExAM__Question_Order_No__c];
                questionsLists = new List<ExAM__Question_Template__c> ();
                List<ExAM__Question_Template__c> tempQuestionsLists = [SELECT Id, Name, ExAM__Section_Question__r.id, ExAM__Question_Label__c, ExAM__Question_Order_No__c, ExAM__Weight_of_Answer__c, ExAM__Question_Type__c, ExAM__HelpText__c, ExAM__Subquestion_Label__c, ExAM__Is_Mandatory__c, ExAM__Next_Question__c FROM ExAM__Question_Template__c where ExAM__Section_Question__r.id = : id order by ExAM__Question_Order_No__c];
                Set<String> decisionTreeQuestionSet = new Set<String>();

                for (ExAM__Question_Template__c quesTm : tempQuestionsLists) {
                    if (quesTm.ExAM__Next_Question__c != null) {
                        List<String> questionNameSplit = quesTm.ExAM__Next_Question__c.split('~');
                        if (questionNameSplit != null && questionNameSplit.size() > 0) {
                            decisionTreeQuestionSet.addAll(questionNameSplit);
                        }
                    }
                }
                for (ExAM__Question_Template__c quesTm : tempQuestionsLists) {
                    if (decisionTreeQuestionSet == null || (decisionTreeQuestionSet != null && !decisionTreeQuestionSet.contains(quesTm.Name))) {
                        questionsLists.add(quesTm);
                    }
                }
                //System.debug('----------------questions Returned : ' + questionsLists);
            }
            List < Id > questionIds = new List < Id > ();
            if (questionsLists != NULL && questionsLists.size() >= 1) {
                for (ExAM__Question_Template__c qids: questionsLists) {
                    questionIds.add(qids.id);
                    //System.debug('~~~~~~~~~id='+qids);
                }
            }
            //List<Questionnaire_Response__c> responseObjects = new List<Questionnaire_Response__c>();
            //Questionnaire_Response__c[] responseObjectsAll=[Select id,Response__c,Question_Template__c,Account_to_Response__c,Questionnaire_Taker_user__c from Questionnaire_Response__c where Account_to_Response__c=:accountId and Question_Template__c IN :questionIds order by Question_Template__r.Question_Order_No__c] ;
            ExAM__Questionnaire_Response__c[] responseObjectsAll = new ExAM__Questionnaire_Response__c[] {};
            if (accountId != null && accountId != '') {
                responseObjectsAll = [Select id, ExAM__Response__c, ExAM__Question_Template__c, ExAM__Weight_Response__c, ExAM__Account_to_Response__c, ExAM__Issue_Request__c, ExAM__Questionnaire_Taker_user__c, (SELECT Id, Title, body, CreatedDate, Owner.FirstName, Owner.LastName FROM Notes order by CreatedDate) from ExAM__Questionnaire_Response__c where ExAM__Issue_Request__c = : issueId AND ExAM__Account_to_Response__c = : accountId and ExAM__Question_Template__c IN: questionIds order by ExAM__Question_Template__r.ExAM__Question_Order_No__c];
            } else {
                responseObjectsAll = [Select id, ExAM__Response__c, ExAM__Question_Template__c, ExAM__Weight_Response__c, ExAM__Account_to_Response__c, ExAM__Issue_Request__c, ExAM__Questionnaire_Taker_user__c, (SELECT Id, Title, body, CreatedDate, Owner.FirstName, Owner.LastName FROM Notes order by CreatedDate) from ExAM__Questionnaire_Response__c where ExAM__Issue_Request__c = : issueId AND ExAM__Question_Template__c IN: questionIds order by ExAM__Question_Template__r.ExAM__Question_Order_No__c];
            }

            /*for(Question_Template__c quest: questionsLists )
          {
                 if(responseObjectsAll !=NULL && responseObjectsAll.size()>=1)
                    {
                        for(Questionnaire_Response__c res: responseObjectsAll )
                        {
                            if(quest.id==res.Question_Template__c)
                            {
                                responseObjects.add(res);
                            }
                        }
                    }
          }   */
            //System.debug('Hhhhhhhhhhhhh~~~~~~~~~~~~~'+responseObjects);
            if ((responseObjectsAll == null) || (responseObjectsAll.size() == 0)) {
                //System.debug('~~~~~~~~444 allresponse is null  getquestionlist');

                System.debug('---------q all response null list:' + questionsLists);
                //iterate over and depending on question type,create a list from subquestion label.
                if (questionsLists != NULL && questionsLists.size() >= 1) {
                    for (ExAM__Question_Template__c quest: questionsLists) { //allFileList.add(new Attachment()) ;
                        Note[] attachnotes = new Note[] {};
                        ExAM__Questionnaire_Response__c resp = new ExAM__Questionnaire_Response__c();
                        //resp.Notes=  attachnotes;
                        List < SelectOption > options = new List < SelectOption > ();
                        if (quest.ExAM__Question_Type__c.equalsIgnoreCase('RadioPicklist')) {
                            String qoptionValues = quest.ExAM__Subquestion_Label__c;
                            List < String > ls = qoptionValues.split('~');
                            for (String s: ls) {
                                options.add(new SelectOption(s, s));
                            }
                            //RadioPicklistflag='true';
                            System.debug('-----radio picklist:' + qoptionValues);
                            Boolean isDecisionFlag = false;
                            if (quest.ExAM__Next_Question__c != null) {
                                isDecisionFlag = true;
                            }
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, null, isDecisionFlag ));
                            i = 1;
                        } else if (quest.ExAM__Question_Type__c.equalsIgnoreCase('Text') || quest.ExAM__Question_Type__c.equalsIgnoreCase('Textarea') || quest.ExAM__Question_Type__c.equalsIgnoreCase('Date')) {
                            //Textflag='true';
                            System.debug('-----text:');
                            //options.add(new SelectOption('none','none'));
                            //resp.Response__c=quest.Subquestion_Label__c;
                            //listQuestWithOptions.add(new QuestionDisplay(quest,options,resp,null));

                            if (resp.ExAM__Response__c == null) {
                                if (quest.ExAM__Subquestion_Label__c != null) {
                                    resp.ExAM__Response__c = quest.ExAM__Subquestion_Label__c;
                                }
                            }
                            System.debug('-----resptext:' + resp);
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, null));
                        } else if (quest.ExAM__Question_Type__c.equalsIgnoreCase('File') ) {
                            //Textflag='true';
                            System.debug('-----text:');
                            //options.add(new SelectOption('none','none'));
                            //resp.Response__c=quest.Subquestion_Label__c;
                            //listQuestWithOptions.add(new QuestionDisplay(quest,options,resp,null));

                            if (resp.ExAM__Response__c == null) {
                                if (quest.ExAM__Subquestion_Label__c != null) {
                                    resp.ExAM__Response__c = quest.ExAM__Subquestion_Label__c;
                                }
                            }
                            System.debug('-----resptext:' + resp);
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, null));
                        } else if (quest.ExAM__Question_Type__c.equalsIgnoreCase('MultiselectPicklist')) {
                            String[] multilist = new String[] {};
                            String qoptionValues = quest.ExAM__Subquestion_Label__c;
                            List < String > ls = qoptionValues.split('~');
                            for (String s: ls) {
                                options.add(new SelectOption(s, s));
                            }
                            //MultiselectPicklistflag='true';
                            System.debug('-----radio picklist:' + qoptionValues);
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, multilist));
                            i = 1;
                        }

                    }
                }
            } //if resp
            else {
                System.debug('~~~~~~~~555 response list not null  getquestionlistq list:' + questionsLists);
                //iterate over and depending on question type,create a list from subquestion label.
                if (questionsLists != NULL && questionsLists.size() >= 1) {
                    for (ExAM__Question_Template__c quest: questionsLists) {
                        ExAM__Questionnaire_Response__c resp = new ExAM__Questionnaire_Response__c();
                        for (ExAM__Questionnaire_Response__c res: responseObjectsAll) {
                            if (quest.id == res.ExAM__Question_Template__c) {
                                resp = res;
                                break;
                            }
                        }
                        //Questionnaire_Response__c[] reponseObject=[Select id,Response__c,Question_Template__c,Account_to_Response__c,Questionnaire_Taker_user__c from Questionnaire_Response__c where Questionnaire_Taker_user__c= :UserInfo.getUserId() AND Question_Template__c=:quest.id] ;
                        //Questionnaire_Response__c[] reponseObject=[Select id,Response__c,Question_Template__c,Account_to_Response__c,Questionnaire_Taker_user__c from Questionnaire_Response__c where Account_to_Response__c= :accountId AND Question_Template__c=:quest.id] ;


                        /* if((reponseObject==null)||(reponseObject.size()==0))
                                {
                                 }
                                  else
                                   {
                                   resp=reponseObject[0];
                                   }       */
                        List < SelectOption > options = new List < SelectOption > ();

                        if (quest.ExAM__Question_Type__c.equalsIgnoreCase('RadioPicklist')) {
                            String qoptionValues = quest.ExAM__Subquestion_Label__c;
                            List < String > ls = qoptionValues.split('~');
                            for (String s: ls) {
                                options.add(new SelectOption(s, s));
                            }
                            //RadioPicklistflag='true';
                            System.debug('-----picklistresp:' + resp);
                            Boolean isDecisionFlag = false;
                            if (quest.ExAM__Next_Question__c != null) {
                                isDecisionFlag = true;
                            }
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, null, isDecisionFlag ));
                            i = 1;
                        }  else if (quest.ExAM__Question_Type__c.equalsIgnoreCase('Text') || quest.ExAM__Question_Type__c.equalsIgnoreCase('Textarea') || quest.ExAM__Question_Type__c.equalsIgnoreCase('Date')) {
                            //Textflag='true';
                            System.debug('-----text:');
                            options.add(new SelectOption('none', 'none'));
                            System.debug('-----resptext:' + resp);
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, null));
                        } else if (quest.ExAM__Question_Type__c.equalsIgnoreCase('File') ) {

                            System.debug('-----text:');
                            options.add(new SelectOption('none', 'none'));
                            System.debug('-----resptext:' + resp);
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, null));

                        } else if (quest.ExAM__Question_Type__c.equalsIgnoreCase('MultiselectPicklist')) {
                            String[] multilist = new String[] {};
                            String qoptionValues = quest.ExAM__Subquestion_Label__c;
                            List < String > ls = qoptionValues.split('~');
                            for (String s: ls) {
                                options.add(new SelectOption(s, s));
                            }
                            //MultiselectPicklistflag='true';
                            System.debug('-----radio picklist:' + qoptionValues);
                            if (resp.ExAM__Response__c != null) {
                                multilist = (resp.ExAM__Response__c).split('~');
                                System.debug('QQQQQQQ' + multilist);
                            }
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, multilist));
                            i = 1;
                        }
                        //}
                    }
                }
            }
        }
        System.debug('~~~~~~~~END   start  getquestionlist' + listQuestWithOptions);
        questionsList = listQuestWithOptions;
        //return listQuestWithOptions;

    }

} //main class end