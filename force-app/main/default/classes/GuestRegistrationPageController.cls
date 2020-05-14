public class GuestRegistrationPageController {
    private String sortOrder{get; set;}
    public List<Event__c> eventList;
    GuestRegistrationPageController(ApexPages.StandardController stdController){
        this.eventList = Database.query('SELECT Id, Name, Starting_Date__c, Number_of_registrations__c, City__c FROM Event__c ORDER BY' + sortOrder);
    }
}