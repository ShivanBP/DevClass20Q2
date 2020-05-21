public with sharing class RegistrationPageController {
    public String THIS_ORG_URL {get; set;}
    public String eventId {get; set;}
    public Event__c event {get; set;}
    public Event_Registration__c eventReg {get; set;}
    public String pictureId {get; set;}
    public String selectedEvent {get; set;}
    public List<SelectOption> getpickListVals (){
        List<SelectOption> options = new List<Selectoption>();
        options.add(new selectOption('first', 'value'));
        List<Event__c> events = [SELECT Name, Id FROM Event__c];
        for(Event__c e : events){
            if(e.Id == apexpages.currentpage().getparameters().get('id')){
                options[0] = new selectOption(e.Id, e.Name);
            }else{
                options.add(new selectOption(e.Id, e.Name));
            }
        }            
        return options;
    }
    
    public RegistrationPageController() {
        eventId = apexpages.currentpage().getparameters().get('id');
        THIS_ORG_URL = Label.THIS_ORG_URL;
        event = [SELECT Name, Id, Price__c,
                    (SELECT Id, ContentDocumentId
                    FROM ContentDocumentLinks LIMIT 1)
                FROM Event__c
                WHERE ID = :eventId];
        selectedEvent = event.Name;     
        if(event.ContentDocumentLinks.size() == 0){
            pictureId = '0685w00000AzCETAA3';
        }else{
            pictureId = [SELECT Id FROM ContentVersion WHERE ContentDocumentId =: event.ContentDocumentLinks[0].ContentDocumentId LIMIT 1].Id;
        }
        eventReg = new Event_Registration__c();
    }

    public Pagereference otherEvent() {
        eventReg = new Event_Registration__c(LastName__c = 'something', Email__c = 'a@a.a');
        Pagereference otherEvent = new PageReference('/apex/RegistrationPage?Id=' + selectedEvent);
        otherEvent.setRedirect(true);
        return otherEvent;
    }

    public Pagereference save() {
        eventReg.Event__c = event.id;
        insert eventReg;
        return new PageReference('/apex/CompletedRegistrationPage');
    }

    public Pagereference back() {
        Pagereference EventListPage = new PageReference('/apex/EventListPage');
        EventListPage.setRedirect(true);
        return EventListPage;
    }
}
