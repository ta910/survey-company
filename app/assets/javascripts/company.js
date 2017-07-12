$(document).on("turbolinks:load", function() {

  function BuildSearchedCompanies (company) {
    var result = `<a href='/companies/${company.id}/users/sign_up'>
                    <div class='searched-user'>
                      <p class='searched-user-name'>${company.name}</p>
                    </div>
                  </a>`
    return result
  }

  function SearchCompanies(name) {
    $.ajax({
      url: '/companies/search',
      type: 'GET',
      data: { name: name },
      dataType: 'json'
    })
    .done(function(data){
      var html = "";
      data.forEach(function(company){
        html += BuildSearchedCompanies(company);
      })
      $('#company-search-result').empty();
      $('#company-search-result').append(html);
    })
    .fail(function() {
      alert('error');
    });
  }

  $('#search').on('keyup', function(){
    var name = $('#search').val();
    if (name.length !== 0) {
      SearchCompanies(name);
    } else {
      $('#company-search-result').empty();
    };
  });
});
