public with sharing class OpportunityProductsViewerController {
    @AuraEnabled(Cacheable=true)
    public static List<OpportunityLineItem> getOpportunityProductsbyOpportunityId(Id opportunityId) {
        return OpportunityProductsSelector.getOpportunityProductsbyOpportunityId(opportunityId);
       }
    }
