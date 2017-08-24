/**
 * Copyright (c) - Millsapps, Ballinger & Associates (MB&A)
 * All rights reserved.
 * You may only use this code and the application associated with it in conjunction with a valid subscription or license agreement with Millsapps, Ballinger and Associates. 
 * Any use of this code in whole or in part is prohibited including modification, copying in whole or in part or distributing it to any third party.    
 * Please see the full license agreement at http://info.mbaoutcome.com/app-terms-of-service
**/
public class NCACustomerFeedbackController{
    //this is extension class of Main_questionnaire template
    //TAke questionnaire field from section,question,question response,template      
    public String assignmentId;
    
    public String issueId{
        get{         
            return assignmentId;
        }
        set;
    }   
    
    public String message;
    
    public String serviceLine{
        get{
            return serviceLine;
        }
        set;
    } 
    
    public String servLine{
        get{
            return servLine;
        }
        set;
    }  
    
    public String sessionID{get; set;}  
        
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
    public String templateName {
        get{                   
          return System.Label.NCA_Customer_Feeback_Template_Name;            
        }      
        set;
    }
    
    
    
    public String templateId {
        get;
        set;
    }
    public String sectionId {
        get;
        set;    
    }

    public String accountId {
        get{
            return System.Label.NCA_Account_Id;
        }
        set;
    } 
    
    public List < ExAM__Questionnaire_Response__c > QuestionResponse {
        get;
        set;
    }
    public List < QuestionDisplay > listQuestWithOptions;
    public List < QuestionDisplay > questionsList { get; set; }
    
    public QuestionDisplay[] listQuestWithText;    
    public PageReference refresh = new PageReference(ApexPages.currentPage().getUrl());
    public Boolean refreshPagePart {
        get;
        set;
    }
    private Boolean theToggleVal = true;
    static integer ltoggle = 0;
    private Boolean theToggleValApproval = false;
    static integer ltoggleApproval = 0;
    public Transient Boolean doRerender;
    public Transient Boolean doRerenderSave;
    public Transient Boolean doRerenderSave2;
    public Boolean getdoRerender() {
        return doRerender;
    }
    public Boolean getdoRerenderSave() {
        return doRerenderSave;
    }
    public Boolean getdoRerenderSave2() {
        return doRerenderSave2;
    }
    //added for not doing DMl in constructor
    public Boolean myFlag {
        get;
        set;
    }   

    public void setmyFlag(Boolean flags) {
        this.myFlag = flags;
    }

    public void setdoRerender(Boolean doRerender) {
        this.doRerender = doRerender;
        System.debug('doRerender should be set here to true: doRerender = ' + this.doRerender);
    }
    public void setdoRerenderSave(Boolean doRerenderSave) {
        this.doRerenderSave = doRerenderSave;
        System.debug('doRerender should be set here to true: doRerender = ' + this.doRerenderSave);
    }
    public void setdoRerenderSave2(Boolean doRerenderSave2) {
        this.doRerenderSave2 = doRerenderSave2;
        System.debug('doRerender should be set here to true: doRerender = ' + this.doRerenderSave2);
    }
    public Boolean ParamToggle {
        get;
        set;
    }

    public void DoToggle() {
        theToggleVal = ParamToggle;
    }

    public Boolean ShouldDisplay {
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
    }
    
    
    public NCACustomerFeedbackController(ApexPages.StandardSetController controller) {
        refreshPagePart = false; 
        questionsList = new List<QuestionDisplay>();
        currentSectionQuestions();       
        System.debug('Before display');
        System.Debug(questionsList);
        System.Debug(questionsLists);        
        System.Debug('After display');
    }
    
    public NCACustomerFeedbackController() {
    }
    
    

    public void sectionStatus() {
        myFlag = false;
        theToggleVal = false;
        theToggleValApproval = false; 
        if (!myFlag) {
            ExAM__SectionStatus__c[] StatusLists = new ExAM__SectionStatus__c[] {}; //setinitialised(true); 
            accountId = System.Label.NCA_Account_Id;
            accountId = accountId != '' ? accountId : null;            
            templateName =  System.Label.NCA_Customer_Feeback_Template_Name;                 
            templateLists = [Select Id, Name, ExAM__Template_name__c from ExAM__Main_questionaire__c where ExAM__Template_name__c = : templateName];            
            System.debug(templateLists);
            if (templateLists != NULL && templateLists.size() >= 1) {
                templateName = templateLists.get(0).ExAM__Template_name__c;
                sectionsLists = [Select Id, Name, ExAM__status__c, ExAM__Section_label__c, ExAM__Order_No__c from ExAM__Section_Template__c where ExAM__Questionnaire_Section__c = : templateLists.get(0).Id order by ExAM__Order_No__c];
                ExAM__SectionStatus__c[] userSectionStatus = [Select id, ExAM__Section_Template__c, ExAM__Section_Template__r.id, ExAM__Section_Template__r.ExAM__Section_Label__c, ExAM__Section_Template__r.ExAM__Order_No__c, ExAM__Section_Template__r.ExAM__Questionnaire_Section__c, ExAM__Status__c, ExAM__User__c, ExAM__Issue_Request__c from ExAM__SectionStatus__c where ExAM__Issue_Request__c = : issueId AND(ExAM__Section_Template__c != null) AND(ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = : templateLists.get(0).Id) order by ExAM__Section_Template__r.ExAM__Order_No__c];
                System.debug('~~~~~~~~11111~sectionstatus~~~~~~~~~~~~' + userSectionStatus.size());
                if ((userSectionStatus == null) || (userSectionStatus.size() == 0)) {
                    System.debug('~~~~~~~~~~~~~COMES IN SECTION STATUS');
                    for (ExAM__Section_Template__c res: sectionsLists) {
                        ExAM__SectionStatus__c stat = new ExAM__SectionStatus__c();
                        stat.ExAM__User__c = UserInfo.getUserId();
                        stat.ExAM__Issue_Request__c = issueId;
                        stat.ExAM__Section_Template__c = res.id;
                        stat.ExAM__status__c = 'Incomplete';
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
                            //create new section status
                            ExAM__SectionStatus__c newstat = new ExAM__SectionStatus__c();
                            newstat.ExAM__User__c = UserInfo.getUserId();
                            newstat.ExAM__Issue_Request__c = issueId;
                            newstat.ExAM__Section_Template__c = res.id;
                            newstat.ExAM__status__c = 'Incomplete';
                            newstat.ExAM__Account_to_SectionStatus__c = accountId != '' ? accountId : null;
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
                            deleteSectionStatus.add(statusobj);
                        }
                        i = 0;
                    }
                    try { 
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
                    sectionsStatusLists = [Select id, ExAM__Section_Template__c, ExAM__Section_Template__r.id, ExAM__Section_Template__r.ExAM__Section_Label__c, ExAM__Section_Template__r.ExAM__Questionnaire_Section__c, ExAM__Section_Template__r.ExAM__Order_No__c, ExAM__Issue_Request__c, ExAM__Status__c, ExAM__User__c from ExAM__SectionStatus__c where ExAM__Issue_Request__c = : issueId AND(ExAM__Section_Template__c != null) AND(ExAM__Section_Template__r.ExAM__Questionnaire_Section__c = : templateLists.get(0).Id) order by ExAM__Section_Template__r.ExAM__Order_No__c];

                } else { 
                    sectionsStatusLists = userSectionStatus;
                }
                System.debug('~~~~~~~222  section sttus~~~~~~final section list SECTION STATUS LIST----' + sectionsStatusLists);

            }
            myFlag = true;
        }         
        currentSectionQuestions(); 
    }


    public PageReference save() {   
        System.debug('IN MAIN SAVE METHOD ' + accountId);
        if(issueId == null){
            CreateAssignmentManager();
        }
        
        try {
            if ((this.doRerenderSave != null) || (this.doRerenderSave != false || this.doRerenderSave2 != null) || (this.doRerenderSave2 != false)) {
                ExAM__SectionStatus__c[] userSectionStatus = new ExAM__SectionStatus__c[] {};
                userSectionStatus = [Select id, ExAM__Section_Template__c, ExAM__Status__c, ExAM__Issue_Request__c, ExAM__User__c from ExAM__SectionStatus__c where ExAM__Issue_Request__c = : issueId AND ExAM__Section_Template__c = : listQuestWithOptions[0].newquestFormat.ExAM__Section_Question__r.id];
                System.debug('IN MAIN SAVE METHOD section status~~~~~~~~~~~~~' + userSectionStatus);
                if ((userSectionStatus == null) || (userSectionStatus.size() == 0)) {
                    System.debug('!!!!~~~~~~~~~~~~~SHOULD NEVER COME HERE EVER');
                    ExAM__SectionStatus__c stat = new ExAM__SectionStatus__c();
                    stat.ExAM__User__c = UserInfo.getUserId();
                    stat.ExAM__Account_to_SectionStatus__c = accountId != '' ? accountId : null;
                    stat.ExAM__Issue_Request__c = issueId;
                    stat.ExAM__Section_Template__c = listQuestWithOptions[0].newquestFormat.ExAM__Section_Question__r.id;
                    stat.ExAM__status__c = 'Complete';
                    System.debug('~~~~~~~~~~~~~in save section NEW status------' + stat);
                    upsert stat;

                } else {
                    System.debug('else in~EDIT~~~~~~~~~~~~' + userSectionStatus);
                    userSectionStatus[0].ExAM__Status__c = 'Complete';
                    upsert userSectionStatus;
                }
                map < string, string > formparams = ApexPages.currentPage().getParameters();
                map < string, string > formsubparams = new map < string, string > ();
                for (string keyName: formparams.keySet()) {
                    if (keyName.contains('row')) {
                        formsubparams.put(keyName, formparams.get(keyName));
                        System.debug('~~~~~~~~~~in ' + keyName + ': ' + formparams.get(keyName));
                        System.debug('~~~~~~~~~~in ' + keyName + ': ' + formparams.get(keyName));
                    } else {
                        System.debug('~~~~~~~~~~in ' + keyName + ': ' + formparams.get(keyName));
                    }
                }
                try {                 
                    QuestionDisplay l = new QuestionDisplay(); 
                    
                    l.innerSave(listQuestWithOptions, accountId, issueId, formsubparams);
                    System.debug(' ----------------Record saved successfully : ');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Record saved successfully');
                    // Tom had to comment out bumping into SessionControl
                    //ApexPages.addMessage(myMsg);
                } catch (Exception e) {
                    System.debug('------------------Error in the main save method : ' + e);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Record could not be saved Error');
                    ApexPages.addMessage(myMsg);
                }
                refreshPagePart = true;
                theToggleValApproval = true; //myFlag=true; 
            } 
        } catch (Exception e) {
            System.debug('Dont hit save for no questions');
        }
        String urlform = '';
        if (accountId != null && accountId != '') {
            urlform = '/survey/QuestionnaireSurveyVA?accid=' + accountId + '&issueid=' + issueId + '&templatename=' + templateName;
        } else {
            urlform = '/survey/CustomerFeedback?feedback=true&issueid=' + issueId + '&templatename=' + templateName;
        }
        
        PageReference tmp = submitForApproval();
        return tmp;
    }
     
    
    public PageReference submitForApproval() { 
        try {    
            System.debug('22222~~~~~INSIDE SUBMITurl' + issueId);
            List<ExAM__IssueRequest_Life_Cycle__c> issuerecord = [Select id, ExAM__Assessor_Resource__c, ExAM__Assessment_Form_Completion__c, ExAM__Date_Completed__c, ExAM__Status__c, 
                                                                  
                                                                  ExAM__InvestigationType__c, ExAM__InvestigationType__r.Redirect_to__c//, ExAM__InvestigationType__r.Override_URL__c, ExAM__InvestigationType__r.Quiz_Completed_URL_Page__c
                                                            FROM ExAM__IssueRequest_Life_Cycle__c where id = : issueId];
            
            // This is Tom's code, begins Session Control, concatenates 'ip address + date + service line'
            ExAM__Questionnaire_Response__c[] answerList = [SELECT Id, ExAM__Issue_Request__c, Exam_Service_Line__c FROM ExAM__Questionnaire_Response__c ans WHERE ExAM__Issue_Request__c =: issueID];
                       for (ExAM__Questionnaire_Response__c an : answerList) {
                           servLine = an.Exam_Service_Line__c;
                       }  
                 
            if (issuerecord != null && issuerecord.size() > 0) {
                issuerecord[0].ExAM__Assessment_Form_Completion__c = 'Complete';                
                issuerecord[0].ExAM__Status__c = 'Completed';
                String sessionController = system.today().format()+'-'+sessionID+'-'+servLine;
                issuerecord[0].Session_Control__c = sessionController; 
                
                List<ExAM__IssueRequest_Life_Cycle__c> issuerecords = [Select id, Session_Control__c FROM ExAM__IssueRequest_Life_Cycle__c 
                                                                       where Session_Control__c = : sessionController];
                if(issuerecords.size() > 0){
                    ExAM__Questionnaire_Response__c[] savedAnswerList = [SELECT Id, ExAM__Issue_Request__c, Exam_Service_Line__c FROM ExAM__Questionnaire_Response__c ans WHERE ExAM__Issue_Request__c =: issueID];
                    Delete(savedAnswerList);                    
                    ApexPages.addmessage (new ApexPages.message(ApexPages.severity.FATAL, 'You may only rate the same support office once per day.  Either select a different service line or exit the survey by clicking on the button below.'));       
                    
                } else if(issuerecords.size() == 0) {               
                upsert issuerecord;
                
                    //Page redirects once assessments completes-if value available in Redirect to field, it will redirect to that page
                    if ( issuerecord[0].ExAM__InvestigationType__r.Redirect_to__c != NULL && this.doRerenderSave == true ){                
                        String redirectURLto =  issuerecord[0].ExAM__InvestigationType__r.Redirect_to__c;
                        PageReference redirctAfterComplete = new PageReference( redirectURLto );
                        redirctAfterComplete.setRedirect(true);                                          
                        return redirctAfterComplete;
                    }
                    else if (issuerecord[0].ExAM__InvestigationType__r.Redirect_to__c != NULL && this.doRerenderSave2 == true ){
                        String redirectURLto =  '/survey/NCAFeedback?feedback=true';
                        PageReference redirectAfterContinue = new PageReference(redirectURLto);
                        redirectAfterContinue.setRedirect(true);                    
                        return redirectAfterContinue;
                    }
                }            
            }
        } catch (Exception e) {
          System.debug('catch exception: '+ e);
        }
        return NULL;
    }
    
    
    public PageReference Cancel() {
        PageReference cancelClicked = new PageReference('http://www.cem.va.gov/');
        cancelClicked.setRedirect(true);
        return cancelClicked;
    }
    
    
        
    //create a new inner class so that we can add the flags for each record and display/create the questions as checklist/text/piclist etc.
    public class QuestionDisplay {
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
        
        public String serviceLine {
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
            this.optionsList = subQuestionOption;
            this.multiselectlist = multi;
            System.Debug(this);
        }
        public QuestionDisplay(ExAM__Question_Template__c question, List < SelectOption > subQuestionOption, ExAM__Questionnaire_Response__c responseObj, String[] multi, Boolean decisionTreeFlagParam) {
            newquestFormat = new ExAM__Question_Template__c();
            optionsList = new List < SelectOption > ();
            resObj = new ExAM__Questionnaire_Response__c();
            System.Debug('Line 486 inside quetsions');
            System.Debug(question);
            this.newquestFormat = question;
            this.resObj = responseObj;
            //this.sectionLabel=sectionLabels;
            this.optionsList = subQuestionOption;
            this.multiselectlist = multi;
            this.decisionTreeFlag = decisionTreeFlagParam != null ? decisionTreeFlagParam : false;
            System.Debug(this);
        }
        public QuestionDisplay(ExAM__Question_Template__c question) {
            this.newquestFormat = question;
        }
        public QuestionDisplay() {
        }

       
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
                //Note[] attachnotes = new Note[] {};
                if ((reponseObjects == null) || (reponseObjects.size() == 0)) {
                    for (QuestionDisplay t: qdisplist) {
                        ExAM__Questionnaire_Response__c respRecord = new ExAM__Questionnaire_Response__c();
                        System.debug('create new record');
                        respRecord.ExAM__Question_Template__c = t.newquestFormat.id;
                        respRecord.ExAM__Questionnaire_Taker_user__c = UserInfo.getUserId();        
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
                        system.debug('===== tcontreras wtoption :' +wtoption);
                        if (wtoption != null) {
                            wtoptionvalue = wtoption.split('~');
                        }
                        // To get serviceLine for non-weighted Service Line Question                         
                        if (wtoption == null){
                        serviceLine = t.resObj.ExAM__Response__c;
                        }        
                        system.debug('===== tcontreras serviceLine :' + serviceLine);
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
                            }
                            if (s.endsWithIgnoreCase('~')) {
                                s = s.substring(0, s.length() - 1);
                                // s=s.trim();
                                // System.debug('qqqqqqqq SAVING RECORDnewSetStr ============ ' + s);
                                respRecord.ExAM__Response__c = s;

                            }
                        } else {
                            //System.debug('qqqqqqqq SAVING RECORDnewSetStr ============ ' +t.resObj.ExAM__Response__c);
                            respRecord.ExAM__Response__c = t.resObj.ExAM__Response__c;
                            // Adds serviceLine to respRecord.Service_Line__c and corrects for Strongly Agree error
                            if (respRecord.ExAM__Response__c == 'Strongly Agree'){
                                respRecord.Exam_Service_Line__c = serviceLine;
                            }                            
                            respRecord.Exam_Service_Line__c = serviceLine;
                            respRecord.ExAM_Service_Line_Grouping__c = GetServiceLineGroup(serviceLine);
                            
                            if ((respRecord.ExAM__Response__c != null)) {
                                if (t.newquestFormat.ExAM__Question_Type__c.equalsIgnoreCase('RadioPicklist')) {
                                    for (integer i = 0; i < qoptionvalue.size(); i++) 
                                    {
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
                                
                            }
                        }
                        responseLists.add(respRecord); //System.debug('!!!'+respRecord);
                    } //end for loop                      
                    if (responseLists.size() > 0) {
                        System.debug('-------ALL RECORD TO BE UPSERTEDresponseLists.size()>0!!!' + responseLists);
                        upsert responseLists;
                        //attachnotes = createNotes(responseLists, formsubparams);
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
                            if (t.newquestFormat.id == res.ExAM__Question_Template__c) { //res.ExAM__Weight_Response__c=0;
                                flagnewquestion = 1; //both reospone object and UI contains that record                                
                                String[] str = t.multiselectlist;
                                String s = '';
                                double multireswt = 0;
                                if (str != null) {
                                    if (t.newquestFormat.ExAM__Question_Type__c.equalsIgnoreCase('MultiselectPicklist')) {
                                        res.ExAM__Weight_Response__c = -1;
                                    }
                                    for (integer i = 0; i < str.size(); i++) {
                                        s = str[i] + '~' + s;
                                    }
                                    if (s.endsWithIgnoreCase('~')) {
                                        s = s.substring(0, s.length() - 1);                                        
                                        res.ExAM__Response__c = s;
                                    }
                                    }
                                   else {
                                    res.ExAM__Response__c = t.resObj.ExAM__Response__c;                                    
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
                                    }
                                }

                                System.debug(res);
                                responseLists.add(res);
                                break;
                            }
                        } //for(ExAM__Questionnaire_Response__c res
                        if (flagnewquestion == 0) { //its a new question enterd later so create a new response record for it

                            ExAM__Questionnaire_Response__c respRecord = new ExAM__Questionnaire_Response__c();
                            System.debug('create new record');
                            respRecord.ExAM__Question_Template__c = t.newquestFormat.id;
                            respRecord.ExAM__Questionnaire_Taker_user__c = UserInfo.getUserId();
                            //System.debug('!!!!!!!!!!!~~~~~~~~~~!!!!!!!!!!!new record account'+accountId);
                            respRecord.ExAM__Account_to_Response__c = accountId != null ? accountId : null;
                            respRecord.ExAM__Issue_Request__c = issueId;
                            //respRecord.ExAM__Weight_Response__c=0;//added logic below
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
                                }
                                if (s.endsWithIgnoreCase('~')) {
                                    s = s.substring(0, s.length() - 1);                                    
                                    respRecord.ExAM__Response__c = s;

                                }
                            } else {                                
                                respRecord.ExAM__Response__c = t.resObj.ExAM__Response__c;                                
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
                                }
                            }
                            responseLists.add(respRecord);
                        } // if(flagnewquestion==0)

                    } //end for loop for(QuestionDisplay t: qdisplist)                     
                    if (responseLists.size() > 0) {
                        upsert responseLists;
                        //for (ExAM__Questionnaire_Response__c r: responseLists)
                        //to call create notes and get existing notes
                        //attachnotes = createNotes(responseLists, formsubparams);
                    }
                   } 
                //if (attachnotes.size() > 0) {
                //    upsert attachnotes;
                //}
            } catch (Exception e) {
                System.debug('----------------Exception in saving the records :  ' + e);
            } finally { //allFileList =null;
            }

        }
    } //end inner class
    
    public void currentSectionQuestions() {
        System.Debug('Get Questions Inside current SectionQuestions');       
        accountId = System.Label.NCA_Account_Id;
        accountId = accountId != '' ? accountId : null;
        String templateName = System.Label.NCA_Customer_Feedback_Survey_Template;        
        Integer i = 0; 
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
               this.doRerender = false;            
        }    
        
        System.Debug('~~~555~~~' + this.doRerender);        
        this.doRerender = true;
        if (this.doRerender != null) {
            listQuestWithOptions = new QuestionDisplay[] {};
            listQuestWithText = new QuestionDisplay[] {};            
            List<Id> secIds = new List<Id>();
            Id id = System.Label.NCA_Customer_Feeback_Section_Id;
            secIds.add(id);
                       
            if (id == null) {} else {            
                questionsLists = new List<ExAM__Question_Template__c> ();
                List<ExAM__Question_Template__c> tempQuestionsLists = [SELECT Id, Name, ExAM__Section_Question__r.id, ExAM__Question_Label__c, ExAM__Question_Order_No__c, ExAM__Weight_of_Answer__c, ExAM__Question_Type__c, ExAM__HelpText__c, ExAM__Subquestion_Label__c, ExAM__Is_Mandatory__c, ExAM__Next_Question__c FROM ExAM__Question_Template__c where ExAM__Section_Question__r.id IN : secIds order by ExAM__Question_Order_No__c];
                System.debug('Question Template Today');
                System.Debug(tempQuestionsLists);
                
                Set<String> decisionTreeQuestionSet = new Set<String>();
                
                for (ExAM__Question_Template__c quesTm : tempQuestionsLists) {
                    if (quesTm.ExAM__Next_Question__c != null) {
                        System.Debug('Inside 101 next question');
                        List<String> questionNameSplit = quesTm.ExAM__Next_Question__c.split('~');
                        if (questionNameSplit != null && questionNameSplit.size() > 0) {
                            System.Debug('Inside 102 decision question ');
                            decisionTreeQuestionSet.addAll(questionNameSplit);
                        }
                    }
                }
                for (ExAM__Question_Template__c quesTm : tempQuestionsLists) {
                    if (decisionTreeQuestionSet == null || (decisionTreeQuestionSet != null && !decisionTreeQuestionSet.contains(quesTm.Name))) {
                        System.Debug('Inside 104  question add');
                        System.Debug(quesTm);
                        questionsLists.add(quesTm);
                    }
                }
            }
        
            
            List < Id > questionIds = new List < Id > ();
            if (questionsLists != NULL && questionsLists.size() >= 1) {
                for (ExAM__Question_Template__c qids: questionsLists) {
                    System.Debug('Inside 105  question ids add');
                    questionIds.add(qids.id);                 
                }
            }            
            ExAM__Questionnaire_Response__c[] responseObjectsAll = new ExAM__Questionnaire_Response__c[] {};
          
            if ((responseObjectsAll == null) || (responseObjectsAll.size() == 0)) {          
                System.Debug('Inside 106  question response null');
                System.debug('---------q all response null list:' + questionsLists);                
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
                               List <String> lsOption = s.split('!');                                
                                if(lsOption.size() ==1){
                                    options.add(new SelectOption(s, s));                                    
                                }
                                else
                                {
                                     SelectOption so1 = new SelectOption(lsOption[0], lsOption[1]);
                                     so1.setEscapeItem(false);
                                     options.add(so1);
                                }
                            }
                            //RadioPicklistflag='true';
                            System.debug('-----radio picklist:' + qoptionValues);
                            Boolean isDecisionFlag = false;
                            if (quest.ExAM__Next_Question__c != null) {
                                isDecisionFlag = true;
                            }
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, null, isDecisionFlag ));
                            System.debug(listQuestWithOptions);
                            i = 1;
                        } else if (quest.ExAM__Question_Type__c.equalsIgnoreCase('Text') || quest.ExAM__Question_Type__c.equalsIgnoreCase('Textarea') || quest.ExAM__Question_Type__c.equalsIgnoreCase('Date')) {
                            if (resp.ExAM__Response__c == null) {
                                if (quest.ExAM__Subquestion_Label__c != null) {
                                    resp.ExAM__Response__c = quest.ExAM__Subquestion_Label__c;
                                }
                            }
                            System.debug('-----resptext:' + resp);
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, null));
                        } 

                    }
                }                
            } //if resp
            else {
                System.Debug('Inside 111  getquestion add');
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
                        List < SelectOption > options = new List < SelectOption > ();
                        if (quest.ExAM__Question_Type__c.equalsIgnoreCase('RadioPicklist')) {
                            String qoptionValues = quest.ExAM__Subquestion_Label__c;
                            List < String > ls = qoptionValues.split('~');
                            for (String s: ls) {
                                s = s.replace('&lt;', '<');
                                s=s.replace('&gt;', '>');
                                options.add(new SelectOption(s, s));
                            }
                            System.debug('-----picklistresp:' + resp);
                            Boolean isDecisionFlag = false;
                            if (quest.ExAM__Next_Question__c != null) {
                                isDecisionFlag = true;
                            }
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, null, isDecisionFlag ));
                            i = 1;
                        }  else if (quest.ExAM__Question_Type__c.equalsIgnoreCase('Text') || quest.ExAM__Question_Type__c.equalsIgnoreCase('Textarea') || quest.ExAM__Question_Type__c.equalsIgnoreCase('Date')) {
                            System.debug('-----text:');
                            options.add(new SelectOption('none', 'none'));
                            System.debug('-----resptext:' + resp);
                            listQuestWithOptions.add(new QuestionDisplay(quest, options, resp, null));
                        } 
                           
                    }
                }
            }
        }
        System.debug('~~~~~~~~END   start  getquestionlist' + listQuestWithOptions);
        questionsList = listQuestWithOptions;                   
    }
    
    public void createCookie() {
        Cookie setCookie = ApexPages.currentPage().getCookies().get('setCookie');

        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'setCookie', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        if (setCookie == null) {           
            Integer len = 10;
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            String randStr = key.substring(0,len);
            System.debug(randStr);
            
            setCookie = new Cookie('setCookie',randStr,null,-1,false);
        } else {
        // If this isn't the first time the user is accessing the page
        // uses existing cookie 
            setCookie = ApexPages.currentPage().getCookies().get('setCookie');
            System.debug('this uses exiting cookie');
        }
        
        // Set the new and/or existing cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{setCookie});

    }


    // This method is used by the Visualforce action {!count} to display the current 
    // value of the number of times a user had displayed a page. 
    // This value is stored in the cookie.
    public String getCookie() {
        Cookie setCookie = ApexPages.currentPage().getCookies().get('setCookie');
        if(setCookie == null) {
            return '0';
        }
        return setCookie.getValue();
    }
    
   
        
    public void CreateAssignmentManager()
    {   
        createCookie();
        getCookie();
        String getCookie = getCookie();
        system.debug('string getCookie: '+ getCookie);           
        
        if(assignmentId == null){       
            ExAM__IssueRequest_Life_Cycle__c newAM = new ExAM__IssueRequest_Life_Cycle__c();
            newAM.ExAM__Status__c = 'Open';
            newAM.Session_Cookie__c = getCookie;
            newAM.ExAM__InvestigationType__c = System.Label.NCA_Customer_Feedback_Survey_Template;
            newAM.ExAM__Facility_Name__c = (Id)accountId ;
            insert newAM;
            System.Debug('Test Assignment Manager after insert');
            System.Debug(newAM);                
            assignmentId = newAM.Id;
            sessionID = getCookie;
            System.debug('sessionID: '+sessionID);
            
        }
    }
    
    
     public static string GetServiceLineGroup(String service){ 
     Map<String, String> ServiceLineMap = new Map<String,String>();
     ServiceLineMap.put('Office of the Interim Under Secretary for Memorial Affairs (40, 40A, 40A1)','USMA');  
     ServiceLineMap.put('Alternative Dispute Resolution and Diversity (40A2)','USMA');
     ServiceLineMap.put('Veterans Cemetery Grants Program (40A3)','USMA');
     ServiceLineMap.put('Office of the Deputy Under Secretary for Field Programs and Cemetery Operations (41)','DUSFP');
     ServiceLineMap.put('Office of Field Programs (Policy, Planning and Communications; Current and Integrated Operations; and Emergency Preparedness) (41A)','DUSFP');
     ServiceLineMap.put('Scheduling Office/Eligibility (41A1)','DUSFP');
     ServiceLineMap.put('Memorial Programs Service (41B)','DUSFP');
     ServiceLineMap.put('Cemetery Development and Improvement Service (41C)','DUSFP');
     ServiceLineMap.put('Continental District Office (789)','DUSFP');
     ServiceLineMap.put('Pacific District Office (775)','DUSFP');
     ServiceLineMap.put('North Atlantic District Office (787)','DUSFP');
     ServiceLineMap.put('Southeast District Office (788)','DUSFP');
     ServiceLineMap.put('Midwest District Office (774)','DUSFP');
     ServiceLineMap.put('Office of the Deputy Under Secretary for Finance and Planning/Chief Financial Officer (42)','DUSF&P');    
     ServiceLineMap.put('Policy and Planning Service (42A)','DUSF&P');
     ServiceLineMap.put('Budget Service (42B)' ,'DUSF&P');
     ServiceLineMap.put('Finance Service (42C)','DUSF&P');
     ServiceLineMap.put('Improvement and Compliance Service (42D)','DUSF&P');
     ServiceLineMap.put('Legislative and Regulatory Service (42E)','DUSF&P');
     ServiceLineMap.put('Office of the Deputy Under Secretary for Management (43)','DUSM');    
     ServiceLineMap.put('Management and Communications Service (43A)','DUSM');
     ServiceLineMap.put('Design and Construction Service (43B)','DUSM');
     ServiceLineMap.put('Contracting Service (43C)','DUSM');
     ServiceLineMap.put('Management and Business Support Services (43D)','DUSM');
     ServiceLineMap.put('Business Transformation, Sustainment & Requirements Service (43E)','DUSM');
     ServiceLineMap.put('Training, Workforce Development & Safety Service (43F1)','DUSM');
     ServiceLineMap.put('Human Capital Management Policy and Programs Service (43F2)','DUSM');
     ServiceLineMap.put('Human Resources Center (43F3)','DUSM');
     
     return ServiceLineMap.get(service);
}
    
    
} //main class end3