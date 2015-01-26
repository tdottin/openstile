//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.

$(document).ready(function() {
  
  $('.datepicker').pickadate({
    format: 'dddd, mmmm d, yyyy',
    formatSubmit: 'yyyy-mm-dd',
    hiddenName: true,
    min: true,
    disable: [true],
    onSet: function(context) {
      if (this.get('value')){
        $.ajax({
          url: "/retailers/" + $('.drop-in').data("retailer-id") + "/enable_available_times",
          data: {date: this.get('value')}
        }).done(function (){
          console.log("Available times enabled")
        });
      }
    }
  })

  $('.timepicker').pickatime({
    formatSubmit: 'HH:i',
    hiddenName: true,
    min: [6,0],
    max: [23,0],
    disable: [true]
  })

  if ($('.drop-in').data('retailer-id') != null) {
    $.ajax({
      url: "/retailers/" + $('.drop-in').data("retailer-id") + "/enable_available_dates",
    }).done(function (){
      console.log("Available dates enabled")
    });
  }
});