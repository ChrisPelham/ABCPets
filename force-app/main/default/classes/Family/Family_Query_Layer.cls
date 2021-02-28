public class Family_Query_Layer 
{
    public static Map<Id, List<People__c>> getFamilyMembers(List<Id> familyIds)
    {
        Map<Id, List<People__c>> mapFamilyMembers = new Map<Id, List<People__c>>();
        for (Family__c f : [Select Id, (SELECT Id From People__r) From Family__c WHERE ID IN :familyIds])
        {
            mapFamilyMembers.put(f.Id, f.People__r);
        }
        return mapFamilyMembers;
    }
}