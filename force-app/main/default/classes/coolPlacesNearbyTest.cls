@isTest
public class coolPlacesNearbyTest {
    @testSetup static void insertAccount() {
        Account acc = new Account (Name = 'TestAccount',
                                   BillingPostalCode = '108',
                                   BillingStreet = 'Sesame');
        insert acc;
    }

    @isTest
    public static void callFutureMethod() {
        callout();
    }

    //@future(callout = true)
    public static void callout(){
        Account acc = [SELECT Id, BillingPostalCode, BillingStreet FROM Account LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new coolPlacesNearbyMock());
        Object response = coolPlacesNearbyController.findCoolPlaces(acc.id);
        String expectedValue = '(majestic badger, fluffy bunny, scary bear, chicken, mighty moose)';
        System.assertEquals(response.toString(), expectedValue);
    }
}