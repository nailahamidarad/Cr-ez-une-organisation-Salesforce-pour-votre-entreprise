public with sharing class OpportunityProductsSelector {
    public static List<OpportunityLineItem> getOpportunityProductsbyOpportunityId(Id opportunityId) {
        List<OpportunityLineItem> opportunityProducts = [
            SELECT Id, Product2.Name, Quantity, UnitPrice, TotalPrice, Product2.QuantityinStock__c
            FROM OpportunityLineItem
            WHERE OpportunityId = :opportunityId
        ];
        return opportunityProducts;
    }
}