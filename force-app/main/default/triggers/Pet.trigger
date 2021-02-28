trigger Pet on Pet__c (before insert, before update, before delete, after insert, after update, after delete) 
{
    if (Trigger.isBefore)
    {
        if (Trigger.isInsert) {}
        if (Trigger.isUpdate) {}
        if (Trigger.isDelete) {}
    }
    else if (Trigger.isAfter)
    {
        if (Trigger.isInsert)
        {
            Pet_Trigger_Utility.AfterInsert(Trigger.new);
        }

        if (Trigger.isUpdate) {}
        if (Trigger.isDelete) {}
    }
}