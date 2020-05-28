@isTest
public class RegistrationPageControllerTest {
    @isTest 
    static void theTest() {
        //Insert event
        Event__c event1 = new Event__c(Name='Mega Rave', Price__c=20);
        insert event1;

        //Create contentdocument
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = event1.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        PageReference pageRef = Page.UnifiedRegistrationPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', event1.Id);

        RegistrationPageController controller = new RegistrationPageController();
        controller.getpickListVals();

        //Register + Validation
        controller.save();
        System.assertEquals(true, (controller.lastErrorMessage != null));
        controller.eventReg.FirstName__c = 'Mr';
        controller.eventReg.LastName__c = 'Brown';
        controller.save();
        System.assertEquals(true, (controller.emailErrorMessage != null));
        controller.eventReg.Email__c = 'mr@brown.com'; 
        controller.save();
        Integer regs = [SELECT Count() FROM Event_Registration__c WHERE Event__c =: event1.Id];
        System.assertEquals(1, regs);
        
        //Switch event
        Event__c event2 = new Event__c(Name='Giga Rave', Price__c=10);
        insert event2;
    
        controller.selectedEvent = event2.id;

        controller.otherEvent();

        System.assertEquals(event2.Id, controller.event.Id);
    }
}
