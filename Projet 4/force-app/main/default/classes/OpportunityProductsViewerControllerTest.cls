@isTest
public class OpportunityProductsViewerControllerTest {
    
    @testSetup
    static void setup() {
        Account testAccount = TestDataFactory.createTestAccount();
        Pricebook2 testPricebook2 = TestDataFactory.createTestPricebook();
        Opportunity testOpportunity = TestDataFactory.createTestOpportunity(testAccount.Id, testPricebook2.Id);
        Product2 testProduct2 = TestDataFactory.createTestProduct();
        PricebookEntry testPricebookEntry = TestDataFactory.createTestPricebookEntry(testPricebook2.Id, testProduct2.Id);
        OpportunityLineItem testOLI = TestDataFactory.createTestOLI(testOpportunity.Id, testProduct2.Id, testPricebookEntry.Id);

        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsActive = true LIMIT 1];
    }

    @isTest
    static void testGetOpportunityProductsbyOpportunityId() {
        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        
        Test.startTest();
        List<OpportunityLineItem> result = OpportunityProductsViewerController.getOpportunityProductsbyOpportunityId(testOpportunity.Id);
        Test.stopTest();
        
        System.assertNotEquals(result, null, 'La liste des OpportunityLineItems ne doit pas être nulle.');
        System.assertEquals(result.size(), 1, 'Il doit y avoir un produit d\'opportunité retourné.');
    }

    @isTest
    static void testDeleteOpportunityProduct() {
        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        Product2 testProduct2 = [SELECT Id FROM Product2 WHERE Name = 'Test Product' LIMIT 1];
        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsActive = true LIMIT 1];
        
        OpportunityLineItem oliToDelete = new OpportunityLineItem(
            OpportunityId = testOpportunity.Id,
            Product2Id = testProduct2.Id,
            Quantity = 10,
            UnitPrice = 100
        );
        insert oliToDelete;
        
        OpportunityLineItem oliCheck = [SELECT Id FROM OpportunityLineItem WHERE Id = :oliToDelete.Id LIMIT 1];
        System.assertNotEquals(oliCheck, null, 'Le produit d\'opportunité doit être présent avant la suppression.');
        
        Test.startTest();
        OpportunityProductsViewerController.deleteOpportunityProduct(oliToDelete.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetUserProfileName() {
        Test.startTest();
        String profileName = OpportunityProductsViewerController.getUserProfileName();
        Test.stopTest();
        
        System.assertNotEquals(profileName, null, 'Le nom du profil ne doit pas être nul.');
        System.assertEquals(profileName, 'System Administrator', 'Le nom du profil retourné doit correspondre au profil de l\'utilisateur actuel.');
    }
}
