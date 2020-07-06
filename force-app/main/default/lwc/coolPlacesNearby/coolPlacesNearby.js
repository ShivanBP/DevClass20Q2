import { LightningElement, api } from 'lwc';
import findCoolPlaces from '@salesforce/apex/coolPlacesNearbyController.findCoolPlaces';


export default class CoolPlacesNearby extends LightningElement {
    @api recordId;
    dataLoad;


    connectedCallback(){
        findCoolPlaces({currentId : this.recordId})
            .then(result => {
                this.processBusinesses(result);
            })
            .catch(error => {
                console.log(error);
            })
    }

    processBusinesses(result){
        this.dataLoad = [];
        for(let i = 0; i < result.length; i++){
            var data = [];
            data.index = i + 1;
            data.name = result[i].name
            data.Id = result[i].Id;
            data.image_url = result[i].image_url;
            data.url = result[i].url;
            data.review_count = result[i].review_count;
            data.price = result[i].price;
            data.categories='';
            for(var j = 0; j < result[i].categories.length; j++){ű
                console.log(result[i].categories[j].title);
                data.categories += result[i].categories[j].title;
                if(j + 1 < result[i].categories.length){
                    data.categories += ', ';
                }
            }
            data.phone = result[i].phone;
            data.location = result[i].location;
            var rating = result[i].rating;
            if(rating == 0){
                data.class='star-ratings-sprite-rating half';
            }else if(0.5 <= rating && rating < 1){
                data.class='star-ratings-sprite-rating one';
            }else if(1 <= rating && rating < 1.5){
                data.class='star-ratings-sprite-rating oneAndaHalf';
            }else if(1.5 <= rating && rating < 2){
                data.class='star-ratings-sprite-rating two';
            }else if(2 <= rating && rating < 2.5){
                data.class='star-ratings-sprite-rating twoAndaHalf';
            }else if(3 <= rating && rating < 3.5){
                data.class='star-ratings-sprite-rating three';
            }else if(3.5 <= rating && rating < 4){
                data.class='star-ratings-sprite-rating threeAndaHalf';
            }else if(4 <= rating && rating < 4.5){
                data.class='star-ratings-sprite-rating four';
            }else if(4.5 <= rating && rating < 4.75){
                data.class='star-ratings-sprite-rating fourAndaHalf';
            }else if(rating > 4.75){
                data.class='star-ratings-sprite-rating five';
            }
            this.dataLoad.push(data);
        }
        console.log(this.dataLoad);
    }
}