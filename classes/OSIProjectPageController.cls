/**
 * Copyright (c) - Millsapps, Ballinger & Associates (MB&A)
 * All rights reserved.
 * You may only use this code and the application associated with it in conjunction with a valid subscription or license agreement with Millsapps, Ballinger and Associates. 
 * Any use of this code in whole or in part is prohibited including modification, copying in whole or in part or distributing it to any third party.    
 * Please see the full license agreement at http://info.mbaoutcome.com/app-terms-of-service
 * Author: Tom Contreras
**/

Public class OSIProjectPageController {
    
    Public String pageId = ApexPages.currentPage().getParameters().get('id');    
    Public List<osi_project__c> parentProject = new List<osi_project__c>();    
    Public List<osi_project_milestone__c> allMilestoneList = new List<osi_project_milestone__c>();    
    Public List<osi_project_milestone__c> deleteMilestoneList = new List<osi_project_milestone__c>();    
    Public List<OSI_Project_Compliance_Documents__c> allComplianceList = new List<OSI_Project_Compliance_Documents__c>();    
    Public List<OSI_Project_Compliance_Documents__c> deleteComplianceList = new List<OSI_Project_Compliance_Documents__c>();
    Public List<OSI_Project_Resource__c> allStaffingList = new List<OSI_Project_Resource__c>();
    Public List<OSI_Project_Resource__c> deleteStaffingList = new List<OSI_Project_Resource__c>();
    
    

    public String rowID = '';    
    public boolean displayStaffing {get;set;}     
    public boolean displayCompliance {get;set;}     
    public boolean displayMilestones {get;set;}
    
    
    Public OSIProjectPageController(){
		parentProject = [select id, name, status__c, Project_Complexity__c, Portfolio_Manager__c, Project_Manager__c, Overall_Project__c, Planned_Start_Date__c, 
                         Planned_End_Date__c, Total_Planned_Days__c
                         FROM osi_project__c where id =: pageId];
    
    }
    
	
	Public void InitializePageOne(){
    // osi milestone query
        displayMilestones = true;
        displayCompliance = false;
        displayStaffing = false;
        allMilestoneList = [Select id, name, Project_Phases__c, Project_Phase_Status__c, Phase_Status__c, Planned_Start_Date__c, Planned_End_Date__c, Number_of_Days__c, 
                            Comments__c, Projected_Actual_Start_Date__c, Projected_Actual_End_Date__c, order__c, Start_Date_Variance__c, End_Date_Variance__c
                          	FROM osi_project_milestone__c WHERE OSI_Project__c =:pageId Order by order__c ASC];
    }
    
    Public void InitializePageTwo(){
    // osi compliance query
        displayCompliance = true;
        displayMilestones = false;
        displayStaffing = false;
        allComplianceList = [Select id, name, Document__c, Document_Status__c, Due_Date__c, Template_URL__c, External_URL__c, Compliance__c
                          	FROM OSI_Project_Compliance_Documents__c WHERE OSI_Project__c =:pageId];

    }
    
    Public void InitializePageThree(){
    // osi staffing query
        displayStaffing = true;
        displayMilestones = false;
        displayCompliance = false;
		allStaffingList = [Select id, name, Active_Status__c, OSI_Resource__c, Start_Date__c, End_Date__c, Weekly_Email_Sent__c
                          	FROM OSI_Project_Resource__c WHERE OSI_Project__c =:pageId];
    }
       
    Public list<OSI_Project__c> GetProject() {    
    	return parentProject;
    }
    
    
    Public List<osi_project_milestone__c> GetMilestones(){
        return allMilestoneList;
	}
    
    Public List<osi_project_compliance_documents__c> GetCompliance(){
        return allComplianceList;
	}
    
    Public List<osi_project_resource__c> GetResources(){
        return allStaffingList;
	}
    
    Public void AddMilestone(){
        osi_project_milestone__c m = new osi_project_milestone__c();
            m.osi_project__c = pageId;
            allMilestoneList.add(m);
    }
    
    Public void AddStaff(){
        osi_project_resource__c m = new osi_project_resource__c();
            m.osi_project__c = pageId;
            allStaffingList.add(m);
    }
    
    Public void Save() {
        //for(osi_project_milestone__c ms : allMilestoneList);
        upsert allMilestoneList;       
        InitializePageOne();
   	} 
    
    Public void SaveCompliance() {        
        upsert allComplianceList;       
        InitializePageTwo();
   	} 
    
    Public void SaveStaffing() {        
        upsert allStaffingList;       
        InitializePageThree();
   	} 
    
	Public void UpdatePlanDates(){
        update allMilestoneList;
        for (osi_project_milestone__c ms : allMilestoneList) {                  
                if (ms.Number_of_Days__c >= 1){
            		ms.Planned_End_Date__c = ms.Planned_Start_Date__c + integer.valueOf(ms.Number_of_Days__c);
                }    
            	for(osi_project__c p : parentProject) {
                    if(ms.Planned_End_Date__c > p.Planned_End_Date__c) {
                        System.debug('ms.endDate: ' + ms.Planned_End_Date__c);
                        system.debug('p.endDate: '+ p.Planned_End_Date__c);
                    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Milestone End Date cannot be greater than Planned End Date')); 
                    }
            	}
                update allMilestoneList;  
            }     
        InitializePageOne();
    }
    
    Public void PopulateDatesAction(){
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index')); 
        rowID = allMilestoneList[indexVal - 1].Id;
        
        osi_project_milestone__c[] milestoneList = [Select id, name, Project_Phases__c, Project_Phase_Status__c, Phase_Status__c, Planned_Start_Date__c, Planned_End_Date__c, Number_of_Days__c, 
                            						Comments__c, Projected_Actual_Start_Date__c, Projected_Actual_End_Date__c, order__c, Use_Days__c
                          							FROM osi_project_milestone__c WHERE id =: rowID];
			for (osi_project_milestone__c ms : milestoneList) {  
                ms.Projected_Actual_Start_Date__c = ms.planned_start_date__c;  
                ms.Projected_Actual_End_Date__c = ms.Planned_End_Date__c;
            }     
        	update milestonelist;  
        	InitializePageOne();
    }

    
    public PageReference RemoveMilestone(){   
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index'));     
		rowID = allMilestoneList[indexVal - 1].Id;        
        

        System.Debug('indexVal ' + indexVal);
        System.Debug('allMilestoneList ' + allMilestoneList);
        
        osi_project_milestone__c[] milestoneList = [Select id, name, Project_Phases__c, Project_Phase_Status__c, Phase_Status__c, Planned_Start_Date__c, Planned_End_Date__c, Number_of_Days__c, 
                                                    Comments__c, Projected_Actual_Start_Date__c, Projected_Actual_End_Date__c, order__c, Use_Days__c
                                                    FROM osi_project_milestone__c WHERE id =: rowID];
        
        for (osi_project_milestone__c ms : milestoneList) {  
            deleteMilestoneList.add(allMilestoneList[indexVal - 1]);                    
            allMilestoneList.remove(indexVal - 1);                   
            if(deleteMilestoneList.size() > 0) {
                delete deleteMilestoneList;
            }
        }
        pageReference pg = new pageReference(ApexPages.currentPage().getURL());
        pg.setRedirect(TRUE);
        return pg;        
    }       
    
}