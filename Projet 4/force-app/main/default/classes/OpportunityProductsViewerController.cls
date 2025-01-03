public with sharing class OpportunityProductsViewerController {
    @AuraEnabled(Cacheable=true)
    public static List<OpportunityLineItem> getOpportunityProductsbyOpportunityId(Id opportunityId) {
        return OpportunityProductsSelector.getOpportunityProductsbyOpportunityId(opportunityId);
       }
       
       @AuraEnabled
       public static void deleteOpportunityProduct(Id opportunityLineItemId) {
           try {
               OpportunityLineItem oliToDelete = [SELECT Id FROM OpportunityLineItem WHERE Id = :opportunityLineItemId LIMIT 1];
               delete oliToDelete;
           } catch (Exception e) {
               throw new AuraHandledException('Erreur lors de la suppression de l\'enregistrement : ' + e.getMessage());
           }
       }
     
    }
