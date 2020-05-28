public class RegistrationPageController {
    public String THIS_ORG_URL {get; set;}
    public String eventId {get; set;}
    public Event__c event {get; set;}
    public Event_Registration__c eventReg {get; set;}
    public String pictureId {get; set;}
    public String selectedEvent {get; set;}
    public String lastErrorMessage {get; set;}
    public String emailErrorMessage {get; set;}
    public List<SelectOption> getpickListVals (){
        List<SelectOption> options = new List<Selectoption>();
        List<Event__c> events = [SELECT Name, Id FROM Event__c];
        for(Event__c e : events){
            options.add(new selectOption(e.Id, e.Name));
        }            
        return options;
    }
    
    public RegistrationPageController() {
        eventId = apexpages.currentpage().getparameters().get('id');
        this.callEvent();
        eventReg = new Event_Registration__c();
    }

    public void otherEvent() {
        eventId = selectedEvent;
        this.callEvent();
    }

    public void callEvent() {
        event = [SELECT Name, Id, Price__c,
                    (SELECT Id, ContentDocumentId
                    FROM ContentDocumentLinks LIMIT 1)
                FROM Event__c
                WHERE ID = :eventId];
        if(event.ContentDocumentLinks.size() == 0){
            pictureId = '0685w00000AzCETAA3';
        }else{
            pictureId = [SELECT Id 
                        FROM ContentVersion 
                        WHERE ContentDocumentId =: event.ContentDocumentLinks[0].ContentDocumentId LIMIT 1].Id;
        }
    }

    public void save() {
        if (eventReg.LastName__c == null){
            lastErrorMessage = '¡Ay, caramba!';
        }else if (eventReg.Email__C == null){
            emailErrorMessage = 'Oh mondieu!';
        }else{
            eventReg.Event__c = event.id;
            insert eventReg;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
        }
    }
}