@isTest
global class coolPlacesNearbyMock implements HttpCalloutMock {
    global HttpResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.SetHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody('{"businesses": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}');
        return response;
    }
}
