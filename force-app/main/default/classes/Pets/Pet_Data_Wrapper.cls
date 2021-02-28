public class Pet_Data_Wrapper 
{
    @AuraEnabled 
    public Id petId {get;set;}
    @AuraEnabled 
    public String petURL {get;set;}
    @AuraEnabled 
    public String name {get;set;}
    @AuraEnabled 
    public String ownerURL {get;set;}
    @AuraEnabled 
    public String owner {get;set;}
    @AuraEnabled 
    public String type {get;set;}
    @AuraEnabled 
    public String breed {get;set;}
    @AuraEnabled 
    public String age {get;set;}
    @AuraEnabled 
    public Date birthdate {get;set;}
    @AuraEnabled 
    public String birthday {get;set;}

    public Pet_Data_Wrapper() 
    {
        petId = null;
        petURL = null;
        name = '';
        ownerURL = null;
        owner = '';
        type = '';
        breed = '';
        age = '';
        birthdate = null;
        birthday = null;
    }
}