$(document).on('turbolinks:load', function () {
  var apiDestination;
  var $postForm = $('#post-form');




  $('#libraries').change(function () {
    $('#predictions').empty().addClass('hide');
    apiDestination = $(this).find(':selected').data('author');
    $('#user-text').prop('disabled', false);
  });

  $postForm.on('keyup', '#user-text', function (event) {
    var $predictions = $('#predictions');
    var $active;
    var userInput = $('#user-text').val();
    $('.tooltipped').tooltip('remove');
    eventCleanup(event, userInput);


    if(event.which === 32){
      var userText = $(this).serialize();
      var response = $.ajax({
        url: apiDestination,
        data: userText
      });

      response.done(function (predictions) {
        renderWords(predictions);
        $predictions.find('a').first().addClass('active')
      });
    }

    else if(event.which === 40){
      event.preventDefault();
      $active = $predictions.find('.active');
      if($active.next().is('.collection-item')){
        $active.removeClass('active');
        $active = $active.next();
        $active.addClass('active')
      }else{
       $active.removeClass('active');
       $predictions.find('a').first().addClass('active')
      }
    }

    else if(event.which === 38){
      event.preventDefault();
      $active = $predictions.find('.active');
      if($active.prev().is('.collection-item')){
        $active.removeClass('active');
        $active = $active.prev();
        $active.addClass('active')
      }
      else{
        $active.removeClass('active');
        $predictions.find('a').last().addClass('active')
      }
    }

  });

  $postForm.on('keydown', '#user-text', function (event) {
    var $predictions = $('#predictions');
    var $active;
    var $userText = $('#user-text');
    eventCleanup($userText.val());
    if (event.which === 9) {
      event.preventDefault();
      $active = $predictions.find('.active');
      $userText.val($userText.val() + $active.text() + ' ');
      triggerSpace();
    }
  });

  $('#predictions').on('click touchend', 'a', function (event) {
    event.preventDefault();
    var $userText = $('#user-text');
    $userText.val($userText.val() + $(this).text() + ' ');
    triggerSpace();
  });

  //fixes chrome on android not providing the right keycodes by setting the keycode to the last character typed
  function eventCleanup(event, userInput){
    if (event.which === 0 || event.which === 229){
      event.which = userInput.charAt(userInput.length-1).charCodeAt(0);
    }
  }

  function triggerSpace() {
    e = $.Event('keyup');
    e.which = 32;
    $('#user-text').trigger(e);
  }

  function renderWords(wordsArray) {
    var $predictionField = $('#predictions');
    $predictionField.empty();
    $predictionField.removeClass('hide');
    for(var i = 0; i < wordsArray.length; i++){
      $predictionField.append("<a class='collection-item'>" + wordsArray[i] + "</a>")
    }
  }
});