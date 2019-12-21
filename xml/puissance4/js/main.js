;(function($) {

    /**
     * Projet XML/XSLT - Puissance 4
     *
     * @author ZHANG Zhao 
     * @email  <zo.zhang@gmail.com>
     */
    var Puissance4 = function (settings) {

    	var self = this;

        this.settings = settings;

  		// transforme au xml
        this.transforme = function(e) {
			
			self.settings.transformation.xslt($.trim(self.settings.textareaXml.val()), $.trim(self.settings.textareaXslt.val()));
        };

        // initialise les functions
        this.initialise = function() {

        	this.reloadFiles();

            return this;
        };

        // reload files
        this.reloadFiles = function() {
			var loadXml  = this.loadFileXml();
			var loadXslt = this.loadFileXslt();

			$.when(loadXml, loadXslt).done(function() {
			    self.transforme();
			});
        };

        // charge le chier xml
        this.loadFileXml = function() {
			return $.get(self.settings.xml, function(xml,dd){
					self.settings.textareaXml.text(xml.toString());
			}, 'text');
        };

		// charge le chier xslt
        this.loadFileXslt = function() {
        	 return $.get(self.settings.xslt, function(response){
						self.settings.textareaXslt.text(response);
					}, 'text');
        };

        return this.initialise();
    };

   
    $(document).ready(function(){

       var instance = new Puissance4({
	       	xml: 'xml/configuration-diagonal.xml',
	       	xslt:'xslt/validation.xsl',
			textareaXml : $('textarea#xml'),
	 		textareaXslt : $('textarea#xslt'),
	 		transformation : $('#transformation')
       });

		$('button').click(function() {

			switch(this.value) {
				case 'horizontal':
				case 'vertical':
				case 'diagonal':
					instance.settings.xml = 'xml/configuration-'+this.value+'.xml';
					instance.reloadFiles()
				break;

				case 'transform':
					instance.transforme();
				break;
			}
		});

    });

})(jQuery);