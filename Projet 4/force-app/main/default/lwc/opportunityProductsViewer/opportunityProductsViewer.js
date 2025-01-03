import { LightningElement, api, wire, track } from 'lwc';
import getOpportunityProductsbyOpportunityId from '@salesforce/apex/OpportunityProductsViewerController.getOpportunityProductsbyOpportunityId';
import { NavigationMixin } from 'lightning/navigation';
import deleteOpportunityProduct from '@salesforce/apex/OpportunityProductsViewerController.deleteOpportunityProduct';

export default class OpportunityProductsViewer extends LightningElement {
    @api recordId;
    @track opportunityProducts = [];
    
    columns = [
        { label: 'Nom du Produit', fieldName: 'Product2Name', type: 'text' },
        { label: 'Quantité', fieldName: 'Quantity', type: 'text' },
        { label: 'Prix unitaire', fieldName: 'UnitPrice', type: 'currency', cellAttributes: { alignment: 'left' } },
        { label: 'Prix Total', fieldName: 'TotalPrice', type: 'currency', cellAttributes: { alignment: 'left' } },
        { label: 'Quantité en Stock', fieldName: 'Product2QuantityInStock__c', type: 'text' },
        { label: 'Supprimer', type: 'button-icon',
            typeAttributes: {
                label: 'Supprimer',
                name: 'delete',
                iconName: 'utility:delete',
                variant: 'neutral',
            }
        },
        { label: 'Voir produit', type: 'button',
            typeAttributes: {
                label: 'View Product',
                name: 'open',
                iconName: 'utility:preview',
                iconPosition: 'left',
                variant: 'brand',
            },
        }
    ];

    @wire(getOpportunityProductsbyOpportunityId, { opportunityId: '$recordId' })
    wiredOpportunityLineItems(result) {
        this.wiredResult = result;

        if (result.data) {
            this.opportunityProducts = result.data.map(item => ({
                ...item,
                Product2Name: item.Product2.Name,
                Product2QuantityInStock__c: item.Product2.QuantityInStock__c,
            }));
        } else if (result.error) {
            this.opportunityProducts = [];
        }
    }

    get hasOpportunityProducts() {
        return Array.isArray(this.opportunityProducts) && this.opportunityProducts.length > 0;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;  
        const recordId = event.detail.row.Id;  
    
        if (actionName === 'open') {  
            this.openRecord(recordId);
        } else if (actionName === 'delete') {  
            this.deleteRow(recordId);
        }
    }

    openRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',  
            attributes: {
                recordId: recordId,   
                objectApiName: 'OpportunityLineItem', 
                actionName: 'view'  
            }
        });
    }

    deleteRecord(recordId) {
        deleteOpportunityProduct({ opportunityLineItemId: recordId })  

}
}
