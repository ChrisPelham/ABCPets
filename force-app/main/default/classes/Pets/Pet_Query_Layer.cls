public class Pet_Query_Layer 
{
    public static List<Pet__c> getPetsByIds(List<Id> petIds)
    {
        List<Pet__c> pets = new List<Pet__c>();
        pets = [SELECT Id, Pet_Owner__r.Family__c FROM Pet__c WHERE Id IN :petIds];
        return pets;
    }

    public static List<Pet__c> getPetsByFamilyId(Id familyId)
    {
        List<Pet__c> pets = new List<Pet__c>();
        pets = [SELECT Id, Name, Pet_Owner__c, Pet_Owner__r.Name, Type__c, Breed__c, Age__c, Birthday__c, Birthdate__c FROM Pet__c WHERE Family__c = :familyId];
        return pets;
    }
}