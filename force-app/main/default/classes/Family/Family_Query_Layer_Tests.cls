@isTest
public class Family_Query_Layer_Tests 
{
    @TestSetup
    static void makeData()
    {
        Test.startTest();
        
        Family__c f = new Family__c();
        f.Name = 'Test Family';
        insert f;

        People__c p= new People__c();
        p.Family__c = f.Id;
        p.Name = 'Test Person';
        p.Email__c = 'test.person@demo.biz';
        p.Primary_Phone__c = '1234567890';
        p.Mailing_Address__c = '123 Test Dr';
        p.Mailing_City__c = 'Somewhere';
        p.Mailing_State__c = 'NJ';
        p.Mailing_Zip_Code__c = '12345';
        insert p;

        Test.stopTest();
    }

    @isTest static void test_getFamilyMembers_Positive()
    {
        List<People__c> people = [SELECT Id, Family__c FROM People__c WHERE Email__c = 'test.person@demo.biz'];
        Family__c f = [SELECT Id From Family__c WHERE ID = :people[0].Family__c];

        Test.startTest();
        Map<Id, List<People__c>> results = Family_Query_Layer.getFamilyMembers(new List<Id>{f.Id});
        Test.stopTest();

        System.assert(!results.isEmpty());
        System.assert(results.containsKey(f.Id));
        System.assertEquals(people, results.get(f.Id));
    }

    @isTest static void test_getFamilyMembers_Negative()
    {
        List<Id> familyIds = new List<Id>();

        Test.startTest();
        Map<Id, List<People__c>> results = Family_Query_Layer.getFamilyMembers(familyIds);
        Test.stopTest();

        System.assert(results.isEmpty());
    }
}