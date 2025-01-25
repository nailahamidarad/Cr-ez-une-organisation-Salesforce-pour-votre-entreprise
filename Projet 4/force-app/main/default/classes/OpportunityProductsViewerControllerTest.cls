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
        TestDataFactory.createTestUsers();

        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsActive = true LIMIT 1];
    }

    @isTest
    static void testGetOpportunityProductsbyOpportunityId() {
        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        
        Test.startTest();
        List<OpportunityLineItem> result = OpportunityProductsViewerController.getOpportunityProductsbyOpportunityId(testOpportunity.Id);
        Test.stopTest();
        
        System.assertNotEquals(result, null, 'La liste des OLI ne doit pas être nulle.');
        System.assertEquals(result.size(), 1, 'Il doit y avoir un OLI retourné.');
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
        System.assertNotEquals(oliCheck, null, 'Le OLI doit être présent avant la suppression.');
        
        Test.startTest();
        OpportunityProductsViewerController.deleteOpportunityProduct(oliToDelete.Id);
        Test.stopTest();

        try {
            OpportunityLineItem deletedOliCheck = [SELECT Id FROM OpportunityLineItem WHERE Id = :oliToDelete.Id LIMIT 1];
            System.assertEquals(deletedOliCheck, null, 'L OLI doit être supprimée.');
        } catch (QueryException e) {
            System.assert(true, 'L OLI a été supprimée.');
        }
    }

    @isTest
    static void testGetUserProfileName() {
        User sysAdminUser = [SELECT Id, Profile.Name FROM User WHERE Username = 'sysadmin@test.comnh0125' LIMIT 1];
        User salesUser = [SELECT Id, Profile.Name FROM User WHERE Username = 'sales@test.comnh0125' LIMIT 1];

    Test.startTest();
    System.runAs(sysAdminUser) {
        String profileName = OpportunityProductsViewerController.getUserProfileName();
        System.assertEquals(profileName, 'System Administrator', 'Le nom du profil doit être System Administrator pour le sysAdminUser');
    }

    System.runAs(salesUser) {
        String profileName = OpportunityProductsViewerController.getUserProfileName();
        System.assertEquals(profileName, 'Custom: Sales Profile', 'Le nom du profil doit être Custom: Sales Profile pour le salesUser');
    }
    Test.stopTest();
}
}