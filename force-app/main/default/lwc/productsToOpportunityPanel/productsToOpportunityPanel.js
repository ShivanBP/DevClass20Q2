import { LightningElement, track} from 'lwc';
import fetchProductsFromServer from '@salesforce/apex/productsToOpportunityController.fetchProductsFromServer';
import fetchPricebooksFromServer from '@salesforce/apex/productsToOpportunityController.fetchPricebooksFromServer';
import fetchProductFamiliesFromServer from '@salesforce/apex/productsToOpportunityController.fetchProductFamiliesFromServer';

export default class ProductsToOpportunityPanel extends LightningElement {
    @track columns = [
        { label: 'Name', fieldName: 'Name', type: 'text', sortable: true},
        { label: 'Family', fieldName: 'Family', type: 'text', sortable: true},
        { label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency', sortable: true},
        { label: 'Product Code', fieldName: 'ProductCode', type: 'number', sortable: true},
        { label: 'Description', fieldName: 'Description', type: 'text', sortable: true},
        { label: 'LastModifiedDate', fieldName: 'LastModifiedDate', type: 'date', sortable: true} 
    ];    
    pricebookList;
    selectedPricebook;
    selectableFamilies;
    selectedFamilies;
    searchText;
    selectedProducts;
    error;
    data=[];
    @track page = 1;
    perpage = 20;
    @track pages = [];
    set_size = 10;

    connectedCallback(){
        //Also calling fetchProducts in it's callback function
        this.fetchPricebooks();
        this.fetchProductFamilies();
    }

    renderedCallback(){
        this.renderButtons();   
    }

    renderButtons = ()=>{
        this.template.querySelectorAll('button').forEach((but)=>{
            but.style.backgroundColor = this.page===parseInt(but.dataset.id,10)?'yellow':'white';
         });
    }

    fetchPricebooks(){
        fetchPricebooksFromServer()
        .then(result => {
            this.pricebookList = [];
            for(let i = 0; i < result.length; i++){
                var pricebook = [];
                pricebook.label = result[i].Name;
                pricebook.value = result[i].Id;
                this.pricebookList.push(pricebook);
                if(result[i].IsStandard == true){
                    this.selectedPricebook = result[i].Id;
                }
            }
            this.fetchProducts();

        })
        .catch(error => {
            this.error = error;
            console.log(error);
        })
    }

    fetchProducts(){
        console.log(this.selectedPricebook);
        console.log(this.searchText);
        console.log(this.selectedFamilies);
        fetchProductsFromServer({pricebookId: this.selectedPricebook, selectedFamilies: this.selectedFamilies, searchText: this.searchText})
        .then(result => {
            this.data = [];
            console.log(result);
            for(let i = 0; i < result.length; i++){
                var product = [];
                product.Name = result[i].Product2.Name;
                product.UnitPrice = result[i].UnitPrice;
                product.Family = result[i].Product2.Family
                product.Id = result[i].Product2Id;
                product.ProductCode = result[i].Product2.ProductCode;
                product.Description = result[i].Product2.Description;
                console.log(result[i].LastModifiedDate);
                product.LastModifiedDate = result[i].Product2.LastModifiedDate;
                this.data.push(product);
            }
            this.setPages(this.data);
        })
        .catch(error => {
            this.error = error;
            console.log(error);
        })
    }

    fetchProductFamilies(){
        fetchProductFamiliesFromServer()
        .then(result => {
            this.selectableFamilies = [];
            this.selectedFamilies = [];
            for(let i = 0; i < result.length; i++){
                var family = [];
                family.label = result[i];
                family.value = result[i];
                this.selectableFamilies.push(family);
                this.selectedFamilies.push(result[i]);
            }
        })
        .catch(error => {
            this.error = error;
            console.log(error);
        })
    }

    pickPricebook(event) {
        this.selectedPricebook = event.detail.value;
    }

    pickFamily(event) {
        this.selectedFamilies = event.detail.value;
    }

    typeText(event) {
        this.searchText = event.target.value;
    }

    getSelectedProducts(event) {
        this.selectedProducts = event.detail.selectedRows;
    }
    
    doSearch(){
        this.fetchProducts();
        this.renderButtons();
    }

    get pagesList(){
        let mid = Math.floor(this.set_size/2) + 1 ;
        if(this.page > mid){
            return this.pages.slice(this.page-mid, this.page+mid-1);
        } 
        return this.pages.slice(0,this.set_size);
    }
    
    pageData = ()=>{
        let page = this.page;
        let perpage = this.perpage;
        let startIndex = (page*perpage) - perpage;
        let endIndex = (page*perpage);
        return this.data.slice(startIndex,endIndex);
    }

    setPages = (data)=>{
        this.pages = [];
        let numberOfPages = Math.ceil(data.length / this.perpage);
        for (let index = 1; index <= numberOfPages; index++) {
            this.pages.push(index);
        }
    }  
    
    get hasPrev(){
        return this.page > 1;
    }
    
    get hasNext(){
        return this.page < this.pages.length
    }

    onNext = ()=>{
        ++this.page;
    }

    onPrev = ()=>{
        --this.page;
    }

    onPageClick = (e)=>{
        this.page = parseInt(e.target.dataset.id,10);
    }

    get currentPageData(){
        return this.pageData();
    }

    goToEditSelectedPanel(){
        
    }

}