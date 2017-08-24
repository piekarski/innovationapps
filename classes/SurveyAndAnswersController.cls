public class SurveyAndAnswersController {
    public string tempId { get; set; }
    public string templateName { get; set; }
    public string templateFriendlyName { get; set; }
    public string objId { get; set; }
    public string assessibleFieldName { get; set; }
    public string decisionTreeResultString { get; set; }
    public Boolean skip_Answer_For_Decision_Tree_Steps { get; set; }
    public string headerStr { get; set; }
    public string footerStr { get; set; }
    public string templateDescription { get; set; }
    public string surveyIntro { get; set; }
    public string assignmentId { get;set;}
    public ExAM__IssueRequest_Life_Cycle__c currentAssignment {get;set;}
    public string amReqdStatus { get; set; }
    public string redirectUrl { get; set; }
    public Boolean showImgIcon { get; set; }
    public Boolean showNotesIcon { get; set; }
    public Boolean showRefreshIcon { get; set; }
    public Boolean showModalWindow { get; set; }
    public string modalWindowTxt { get; set; }
    public string assessibleObjReferenceForAnsCreation { get; set; }

    public class FilteredSectionAndQuestionTemplateClass {
        public ExAM__Section_Template__c sectionTemplateRecord{get; set;}
        public List<ExAM__Question_Template__c> questionTemplateRecords{get; set;}

        public FilteredSectionAndQuestionTemplateClass(ExAM__Section_Template__c sectionTemplate, List<ExAM__Question_Template__c> questionTemplateList) {

            this.sectionTemplateRecord = sectionTemplate;
            this.questionTemplateRecords = questionTemplateList;
        }
    }

    public class AnswerRecordClass {
        public String questiontemplateId;
        public String assignmentManagerId;
        public String response;
        public String comment;
    }

    public class DecisionTreeResultClass {
        public String fieldLabelName{get;set;}
        public String fieldAPIName{get;set;}
        public String fieldType{get;set;}
        public List<String> picklistValues{get;set;}

        public DecisionTreeResultClass(String fieldLabel, String fieldAPI, String fieldType, List<String> pklstValuesList) {

            this.fieldLabelName = fieldLabel;
            this.fieldAPIName = fieldAPI;
            this.fieldType = fieldType;
            this.picklistValues = pklstValuesList;
        }
    }

    public class AttachmentDetails {
        public string fileNameStr;
        public string imgContent;
        public string cType;
        public string parentIdStr;
        public Boolean isPrivate;
    }

    public SurveyAndAnswersController() {
        //tempId = ApexPages.currentPage().getParameters().get('tempId');
        //objId = ApexPages.currentPage().getParameters().get('objId');
        assignmentId = ApexPages.currentPage().getParameters().get('Id');
        List<ExAM__IssueRequest_Life_Cycle__c> lsAssignments = [SELECT CreatedDate, Id, ExAM__InvestigationType__c, AM_AGPSurveyParticipant__c, Name FROM ExAM__IssueRequest_Life_Cycle__c WHERE Id =: assignmentId];

        if(lsAssignments.size() > 0 ) {
              currentAssignment = lsAssignments[0];
              objId = currentAssignment.AM_AGPSurveyParticipant__c;
              tempId = currentAssignment.ExAM__InvestigationType__c;
        }
        else
            return;


        String sObjName = Id.valueOf(objId).getSObjectType().getDescribe().getName();
        assessibleFieldName = (sObjName == 'Account') ? 'ExAM__Facility_Name__c' : 'AM_'+sObjName;
        assessibleObjReferenceForAnsCreation = (sObjName == 'Account') ? 'ExAM__Account_to_Response__c' : '';

        if (sObjName != 'Account') {

            Map <string, Schema.SObjectField> answerFieldNameAPIMap = Schema.SObjectType.ExAM__Questionnaire_Response__c.fields.getMap();
            for (Schema.SObjectField ansfield : answerFieldNameAPIMap.values()) {

                Schema.DescribeFieldResult res = ansfield.getdescribe();

                if (String.valueOf(res.getType()).touppercase() == 'REFERENCE' && res.isCustom() && res.getLocalName().startsWithIgnoreCase('ANS_')) {
                    for(Schema.SObjectType reference : res.getReferenceTo()) {

                        if (sObjName.equalsIgnoreCase(reference.getDescribe().getName())) {

                                assessibleObjReferenceForAnsCreation = res.getName();
                                break;
                        }
                    }
                }
            }
        }

        headerStr = footerStr = amReqdStatus = '';

        showImgIcon = false;
        showNotesIcon = false;
        showRefreshIcon = false;

        showModalWindow = false;
        modalWindowTxt = '';

        if (string.isNotBlank(tempId) && tempId != 'null') {

            List<ExAM__Main_questionaire__c> templateList = new List<ExAM__Main_questionaire__c>();
            templateList = [
                SELECT ExAM__Assessment_Completed_URL__c, Id, ExAM__Modal_Window_Text__c, Name, ExAM__Public_Assessment_Page_Footer__c,
                       ExAM__Public_Assessment_Page_Header__c, ExAM__Show_Image_Upload_Icon__c, ExAM__Show_Modal_Window__c,
                       ExAM__Show_Notes_Icon__c, ExAM__Show_Refresh_Icon__c, ExAM__Template_name__c, ExAM__Description__c, Survey_Intro__c
                FROM   ExAM__Main_questionaire__c
                WHERE  Id = :tempId
            ];
            if (templateList != null && templateList.size() > 0) {

                templateName = templateList[0].Name;
                templateFriendlyName = templateList[0].ExAM__Template_name__c;
                surveyIntro = templateList[0].Survey_Intro__c;
                headerStr = templateList[0].ExAM__Public_Assessment_Page_Header__c;
                footerStr = templateList[0].ExAM__Public_Assessment_Page_Footer__c;
                showImgIcon = templateList[0].ExAM__Show_Image_Upload_Icon__c;
                showNotesIcon = templateList[0].ExAM__Show_Notes_Icon__c;
                showRefreshIcon = templateList[0].ExAM__Show_Refresh_Icon__c;

                showModalWindow = templateList[0].ExAM__Show_Modal_Window__c;
                modalWindowTxt = templateList[0].ExAM__Modal_Window_Text__c;

                if (templateList[0].ExAM__Assessment_Completed_URL__c != null) {
                    redirectUrl = templateList[0].ExAM__Assessment_Completed_URL__c;
                }
            }
        }

        decisionTreeResultString = constructDecisionTreeResultQuestion();
    }//end constructor

    public String constructDecisionTreeResultQuestion() {

        Boolean isPictureConfig = false;
        String decisionTreeResultStr = '';
        String fields = '';
        List<DecisionTreeResultClass> decisionTreeResultList = new List<DecisionTreeResultClass>();
        List<ExAM__ExAM_Configuration__c> configRecordList = new List<ExAM__ExAM_Configuration__c>();
        Set<String> fieldSet = new Set<String>();

        configRecordList = [
            SELECT ExAM__Decision_Tree__c, Id, ExAM__Overall_Status_on_Submit__c, Name, ExAM__skip_Answer_For_Decision_Tree_Steps__c
            FROM   ExAM__ExAM_Configuration__c LIMIT 1
        ];

        if (configRecordList != null && configRecordList.size() > 0) {

            skip_Answer_For_Decision_Tree_Steps = configRecordList[0].ExAM__skip_Answer_For_Decision_Tree_Steps__c;
            amReqdStatus = configRecordList[0].ExAM__Overall_Status_on_Submit__c;
            List<String> fieldListTemp = new List<String>();

            fields = configRecordList[0].ExAM__Decision_Tree__c;
            if ( String.isNotBlank(fields)) {

                if (fields.contains('~')) {

                    fieldListTemp = fields.split('~');
                }
                else {

                    fieldListTemp.add( fields );
                }
            }

            for(String f : fieldListTemp) {
                if (f != 'Pictures' && f.contains('__c')) {
                    fieldSet.add(f.toLowercase());
                } else if (f == 'Pictures') {
                    isPictureConfig = true;
                }
            }

            Map <string, Schema.SObjectField> answerFieldNameAPIMap = Schema.SObjectType.ExAM__Questionnaire_Response__c.fields.getMap();
            for (String ansStr : answerFieldNameAPIMap.keySet()) {

                Schema.SObjectField ansfield = answerFieldNameAPIMap.get(ansStr);
                if (fieldSet != null && fieldSet.contains(ansStr)) {

                    Schema.DescribeFieldResult res = ansfield.getdescribe();

                    List<String> picklistvalueTempList = new List<String>();
                    if (res.getType() == Schema.DisplayType.pickList) {

                        List<Schema.PicklistEntry> ple = res.getPicklistValues();
                        for( Schema.PicklistEntry f : ple) {
                            picklistvalueTempList.add(f.getValue());
                        }
                    }
                    decisionTreeResultList.add( new DecisionTreeResultClass(res.getLabel(), res.getName(), res.getType().name(), picklistvalueTempList) );



                }// end if fieldSet contains the api name of current field in iteration
            }// end answerFieldNameAPIMap fields map iteration

            if (isPictureConfig) {
                decisionTreeResultList.add(new DecisionTreeResultClass('Picture', '', 'PICTURE', new List<String>()) );
            }
            if (decisionTreeResultList != null && decisionTreeResultList.size() > 0) {

                decisionTreeResultStr = JSON.serialize(decisionTreeResultList);
            }

        }// end if configRecordList size check
        return decisionTreeResultStr;
    }

    @RemoteAction
    public static List<FilteredSectionAndQuestionTemplateClass> returnSectionAndQuestionTemplate(String assessmentTemplateId) {

        List<ExAM__Question_Template__c> primaryQuestionsList;
        List<FilteredSectionAndQuestionTemplateClass> filteredInnerClassList = new List<FilteredSectionAndQuestionTemplateClass>();
        Set<String> questionTemplateNameSet = new Set<String>();

        try {

            List<ExAM__Section_Template__c> sectionTemplateList = new List<ExAM__Section_Template__c>();

            Map<Id, ExAM__Section_Template__c> sectionTemplateMap = new Map<Id, ExAM__Section_Template__c>(
                [
                    SELECT Id, Name, ExAM__No_of_Questions_Section__c, ExAM__No_of_response_per_section_per_user__c, ExAM__Order_No__c, ExAM__Questionnaire_Section__c,
                           ExAM__Section_Description__c, ExAM__Section_label__c, ExAM__Section_Weight__c, ExAM__status__c, ExAM__Subsectionlabel__c, ExAM__SuperSection__c
                    FROM   ExAM__Section_Template__c
                    WHERE  ExAM__Questionnaire_Section__c = :assessmentTemplateId ORDER BY ExAM__Order_No__c ASC
                ]
            );

            Map<Id, List<ExAM__Question_Template__c>> sectionTemplateIdAndQuestionTemplateListMap = new Map<Id, List<ExAM__Question_Template__c>>();
            for(ExAM__Question_Template__c qt : [SELECT ExAM__Do_Not_Create_Answer__c, ExAM__HelpText__c, ExAM__Is_Mandatory__c, Name, ExAM__Next_Question__c,
                                                  ExAM__Question_Label__c, ExAM__Question_Order_No__c, ExAM__Question_Type__c, ExAM__Subquestion_Label__c,
                                                  ExAM__Section_Question__c, ExAM__SubSection_label__c, ExAM__Weight_Of_Question__c
                                           FROM   ExAM__Question_Template__c
                                           WHERE  ExAM__Section_Question__c IN :sectionTemplateMap.keySet()]) {

                    if (!sectionTemplateIdAndQuestionTemplateListMap.containsKey(qt.ExAM__Section_Question__c)) {
                        sectionTemplateIdAndQuestionTemplateListMap.put(qt.ExAM__Section_Question__c, new List<ExAM__Question_Template__c>());
                    }
                    sectionTemplateIdAndQuestionTemplateListMap.get(qt.ExAM__Section_Question__c).add( qt );
            }

            for(ExAM__Section_Template__c sectionTemplateRecord : sectionTemplateMap.values()) {

                if (sectionTemplateIdAndQuestionTemplateListMap.containsKey(sectionTemplateRecord.Id) &&
                    sectionTemplateIdAndQuestionTemplateListMap.get( sectionTemplateRecord.Id ).size() > 0
                ) {

                    for(ExAM__Question_Template__c questionTemplateRecord : sectionTemplateIdAndQuestionTemplateListMap.get(sectionTemplateRecord.Id) ) {

                        if (String.isNotBlank(questionTemplateRecord.ExAM__Next_Question__c) &&
                            (questionTemplateRecord.ExAM__Question_Type__c == 'RadioPicklist' || questionTemplateRecord.ExAM__Question_Type__c == 'Dropdown Picklist')
                        ) {

                                if (questionTemplateRecord.ExAM__Next_Question__c.contains('~')) {

                                    questionTemplateNameSet.addAll( questionTemplateRecord.ExAM__Next_Question__c.split('~') );
                                }
                                else {

                                    questionTemplateNameSet.add( questionTemplateRecord.ExAM__Next_Question__c );
                                }
                        }
                    }
                }
            }

            for(ExAM__Section_Template__c sectionTemplateRecord : sectionTemplateMap.values()) {

                primaryQuestionsList = new List<ExAM__Question_Template__c>();
                if (sectionTemplateIdAndQuestionTemplateListMap.containsKey(sectionTemplateRecord.Id) &&
                    sectionTemplateIdAndQuestionTemplateListMap.get( sectionTemplateRecord.Id ).size() > 0
                ) {

                    for(ExAM__Question_Template__c questionTemplateRecord : sectionTemplateIdAndQuestionTemplateListMap.get(sectionTemplateRecord.Id) ) {

                        if (questionTemplateNameSet.size() == 0 ||
                            (questionTemplateNameSet.size() > 0 && !questionTemplateNameSet.contains( questionTemplateRecord.Name ))
                        ) {

                            primaryQuestionsList.add( questionTemplateRecord );
                        }
                    }
                }
                filteredInnerClassList.add( new FilteredSectionAndQuestionTemplateClass(sectionTemplateRecord, primaryQuestionsList) );
            }


        }catch(Exception exp) {

            filteredInnerClassList.add( new FilteredSectionAndQuestionTemplateClass(new ExAM__Section_Template__c(), new List<ExAM__Question_Template__c>()) );
        }
        return filteredInnerClassList;
    }

    @RemoteAction
    public static String saveAnswerRecords(List<AnswerRecordClass> answerList, String tempId, String assessibleObjId, String assessibleFieldApiName, String amReqdStatus, String assessibleObjReferenceForAnsCreation, String amId) {
        String fieldPrefix = 'AM_';
        String resultMsg = 'No Answer Records to save';
        SObject newASMRecord;
        List<ExAM__Questionnaire_Response__c> upsertAnswerList = new List<ExAM__Questionnaire_Response__c>();
        List<ExAM__IssueRequest_Life_Cycle__c> amList = new List<ExAM__IssueRequest_Life_Cycle__c>();
        Map<Id, ExAM__Question_Template__c> quesIdwithQuestionMap = new Map<Id, ExAM__Question_Template__c>();

        if (String.isBlank(amId) && String.isNotBlank(assessibleFieldApiName) && String.isNotBlank(assessibleObjId)) {
                newASMRecord = new ExAM__IssueRequest_Life_Cycle__c();
                newASMRecord.put('ExAM__InvestigationType__c', tempId);
                newASMRecord.put(assessibleFieldApiName, assessibleObjId);            	
                if (string.isNotBlank(amReqdStatus)) {
                    newASMRecord.put('ExAM__Status__c', amReqdStatus);
                }
                insert newASMRecord;
        }

        if ( (answerList != null && answerList.size() > 0) &&
             (String.isNotBlank(amId) || newASMRecord.Id != null)
        ) {

            String assignmentManagerId = '';
            if (String.isNotBlank(amId) ) {
                assignmentManagerId = amId;
            }
            else {
                assignmentManagerId = newASMRecord.Id;
            }

            if (tempId != null && tempId != '') {
                quesIdwithQuestionMap = new Map<Id, ExAM__Question_Template__c>([
                    SELECT Id, ExAM__Subquestion_Label__c, ExAM__Weight_of_Answer__c,  ExAM__HelpText__c, ExAM__Section_Question__c,
                           ExAM__Section_Question__r.ExAM__Questionnaire_Section__c, ExAM__Question_Label__c, ExAM__Question_Order_No__c,
                           ExAM__Question_Type__c, ExAM__Do_Not_Create_Answer__c
                    FROM   ExAM__Question_Template__c
                    WHERE  ExAM__Section_Question__r.ExAM__Questionnaire_Section__c = :tempId AND ExAM__Do_Not_Create_Answer__c = false ORDER BY ExAM__Question_Order_No__c ASC
                ]);
            }

            List<ExAM__Questionnaire_Response__c> answerList2 = new List<ExAM__Questionnaire_Response__c >();
            for (AnswerRecordClass anscls : answerList) {

                if (quesIdwithQuestionMap != null && quesIdwithQuestionMap.size() > 0 &&
                    (quesIdwithQuestionMap.containskey(anscls.questiontemplateId) &&
                     quesIdwithQuestionMap.get(anscls.questiontemplateId) != null)
                ) {

                    ExAM__Questionnaire_Response__c ans = new ExAM__Questionnaire_Response__c();
                    ans.ExAM__Question_Template__c = anscls.questiontemplateId;
                    ans.ExAM__Issue_Request__c = assignmentManagerId;
                    ans.ExAM__Response__c = anscls.response;
                    ans.ExAM__Comment__c = anscls.comment;
                    if (string.isNotBlank(assessibleObjReferenceForAnsCreation) ) {
                        ans.put(assessibleObjReferenceForAnsCreation, assessibleObjId);
                    }

                    //calculate answer weight
                    if (String.isNotBlank(ans.ExAM__Response__c) && quesIdwithQuestionMap != null
                            && quesIdwithQuestionMap.containsKey(ans.ExAM__Question_Template__c)
                            && quesIdwithQuestionMap.get(ans.ExAM__Question_Template__c).ExAM__Weight_of_Answer__c != null
                            && quesIdwithQuestionMap.get(ans.ExAM__Question_Template__c).ExAM__Subquestion_Label__c != null
                            && ( quesIdwithQuestionMap.get(ans.ExAM__Question_Template__c).ExAM__Question_Type__c == 'RadioPicklist' ||
                                 quesIdwithQuestionMap.get(ans.ExAM__Question_Template__c).ExAM__Question_Type__c == 'Dropdown Picklist')
                    ) {

                        List<String> answerWeightList = quesIdwithQuestionMap.get(ans.ExAM__Question_Template__c).ExAM__Weight_of_Answer__c.split('~');

                        List<String> answerOptions = quesIdwithQuestionMap.get(ans.ExAM__Question_Template__c).ExAM__Subquestion_Label__c.split('~');

                        for (integer i = 0 ; i < answerOptions.size() ; i++) {
                            if (ans.ExAM__Response__c.equalsIgnoreCase(answerOptions.get(i))) {
                                if ((ans.ExAM__Response__c).equalsIgnoreCase('N/A') || (ans.ExAM__Response__c).equalsIgnoreCase('NA')) {
                                    ans.ExAM__Weight_Response__c = -1;
                                } else if( answerWeightList != null && answerWeightList.size() > i ) {
                                    ans.ExAM__Weight_Response__c = Decimal.valueOf(answerWeightList.get(i).trim());
                                }
                            }
                        }
                    }
					
                    System.Debug(assessibleObjId);
                    System.Debug(assessibleFieldApiName);
                    if((assessibleObjId != null) && (assessibleFieldApiName != null) && (assessibleFieldApiName.indexOf('AGP') != -1)){
                		ans.AGPSurvey_Participant__c = assessibleObjId;
            		}
                    ans.ExAM__Questionnaire_Taker_user__c = UserInfo.getUserId();
                    upsertAnswerList.add(ans);
                }
            }

            try {

                if (upsertAnswerList != null && upsertAnswerList.size() > 0) {

                    List<ExAM__Questionnaire_Response__c> lsQsResponse = [SELECT Id, Name FROM ExAM__Questionnaire_Response__c WHERE ExAM__Issue_Request__c =: amId];
                    DELETE lsQsResponse;

                    upsert upsertAnswerList;
                    List<ExAM__IssueRequest_Life_Cycle__c> lsAssignment = [SELECT CreatedDate, Id, ExAM__InvestigationType__c, AM_AGPSurveyParticipant__c, Name FROM ExAM__IssueRequest_Life_Cycle__c WHERE Id =: amId];
                    if(lsAssignment.size() > 0){
                        lsAssignment[0].ExAM__Status__c = 'Completed';
                        UPDATE lsAssignment[0];
                    }

                    Map<Id,List<Id>> quesIdwithAnsIdMap = new Map<Id, List<Id>>();
                    for (ExAM__Questionnaire_Response__c ans :upsertAnswerList) {
                        if (!quesIdwithAnsIdMap.containskey(ans.ExAM__Question_Template__c)) {
                            quesIdwithAnsIdMap.put(ans.ExAM__Question_Template__c, new List<Id>());
                        }
                        quesIdwithAnsIdMap.get(ans.ExAM__Question_Template__c).add(ans.Id);
                    }
                    return JSON.serialize(quesIdwithAnsIdMap);
                }

            } catch(Exception ex) {

                resultMsg = ex.getMessage();
            }
        }
        return resultMsg;
    }

    @RemoteAction
    public static string saveDecisionTreeAnswerRecords(List<ExAM__Questionnaire_Response__c> decisionTreeAnsList, String tempId, String assessibleObjId, String assessibleFieldApiName, String amReqdStatus, String assessibleObjReferenceForAnsCreation, String createdAMId) {

        SObject newASMRecord;
        String resultMsg = 'DecisionTree Answer have not save';
        Map<Id, ExAM__Questionnaire_Response__c> questionIdWithCreatedAnswerMap = new Map<Id, ExAM__Questionnaire_Response__c>();
        List<ExAM__IssueRequest_Life_Cycle__c> amList = new List<ExAM__IssueRequest_Life_Cycle__c>();

        try {


            if (String.isBlank(createdAMId) && String.isNotBlank(assessibleFieldApiName) && String.isNotBlank(assessibleObjId)) {



                //Commented out on 9-5-2016 because each time a new assignment manager needs to be created
                /*String queryStr = 'SELECT CreatedDate, Id, InvestigationType__c, Name, ';
                queryStr += assessibleFieldApiName;
                queryStr += ' FROM IssueRequest_Life_Cycle__c';
                queryStr += ' WHERE InvestigationType__c = \''+tempId+'\' AND '+assessibleFieldApiName+' = \''+assessibleObjId+'\' ORDER BY CreatedDate DESC LIMIT 1';

                amList = Database.query( queryStr );

                if (amList.size() == 0) {*/
                    newASMRecord = new ExAM__IssueRequest_Life_Cycle__c();
                    newASMRecord.put('ExAM__InvestigationType__c', tempId);
                    newASMRecord.put(assessibleFieldApiName, assessibleObjId);
                    if (string.isNotBlank(amReqdStatus)) {
                        newASMRecord.put('ExAM__Status__c', amReqdStatus);
                    }
                    insert newASMRecord;
                //}
            }

            if (decisionTreeAnsList != null && decisionTreeAnsList.size() > 0) {
                Map<Id, ExAM__Questionnaire_Response__c> questionIdwithAnswerMap = new Map<Id, ExAM__Questionnaire_Response__c>();
                for (ExAM__Questionnaire_Response__c ans : decisionTreeAnsList ) {

                    ExAM__Questionnaire_Response__c answerNewIns = new ExAM__Questionnaire_Response__c();
                    answerNewIns = ans;
                    if (String.isNotBlank(createdAMId)) {
                        answerNewIns.ExAM__Issue_Request__c = createdAMId;
                    }
                    else {
                        answerNewIns.ExAM__Issue_Request__c = newASMRecord.Id;
                    }
                    if (string.isNotBlank(assessibleObjReferenceForAnsCreation) ) {
                        answerNewIns.put(assessibleObjReferenceForAnsCreation, assessibleObjId);
                    }
                    questionIdwithAnswerMap.put(answerNewIns.ExAM__Question_Template__c, answerNewIns);
                }
                for (ExAM__Question_Template__c questionTemp : [SELECT Id, ExAM__Do_Not_Create_Answer__c from ExAM__Question_Template__c WHERE Id IN:questionIdwithAnswerMap.keySet() AND ExAM__Do_Not_Create_Answer__c = true]) {
                    questionIdwithAnswerMap.remove(questionTemp.Id);
                }
                if (questionIdwithAnswerMap != null && questionIdwithAnswerMap.size() > 0) {
                    decisionTreeAnsList = questionIdwithAnswerMap.values();
                    insert decisionTreeAnsList;
                    resultMsg = 'Decision tree answer have saved successfully';

                    for (ExAM__Questionnaire_Response__c res : decisionTreeAnsList) {
                        questionIdWithCreatedAnswerMap.put(res.ExAM__Question_Template__c, res);
                    }
                    return JSON.serialize(questionIdWithCreatedAnswerMap);
                }
            }
        }
        catch(DMLException dmlexp) {

            resultMsg = dmlexp.getDMLMessage(0);
        }catch(Exception exp) {

            resultMsg = exp.getMessage();
        }
        return resultMsg;
    }

    @RemoteAction
    public static string saveAttachments(List<AttachmentDetails> attDtlObj) {

        string attSaveResponse = '';
        List<Attachment> attList = new List<Attachment>();

        try {

            if ( attDtlObj != null ) {

                for(AttachmentDetails attRec : attDtlObj) {

                    Attachment att = new Attachment();
                    att.Body = EncodingUtil.Base64Decode(attRec.imgContent);
                    att.Name = attRec.fileNameStr;
                    att.ContentType = attRec.cType;
                    att.ParentId = attRec.parentIdStr;
                    att.IsPrivate = attRec.isPrivate;
                    attList.add( att );
                }
                if ( attList.size() > 0 ) {
                    insert attList;
                    attSaveResponse = 'success';
                }
            }
        }
        catch(DMLException dmlexp) {
            attSaveResponse = dmlexp.getDMLMessage(0);
        }
        catch(Exception exp) {
            attSaveResponse = exp.getMessage();
        }
        return attSaveResponse;
    }

}