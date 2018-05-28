$( document ).on('turbolinks:load', function() {
  $('#type').change(function() {
    var val = this.value;
    $('#title_group').removeClass('hidden');
    if(val == 'pie' || val == 'bar')
    {
      $('#val_group').removeClass('hidden');
      $('#name_group').removeClass('hidden');
      $('#loc_group').addClass('hidden');
    }
    else
    {
      $('#val_group').addClass('hidden');
      $('#name_group').removeClass('hidden');
      $('#loc_group').removeClass('hidden');
    }
  });
});
