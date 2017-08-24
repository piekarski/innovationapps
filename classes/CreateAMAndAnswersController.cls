public class CreateAMAndAnswersController {

    public string tempId { get; set; }
    public string templateName { get; set; }
    public string objId { get; set; }
    public string assessibleFieldName { get; set; }
    public string decisionTreeResultString { get; set; }
    public Boolean skip_Answer_For_Decision_Tree_Steps { get; set; }
    public string headerStr { get; set; }
    public string footerStr { get; set; }

    public string amReqdStatus { get; set; }
    public string redirectUrl { get; set; }

    public Boolean showImgIcon { get; set; }
    public Boolean showNotesIcon { get; set; }
    public Boolean showRefreshIcon { get; set; }

    public Boolean showModalWindow { get; set; }
    public string modalWindowTxt { get; set; }

    public string assessibleObjReferenceForAnsCreation { get; set; }

    public string configuredDecisionTree { get; set; }

    public string customStylesConfigured { get; set; }
    public string customScriptConfigured { get; set; }

    public class FilteredSectionAndQuestionTemplateClass {
        public Section_Template__c sectionTemplateRecord{get; set;}
        public List<Question_Template__c> questionTemplateRecords{get; set;}

        public FilteredSectionAndQuestionTemplateClass(Section_Template__c sectionTemplate, List<Question_Template__c> questionTemplateList) {

            this.sectionTemplateRecord = sectionTemplate;
            this.questionTemplateRecords = questionTemplateList;        
        }
    }

    public class AnswerRecordClass {
        public String questiontemplateId;
        public String assignmentManagerId;
        public String response;
        public String comment;
        //public String hierarchalObjId;
    }

    public class DecisionTreeResultClass {
        public String fieldLabelName { get; set; }
        public String fieldAPIName { get; set; }
        public String fieldType { get; set; }
        public List<String> picklistValues { get; set; }
        public Boolean hasEnabled { get; set; }

        public DecisionTreeResultClass(String fieldLabel, String fieldAPI, String fieldType, List<String> pklstValuesList, Boolean enableField) {

            this.fieldLabelName = fieldLabel;
            this.fieldAPIName = fieldAPI;
            this.fieldType = fieldType;
            this.picklistValues = pklstValuesList;
            this.hasEnabled = enableField;
        }
    }

    public class AttachmentDetails {
        public string fileNameStr;
        public string imgContent;
        public string cType;
        public string parentIdStr;
        public Boolean isPrivate;        
    }

    public CreateAMAndAnswersController() {  

        tempId = ApexPages.currentPage().getParameters().get('tempId');
        objId = ApexPages.currentPage().getParameters().get('objId');

        String sObjName = Id.valueOf(objId).getSObjectType().getDescribe().getName();
        assessibleFieldName = (sObjName == 'Account') ? 'Facility_Name__c' : 'AM_'+sObjName;
        assessibleObjReferenceForAnsCreation = (sObjName == 'Account') ? 'Account_to_Response__c' : '';

        if (sObjName != 'Account') {

            Map <string, Schema.SObjectField> answerFieldNameAPIMap = Schema.SObjectType.Questionnaire_Response__c.fields.getMap();
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

        headerStr = footerStr = amReqdStatus = customScriptConfigured = '';

        showImgIcon = false;
        showNotesIcon = false;
        showRefreshIcon = false;

        showModalWindow = false;
        modalWindowTxt = '';

        if (string.isNotBlank(tempId) && tempId != 'null') {

            List<Main_questionaire__c> templateList = new List<Main_questionaire__c>();
            templateList = [
                SELECT Assessment_Completed_URL__c, Id, Modal_Window_Text__c,
                       Name, Public_Assessment_Page_Footer__c, Public_Assessment_Page_Header__c,
                       Show_Image_Upload_Icon__c, Show_Modal_Window__c, Show_Notes_Icon__c, Show_Refresh_Icon__c
                FROM   Main_questionaire__c
                WHERE  Id = :tempId  
            ];
            if (templateList != null && templateList.size() > 0) {

                templateName = templateList[0].Name;
                headerStr = templateList[0].Public_Assessment_Page_Header__c;
                footerStr = templateList[0].Public_Assessment_Page_Footer__c;
                showImgIcon = templateList[0].Show_Image_Upload_Icon__c;
                showNotesIcon = templateList[0].Show_Notes_Icon__c;
                showRefreshIcon = templateList[0].Show_Refresh_Icon__c;

                showModalWindow = templateList[0].Show_Modal_Window__c;
                modalWindowTxt = templateList[0].Modal_Window_Text__c;

                //customStylesConfigured = templateList[0].URL__c;
                //customScriptConfigured = templateList[0].Google_Analytics_Script__c;

                //if (templateList[0].Assessment_Completed_URL__c != null) {
                //    redirectUrl = templateList[0].Assessment_Completed_URL__c;
                // }

                //configuredDecisionTree = templateList[0].Decision_Tree__c;
            }
        }

        decisionTreeResultString = constructDecisionTreeResultQuestion();
    }//end constructor

    public String constructDecisionTreeResultQuestion() {

        Boolean isPictureConfig = false;
        String decisionTreeResultStr = '';
        String fields = '';
        List<DecisionTreeResultClass> decisionTreeResultList = new List<DecisionTreeResultClass>();
        List<ExAM_Configuration__c> configRecordList = new List<ExAM_Configuration__c>();
        Set<String> fieldSet = new Set<String>();
        Map<String, String> fieldApiNameAndValueMap = new Map<String, String>();

        configRecordList = [
            SELECT Decision_Tree__c, Id, Overall_Status_on_Submit__c, Name, skip_Answer_For_Decision_Tree_Steps__c
            FROM   ExAM_Configuration__c LIMIT 1
        ];

        if (configRecordList != null && configRecordList.size() > 0) {

            skip_Answer_For_Decision_Tree_Steps = configRecordList[0].skip_Answer_For_Decision_Tree_Steps__c;
            amReqdStatus = configRecordList[0].Overall_Status_on_Submit__c;
        }

        if (String.isNotBlank(configuredDecisionTree) ) {

            List<String> fieldListTemp = new List<String>();

            if (configuredDecisionTree.contains('~')) {

                fieldListTemp = configuredDecisionTree.split('~');
            }
            else {

                fieldListTemp.add( configuredDecisionTree );
            }
            
            for(String f : fieldListTemp) {

                String fieldApiName = f.split(':')[0];
                String hasEnabled = f.split(':')[1];

                if (fieldApiName != 'Pictures' && fieldApiName.contains('__c')) {
                    fieldApiNameAndValueMap.put(fieldApiName, hasEnabled);
                } else if (fieldApiName == 'Pictures') {
                    isPictureConfig = true;
                    fieldApiNameAndValueMap.put(fieldApiName, hasEnabled);
                }
            }

            Map <string, Schema.SObjectField> answerFieldNameAPIMap = Schema.SObjectType.Questionnaire_Response__c.fields.getMap();
            for (String ansStr : answerFieldNameAPIMap.keySet()) {

                Schema.SObjectField ansfield = answerFieldNameAPIMap.get(ansStr);

                if (fieldApiNameAndValueMap != null && fieldApiNameAndValueMap.containsKey(ansStr.toLowerCase())) {    

                    Schema.DescribeFieldResult res = ansfield.getdescribe();

                    List<String> picklistvalueTempList = new List<String>();
                    if (res.getType() == Schema.DisplayType.pickList) {

                        List<Schema.PicklistEntry> ple = res.getPicklistValues();                        
                        for( Schema.PicklistEntry f : ple) {
                            picklistvalueTempList.add(f.getValue());
                        }       
                    }
                    decisionTreeResultList.add(
                        new DecisionTreeResultClass(
                            res.getLabel(),
                            res.getName().toLowerCase(),
                            res.getType().name(),
                            picklistvalueTempList,
                            Boolean.valueOf( fieldApiNameAndValueMap.get(ansStr.toLowerCase()) )
                        )
                    );

                    
    
                }// end if fieldSet contains the api name of current field in iteration
            }// end answerFieldNameAPIMap fields map iteration
            
            if (isPictureConfig) {
                decisionTreeResultList.add( 
                    new DecisionTreeResultClass(
                        'Picture',
                        '',
                        'PICTURE',
                        new List<String>(),
                        Boolean.valueOf( fieldApiNameAndValueMap.get('Pictures') )
                    )
                );
            }
            if (decisionTreeResultList != null && decisionTreeResultList.size() > 0) {

                decisionTreeResultStr = JSON.serialize(decisionTreeResultList);
            }

        }// end if configRecordList size check
        return decisionTreeResultStr;
    }

    @RemoteAction
    public static List<FilteredSectionAndQuestionTemplateClass> returnSectionAndQuestionTemplate(String assessmentTemplateId) {

        List<Question_Template__c> primaryQuestionsList;
        List<FilteredSectionAndQuestionTemplateClass> filteredInnerClassList = new List<FilteredSectionAndQuestionTemplateClass>();
        Set<String> questionTemplateNameSet = new Set<String>();

        try {

            List<Section_Template__c> sectionTemplateList = new List<Section_Template__c>();

            Map<Id, Section_Template__c> sectionTemplateMap = new Map<Id, Section_Template__c>(
                [
                    SELECT Id, Name, No_of_Questions_Section__c, No_of_response_per_section_per_user__c, Order_No__c, Questionnaire_Section__c,
                           Section_Description__c, Section_label__c, Section_Weight__c, status__c, Subsectionlabel__c, SuperSection__c
                    FROM   Section_Template__c
                    WHERE  Questionnaire_Section__c = :assessmentTemplateId ORDER BY Order_No__c ASC
                ]
            );

            Map<Id, List<Question_Template__c>> sectionTemplateIdAndQuestionTemplateListMap = new Map<Id, List<Question_Template__c>>();
            for(Question_Template__c qt : [SELECT Do_Not_Create_Answer__c, HelpText__c, Is_Mandatory__c, Name, Next_Question__c,
                                                  Question_Label__c, Question_Order_No__c, Question_Type__c, Subquestion_Label__c,
                                                  Section_Question__c, SubSection_label__c, Weight_Of_Question__c
                                           FROM   Question_Template__c
                                           WHERE  Section_Question__c IN :sectionTemplateMap.keySet()]) {

                    if (!sectionTemplateIdAndQuestionTemplateListMap.containsKey(qt.Section_Question__c)) {
                        sectionTemplateIdAndQuestionTemplateListMap.put(qt.Section_Question__c, new List<Question_Template__c>());
                    }
                    sectionTemplateIdAndQuestionTemplateListMap.get(qt.Section_Question__c).add( qt );
            }

            for(Section_Template__c sectionTemplateRecord : sectionTemplateMap.values()) {

                if (sectionTemplateIdAndQuestionTemplateListMap.containsKey(sectionTemplateRecord.Id) &&
                    sectionTemplateIdAndQuestionTemplateListMap.get( sectionTemplateRecord.Id ).size() > 0
                ) {

                    for(Question_Template__c questionTemplateRecord : sectionTemplateIdAndQuestionTemplateListMap.get(sectionTemplateRecord.Id) ) {

                        if (String.isNotBlank(questionTemplateRecord.Next_Question__c) &&
                            (questionTemplateRecord.Question_Type__c == 'RadioPicklist' || questionTemplateRecord.Question_Type__c == 'Dropdown Picklist')
                        ) {

                                if (questionTemplateRecord.Next_Question__c.contains('~')) {

                                    questionTemplateNameSet.addAll( questionTemplateRecord.Next_Question__c.split('~') );
                                }
                                else {

                                    questionTemplateNameSet.add( questionTemplateRecord.Next_Question__c );
                                }
                        }
                    }
                }
            }

            for(Section_Template__c sectionTemplateRecord : sectionTemplateMap.values()) {

                primaryQuestionsList = new List<Question_Template__c>();
                if (sectionTemplateIdAndQuestionTemplateListMap.containsKey(sectionTemplateRecord.Id) &&
                    sectionTemplateIdAndQuestionTemplateListMap.get( sectionTemplateRecord.Id ).size() > 0
                ) {

                    for(Question_Template__c questionTemplateRecord : sectionTemplateIdAndQuestionTemplateListMap.get(sectionTemplateRecord.Id) ) {

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

            filteredInnerClassList.add( new FilteredSectionAndQuestionTemplateClass(new Section_Template__c(), new List<Question_Template__c>()) );
        }
        return filteredInnerClassList;
    }

    @RemoteAction
    public static String saveAnswerRecords(List<AnswerRecordClass> answerList, String tempId, String assessibleObjId, String assessibleFieldApiName, String amReqdStatus, String assessibleObjReferenceForAnsCreation, String amId) {

        String fieldPrefix = 'AM_';
        String resultMsg = 'No Answer Records to save';
        SObject newASMRecord;
        List<Questionnaire_Response__c> upsertAnswerList = new List<Questionnaire_Response__c>();
        List<IssueRequest_Life_Cycle__c> amList = new List<IssueRequest_Life_Cycle__c>();
        Map<Id, Question_Template__c> quesIdwithQuestionMap = new Map<Id, Question_Template__c>();
        
        if (String.isBlank(amId) && String.isNotBlank(assessibleFieldApiName) && String.isNotBlank(assessibleObjId)) {

            //Commented out on 9-5-2016 because each time a new assignment manager needs to be created
            /*String queryStr = 'SELECT CreatedDate, Id, InvestigationType__c, Name, ';
            queryStr += assessibleFieldApiName;
            queryStr += ' FROM IssueRequest_Life_Cycle__c';
            queryStr += ' WHERE InvestigationType__c = \''+tempId+'\' AND '+assessibleFieldApiName+' = \''+assessibleObjId+'\' ORDER BY CreatedDate DESC LIMIT 1';

            amList = Database.query( queryStr );

            if (amList.size() == 0) {*/
                newASMRecord = new IssueRequest_Life_Cycle__c();
                newASMRecord.put('InvestigationType__c', tempId);
                newASMRecord.put(assessibleFieldApiName, assessibleObjId);
                if (string.isNotBlank(amReqdStatus)) {
                    newASMRecord.put('Status__c', amReqdStatus);
                }
                insert newASMRecord;
            //}
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
                quesIdwithQuestionMap = new Map<Id, Question_Template__c>([ 
                    SELECT Id, Subquestion_Label__c, Weight_of_Answer__c,   HelpText__c, Section_Question__c, 
                           Section_Question__r.Questionnaire_Section__c, Question_Label__c, Question_Order_No__c,
                           Question_Type__c, Do_Not_Create_Answer__c
                    FROM   Question_Template__c
                    WHERE  Section_Question__r.Questionnaire_Section__c = :tempId AND Do_Not_Create_Answer__c = false ORDER BY Question_Order_No__c ASC
                ]);
            }

            List<Questionnaire_Response__c> answerList2 = new List<Questionnaire_Response__c >();
            for (AnswerRecordClass anscls : answerList) {

                if (quesIdwithQuestionMap != null && quesIdwithQuestionMap.size() > 0 && 
                    (quesIdwithQuestionMap.containskey(anscls.questiontemplateId) && 
                     quesIdwithQuestionMap.get(anscls.questiontemplateId) != null)
                ) { 

                    Questionnaire_Response__c ans = new Questionnaire_Response__c();
                    ans.Question_Template__c = anscls.questiontemplateId;
                    ans.Issue_Request__c = assignmentManagerId;
                    ans.Response__c = anscls.response;
                    ans.Comment__c = anscls.comment;
                    if (string.isNotBlank(assessibleObjReferenceForAnsCreation) ) {
                        ans.put(assessibleObjReferenceForAnsCreation, assessibleObjId);
                    }
                    
                    //calculate answer weight 
                    if (String.isNotBlank(ans.Response__c) && quesIdwithQuestionMap != null 
                            && quesIdwithQuestionMap.containsKey(ans.Question_Template__c) 
                            && quesIdwithQuestionMap.get(ans.Question_Template__c).Weight_of_Answer__c != null
                            && quesIdwithQuestionMap.get(ans.Question_Template__c).Subquestion_Label__c != null
                            && ( quesIdwithQuestionMap.get(ans.Question_Template__c).Question_Type__c == 'RadioPicklist' ||
                                 quesIdwithQuestionMap.get(ans.Question_Template__c).Question_Type__c == 'Dropdown Picklist')
                    ) {
                
                        List<String> answerWeightList = quesIdwithQuestionMap.get(ans.Question_Template__c).Weight_of_Answer__c.split('~');
    
                        List<String> answerOptions = quesIdwithQuestionMap.get(ans.Question_Template__c).Subquestion_Label__c.split('~');
    
                        for (integer i = 0 ; i < answerOptions.size() ; i++) {
                            if (ans.Response__c.equalsIgnoreCase(answerOptions.get(i))) {

                                if ((ans.Response__c).equalsIgnoreCase('N/A') || (ans.Response__c).equalsIgnoreCase('NA')) {
                                    ans.Weight_Response__c = -1;
                                } else if( answerWeightList != null && answerWeightList.size() > i ) {
                                    ans.Weight_Response__c = Decimal.valueOf(answerWeightList.get(i).trim()); 
                                }
                            }
                        }                          
                    }
                    
                    ans.Questionnaire_Taker_user__c = UserInfo.getUserId();
                    upsertAnswerList.add(ans); 
                }//end question map not null and size check
            }
            
            try {

                if (upsertAnswerList != null && upsertAnswerList.size() > 0) {
                    upsert upsertAnswerList;
                    
                    Map<Id,List<Id>> quesIdwithAnsIdMap = new Map<Id, List<Id>>();
                    for (Questionnaire_Response__c ans :upsertAnswerList) {
                        if (!quesIdwithAnsIdMap.containskey(ans.Question_Template__c)) {
                            quesIdwithAnsIdMap.put(ans.Question_Template__c, new List<Id>());
                        }
                        quesIdwithAnsIdMap.get(ans.Question_Template__c).add(ans.Id);
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
    public static string saveDecisionTreeAnswerRecords(List<Questionnaire_Response__c> decisionTreeAnsList, String tempId, String assessibleObjId, String assessibleFieldApiName, String amReqdStatus, String assessibleObjReferenceForAnsCreation, String createdAMId) {

        SObject newASMRecord;
        String resultMsg = 'DecisionTree Answer have not save';
        Map<Id, Questionnaire_Response__c> questionIdWithCreatedAnswerMap = new Map<Id, Questionnaire_Response__c>();
        List<IssueRequest_Life_Cycle__c> amList = new List<IssueRequest_Life_Cycle__c>();
        
        try {

            if (String.isBlank(createdAMId) && String.isNotBlank(assessibleFieldApiName) && String.isNotBlank(assessibleObjId)) {

                //Commented out on 9-5-2016 because each time a new assignment manager needs to be created
                /*String queryStr = 'SELECT CreatedDate, Id, InvestigationType__c, Name, ';
                queryStr += assessibleFieldApiName;
                queryStr += ' FROM IssueRequest_Life_Cycle__c';
                queryStr += ' WHERE InvestigationType__c = \''+tempId+'\' AND '+assessibleFieldApiName+' = \''+assessibleObjId+'\' ORDER BY CreatedDate DESC LIMIT 1';

                amList = Database.query( queryStr );

                if (amList.size() == 0) {*/
                    newASMRecord = new IssueRequest_Life_Cycle__c();
                    newASMRecord.put('InvestigationType__c', tempId);
                    newASMRecord.put(assessibleFieldApiName, assessibleObjId);
                    if (string.isNotBlank(amReqdStatus)) {
                        newASMRecord.put('Status__c', amReqdStatus);
                    }
                    insert newASMRecord;
                //}
            }

            if (decisionTreeAnsList != null && decisionTreeAnsList.size() > 0) {
                Map<Id, Questionnaire_Response__c> questionIdwithAnswerMap = new Map<Id, Questionnaire_Response__c>();
                for (Questionnaire_Response__c ans : decisionTreeAnsList ) {

                    Questionnaire_Response__c answerNewIns = new Questionnaire_Response__c();
                    answerNewIns = ans;
                    if (String.isNotBlank(createdAMId)) {
                        answerNewIns.Issue_Request__c = createdAMId;
                    }
                    else {
                        answerNewIns.Issue_Request__c = newASMRecord.Id;
                    }
                    if (string.isNotBlank(assessibleObjReferenceForAnsCreation) ) {
                        answerNewIns.put(assessibleObjReferenceForAnsCreation, assessibleObjId);
                    }
                    questionIdwithAnswerMap.put(answerNewIns.Question_Template__c, answerNewIns);
                }
                for (Question_Template__c questionTemp : [SELECT Id, Do_Not_Create_Answer__c from Question_Template__c WHERE Id IN:questionIdwithAnswerMap.keySet() AND Do_Not_Create_Answer__c = true]) {
                    questionIdwithAnswerMap.remove(questionTemp.Id);             
                } 
                if (questionIdwithAnswerMap != null && questionIdwithAnswerMap.size() > 0) {
                    decisionTreeAnsList = questionIdwithAnswerMap.values();
                    insert decisionTreeAnsList;
                    resultMsg = 'Decision tree answer have saved successfully';
                    
                    for (Questionnaire_Response__c res : decisionTreeAnsList) {
                        questionIdWithCreatedAnswerMap.put(res.Question_Template__c, res);
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