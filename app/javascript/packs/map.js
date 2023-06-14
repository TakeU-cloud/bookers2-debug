window.initMap = function() {
  const input = document.getElementById('book_address');
  if (!input) {
    return;
  }
  const autocomplete = new google.maps.places.Autocomplete(input);

  autocomplete.addListener('place_changed', function() {
    const place = autocomplete.getPlace();
    if (!place.geometry) {
      window.alert("No details available for input: '" + place.name + "'");
      return;
    }
  
    // 緯度経度をフォームに設定
    document.getElementById('book_latitude').value = place.geometry.location.lat();
    document.getElementById('book_longitude').value = place.geometry.location.lng();

    const map = new google.maps.Map(document.getElementById('map'), {
      zoom: 13,
      center: place.geometry.location,
    });

    new google.maps.Marker({
      map: map,
      position: place.geometry.location,
    });

    const nearbyBooks = JSON.parse(document.getElementById('nearby_books').dataset.books);

    if (nearbyBooks === null) {
      return;
    }
    nearbyBooks.forEach((book) => {
      const marker = new google.maps.Marker({
        position: { lat: book.latitude, lng: book.longitude },
        map: map,
        title: book.title,
      });

      // InfoWindowを作成
      const infowindow = new google.maps.InfoWindow({
        content: `<div style="padding: 10px;">
                    <h6>${book.title}</h6>
                    <img src="${book.user_profile_image_url}" style="width: 100px;" alt="${book.title}"/>
                  </div>`,
        // disableAutoPan: true
      });

      // マーカーにマウスオーバーイベントを追加
      marker.addListener('mouseover', function() {
        infowindow.open(map, marker);
      });

      // マーカーにマウスアウトイベントを追加
      marker.addListener('mouseout', function() {
        infowindow.close();
      });

      marker.addListener('click', () => {
        window.location.href = book.book_url;
      });
    });
  });
}

document.addEventListener('turbolinks:load', function() {
  initMap();
});
