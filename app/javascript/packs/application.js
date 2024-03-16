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
// class = "ratings"の子要素を取得
const stars = document.querySelector(".ratings").children;
// const stars = document.getElementsByClassName("ratings").children;
// id = "rating-value"の要素を取得
const ratingValue = document.getElementById("rating-value");
// id = "rating-value-display"の要素を取得
const ratingValueDisplay = document.getElementById("rating-value-display");
// indexという変数を定義
let index;

// reveiwの投稿ページに遷移するとstars.lengthの値（5）だけ繰り返し
for(let i=0; i<stars.length; i++){
	console.log(stars.length)
	// 星にカーソルが乗ったときに実行する関数を定義
	stars[i].addEventListener("mouseover",function(){
		// stars.lengthの値（5）だけ繰り返し
		// つまり、星カーソルが乗った時、5回繰り返される
		for(let j=0; j<stars.length; j++){
			console.log(stars.length)
			// まず全て星をくり抜く
			stars[j].classList.remove("fa-star");
			stars[j].classList.add("fa-star-o");
		}
		// そのあと星の数だけ以下の関数が繰り返される。
		for(let j=0; j<=i; j++){
			console.log(stars.length)
			stars[j].classList.remove("fa-star-o");
			// カーソルが乗った星まで星を塗りつぶす
			stars[j].classList.add("fa-star");
		}
	})
	// クリックされた星の番号+1をratingValueに代入
	stars[i].addEventListener("click",function(){
		ratingValue.value = i+1;
		ratingValueDisplay.textContent = ratingValue.value;
		// indexにクリックされた星の番号を代入
		index = i;
	})
	// 星からカーソルが離れたときに実行される関数
	stars[i].addEventListener("mouseout",function(){
		// まず5回繰り返す
		for(let j=0; j<stars.length; j++){
			// まず全ての星をくり抜く
			stars[j].classList.remove("fa-star");
			stars[j].classList.add("fa-star-o");
		}
		for(let j=0; j<=index; j++){
			// クリックされている星まで塗りつぶす
			stars[j].classList.remove("fa-star-o");
			stars[j].classList.add("fa-star");
		}
	})
}
});

document.addEventListener("DOMContentLoaded", function () {
  var ratingForm = document.querySelector('.starability-grow form');
  var stars = ratingForm.querySelectorAll('input');

  stars.forEach(function (star) {
    star.addEventListener('change', function () {
      // 選択された星の値（1から5の範囲）を取得
      var selectedRating = this.value;
      console.log("Selected rating: " + selectedRating);

      // ここでAjaxなどを使用してサーバーに選択された評価を送信できる
    });
  });
});


