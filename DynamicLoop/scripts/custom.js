$(document).ready(function(){	
	$('#middleContent ul.list>li:nth-child(even)').not('.arrow-up').css({ 'background': '#e6e6e6'});
	$('#middleContent ul.list>li:nth-child(odd)').not('.arrow-up').css({ 'background': '#f6f6f6'});
	$('#middleContent ul.list:last-child').css({'margin-bottom':'0'});
	
	 Cufon.replace('h1');
	 Cufon.replace('h2');
	 Cufon.replace('h3');
	 Cufon.replace('h4');
	 Cufon.replace('h4');
	 Cufon.replace('.top-description');
	 Cufon.replace('.link-container a', { hover: 'true' });
	 Cufon.replace('.link-container .selected');
	 Cufon.now();
});