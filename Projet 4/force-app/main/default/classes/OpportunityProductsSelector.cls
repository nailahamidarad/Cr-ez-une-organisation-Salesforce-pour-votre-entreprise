public with sharing class OpportunityProductsSelector {
    public static List<OpportunityLineItem> getOpportunityProductsbyOpportunityId(Id opportunityId) {
        List<OpportunityLineItem> opportunityProducts = [
            SELECT Id, Product2Id, Insufficient_Quantity_in_stock__c, Product2.Name, Quantity, UnitPrice, TotalPrice, Product2.QuantityinStock__c
            FROM OpportunityLineItem
            WHERE OpportunityId = :opportunityId
        ];
        return opportunityProducts;
    }
}