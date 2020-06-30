public with sharing class TestDataFactory {
    
    public static List<Account> createAccounts(Integer numAccts) {
        List<Account> accts = new List<Account>();
            
      
        for (Integer i = 0; i < numAccts; i++) {
          Account a = new Account(
            Name = 'TestPMAccount' + i,
            phone = '000000000000'
          );
          accts.add(a);
        }
        insert accts;
        return accts;
        
      }
   
     


  public static Relation__c createRelation(Account a,Account b,String relation) {

    Relation__c r = new Relation__c();
    r.ParentRelation__c = a.Id;
    r.AccountInRelation__c = b.Id;
    r.Relation__c = relation;
    return r;
  }
}
