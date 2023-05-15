// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "jquery";
import "popper.js";
import "bootstrap";
import '@fortawesome/fontawesome-free/js/all';
import "../stylesheets/application";
import Chart from 'chart.js/auto';

Rails.start();
Turbolinks.start();
ActiveStorage.start

document.addEventListener('turbolinks:load', () => {
  // 既存のチャートがあれば破棄する
  if (window.myBooksChart) {
    window.myBooksChart.destroy();
  }

  const ctx = document.getElementById('myChart').getContext('2d');
  window.myBooksChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: ['6日前', '5日前', '4日前', '3日前', '2日前', '1日前', '今日'],
      datasets: [{
        label: '投稿した本の数',
        data: JSON.parse(ctx.canvas.dataset.books),
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
        borderColor: 'rgba(75, 192, 192, 1)',
        borderWidth: 1,
        tension: 0.4
      }]
    },
    options: {
      scales: {
        y: {
          beginAtZero: true
        }
      }
    }
  });
});