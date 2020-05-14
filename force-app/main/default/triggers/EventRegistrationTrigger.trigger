trigger EventRegistrationTrigger on Event_Registration__c (before delete, after insert) {
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            EventRegistrationEmailNotification.registrationDeleted(Trigger.old);
        }
    }
    if (Trigger.isAfter) {
    	if (Trigger.isInsert) {
            EventRegistrationEmailNotification.guestRegistered(Trigger.new);
        }
    }
}