// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";

Rails.start()
Turbolinks.start()
ActiveStorage.start()


import 'bootstrap/dist/js/bootstrap';
import 'bootstrap/dist/css/bootstrap';


document.addEventListener('turbolinks:load', () => {
const stars = document.querySelector(".ratings").children;
const ratingValue = document.getElementById("rating-value");
const ratingValueDisplay = document.getElementById("rating-value-display");

let index;

for(let i=0; i<stars.length; i++){
  stars[i].addEventListener("mouseover", function(){
    for(let j=0; j<stars.length; j++){
      stars[j].classList.remove("fa-star");
      stars[j].classList.add("fa-star-o");
    }
      for(let j=0; j<=i; j++){
      stars[j].classList.remove("fa-star-o");
      stars[j].classList.add("fa-star");
      }
  })

  stars[i].addEventListener("click", function(){
    ratingValue.value = i +1;
    ratingValueDisplay.textContent = ratingValue.value;
    index = i;
  })

  stars[i].addEventListener("mouseout", function(){
    for(let j=0; j<stars.length; j++){
      stars[j].classList.remove("fa-star");
      stars[j].classList.add("fa-star-o");
    }
      for(let j=0; j<=index; j++){
      stars[j].classList.remove("fa-star-o");
      stars[j].classList.add("fa-star");
      }
    })
  }
});