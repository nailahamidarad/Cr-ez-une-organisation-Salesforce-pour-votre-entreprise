@IsTest
private class OpportunityProductsSelectorTest {
    @TestSetup
    static void setup() {
        Account testAccount = TestDataFactory.createTestAccount();
        Pricebook2 testPricebook2 = TestDataFactory.createTestPricebook();
        Product2 testProduct = TestDataFactory.createTestProduct();
        PricebookEntry testPricebookEntry = TestDataFactory.createTestPricebookEntry(testPricebook2.id, testProduct.id);
        Opportunity testOpportunity = TestDataFactory.createTestOpportunity(testAccount.Id, testPricebook2.Id);
        TestDataFactory.createTestOLI(testOpportunity.Id, testProduct.Id, testPricebookEntry.Id);
    }

    @IsTest
    static void testGetOpportunityProductsbyOpportunityId() {
        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        List<OpportunityLineItem> results = OpportunityProductsSelector.getOpportunityProductsbyOpportunityId(testOpportunity.Id);
        Test.stopTest();
        Assert.areNotEqual(0, results.size(), 'Should return at least one opportunity line item');
    }
}