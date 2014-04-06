/**
*
* This is Placeholde for testing purposses, you may use this as a template configuration.
*
**/
requirejs.config({
    "paths": {
      "jquery": "//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min"
    }
});
require(['jquery','pulsoviral'],function($,pv){
	pv.init({
		id:296, // Pulso ID
		size:20 //Number of Twits
	});
});
