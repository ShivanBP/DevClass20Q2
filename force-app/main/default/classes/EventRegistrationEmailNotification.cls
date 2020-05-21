public class EventRegistrationEmailNotification {
    public static void guestRegistered(Event_Registration__c[] newTrigger){
        for(Event_Registration__c er : newTrigger){
            Messaging.reserveSingleEmailCapacity(2);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {er.Email__c});
            mail.setReplyTo('lantitis@gmail.com');
            mail.setSenderDisplayName('Top Events Crew');
            mail.setSubject('Registration succesful');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody('You have succesfully registered to the event: ' + er.Event__c);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    public static void registrationDeleted(Event_Registration__c[] oldTrigger){
    	for(Event_Registration__c er : oldTrigger){
        	Messaging.reserveSingleEmailCapacity(2);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {RegistrationDeletionEmailAdress__c.getall().values().Email__c});
            mail.setReplyTo('lantitis@gmail.com');
            mail.setSenderDisplayName('Top Events Crew');
            mail.setSubject('Registration has been deleted');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody(Userinfo.getName() + ' has deleted the Event Registration with the Id: ' + er.Id +
                                 'Information about the guest:\n' + 
                                 'Name: '+ er.FirstName__c +' '+ er.LastName__c + '\n' +
                                 'Email: ' + er.Email__c);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}