@isTest()
public class TestStrategicCommunitiesSelfRegCntlr {

    static public TestMethod void TestCntlr(){
        StrategicCommunitiesSelfRegController scsrc = new StrategicCommunitiesSelfRegController();
        
        scsrc.firstName = 'Test';
        scsrc.lastName = 'User';
        scsrc.email = 'test.user@testing.com';
        scsrc.password = null;
        scsrc.confirmPassword = null;
        scsrc.communityNickname = null;
        
        scsrc.registerUser();
        
        List<SelectOption> myList = scsrc.getAccountList();
        
        scsrc.confirmPassword = 'NoMatch';
        scsrc.registerUser();
        
        scsrc.confirmPassword = 'Password';
        scsrc.password = 'Password';
		
        scsrc.registerUser();
        
        
        
        
    }
}