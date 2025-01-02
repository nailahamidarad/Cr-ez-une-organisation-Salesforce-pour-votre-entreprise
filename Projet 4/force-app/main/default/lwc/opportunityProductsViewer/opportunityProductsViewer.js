import { LightningElement, api, wire, track } from 'lwc';
import getOpportunityProductsbyOpportunityId from '@salesforce/apex/OpportunityProductsViewerController.getOpportunityProductsbyOpportunityId';
import { NavigationMixin } from 'lightning/navigation';

export default class AccountOpportunitiesViewer extends NavigationMixin(LightningElement) {
    @api recordId;
    @track opportunityProducts = [];
    @track noresult = false;

    columns = [
        { label: 'Nom du Produit', fieldName: 'Product2Name', type: 'text' },
        { label: 'Quantité', fieldName: 'Quantity', type: 'currency' },
        { label: 'Prix unitaire', fieldName: 'UnitPrice', type: 'currency' },
        { label: 'Prix Total', fieldName: 'TotalPrice', type: 'currency' },
        { label: 'Quantité en Stock', fieldName: 'Product2QuantityInStock__c', type: 'text' },
        { label: 'Supprimer', type: 'button-icon',
            typeAttributes: {
                label: 'Supprimer',
                name: 'delete',
                iconName: 'utility:delete',
                variant: 'neutral'
            }
        },
       { label: 'Voir produit', type: 'button',
            typeAttributes: {
                label: 'View Product',
                name: 'viewProduct',
                iconName: 'utility:preview',
                iconPosition: 'left',
                variant: 'brand'
            }
        }
    ];

    @wire(getOpportunityProductsbyOpportunityId, { opportunityId: '$recordId' })
    wiredOpportunityLineItems(result) {
        this.wiredResult = result;

        if (result.data) {
            this.opportunityProducts = result.data;
            this.noresult = this.opportunityProducts.length === 0;
        } else if (result.error) {
            this.noresult = true; 
            this.opportunityProducts = [];
        }
    }

    get hasOpportunityProducts() {
        return Array.isArray(this.opportunityProducts) && this.opportunityProducts.length > 0;
    }

    handleRowDeletion(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'delete') {
            this.deleteRow(row);
        }
    }

    deleteRow(row) {
        this.opportunityProducts = this.opportunityProducts.filter(item => item.Id !== row.Id);
    }
}
