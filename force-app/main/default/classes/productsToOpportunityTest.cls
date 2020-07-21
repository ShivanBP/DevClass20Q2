@isTest
public with sharing class productsToOpportunityTest {
    STATIC FINAL String standardPricebookId = Test.getStandardPricebookId();
    static final List<String> families = productsToOpportunityController.fetchProductFamiliesFromServer();
    static final Integer numOfPricebooks = 4;
    
    @testSetup static void createTestData() {
        //Create Pricebooks
        List<Pricebook2> pricebookList = new List<Pricebook2>();
        for(Integer i = 0; i < numOfPricebooks; i++){
            pricebookList.add(new Pricebook2(Name = 'testpricebook' + i, isActive = true));
        }
        insert pricebookList;
        //Create Products
        List<Product2> productList = new List<Product2>();
        for(Integer i = 0; i < 200; i++){
            Product2 p = new Product2();
            p.Name = 'testproduct'+ i;
            p.isActive = true;
            p.Family = families.get(Math.mod(i, families.size()));
            p.ProductCode = '5A4' + i;
            productList.add(p);
        }
        insert productList;
        //Create Pricebookentries
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        List<PricebookEntry> notStandardPbeList = new List<PricebookEntry>();
        for(Integer i = 0; i < productList.size(); i++){
            //Standard Price Book Entries
            PricebookEntry pbe = new PricebookEntry();
            pbe.Product2Id = productList[i].Id;
            pbe.Pricebook2Id = standardPricebookId;
            pbe.isActive = true;
            pbe.UnitPrice = i * 100;
            pbeList.add(pbe);
            //Non Standard Price Book Entries
            PricebookEntry nsPbe = new PricebookEntry();
            nsPbe.Product2Id = productList[i].Id;
            nsPbe.Pricebook2Id = pricebookList[Math.mod(i,numOfPricebooks)].Id;
            nsPbe.isActive = true;
            nsPbe.UnitPrice = i * 200;
            notStandardPbeList.add(nsPbe);
        }
        try{
            Database.insert(pbeList);
        }catch(DmlException e){
            System.debug(e);
        }
        try{
            Database.insert(notStandardPbeList);
        }catch(DmlException e){
            System.debug(e);
        }
    }

    @isTest
    public static void checkInsertedPricebooks(){
        List<String> filterFamily = new List<String>();
        filterFamily.add(families[0]);
        Test.startTest();
        List<Pricebook2> pricebookList = productsToOpportunityController.fetchPricebooksFromServer();
        Integer fetchedProducts0 = (productsToOpportunityController.fetchProductsFromServer(standardPricebookId, families, null)).size();
        Integer fetchedProducts1 = (productsToOpportunityController.fetchProductsFromServer(pricebookList[0].Id, families, null)).size();
        Integer fetchedProducts2 = (productsToOpportunityController.fetchProductsFromServer(pricebookList[0].Id, filterFamily, null)).size();
        Integer fetchedProducts3 = (productsToOpportunityController.fetchProductsFromServer(pricebookList[0].Id, families, '0')).size();
        Integer fetchedProducts4 = (productsToOpportunityController.fetchProductsFromServer(pricebookList[0].Id, filterFamily, '0')).size();
        Test.stopTest();
        System.AssertEquals(numOfPricebooks, pricebookList.size());
        System.AssertEquals(200, fetchedProducts0);
        System.AssertEquals(50, fetchedProducts1);
        System.AssertEquals(50, fetchedProducts2);
        System.AssertEquals(12, fetchedProducts3);
        System.AssertEquals(12, fetchedProducts4);
    }
}
