public with sharing class productsToOpportunityController {
    @AuraEnabled(cacheable=true)
    public static List<Product2> fetchProductsFromServer(String pricebookId, List<String> selectedFamilies, String searchText) {
        String query = 'SELECT Id, UnitPrice, Product2.Name, Product2.Family, Product2.ProductCode, Product2.Description, Product2.LastModifiedDate, Product2Id FROM PricebookEntry WHERE IsActive = True AND Pricebook2Id = \'' + pricebookId + '\'';
        if(selectedFamilies.size() > 0){
            query += ' AND (Product2.Family = \'' + String.join(selectedFamilies, '\' OR Product2.Family = \'') +'\')';
        }
        if(searchText != null){
            query += ' AND (Product2.Name LIKE \'%' + searchText + '%\' OR Product2.ProductCode LIKE \'%' + searchText + '%\' OR Product2.Description LIKE \'%' + searchText + '%\')';
        }
        System.debug(query);
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static List<Pricebook2> fetchPricebooksFromServer() {
        return Database.query('SELECT Name, IsStandard FROM Pricebook2 WHERE IsActive = True');
    }

    @AuraEnabled(cacheable=true)
    public static List<String> fetchProductFamiliesFromServer(){
        List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = Product2.Family.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
        }     
        pickListValuesList.remove(0);

		return pickListValuesList;
    }
}