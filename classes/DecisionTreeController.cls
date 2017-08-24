/**
 * Copyright (c) - Millsapps, Ballinger & Associates (MB&A)
 * All rights reserved.
 * You may only use this code and the application associated with it in conjunction with a valid subscription or license agreement with Millsapps, Ballinger and Associates.
 * Any use of this code in whole or in part is prohibited including modification, copying in whole or in part or distributing it to any third party.
 * Please see the full license agreement at http://info.mbaoutcome.com/app-terms-of-service
**/

public class DecisionTreeController{
    public String amId ;
    public String assTempId;
    public String questionId;
    public String multiSelectAnswer;
    public String accountId ;
    public String selectedOption;
    public List<SelectOption> answerOption { get; set; }
    public Map<String, integer> answerKeywithPositionMap ;
    public Map<integer, String> postionwithQuestionMap;
    public ExAM__Question_Template__c questionTemp { get; set; }
    public ExAM__Questionnaire_Response__c questionRes { get; set; }

    public Boolean isPreviousQuestion { get; set; }
    public List<SelectOption> previousAnswerOption { get; set; }
    public ExAM__Question_Template__c previousQuestionTemp { get; set; }
    public ExAM__Questionnaire_Response__c previousQuestionRes { get; set; }

    public List<String> resultPageFieldsList { get; set; }
    public Map<String, String> fieldAPIWithLabel { get; set; }
    public String resultPageFields { get; set; }

    public String[] MultiAnswers {
     get {
        String[] selected = new List<String>();
         System.Debug( questionRes.ExAM__Response__c);
         System.Debug( multiSelectAnswer);
         if(multiSelectAnswer != null){
             questionRes.ExAM__Response__c = multiSelectAnswer;
         }
        List<SelectOption> sos = answerOption;
        for(SelectOption s : sos) {
            if (questionRes.ExAM__Response__c !=null && questionRes.ExAM__Response__c.contains(s.getValue()))
               selected.add(s.getValue());
            }
        return selected;
     }public set {
        String selectedConcat = '';
        for(String s : value) {
         if (selectedConcat == '')
           selectedConcat += s;
         else selectedConcat += '~' + s;
        }

         System.Debug('selectedConcat' + selectedConcat);
         questionRes.ExAM__Response__c= selectedConcat;
         //multiSelectAnswer = selectedConcat;
     }
}

    public Boolean isPictures { get; set;}
    public List<questionPathClass> questionPathList ;
    public Class questionPathClass {
        public ExAM__Question_Template__c question { get; set; }
        public ExAM__Questionnaire_Response__c response { get; set; }
        public List<SelectOption> ansOp { get; set; }
    }



    public DecisionTreeController() {
        amId = ApexPages.currentPage().getParameters().get('amid');
        questionId = ApexPages.currentPage().getParameters().get('questionid');
        selectedOption = ApexPages.currentPage().getParameters().get('selectedoption');
        multiSelectAnswer = null;
        questionPathList = new List<questionPathClass>();
        fieldAPIWithLabel = new Map<String, String>();
        isPictures = false;
        isPreviousQuestion = false;
        previousAnswerOption = new List<SelectOption>();
        previousQuestionTemp = new ExAM__Question_Template__c ();
        previousQuestionRes = new ExAM__Questionnaire_Response__c();

        answerOption = new List<SelectOption>();
        answerKeywithPositionMap = new Map<String, integer> ();
        questionTemp = new ExAM__Question_Template__c ();
        postionwithQuestionMap = new Map<integer, String> ();
        questionRes = new ExAM__Questionnaire_Response__c();


        if (amId != null && amId != '' && questionId != null && questionId != '' && selectedOption != null && selectedOption != '') {
            List<ExAM__IssueRequest_Life_Cycle__c> amlist = [ SELECT ID, Name, ExAM__InvestigationType__c, ExAM__Facility_Name__c FROM ExAM__IssueRequest_Life_Cycle__c
                                                        WHERE Id =:amId ];
            if (amlist != null && amlist.size() > 0) {
                assTempId = amlist[0].ExAM__InvestigationType__c;
                accountId = amlist[0].ExAM__Facility_Name__c ;

                if (questionId != null && questionId != '') {
                    List<ExAM__Question_Template__c> quesTempList = [ SELECT Id, ExAM__Question_Label__c, ExAM__Subquestion_Label__c, ExAM__Weight_of_Answer__c,
                                                                        ExAM__HelpText__c, ExAM__Next_Question__c, ExAM__Question_Order_No__c, ExAM__Question_Type__c
                                                                FROM ExAM__Question_Template__c
                                                                WHERE Id =: questionId LIMIT 1
                                                              ];
                    if (quesTempList != null && quesTempList.size() > 0) {
                        if ( quesTempList[0].ExAM__Subquestion_Label__c != null) {
                            List<String> ansOption = quesTempList[0].ExAM__Subquestion_Label__c.split('~');
                            Integer i = 0;
                            for (String ans : ansOption) {
                                answerKeywithPositionMap.put(ans, i);
                                i++;
                            }
                        }
                        if (quesTempList[0].ExAM__Next_Question__c != null) {
                            List<String> questionList = quesTempList[0].ExAM__Next_Question__c.split('~');
                            integer i = 0;
                            for(String quesName : questionList) {
                                postionwithQuestionMap.put(i, quesName);
                                i++;
                            }
                        }
                        if (answerKeywithPositionMap != null && answerKeywithPositionMap.containsKey(selectedOption) && postionwithQuestionMap != null
                                && postionwithQuestionMap.containsKey(answerKeywithPositionMap.get(selectedOption))) {

                            String questionName = postionwithQuestionMap.get(answerKeywithPositionMap.get(selectedOption));
                            List<ExAM__Question_Template__c> showQuesTempList = [ SELECT Id, Name, ExAM__Question_Label__c, ExAM__Subquestion_Label__c, ExAM__Weight_of_Answer__c,
                                                                        ExAM__HelpText__c, ExAM__Next_Question__c,ExAM__Question_Order_No__c, ExAM__Question_Type__c
                                                                FROM ExAM__Question_Template__c
                                                                WHERE Name =:questionName  LIMIT 1
                                                              ];

                            if (showQuesTempList != null && showQuesTempList.size() > 0) {
                                questionTemp = showQuesTempList[0];
                                if ( showQuesTempList[0].ExAM__Subquestion_Label__c != null) {
                                    List<String> ansOption = showQuesTempList[0].ExAM__Subquestion_Label__c.split('~');
                                    Integer i = 0;
                                    for (String ans : ansOption) {
                                        answerOption.add(new SelectOption(ans,ans));
                                    }
                                }

                                List<ExAM__Questionnaire_Response__c> qResList = [SELECT id, ExAM__Response__c, ExAM__Issue_Request__c, ExAM__Question_Template__c, ExAM__Question_Template__r.ExAM__Section_Question__c,
                                                                                    ExAM__Question_Template__r.ExAM__Section_Question__r.ExAM__Questionnaire_Section__c,
                                                                                    ExAM__Comment__c, ExAM__Priority__c, ExAM__deficiency_status__c, ExAM__Answer_Text__c
                                                                            FROM ExAM__Questionnaire_Response__c
                                                                            WHERE ExAM__Issue_Request__c =:amId
                                                                            AND ExAM__Question_Template__r.ExAM__Section_Question__r.ExAM__Questionnaire_Section__c =: assTempId
                                                                            AND ExAM__Question_Template__c =:showQuesTempList[0].Id LIMIT 1];

                                if (qResList != null && qResList.size() > 0) {
                                    questionRes = qResList[0];
                                }
                            }
                        }
                        System.debug(':::quesTempList[0].id :::'+quesTempList[0].id );


                    }
                }
            }
        }
        questionPathClass questionPathOb = new questionPathClass ();
        questionPathOb.question = questionTemp;
        questionPathOb.response = questionRes;
        questionPathOb.ansOp = answerOption;
        questionPathList.add(questionPathOb);

        resultPageFieldsList = new List<String>();
        resultPageFields = '';
        List<Configuration__c> decisionfields = [SELECT Id, Name , Decision_Tree__c FROM Configuration__c WHERE Name ='Configuration'];
        Set<String> fieldsApiset = new Set<String>();
        if (decisionfields != null && decisionfields.size() > 0 && decisionfields[0].Decision_Tree__c != null && decisionfields[0].Decision_Tree__c != '') {
            resultPageFields = decisionfields[0].Decision_Tree__c;
            List<String> tempList = decisionfields[0].Decision_Tree__c.split('~');
            for (String fieldstr : tempList ) {
                if (!fieldstr.equalsignorecase('Pictures')) {
                    resultPageFieldsList.add(fieldstr);
                } else {
                    isPictures = true;
                }
            }
            fieldsApiset.addAll(resultPageFieldsList);
        }


        for (String fdapi :fieldsApiset) {
            fieldAPIWithLabel.put(fdapi, '');
        }

        Map <string, Schema.SObjectField> answerFieldNameAPIMap = Schema.SObjectType.ExAM__Questionnaire_Response__c.fields.getMap();
        for (Schema.SObjectField ansfield : answerFieldNameAPIMap.values()) {

            Schema.DescribeFieldResult res = ansfield.getdescribe();
            if (fieldsApiset != null && fieldsApiset.size() > 0 && fieldsApiset.contains(res.getName())) {
                fieldAPIWithLabel.put(res.getName(), res.getLabel());
            }

        }
    }
    public pageReference saveAnswer() {
        System.Debug('Inside Save Answer');
        if (amId != null && amId != '' && questionTemp != null && questionTemp.id != null) {
            questionRes.ExAM__Issue_Request__c = amId;
            questionRes.ExAM__Questionnaire_Taker_user__c = UserInfo.getUserId();
            questionRes.ExAM__Account_to_Response__c = accountId != '' ? accountId : null;
            if (questionRes.id == null) {
                questionRes.ExAM__Question_Template__c = questionTemp.id;
            }
            upsert questionRes;

            isPreviousQuestion = true;
            previousAnswerOption = answerOption;
            previousQuestionTemp = questionTemp;
            previousQuestionRes = questionRes;

            postionwithQuestionMap = new Map<integer, String> ();
            answerKeywithPositionMap = new Map<String, integer> ();

            answerOption = new List<SelectOption>();
            if ( questionTemp.ExAM__Subquestion_Label__c != null) {
                List<String> ansOption = questionTemp.ExAM__Subquestion_Label__c.split('~');
                Integer i = 0;
                for (String ans : ansOption) {
                    //answerOption.add(new SelectOption(ans,ans));
                    answerKeywithPositionMap.put(ans, i);
                    i++;
                }
            }
            if (questionTemp.ExAM__Next_Question__c != null) {
                List<String> questionList = questionTemp.ExAM__Next_Question__c.split('~');
                integer i = 0;
                for(String quesName : questionList) {
                    postionwithQuestionMap.put(i, quesName);
                    i++;
                }
            }

            /*questionPathClass questionPathOb = new questionPathClass ();
            questionPathOb.question = questionTemp;
            questionPathOb.response = questionRes;
            System.Debug(questionPathOb.response);
            System.Debug(questionPathOb.response.Exam__Response__c);
            questionPathOb.ansOp = answerOption;
            questionPathList.add(questionPathOb);*/
            String responseKey = questionRes.Exam__Response__c;
            if(questionRes.Exam__Response__c != null && questionRes.Exam__Response__c.contains('~')){
                multiSelectAnswer = questionRes.Exam__Response__c;
                responseKey = questionRes.Exam__Response__c.substring(0, questionRes.Exam__Response__c.indexof('~'));
            }

            if (responseKey != null && answerKeywithPositionMap != null && answerKeywithPositionMap.containskey(responseKey)
                    && postionwithQuestionMap != null && postionwithQuestionMap.containsKey(answerKeywithPositionMap.get(responseKey)) ) {

                String questionName = postionwithQuestionMap.get(answerKeywithPositionMap.get(responseKey));

                List<ExAM__Question_Template__c> showQuesTempList = [ SELECT Id, Name, ExAM__Question_Label__c, ExAM__Subquestion_Label__c, ExAM__Weight_of_Answer__c,
                                                                        ExAM__HelpText__c, ExAM__Next_Question__c,ExAM__Question_Order_No__c, ExAM__Question_Type__c
                                                     FROM ExAM__Question_Template__c
                                                     WHERE Name =:questionName LIMIT 1
                                                    ];
                System.debug('::showQuesTempList::::::'+showQuesTempList);
                if (showQuesTempList!= null && showQuesTempList.size() > 0) {
                    questionTemp = showQuesTempList[0];

                    System.debug(':::::questionTemp::::'+questionTemp);

                    if ( showQuesTempList[0].ExAM__Subquestion_Label__c != null) {
                        List<String> ansOption = showQuesTempList[0].ExAM__Subquestion_Label__c.split('~');
                        Integer i = 0;
                        for (String ans : ansOption) {
                            answerOption.add(new SelectOption(ans,ans));
                        }
                    }

                    List<ExAM__Questionnaire_Response__c> qResList = [SELECT id, ExAM__Response__c, ExAM__Issue_Request__c, ExAM__Question_Template__c, ExAM__Question_Template__r.ExAM__Section_Question__c,
                                                                        ExAM__Question_Template__r.ExAM__Section_Question__r.ExAM__Questionnaire_Section__c,
                                                                        ExAM__Comment__c, ExAM__Priority__c, ExAM__deficiency_status__c, ExAM__Answer_Text__c
                                                                FROM ExAM__Questionnaire_Response__c
                                                                WHERE ExAM__Issue_Request__c =:amId
                                                               // AND ExAM__Question_Template__r.ExAM__Section_Question__r.ExAM__Questionnaire_Section__c =: assTempId
                                                                AND ExAM__Question_Template__c =:showQuesTempList[0].Id LIMIT 1];

                    System.Debug('Line 283');
                    System.Debug(qResList);
                    if (qResList != null && qResList.size() > 0) {
                        questionRes = qResList[0];
                        System.debug('::::::'+questionRes);
                    } else {
                        questionRes = new ExAM__Questionnaire_Response__c();
                        System.debug('::::::'+questionRes);

                    }
                }
            } else if (questionTemp.ExAM__Next_Question__c != null) {
                List<String> questionNameList = questionTemp.ExAM__Next_Question__c.split('~');
                System.debug(':::::'+questionNameList );
                String questionName = questionNameList[0];
                List<ExAM__Question_Template__c> showQuesTempList = [ SELECT Id, Name, ExAM__Question_Label__c, ExAM__Subquestion_Label__c, ExAM__Weight_of_Answer__c,
                                                                        ExAM__HelpText__c, ExAM__Next_Question__c,ExAM__Question_Order_No__c, ExAM__Question_Type__c
                                                     FROM ExAM__Question_Template__c
                                                     WHERE Name =:questionName LIMIT 1
                                                    ];
                if (showQuesTempList!= null && showQuesTempList.size() > 0) {
                    questionTemp = showQuesTempList[0];


                    System.debug(':::::questionTemp::else::'+questionTemp);
                    System.Debug(':::::' + amId);
                    System.Debug(':::::' + showQuesTempList[0].Id);
                    List<ExAM__Questionnaire_Response__c> qResList = [SELECT id, ExAM__Response__c, ExAM__Issue_Request__c, ExAM__Question_Template__c, ExAM__Question_Template__r.ExAM__Section_Question__c,
                                                                        ExAM__Question_Template__r.ExAM__Section_Question__r.ExAM__Questionnaire_Section__c,
                                                                        ExAM__Comment__c, ExAM__Priority__c, ExAM__deficiency_status__c, ExAM__Answer_Text__c
                                                                FROM ExAM__Questionnaire_Response__c
                                                                WHERE ExAM__Issue_Request__c =:amId
                                                               // AND ExAM__Question_Template__r.ExAM__Section_Question__r.ExAM__Questionnaire_Section__c =: assTempId
                                                                AND ExAM__Question_Template__c =:showQuesTempList[0].Id LIMIT 1];

                    if (qResList != null && qResList.size() > 0) {
                        questionRes = qResList[0];
                        System.debug('::::::'+questionRes);
                    } else {
                        questionRes = new ExAM__Questionnaire_Response__c();
                    }

                }
            }
        }

	    /*if(multiSelectAnswer != null){
        	questionRes.Exam__Response__c = multiSelectAnswer;
        } */

        questionPathClass questionPathOb = new questionPathClass ();
        questionPathOb.question = questionTemp;
        questionPathOb.response = questionRes;
        System.Debug(questionPathOb.response);
        System.Debug(questionPathOb.response.Exam__Response__c);
        questionPathOb.ansOp = answerOption;
        questionPathList.add(questionPathOb);
        answerKeywithPositionMap = new Map<String, integer> ();
        postionwithQuestionMap = new Map<integer, String> ();
        multiSelectAnswer = null;
        return null;
    }
    public pageReference previousQuestion() {
        System.Debug(questionPathList.size());
        if (questionPathList != null && questionPathList.size() > 1) {
            integer maxIndexOfquestionPath = questionPathList.size() - 1;
            System.debug(questionPathList.get(maxIndexOfquestionPath));
            questionPathList.remove(maxIndexOfquestionPath);
            questionPathClass questionPathOb = questionPathList.get(maxIndexOfquestionPath - 1);
            System.Debug(questionPathOb);
            System.Debug(questionPathOb.response);
            answerOption = questionPathOb.ansOp ;
            questionTemp = questionPathOb.question ;
            questionRes = questionPathOb.response ;
            if (questionPathList.size() == 1) {
                isPreviousQuestion = false;
            }
        }
        return null;
    }

    public pageReference completedAssessments() {

        System.debug('::::::save Result::::::');
        if (amId != null && amId != '' && questionTemp != null && questionTemp.id != null) {
            questionRes.ExAM__Issue_Request__c = amId;
            questionRes.ExAM__Questionnaire_Taker_user__c = UserInfo.getUserId();
            questionRes.ExAM__Account_to_Response__c = accountId != '' ? accountId : null;
            if (questionRes.id == null) {
                questionRes.ExAM__Question_Template__c = questionTemp.id;
            }
            try {
                System.debug(':::questionRes::::'+questionRes);
                upsert questionRes;


            } catch (Exception ex) {
                system.debug(':::::::ex:::::::'+ex.getMessage());
            }
        }
        return null;

    }
}