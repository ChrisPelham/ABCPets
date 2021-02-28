import { api, wire, LightningElement } from 'lwc';
import getPets from '@salesforce/apex/Pet_List_Controller.getPets';
import petIcon from '@salesforce/resourceUrl/petIcon';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import BIRTHDATE_FIELD from '@salesforce/schema/Pet__c.Birthdate__c';
import ID_FIELD from '@salesforce/schema/Pet__c.Id';

const columns = [
    { 
        label : 'Pet Name', 
        fieldName : 'petURL',
        type: 'url',
        typeAttributes: 
        {
            label: 
            {
                fieldName: 'name'
            },
            name: 'view_pet',
            tooltip: 'Click to View Pet'
        }
    },
    { 
        label : 'Owner', 
        fieldName : 'ownerURL',
        type: 'url',
        typeAttributes: 
        {
            label: 
            {
                fieldName: 'owner'
            },
            name: 'view_owner',
            tooltip: 'Click to View Owner'
        }
    },
    { label : 'Type', fieldName : 'type' },    
    { label : 'Breed', fieldName : 'breed' },
    { label : 'Age', fieldName : 'age' },
    { 
        label : 'Birthdate', 
        fieldName : 'birthdate', 
        type : 'date-local',
        typeAttributes: 
        {
            year: "numeric",
            month: '2-digit',
            day: '2-digit'
        },
        editable : true 
    }
];

const ERROR_TITLE = 'An error occurred attempting to retrieve the data.';
const ERROR_VARIANT = 'error';
const SUCCESS_TITLE = 'Success';
const SUCCESS_MESSAGE = 'Pet\'s Birthdate has been updated.';
const SUCCESS_VARIANT = 'success';

export default class PetList extends LightningElement 
{
    @api recordId;
    pets = [];
    columns = columns;
    petIcon = petIcon;
    numberOfPets = 0;

    @wire(getPets, {recordId: '$recordId'})
    wiredPetList({data, error})
    {
        if (data)
        {
            this.pets = data;
            this.numberOfPets = data.length;

            const birthdays = [];
            data.forEach(pet => {
                let d = new Date(pet.birthdate);
                let now = new Date();
                if (d.getUTCMonth() === now.getMonth() && d.getUTCDate() === now.getDate())
                {
                    birthdays.push(pet.name);
                }
            });

            if (birthdays.length > 0)
            {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Today\'s Birthdays',
                        message: 'The following pet(s) have a birthday today: ' + birthdays.join(', '),
                        variant: "info"
                    })
                );
            }
        }
        else if (error)
        {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: error.body.message,
                    variant: ERROR_VARIANT
                })
            );
        }
    }

    handleSave(event)
    {
        const fields = {}; 
        fields[ID_FIELD.fieldApiName] = event.detail.draftValues[0].petId;
        fields[BIRTHDATE_FIELD.fieldApiName] = event.detail.draftValues[0].birthdate;
        const recordInput = {fields};

        updateRecord(recordInput)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: SUCCESS_TITLE,
                    message: SUCCESS_MESSAGE,
                    variant: SUCCESS_VARIANT
                })
            );
            // Display fresh data in the datatable
            return refreshApex(this.pets).then(() => {

                // Clear all draft values in the datatable
                this.draftValues = [];

            });
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: error.body.message,
                    variant: ERROR_VARIANT
                })
            );
        });
    }
}