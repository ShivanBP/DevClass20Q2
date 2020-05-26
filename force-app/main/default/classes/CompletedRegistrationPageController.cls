public with sharing class CompletedRegistrationPageController {
    public String THIS_ORG_URL {get; set;}
    
    public CompletedRegistrationPageController() {
        THIS_ORG_URL = Label.THIS_ORG_URL;
    }
    public Pagereference returnToEventList(){
        Pagereference EventListPage = new PageReference('/apex/EventListPage');
        EventListPage.setRedirect(true);
        return EventListPage;
    }
}
