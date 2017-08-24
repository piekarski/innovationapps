public class MyVACommunityControllerExtension {

    private final MyVA_Community__c myva;
    
    public List<Community_Contacts__c> content;
    
    
    // The extension constructor initializes the private member
    // variable myva by using the getRecord method from the standard
    // controller.
    public MyVACommunityControllerExtension(ApexPages.StandardController stdController) {
        this.myva = (MyVA_Community__c)stdController.getRecord();       
    }
    
    public PageReference records() 
    {
     return new PageReference('/apex/MyVACommunityPrintView');
    }    
    
    public list<Community_Contacts__c> getContent()
        {
        if(content==null) {
            list<Community_Contacts__c> cs = new list<Community_Contacts__c>();
            for(Community_Contacts__c c : [Select c.id, c.name, contact__r.name, contact__r.title, c.contact__c, c.role__c, c.myva_community__c from community_contacts__c c WHERE c.myva_community__c = :this.myva.Id]){
                cs.add(c);
            }
            
            if(cs.size() !=0) { content=cs; }
        }
        return content;
        }
            
}