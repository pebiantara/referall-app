// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


$(document).ready(function(){
	$("#add-photo").click(function(){
		$("#user_avatar").click();
	})

	function readURL(input) {

		if (input.files && input.files[0]) {
			var reader = new FileReader();

			reader.onload = function (e) {
				$('.upload-avatar').attr('src', e.target.result);
			}

			reader.readAsDataURL(input.files[0]);
		}
	}

	$("#user_avatar").change(function(){
		readURL(this);
	});

	$(".circle").hover(function(){
		
	})
})

var clipboard = new Clipboard('.copy-link');

clipboard.on('success', function(e) {
	alert("copied to clipboard: " + e.text);
	e.clearSelection();
});

clipboard.on('error', function(e) {
	console.error('Action:', e.action);
	console.error('Trigger:', e.trigger);
});


function autoHeight() {
	setTimeout(function(){
		var h = $(document).height() - $('body').height();
		if (h > 0) {
			$('footer').css({
				position: 'absolute',
				bottom: '0px',
				width: '100%'
			});
		}		
	}, 500)
}
$(window).on('load', autoHeight);


$('.circle').tooltip({
    animated: 'fade',
    html: true
});
$(".sr-only[data-toggle='tooltip']").tooltip('show');