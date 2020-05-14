trigger OpportunityTrigger on Opportunity (before insert, before update, after undelete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
			OpportunityTriggerHelper.checkStageRules(trigger.new);
        } 
        if (Trigger.isUpdate) {
			OpportunityTriggerHelper.checkStageRules(trigger.new);
        }
    }
    if (Trigger.isUndelete) {
        if (Trigger.isUndelete) {
			OpportunityTriggerHelper.checkStageRules(trigger.new);
        }
    }
}