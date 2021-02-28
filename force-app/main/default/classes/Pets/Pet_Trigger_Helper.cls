public class Pet_Trigger_Helper 
{
    public static void relatePetsToFamilyMembers(Map<Id, Pet__c> newPets)
    {
        List<Relationship__c> relationshipsToInsert = new List<Relationship__c>();
        Map<Id, Id> mapOwnersFamilyIds = People_Query_Layer.getFamilyIdsForPets(new List<Id>(newPets.keySet()));
        Map<Id, List<People__c>> mapFamilyMembers = Family_Query_Layer.getFamilyMembers(mapOwnersFamilyIds.values());

        for (Pet__c pet : newPets.values())
        {
            Id ownerId = pet.Pet_Owner__c;
            if (mapOwnersFamilyIds.containsKey(ownerId))
            {
                Id familyId = mapOwnersFamilyIds.get(ownerId);

                for (People__c familyMember : mapFamilyMembers.get(familyId))
                {
                    Relationship__c r = new Relationship__c();
                    r.Pet__c = pet.Id;
                    r.People__c = familyMember.Id;
                    r.Relation__c = pet.Pet_Owner__c == familyMember.Id ? 'Owner' : 'Family Member';
                    relationshipsToInsert.add(r);
                }
            }
        }

        if (!relationshipsToInsert.isEmpty())
        {
            if (Test.isRunningTest() && newPets.values()[0].Name == 'Exception Handling Test') relationshipsToInsert[0].Pet__c = null;

            Database.SaveResult[] srList = Database.insert(relationshipsToInsert, false);

            for(Database.SaveResult sr : srList)
            {
                if (!sr.isSuccess())
                {
                    for (Database.Error err : sr.getErrors()) 
                    {
                        System.debug('Failed to insert relationship' + err.getMessage() + ' Fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
}