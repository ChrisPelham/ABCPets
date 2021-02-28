@isTest
public class Pet_List_Controller_Tests 
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

    @isTest static void test_getPets_Positive()
    {
        People__c p = [SELECT Id, Family__c FROM People__c WHERE Email__c = 'test.person@demo.biz'];
        Pet__c pet = [SELECT Id FROM Pet__c WHERE Pet_Owner__c = :p.Id];

        Test.startTest();
        List<Pet_Data_Wrapper> results = Pet_List_Controller.getPets(p.Family__c);
        Test.stopTest();

        System.assert(!results.isEmpty());
        System.assertEquals(pet.Id, results[0].petId);
    }

    @isTest static void test_getPets_Negative()
    {
        Family__c f = new Family__c();
        f.Name = 'No Pet Family';
        insert f;

        Test.startTest();
        List<Pet_Data_Wrapper> results = Pet_List_Controller.getPets(f.Id);
        Test.stopTest();

        System.assert(results.isEmpty());
    }
}