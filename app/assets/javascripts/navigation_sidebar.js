$(document).ready(function(){
   $(document).on('click', '.sideBarToggle', function(s) {
       $("#wrapper").toggleClass("toggled");
       if($('#wrapper.toggled').length > 0) {
           $('main, header').css('padding-left', '65px');
       }else{
           $('main, header').css('padding-left', '15px');
       }
    });
});
