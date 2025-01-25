@IsTest
public class TestDataFactory {
    public static Account createTestAccount() {
        Account acc = new Account(Name='Test Account');
        insert acc;
        return acc;
    }

    public static Pricebook2 createTestPricebook(){
        Id pricebook2Id = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
            Id = pricebook2Id,
            IsActive = true
        );
        update standardPricebook;
        return standardPricebook;
    }
    

    public static Opportunity createTestOpportunity(Id accountId, Id pricebook2Id) {
        Opportunity opp = new Opportunity(
                Name='Test Opportunity',
                StageName='Prospecting',
                CloseDate=System.today().addDays(30),
                Amount=10000,
                AccountId=accountId,
                Pricebook2Id=Pricebook2Id
        );
        insert opp;
        return opp;
    }

    public static Case createTestCase(Id accountId) {
        Case cas = new Case(
                Subject='Test Subject 1',
                Status='Working',
                Priority='Medium',
                AccountId=accountId
        );
        insert cas;
        return cas;
    }
    public static Product2 createTestProduct() {
        Product2 prod = new Product2(
                Name='Test Product',
                IsActive=true,
                QuantityinStock__c=10 
        );
        insert prod;
        return prod;
    }

    
    public static PricebookEntry createTestPricebookEntry(Id pricebook2Id, Id Product2) {
        PricebookEntry pbe = new PricebookEntry(
            Product2Id=Product2,
            Pricebook2Id=pricebook2Id,
            UnitPrice=1000,
            IsActive=true,
            UseStandardPrice=false        );
        insert pbe;
        return pbe;
    }

    public static OpportunityLineItem createTestOLI(Id OpportunityId, Id Product2Id, Id PricebookEntryId) {
        OpportunityLineItem OLI = new OpportunityLineItem(
                Quantity=10,
                UnitPrice=1000,
                OpportunityId=OpportunityId,
                Product2Id=Product2Id,
                PricebookEntryId=PricebookEntryId
        );
        insert OLI;
        return OLI;
}
public static void createTestUsers() {
    // Récupération des profils "System Administrator" et "Sales"
    Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
    Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Custom: Sales Profile' LIMIT 1];

    User sysAdminUser = new User(
        Username = 'sysadmin@test.com',
        Email = 'sysadmin@test.com',
        Alias = 'sysadmin',
        ProfileId = sysAdminProfile.Id,
        TimeZoneSidKey = 'America/New_York',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        FirstName = 'System',
        LastName = 'Admin',
        CompanyName = 'Test Company',
        IsActive = true
    );
    insert sysAdminUser;

    User salesUser = new User(
        Username = 'sales@test.com',
        Email = 'sales@test.com',
        Alias = 'sales',
        ProfileId = salesProfile.Id,
        TimeZoneSidKey = 'America/New_York',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        FirstName = 'Sales',
        LastName = 'User',
        CompanyName = 'Test Company',
        IsActive = true
    );
    insert salesUser;
}
}