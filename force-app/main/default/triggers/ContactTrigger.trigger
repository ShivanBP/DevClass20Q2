trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete,
                             before insert, before update, before delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            //Code
        } 
        if (Trigger.isUpdate) {
            //Code
        }
        if (Trigger.isDelete) {
            ContactTriggerHelper.sumContactsOnAccount(Trigger.old, true);   
        }
        if(Trigger.isUndelete){
            //Code
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ContactTriggerHelper.sumContactsOnAccount(Trigger.new, false);
        } 
        if (Trigger.isUpdate) {
            //Add cases for removal
            List <Contact> deletedContactList = new List<Contact>();
            for(Id conId : Trigger.newMap.keySet()){
                if(Trigger.oldMap.get(conId).AccountId != Trigger.newMap.get(conId).AccountId){
                	deletedContactList.add(Trigger.oldMap.get(conId));
                }
  			}
            ContactTriggerHelper.sumContactsOnAccount(deletedContactList, true);
            ContactTriggerHelper.sumContactsOnAccount(Trigger.new, false);
        }
        if (Trigger.isDelete) {
            //Code
        }
        if(Trigger.isUndelete){
            System.debug(trigger.new.size());
            ContactTriggerHelper.sumContactsOnAccount(Trigger.new, false);
        }
    }
}