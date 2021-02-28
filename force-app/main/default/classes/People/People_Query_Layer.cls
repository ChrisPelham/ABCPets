public class People_Query_Layer 
{
    public static Map<Id, Id> getFamilyIdsForPets(List<Id> ownerIds)
    {
        Map<Id, Id> familyIds = new Map<Id, Id>();
        for (People__c p : [SELECT Id, Family__c  FROM People__c WHERE Id IN :ownerIds])
        {
            if (String.isNotBlank(p.Family__c))
            {
                familyIds.put(p.Id,p.Family__c);
            }
        }
        
        return familyIds;
    }
}