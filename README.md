# ABC Pets Implementation Solution

## Objective

Implement a solution for ABC Pets to track customer’s pets, their families and family members utilizing the Lightning user interface.

## Requirements

- Track Pet Information including name, type, birthdate, and age of the pet. 
- Pets should be able to be associated with more than one person.
    - Each person can have a different relationship with the pet.
- When a new pet is added, all other family members of the pet should be associated with the pet as ‘Family’
- When viewing the pet list, a user should be alerted if any of the pets have a birthday
- When viewing a family, a list of pets should be available and the ability to update each pet’s birthdate, without leaving the family view, should be available.


## Assumptions

- Each person should be able to be associated with more than one pet. Since each pet should be able to be associated with more than one person, a many-to-many relationship would be required.
- Pets can be added to the system without an owner. The client may be working with a customer who is not the owner, such as the caretaker or veterinarian.
- If Pet is not associated with its owner, it is possible that the pet may not have any family members in the system, and thus would not be associated with a Family.
- When a new family member is added, all existing Pets of other family members are not automatically associated as ‘Family’.
- Birthday alerts only appear on pages with related lists, not on Pet List Views.


## Methods

### Design and Discovery 
During the design and discovery phase I read through the requirements multiple times to make sure I was making the best possible assumptions and planning out my data structure correctly. I listed out the Custom Objects I would need to complete the requirements as well as the fields those objects should contain. I then drew relationship diagrams to ensure that the records would be related correctly.

Once I had a good idea of the data structure, I determined what logic would be needed to meet the requirements and the best way to put that logic in place.  This included writing pseudocode for the trigger methods, LWC components and its controller as well as the SOQL queries required.

### Data Structure (2 hours)
I chose to use Custom Objects rather than Standard Objects because I personally feel it provides a cleaner first implementation. I believe I could have created the same solution using Accounts and Contacts but the number of available fields and relationships seemed to be overkill for this implementation and might lead to confusion with the client. For my implementation I created the following Custom Objects.

**Family__c** 

The Family object is the main container object used to track family members and their pets. The object has one field, Name, which stores the name of the Family.

**People__c**

The People object contains data related to the customer. 

Custom Fields:
- Family__c - Lookup relationship to the associated Family__c record.
- Email__c 
- Primary_Phone__c 
- Secondary_Phone__c
- Mailing_Address__c
- Mailing_City__c
- Mailing_State__c
- Mailing_Zip_Code__c
- Mailing_Address__c
- Mailing_City__c
- Mailing_State__c
- Mailing_Zip_Code__c
- Other_Address__c
- Other_City__c
- Other_State__c
- Other_Zip_Code__c

**Pet__c**

The Pet object contains data related to the pet.

Custom Fields:
- Type__c - Picklist containing common types of pets
- Breed__c - Optional field to indicate breed of pet
- Birthdate__c - Pet’s birthdate.
- Age__c - Formula field that calculates the pet’s age from their birthdate
- Birthday__c - Formula field that display an image of cake on the pet’s birthday
- Owner__c - Lookup relationship to the pet’s owner’s People__c record
- Family__c - Lookup relationship to the pet’s owner’s Family__c record

**Relationship__c**

The Relationship object is a junction object between the Pet__c object and People__c object. This allows for a many-to-many relationship between pets and people.

Custom Fields:
- Pet__c - Master Detail Relationship with Pet__c
- People__c - Master Detail Relationship with People__c
- Relation__c - Picklist of common relationship types
- Relationship_Description__c - Optional field to describe relationship if ‘Other’ is selected from the relationship picklist

Custom Validation Rules:

If a user attempts to save a record with ‘Other’ selected as the relationship and does not provide a relationship description an error will appear instructing the user to provide a description or select a different type of relationship.

### Pet Process Builder 
When a new pet is created, the Pets process kicks off. If a pet is associated with an owner but not a family, and the owner is associated with a family, the process will associate the pet with the owner’s family. This is safeguard to ensure that all applicable relationships, between a pet and its family, are in place.

### Pet Trigger 
Due to the complex nature of the relationships between pets and their family members, I chose to use an Apex trigger to associate new Pet’s with their family members. This would not have been possible with a Process Builder or Workflow.

When a new Pet is inserted into the database the After Insert trigger begins the process of associating the pet with its family member. If the Pet is associated with an owner, and its owner is associated with a family, the process retrieves all People__c records associated with that family. The process then parses through the list of People__c records and creates a Relationship__c record with the pet. If the People__c record is the Owner’s record, the relationship type is set to ‘Owner’, otherwise the relationship type is set to ‘Family Member’.

### ABC Pets App
I created a custom application, ABC Pets, for this implementation. The app only contains tabs for the necessary objects needed by the client; Family, Pets and People.  This has been set as the Org default and each page as the application default.

### Related Pets List LWC 
Related lists do not allow inline editing within Salesforce. In order to provide the ability to update a pet’s birthdate from a related list, I had to create a custom Related Pets list LWC. The component displays a datatable of all pets associated with a Family__c record Id. I chose to display the following pet information in the datatable:
- Pet’s Name hyperlinked to the pet’s record.
- Owner’s Name hyperlinked to the owner’s record.
- Pet Type
- Pet Breed
- Pet Age
- Pet’s Birthdate 

The Birthdate column has editing enabled, allowing the user to easily update the pet’s birthdate without leaving the Family view. When a pet’s birthdate is updated successfully a success toast message will display. If an error is encountered when updating the pet’s birthdate that error will be displayed in an error toast message.

The pet data is retrieved via an Apex method which accepts a record Id as its parameter. I created this LWC so that it could be used on both Family views as well as People views. It does this by getting the object type from the record Id and then obtains the associated Family__c Id. It then queries for all pets associated with that Family__c record Id, utilizes a custom data wrapper to put the data in the needed format, and passes the list of data back to the LWC for display.

I also used this as an opportunity to alert the user if any of the related pets have a birthday. An info toast message is displayed to the user if the data that is returned contains one or more pets with birthdays.

### Security 

__Organization Wide Defaults__

Due to the nature of the business the client is in I felt like it wasn’t necessary to restrict record sharing. As such, I set all of the custom objects I created, except Relationship__c, to Public Read/Write internally and Private externally. Relationship__c is set to Controlled by Parent by default.

__App Security__

The only profile that was granted access to the ABC Pets application is the System Administrator. Additional access can be granted via permission sets.

__Tab Settings__

Default Off has been set for all profiles, except the System Administrator profile. Tab visibility can be granted via permission sets.

__Field Level Security__

All fields have been set to Read Only for every profile except the System Administrator profile. Additional access can be granted via permission sets.

__Apex Access__

The System Administrator profile is the only profile with access to Apex classes. Additional access can be granted via permission sets.

### Permission Sets
I have created 3 permission sets, each with different levels of access to the ABC Pets application and its records.
- ABC Pets Access - Read Only
    - Access to ABC Pets application
    - Tab visibility for Pets, People and Family.
    - Read Only access to custom objects and fields
    - Apex access for only the classes necessary to view the Related Pets LWC.
- ABC Pets Access - Read/Write
    - Access to ABC Pets application
    - Tab visibility for Pets, People and Family.
    - Read, Create and Edit access to custom objects and fields
    - Apex Class access for the classes necessary to view the Related Pets LWC and the Pets trigger.
- ABC Pets Access - Full Access
    - Access to ABC Pets application
    - Tab visibility for Pets, People and Family.
    - Modify All access to custom objects and fields
    - Apex Class access for all Apex classes.

