@isTest
public class TestDecisionTreeController {
    static testmethod void method1() {

        Map<String, ExAM__Question_Template__c> qtMap = new Map<String, ExAM__Question_Template__c>();

        ExAM__ExAM_Configuration__c  ec = new ExAM__ExAM_Configuration__c (ExAM__Decision_Tree__c = 'Response__c~Comment__c', Name = 'Configuration', ExAM__Overall_Status_on_Submit__c = 'Completed');
        insert ec;

        /*Viewer_Custom_Configuration__c vc = new Viewer_Custom_Configuration__c();
        vc.Name ='Viewer 1';
        insert vc;*/

        ExAM__Main_questionaire__c[] templateList = new ExAM__Main_questionaire__c[] {
            new ExAM__Main_questionaire__c(ExAM__Template_name__c = 'General Safety'),
            new ExAM__Main_questionaire__c(ExAM__Template_name__c = 'Fire Safety')
        };
        insert templateList;

        ExAM__Section_Template__c[] sectionTemplateList = new ExAM__Section_Template__c[] {
            new ExAM__Section_Template__c(ExAM__Questionnaire_Section__c = templateList[0].Id, ExAM__Section_label__c = 'Section Template 1'),
            new ExAM__Section_Template__c(ExAM__Questionnaire_Section__c = templateList[0].Id, ExAM__Section_label__c = 'Section Template 2'),
            new ExAM__Section_Template__c(ExAM__Questionnaire_Section__c = templateList[1].Id, ExAM__Section_label__c = 'Section Template 3'),
            new ExAM__Section_Template__c(ExAM__Questionnaire_Section__c = templateList[1].Id, ExAM__Section_label__c = 'Section Template 4')
        };
        insert sectionTemplateList; 

        ExAM__Question_Template__c[] qtList = new ExAM__Question_Template__c[] {
            new ExAM__Question_Template__c(ExAM__Question_Type__c = 'Text', ExAM__Question_Label__c = 'What is your name?', ExAM__Section_Question__c = sectionTemplateList[0].Id),
            new ExAM__Question_Template__c(ExAM__Question_Type__c = 'Date', ExAM__Question_Label__c = 'Your DOB?', ExAM__Section_Question__c = sectionTemplateList[0].Id),
            new ExAM__Question_Template__c(ExAM__Subquestion_Label__c = 'Cricket~Basket ball~Volley ball', ExAM__Question_Type__c = 'MultiselectPicklist', ExAM__Question_Label__c = 'What are your hobbies?', ExAM__Section_Question__c = sectionTemplateList[1].Id),
            new ExAM__Question_Template__c(ExAM__Subquestion_Label__c = 'Male~Female', ExAM__Question_Type__c = 'RadioPicklist', ExAM__Question_Label__c = 'Gender?', ExAM__Section_Question__c = sectionTemplateList[1].Id),
            new ExAM__Question_Template__c(ExAM__Subquestion_Label__c = 'before 5 years~before 10 years', ExAM__Question_Type__c = 'RadioPicklist', ExAM__Question_Label__c = 'When did you joined this company?', ExAM__Section_Question__c = sectionTemplateList[1].Id),
            new ExAM__Question_Template__c(ExAM__Subquestion_Label__c = 'before 1 year~before 2 years', ExAM__Question_Type__c = 'RadioPicklist', ExAM__Question_Label__c = 'When did you joined this project?', ExAM__Section_Question__c = sectionTemplateList[1].Id),
            new ExAM__Question_Template__c(ExAM__Subquestion_Label__c = 'result', ExAM__Question_Type__c = 'Result', ExAM__Question_Label__c = 'Result Question?', ExAM__Section_Question__c = sectionTemplateList[1].Id),
            new ExAM__Question_Template__c(ExAM__Subquestion_Label__c = '< 5~> 5 but < 10~> 10', ExAM__Question_Type__c = 'RadioPicklist', ExAM__Question_Label__c = 'How many years of IT experience do you have?', ExAM__Section_Question__c = sectionTemplateList[2].Id),
            new ExAM__Question_Template__c(ExAM__Subquestion_Label__c = '1~2~3~4~5', ExAM__Question_Type__c = 'Dropdown Picklist', ExAM__Question_Label__c = 'How satisfield you are with our service?', ExAM__Section_Question__c = sectionTemplateList[2].Id),
            new ExAM__Question_Template__c(ExAM__Subquestion_Label__c = '1~2~3~4~5', ExAM__Question_Type__c = 'RadioPicklist', ExAM__Question_Label__c = 'How is your overall experience?', ExAM__Section_Question__c = sectionTemplateList[3].Id),
            new ExAM__Question_Template__c(ExAM__Question_Type__c = 'Text', ExAM__Question_Label__c = 'Where did you completed your schooling', ExAM__Section_Question__c = sectionTemplateList[3].Id)
        };
        insert qtList;
        
        for (ExAM__Question_Template__c qt : [SELECT Id, Name, ExAM__Question_Type__c, ExAM__Question_Label__c, ExAM__Section_Question__c, ExAM__Subquestion_Label__c FROM ExAM__Question_Template__c]) {
            if ( string.isNotBlank(qt.ExAM__Subquestion_Label__c) ) {
                qtMap.put(qt.ExAM__Subquestion_Label__c, qt);
            }
        }

        if (qtMap.containsKey('Male~Female') && qtMap.get('Male~Female').Id != null) {

            ExAM__Question_Template__c qtForUpdate = new ExAM__Question_Template__c();
            qtForUpdate.Id = qtMap.get('Male~Female').Id;
            qtForUpdate.ExAM__Next_Question__c = qtMap.get('before 5 years~before 10 years').Name + '~' + qtMap.get('before 1 year~before 2 years').Name;
            update qtForUpdate;
        }

        Account[] acctList = new Account[] {
            new Account(Name = 'Bosch INC'),
            new Account(Name = 'J&J Company')
        };
        insert acctList;
        
        /*Insert AGP Survey Participant*/
        
        AGPSurveyParticipant__c agp = new AGPSurveyParticipant__c(Name='Test Today');
        INSERT agp;
        
        ExAM__IssueRequest_Life_Cycle__c islc = [SELECT CreatedDate, Id, ExAM__InvestigationType__c, AM_AGPSurveyParticipant__c, Name FROM ExAM__IssueRequest_Life_Cycle__c WHERE AM_AGPSurveyParticipant__c =:agp.Id limit 1];        
        ApexPages.currentPage().getParameters().put('Id', islc.Id);
        String objId = islc.AM_AGPSurveyParticipant__c;
        String tempId = islc.ExAM__InvestigationType__c;
        
        islc.ExAM__InvestigationType__c = templateList[0].Id;
        UPDATE islc;
        tempId = templateList[0].Id;

        
        SurveyAndAnswersController ctrller = new SurveyAndAnswersController();
        ctrller.constructDecisionTreeResultQuestion();

        List<SurveyAndAnswersController.FilteredSectionAndQuestionTemplateClass> questionList = SurveyAndAnswersController.returnSectionAndQuestionTemplate(templateList[0].Id);
        system.assertEquals(questionList.size(), 2);

        String jsonString1 = '[{';
        jsonString1 += '\"questiontemplateId\"' + ':' + '\"' + qtList[0].Id + '\",';
        jsonString1 += '\"response\"' + ':' + '\"' + 'Micheal' + '\",';
        jsonString1 += '\"comment\"' + ':' + '\"' + 'test comment' + '\"';
        jsonString1 += '},{';
        jsonString1 += '\"questiontemplateId\"' + ':' + '\"' + qtList[1].Id + '\",';
        jsonString1 += '\"response\"' + ':' + '\"' + string.valueOf( Date.today().addYears(-26) ) + '\",';
        jsonString1 += '\"comment\"' + ':' + '\"' + 'test comment' + '\"';
        jsonString1 += '}]';

        List<SurveyAndAnswersController.AnswerRecordClass> answerList = new List<SurveyAndAnswersController.AnswerRecordClass>();
        answerList = (List<SurveyAndAnswersController.AnswerRecordClass>) Json.deserialize(jsonString1, List<SurveyAndAnswersController.AnswerRecordClass>.class);

        SurveyAndAnswersController.saveAnswerRecords(answerList, tempId, objId, 'AM_AGPSurveyParticipant__c', 'Completed', '', islc.Id);
        

        List<ExAM__IssueRequest_Life_Cycle__c> createdAssignmentManagerList = new List<ExAM__IssueRequest_Life_Cycle__c>();
        createdAssignmentManagerList = [
            SELECT AM_AGPSurveyParticipant__c, Id, ExAM__InvestigationType__c, Name, ExAM__Status__c
            FROM   ExAM__IssueRequest_Life_Cycle__c
            WHERE  ExAM__InvestigationType__c = :tempId AND AM_AGPSurveyParticipant__c = :agp.Id
        ];
        system.assertEquals(createdAssignmentManagerList.size(), 1);

        if (createdAssignmentManagerList != null && createdAssignmentManagerList.size() > 0) {
            //system.assertEquals(createdAssignmentManagerList[0].Status__c, 'Open');

            ExAM__Questionnaire_Response__c[] answerList1 = new ExAM__Questionnaire_Response__c[] {
                new ExAM__Questionnaire_Response__c(ExAM__Question_Template__c = qtList[4].Id, ExAM__Response__c = 'before 5 years', ExAM__Comment__c = 'for gender decision tree question'),
                new ExAM__Questionnaire_Response__c(ExAM__Question_Template__c = qtList[5].Id, ExAM__Response__c = 'before 1 year', ExAM__Comment__c = 'project joing date'),
                new ExAM__Questionnaire_Response__c(ExAM__Question_Template__c = qtList[6].Id, ExAM__Response__c = 'Low', ExAM__Comment__c = 'answer for result question')
            };

            //String decisionTreeAnswerSaveResponse = decisionTreeController.saveDecisionTreeAnswerRecords(answerList1, templateList[0].Id, acctList[0].Id, 'ExAM__Facility_Name__c', 'Completed', 'ExAM__Account_to_Response__c', createdAssignmentManagerList[0].Id);

            List<ExAM__Questionnaire_Response__c> createdAnswerList = new List<ExAM__Questionnaire_Response__c>();
            createdAnswerList = [SELECT Id, Name FROM ExAM__Questionnaire_Response__c];

            if (createdAnswerList.size() > 1) {

                Blob b1 = Blob.valueOf('test image 1');
                Blob b2 = Blob.valueOf('test image 2');

                String jsonString2 = '[{';
                jsonString2 += '\"fileNameStr\"' + ':' + '\"Test Attachment Upload 1\"' + ',';
                jsonString2 += '\"imgContent\"' + ':' + '\"' + b1.toString() + '\",';
                jsonString2 += '\"cType\"' + ':' + '\"image/jpeg\"' + ',';
                jsonString2 += '\"parentIdStr\"' + ':' + '\"' + createdAnswerList[0].Id + '\",';
                jsonString2 += '\"isPrivate\"' + ':' + 'false'; 
                jsonString2 += '},{';
                jsonString2 += '\"fileNameStr\"' + ':' +'\"Test Attachment Upload 2\"' + ',';
                jsonString2 += '\"imgContent\"' + ':' + '\"' + b2.toString() + '\",';
                jsonString2 += '\"cType\"' + ':' + '\"image/png\"' + ',';
                jsonString2 += '\"parentIdStr\"' + ':' + '\"' + createdAnswerList[1].Id + '\",';
                jsonString2 += '\"isPrivate\"' + ':' + 'false';
                jsonString2 += '}]';

                List<SurveyAndAnswersController.AttachmentDetails> attList = new List<SurveyAndAnswersController.AttachmentDetails>();
                attList = (List<SurveyAndAnswersController.AttachmentDetails>) Json.deserialize(jsonString2, List<SurveyAndAnswersController.AttachmentDetails>.class);

                String response = SurveyAndAnswersController.saveAttachments(attList);
                system.assertEquals(response, 'success');
            }
        }
        
        DecisionTreeController dtc = new DecisionTreeController();
        List<String> answers = new List<String>() ;
        answers.add('ans1');
        answers.add('ans2');
        answers.add('ans3');
        dtc.MultiAnswers = answers;
        answers = dtc.MultiAnswers;
        
        dtc.completedAssessments();
        dtc.previousQuestion();
        dtc.saveAnswer();
        
    }

}