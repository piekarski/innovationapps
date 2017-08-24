public with sharing class ExAMUtilClass {

    public static SFDCAccessController AccessController {
        get {
            if (AccessController == null) {
                AccessController = new SFDCAccessController();
            }
            return AccessController;
        }
        private set;
    }
    public static String getNameSpacePrefix() {
    
        String nameSpacePrefix = IssueRequest_Life_Cycle__c.sObjectType.getDescribe().getName().subStringBefore('IssueRequest_Life_Cycle__c');
        return nameSpacePrefix;
    }
}