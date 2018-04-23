$(document).ready(function() {
  //Autocomplete
  $(function() {
    $.ajax({
      type: 'GET',
      url: '/tags',
      success: function(response) {
        var tags = response;
        var result = {};
        for (var i = 0; i < tags.length; i++) {
          result[tags[i]] = null;
        }
        $('input.autocomplete').autocomplete({
            data: result,
            limit: 20, // The max amount of results that can be shown at once. Default: Infinity.
            onAutocomplete: function(val) {
                location.assign("/search?tags="+val);
            },
            minLength:1,
        });
      }
    });
  });
});


