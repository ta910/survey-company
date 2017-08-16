$(document).on("turbolinks:load", function() {

  function goBottom() {
    $('.message').delay(100).animate({
      scrollTop: $('.message')[0].scrollHeight
    }, 'slow', 'swing');
  };

  function buildHTML(message) {
    var textHtml = ""
    var imageHtml = ""
    if (message.text) {
      textHtml = message.text + '<br>'
    };
    if (message.image) {
      imageHtml = '<img src="' + message.image + '">'
    };
    var html =
      `<li class="message">
        <div class="sender_message_content">
          ${message.name}
          <br>
          ${message.time}
          <br>
          ${textHtml}
          ${imageHtml}
        </div>
       </li>`
    return html;
  };

  $('#new_message').on ('submit', function(e) {
    var message = $(this);
    e.preventDefault();
    var formdata = new FormData(message[0]);
    $.ajax({
      type: 'POST',
      processData: false,
      contentType: false,
      data: formdata,
      dataType: 'json'
    })
    .done(function(data) {
      var html = buildHTML(data);
      $('ul.messages').append(html);
      message[0].reset();
      $('input').prop('disabled', false);
      goBottom();
    })
    .fail(function() {
      alert('error');
    });
  });
});
