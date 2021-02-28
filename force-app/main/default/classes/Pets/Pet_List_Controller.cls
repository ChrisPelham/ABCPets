public  class Pet_List_Controller 
{
    @AuraEnabled (cacheable=true)
    public static List<Pet_Data_Wrapper> getPets(Id recordId)
    {

        String familyId;
        List<Pet_Data_Wrapper> pets = new List<Pet_Data_Wrapper>();
        String objectType = recordId.getSObjectType().getDescribe().getName();

        switch on objectType
        {
            when 'People__c'
            {
                Map<Id, Id> mapFamilyIds = People_Query_Layer.getFamilyIdsForPets(new List<Id>{recordId});
                if (!mapFamilyIds.isEmpty() && mapFamilyIds.containsKey(recordId))
                {
                    familyId = mapFamilyIds.get(recordId);
                }
            }
            when 'Family__c'
            {
                familyId = recordId;
            }
        }

        if (String.isNotBlank(familyId))
        {
            for (Pet__c p : Pet_Query_Layer.getPetsByFamilyId(familyId))
            {
                Pet_Data_Wrapper pet = new Pet_Data_Wrapper();
                pet.petId = p.Id;
                pet.petURL = '/' + p.Id;
                pet.name = p.Name;
                pet.ownerURL = '/' + p.Pet_Owner__c;
                pet.owner = p.Pet_Owner__r.Name;
                pet.type = p.Type__c;
                pet.breed = p.Breed__c;
                pet.age = String.valueOf(p.Age__c);
                pet.birthdate = p.Birthdate__c;
                pet.birthday = p.Birthday__c;
                pets.add(pet);
            }
        }

        return pets;
    }    
}