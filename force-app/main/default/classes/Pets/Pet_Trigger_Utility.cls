public class Pet_Trigger_Utility 
{
    public static void AfterInsert(List<Pet__c> newPets)
    {
        Map<Id, Pet__c> mapPetsToRelate = new Map<Id, Pet__c>();

        for (Pet__c p : newPets)
        {
            if (String.isNotBlank(p.Pet_Owner__c))
            {
                mapPetsToRelate.put(p.Pet_Owner__c, p);
            }
        }

        if (!mapPetsToRelate.isEmpty()) Pet_Trigger_Helper.relatePetsToFamilyMembers(mapPetsToRelate);      
    }
}