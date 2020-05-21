public with sharing class EventListPageController {
    public String THIS_ORG_URL {get; set;}
    public List<Event__c> Events {get; set;}

    public EventListPageController() {
        THIS_ORG_URL = Label.THIS_ORG_URL;
        Events = [SELECT Id, Name, Starting_Date__c, Number_of_registrations__c, City__c, Price__c FROM Event__c ORDER BY Starting_Date__c];
    }
}
