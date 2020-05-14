trigger CaseTrigger on Case (after insert, after update, after delete, after undelete,
                             before insert, before update, before delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            //Code
        } 
        if (Trigger.isUpdate) {
            //Code
        }
        if (Trigger.isDelete) {
            CaseTriggerHelper.sumCasesOnAccount(Trigger.old, true);   
        }
        if(Trigger.isUndelete){
            //Code
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CaseTriggerHelper.sumCasesOnAccount(Trigger.new, false);
        } 
        if (Trigger.isUpdate) {
            //Add cases for removal
            List <Case> deletedCaseList = new List<Case>();
            for(Id caseId : Trigger.newMap.keySet()){
                if(Trigger.oldMap.get(caseId).AccountId != Trigger.newMap.get(caseId).AccountId){
                	deletedCaseList.add(Trigger.oldMap.get(caseId));
                }
  			}
            CaseTriggerHelper.sumCasesOnAccount(deletedCaseList, true);
            CaseTriggerHelper.sumCasesOnAccount(Trigger.new, false);
        }
        if (Trigger.isDelete) {
            //Code
        }
        if(Trigger.isUndelete){
            System.debug(trigger.new.size());
            CaseTriggerHelper.sumCasesOnAccount(Trigger.new, false);
        }
    }
}