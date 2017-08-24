public class VACI_HA_Status_Tracker_Controller {
    // ******************************* INFORMATION ***************************//

    // ***********************************************************************//
    //  
    // ** NAME - VACI_HA_Status_Tracker_Controller. Controller that powers the 
    // **        Hiring App Status Tracker..supplying it with dynamic information
    // **        about a record.
    // ** 
    // ** @author   Aaron Goldberg <aagoldberg@deloitte.com>, Mike Beck <mibeck@deloitte.com>
    // ** @date     1/25/2015
    // ** 
    // **
    // ** Mod Log
    // ** v1.0      1/25/2015  Initial Creation
    //      
    // ***********************************************************************//

    // ********************************** START ******************************// 
    public VACI_HA_Request__c request { Get; Set; }
    private id requestId;  
    public integer currentStep { Get; Set; }
    public integer prevStep    { Get; Set; }
    public List<NodeWrapper> nodeList { Get; Set; }
    List<String> requestStatusPickVals = new List<String>();

    // =======================================================================// 
    // NodeWrapper - Inner Wrapper Class that holds information about each    // 
    // step in the Hiring App Hiring Process                                  //        
    // =======================================================================//
    public class NodeWrapper {
      public Integer reqStep     { Get; Set; }
      public String  reqStatus   { Get; Set; }
      public String  statDate    { Get; Set; }
      //Inner Class Constructor
      public NodeWrapper(Integer reqStep, String reqStatus, String statDate){
        this.reqStep   = reqStep;
        this.reqStatus = reqStatus;
        this.statDate  = statDate;
      } 
    }

    /**
    * Constructor - Runs initial query to obtain additional field info
    * on current record being displayed. Trigger NodeWrapper list builder.
    * specified by parameter 'id'
    *
    * @param stdController The VACI_HA_Request__c standard controller. Used for 
    *        accessing information about current record being viewed.
    */
    public VACI_HA_Status_Tracker_Controller(ApexPages.StandardController stdController) {
      currentStep = 1;
      prevStep = 1;
      requestId = stdController.getRecord().Id;
      //pull Status Field and Date APIs from Current Request 
      request = [Select Id, Status__c, Status_Date_APIs__c, Previous_Status__c, Cancelled_Date__c, Instructions__c From VACI_HA_Request__c Where Id =: requestId];

      String additionalSelects = 'Status__c, Status_Date_APIs__c, Previous_Status__c,' + request.Status_Date_APIs__c;
      list<sObject> newObjList = Database.query(getDynamicQuery('VACI_HA_Request__c', additionalSelects, String.valueOf(requestId)));  
      sObject  newObj;
      
      if(newObjList.size() > 0){
        newObj = newObjList[0];
        System.debug('VACI_HA_Status_Tracker_Controller -- Constructor -- newObj ==> ' + newObj);
        //request = (VACI_HA_Request__c)newObj;
      }
      System.debug('VACI_HA_Status_Tracker_Controller -- Constructor -- the request ==> ' + request);
      nodeList = getWrapperList(newObj);

      System.debug('currentStep++++++'+currentStep);
      System.debug('prevStep+++++++++'+prevStep);
    }

    /**
    * getWrapperList - Builds the list of NodeWrappers that the front end
    *                  visualforce page uses to iterate over and form the 
    *                  nodes in the status tracker.
    *
    * @param request The request that the status tracker is showing
    *                information on.  It is the current record returned
    *                by the standard controller.
    *        
    */
    public list<NodeWrapper> getWrapperList(sObject request){
      Integer j = 0;
      list<String> pickListVals         = getStatusPickListVals();
      list<String> dateFieldNames       = getDateAPINames();
      list<NodeWrapper> nodeWrapperList = new list<NodeWrapper>();
      NodeWrapper nodeWrapper;
      String dateFieldName  = '';
      String dateFieldValue = '';
      String currentRecordStatus = String.valueOf(request.get('Status__c'));
      //Assume same order for pickListVals and dateFieldNames.
      for(Integer i = 0; i < pickListVals.size(); i++){
        if(i < dateFieldNames.size()){
          System.debug('VACI_HA_Status_Tracker_Controller -- getWrapperList -- checking dateFieldName ' + dateFieldName);
          dateFieldName = dateFieldNames.get(i).trim();
          if(request.get(dateFieldName) != null)
            dateFieldValue = ((DateTIME)request.get(dateFieldName)).format();
        }

          nodeWrapper = new nodeWrapper(i + j, pickListVals.get(i), dateFieldValue);
          nodeWrapperList.add(nodeWrapper);
        

        if(pickListVals.get(i).equals(request.get('Status__c'))) {
          currentStep = i + j;  
        }
        else{

          if(pickListVals.get(i).equals(request.get('Previous_Status__c')) 
              && currentRecordStatus.toLowerCase().equals('cancelled'))
          {
            j = 1;
            currentStep = i + j;
            String cancelledDate = '';
            if(request.get('Cancelled_Date__c') != null)
              cancelledDate = ((DateTIME)request.get('Cancelled_Date__c')).format();
            nodeWrapper = new nodeWrapper(i + 1, 'Cancelled', cancelledDate);
            nodeWrapperList.add(nodeWrapper);
          }
        }

        
      }
      return nodeWrapperList;
    }


    /**
    * getStatusPickListVals - Dynamically grabs the picklist values from the status 
    *                         field 'Status__c.' New Statuses are automatically
    *                         picked up by this method 
    *        
    */
    public list<String> getStatusPickListVals(){
        //Take Status Field Picklist Values and Convert to List
        Schema.DescribeFieldResult requestStatus = VACI_HA_Request__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> rsVals = requestStatus.getPicklistValues();
        list<String> requestStatusPickVals = new list<String>();
        for(Schema.PicklistEntry r: rsVals) {
          if(r.getValue() != 'Cancelled') {
            requestStatusPickVals.add(r.getValue());
          }
        }
        return requestStatusPickVals;
    }

    /**
    * getDateAPINames - Grab the API Names for corresponding status date stamp fields.
    *        
    */
    public list<String> getDateAPINames(){
        List<String> statusDates = new List<String>();
        if (request.Status_Date_APIs__c != null && request.Status_Date_APIs__c.trim() != '') {
          statusDates = request.Status_Date_APIs__c.split(',');
        }
        return statusDates;
    }

    /**
    * getDynamicQuery - Form and return dynamic soql query.
    *
    * @param ObjectName API Name of the object to query
    *        
    */
    public static string getDynamicQuery(String ObjectName, String additionalSelects, String recordID){
      String startQuery = 'SELECT ';
      String query      = '';
      query = startQuery + 'ID, ' + additionalSelects;

      System.debug('VACI_HA_Status_Tracker_Controller -- getDynamicQuery -- start query ==> ' + query);

      query += ' FROM ' + ObjectName;

      query += ' Where ID = \'' + recordID + '\'';

      System.debug('VACI_HA_Status_Tracker_Controller -- getDynamicQuery -- the query ==> ' + query);
      return query; 
    }
}