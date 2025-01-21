import { LightningElement, api, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import getOpportunityProductsbyOpportunityId from '@salesforce/apex/OpportunityProductsViewerController.getOpportunityProductsbyOpportunityId';
import getUserProfileName from '@salesforce/apex/OpportunityProductsViewerController.getUserProfileName';
import deleteOpportunityProduct from '@salesforce/apex/OpportunityProductsViewerController.deleteOpportunityProduct';
import ProductName from "@salesforce/label/c.LWC_OpportunityProducts_ProductName";
import Delete from "@salesforce/label/c.LWC_OpportunityProducts_Delete";
import Quantity from "@salesforce/label/c.LWC_OpportunityProducts_Quantity";
import QuantityInStock from "@salesforce/label/c.LWC_OpportunityProducts_QuantityInStock";
import Title from "@salesforce/label/c.LWC_OpportunityProducts_Title";
import TotalPrice from "@salesforce/label/c.LWC_OpportunityProducts_Total_Price";
import UnitPrice from "@salesforce/label/c.LWC_OpportunityProducts_UnitPrice";
import ViewProduct from "@salesforce/label/c.LWC_OpportunityProducts_ViewProduct";
import QuantityError from "@salesforce/label/c.LWC_OpportunityProducts_QuantityError";
import NoProduct from "@salesforce/label/c.LWC_OpportunityProducts_NoProduct";

export default class OpportunityProductsViewer extends NavigationMixin(LightningElement) {
    @api recordId;
    @track opportunityProducts = [];
    datatableTitle = Title;
    quantityErrorMessage = QuantityError;
    noProductMessage = NoProduct;

    columns = [
        { label: ProductName, fieldName: 'Product2Name', type: 'text' },
        { label: Quantity, fieldName: 'Quantity', type: 'text', cellAttributes: {
            style: { fieldName: 'quantityStyle' }}},
        { label: UnitPrice, fieldName: 'UnitPrice', type: 'currency', cellAttributes: { alignment: 'left' } },
        { label: TotalPrice, fieldName: 'TotalPrice', type: 'currency', cellAttributes: { alignment: 'left' } },
        { label: QuantityInStock, fieldName: 'Product2QuantityInStock__c', type: 'text' },
        { label: Delete, type: 'button-icon',
            typeAttributes: {
                label: 'Supprimer',
                name: 'delete',
                iconName: 'utility:delete',
                variant: 'neutral',

            }
        },
    ];

    profileName;

    @wire(getUserProfileName)
    wiredProfile({ data }) {
        if (data) {
            this.profileName = data;
        if (this.profileName === 'System Administrator' || this.profileName=== 'Administrateur système') {
            this.columns.push({
                    label: ViewProduct, 
                    type: 'button', 
                    typeAttributes: {
                        label: ViewProduct,
                        name: 'open',
                        iconName: 'utility:preview',
                        iconPosition: 'left',
                        variant: 'brand',
                    },
                });
            }}}
 

    @wire(getOpportunityProductsbyOpportunityId, { opportunityId: '$recordId' })
    wiredOpportunityLineItems(result) {
        this.wiredResult = result;

        if (result.data) {
            this.opportunityProducts = result.data.map(item => ({
                ...item,
                Product2Name: item.Product2.Name,
                Product2QuantityInStock__c: item.Product2.QuantityInStock__c,
                quantityStyle: item.Insufficient_Quantity_in_stock__c ? 'font-weight: bold; color: red; background: #D3D3D3' : ''  
            }));
        this.hasInsufficientStock = this.opportunityProducts.some(item => item.Insufficient_Quantity_in_stock__c);
        } else if (result.error) {
            this.opportunityProducts = [];
            this.hasInsufficientStock = false;
        }
    }

    get hasOpportunityProducts() {
        return Array.isArray(this.opportunityProducts) && this.opportunityProducts.length > 0;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;  
        const productId = event.detail.row.Product2Id;  
        const recordId = event.detail.row.Id; 
    
        if (actionName === 'open') {  
            this.openRecord(productId);
        } else if (actionName === 'delete') {  
            this.deleteRecord(recordId);
        }
    }

    openRecord(productId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',  
            attributes: {
                recordId: productId,   
                objectApiName: 'OpportunityLineItem', 
                actionName: 'view'  
            }
        });
    }

    deleteRecord(recordId) {
        deleteOpportunityProduct({ opportunityLineItemId: recordId })
        .then(() => {
            return refreshApex(this.wiredResult);})

    }

}
