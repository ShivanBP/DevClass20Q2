public with sharing class coolPlacesNearbyController {
    @AuraEnabled(cacheable=true)
    public static Object findCoolPlaces(String currentId){
        Account acc = [SELECT BillingState, BillingCity, BillingStreet, BillingPostalCode FROM Account WHERE Id =: currentId];
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String searchLocation = '';
        searchLocation += acc.BillingState.replace(' ', '+');
        searchLocation += '+' + acc.BillingCity.replace(' ', '+');
        searchLocation += '+' + acc.BillingPostalCode;
        searchLocation += '+' + acc.BillingStreet.replace(' ', '+');
        System.debug(searchLocation);
        request.setEndpoint('https://api.yelp.com/v3/businesses/search?location=' + searchLocation + '&categories=coffee,restaurant&radius=5000');
        System.debug('https://api.yelp.com/v3/businesses/search?location=' + searchLocation + '&categories=coffee,restaurant&radius=5000');
        request.setMethod('GET');
        request.setHeader('Authorization','Bearer pHOy8pbRjVwoxdOhBqKWm41pWoC9pWd9CNqLYYdRUMBPi50xzCXCqJwyCkznR4qxLCMMHmbjkzyXp8xAshY2T6mnzqXTv48XwAZ1K0KtT1GvKDRzaBDxtBF9UIvRXnYx');
        HttpResponse response = http.send(request);
        
        Map<String, Object> results = new Map<String, Object>();
        if(response.getStatusCode() == 200) {
            results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        }

        return (List<Object>) results.get('businesses');
    }
}
