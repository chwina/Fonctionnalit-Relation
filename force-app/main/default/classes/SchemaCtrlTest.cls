@isTest(SeeAllData=true)
public with sharing class SchemaCtrlTest {
    @isTest
    public static void init() {
      //Create Accounts
      List<Account> accountList = TestDataFactory.createAccounts(3);
  
      
    
      //Relation__c creation
      List<Relation__c> lRel = new List<Relation__c>();
      lRel.add(
        TestDataFactory.createRelation(
          accountList[0],
          accountList[1],
          'Est parent de'
        )
      ); 
      lRel.add(
        TestDataFactory.createRelation(
          accountList[1],
          accountList[2],
          'Est parent de'
        )
      ); 
    
    insert lRel;
      
  
      String data;
  
      //Start Testing
      Test.startTest();
      data = SchemaCtrlMdt.getData(accountList[0].id);
      List<SchemaCtrlMdt.Wrapper> dataList = (List<SchemaCtrlMdt.Wrapper>) Json.deserialize(
        data,
        List<SchemaCtrlMdt.Wrapper>.class
      );
      system.assertequals(dataList.size(), 6);
      Test.stopTest();
      
    }
}

