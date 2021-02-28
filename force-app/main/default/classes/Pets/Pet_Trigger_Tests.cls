@isTest
public class Pet_Trigger_Tests 
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

        Pet__c pet = new Pet__c();
        pet.Name = 'Test';
        pet.Birthdate__c = Date.today().addYears(-6);
        pet.Type__c = 'Dog';
        pet.Pet_Owner__c = p.Id;
        pet.Family__c = f.Id;
        insert pet;

        Test.stopTest();
    }

    @isTest static void test_relatePetsToFamilyMembers_Positive()
    {
        People__c person = [SELECT Id, Family__c FROM People__c WHERE Email__c = 'test.person@demo.biz'];

        Test.startTest();

        People__c p= new People__c();
        p.Family__c = person.Family__c;
        p.Name = 'Pet Owner';
        p.Email__c = 'pet.owner@demo.biz';
        p.Primary_Phone__c = '1234567890';
        p.Mailing_Address__c = '123 Test Dr';
        p.Mailing_City__c = 'Somewhere';
        p.Mailing_State__c = 'NJ';
        p.Mailing_Zip_Code__c = '12345';
        insert p;
        
        Pet__c pet = new Pet__c();
        pet.Name = 'Rex';
        pet.Birthdate__c = Date.today().addYears(-6);
        pet.Type__c = 'Hamster';
        pet.Pet_Owner__c = p.Id;
        insert pet;

        Test.stopTest();

        List<Id> petIds = new List<Id>{pet.Id};
        List<Id> peopleIds = new List<Id>{person.Id, p.Id};
        List<Relationship__c> results = [SELECT Id, Pet__c, People__c, Relation__c FROM Relationship__c WHERE Pet__c IN : petIds AND People__c IN :peopleIds];
        System.assert(!results.isEmpty());
        for (Relationship__c r : results)
        {
            System.assertEquals(pet.Id, r.Pet__c);
            if (r.People__c == person.Id) System.assertEquals('Family Member', r.Relation__c);
            if (r.People__c == p.Id) System.assertEquals('Owner', r.Relation__c);
        }
    }

    @isTest static void test_relatePetsToFamilyMembers_Negative()
    {
        Test.startTest();

        Pet__c pet = new Pet__c();
        pet.Name = 'Rex';
        pet.Birthdate__c = Date.today().addYears(-6);
        pet.Type__c = 'Hamster';
        insert pet;

        Test.stopTest();

        List<Id> petIds = new List<Id>{pet.Id};
        List<Relationship__c> results = [SELECT Id, Pet__c, People__c, Relation__c FROM Relationship__c WHERE Pet__c IN : petIds];
        System.assert(results.isEmpty());
    }

    @isTest static void test_relatePetsToFamilyMembers_Exception()
    {
        Test.startTest();

        Family__c f = new Family__c();
        f.Name = 'Exception Family';
        insert f;

        People__c p= new People__c();
        p.Family__c = f.Id;
        p.Name = 'Pet Owner';
        p.Email__c = 'pet.owner@demo.biz';
        p.Primary_Phone__c = '1234567890';
        p.Mailing_Address__c = '123 Test Dr';
        p.Mailing_City__c = 'Somewhere';
        p.Mailing_State__c = 'NJ';
        p.Mailing_Zip_Code__c = '12345';
        insert p;
        
        Pet__c pet = new Pet__c();
        pet.Name = 'Exception Handling Test';
        pet.Birthdate__c = Date.today().addYears(-6);
        pet.Type__c = 'Hamster';
        pet.Pet_Owner__c = p.Id;
        insert pet;

        Test.stopTest();

        List<Id> petIds = new List<Id>{pet.Id};
        List<Id> peopleIds = new List<Id>{p.Id};
        List<Relationship__c> results = [SELECT Id, Pet__c, People__c, Relation__c FROM Relationship__c WHERE Pet__c IN : petIds AND People__c IN :peopleIds];
        System.assert(results.isEmpty());
    }
}