@isTest
public class TestRemoteJSON {

    static testMethod void method1() {

      string queryConfig = '{"fields": ["Id", "Name"],"table": "User","limit": 10}';
      Test.startTest();
      List<SObject> result =  remoteJSON.query(queryConfig);
      Test.stopTest();
      System.assertEquals( 10, result.size());

    }
}