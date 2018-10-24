document.addEventListener('DOMContentLoaded', () =>
  console.log 'Initialized app - main.coffee'
  return
);

app = angular.module('myApp', [])

app.filter('startFrom', () ->
  return (input, start)->
    if (!input || !input.length)
      return
    start = +start
    return input.slice(start)
);

app.controller 'myCtrl', ($scope, $http, $timeout) ->
  $scope.itemPerView = '10'

  $scope.searchPhoto = ()->
    if !$scope.searchWord.length
      alert 'Please enter the key word'
      return

    $scope.allPhotos = ''
    $scope.searching = true

    $scope.currentPage = 0;
    $scope.pageSize = 4;
    $scope.numberOfPages = ()->
      return Math.ceil($scope.allPhotos.length/$scope.pageSize)

    url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=4800e8ee13079059dbe19fa4fdf0ba37&text="+$scope.searchWord+"&per_page=35&format=json&&nojsoncallback=1"
    console.log url;

    $http.get(url).then (response) ->
      $timeout(()->
        $scope.searching = false
        console.log response.data
        $scope.allPhotos = response.data.photos.photo
        $scope.allPhotos = $scope.allPhotos.slice(0, $scope.itemPerView)
      ,500)
      return
    return

  $scope.getPhotoURL = (photo)->
    return "https://farm"+photo.farm+".staticflickr.com/"+photo.server+"/"+photo.id+"_"+photo.secret+".jpg"

  $scope.pressEnter = (keyEvent)->
    if(event.keyCode == 13)
      $scope.searchPhoto()
    return

  $scope.clearKeyword = ()->
    $scope.searchWord = ''
    document.getElementById('input-search').focus()
    return

  return
