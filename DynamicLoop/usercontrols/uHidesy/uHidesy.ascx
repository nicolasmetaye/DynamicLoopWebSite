<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uHidesy.ascx.cs" Inherits="uHidesy.Umbraco.usercontrols.uHidesy.uHidesy" %>
<style type="text/css">
    #body_TabView1
    {
        display: none;
    }
    
    #uHidesy_container a
    {
        color: #000;
        text-decoration: none;
    }
    
    #uHidesy_container a:hover
    {
        text-decoration: underline;
    }
    
    #uHidesy_container .uHidesy_off
    {
        color: lightGrey;
    }
    
    #uHidesy_container .uHidesy_property_toggle
    {
        line-height: 1.5;
    }
    
    
    #uHidesy_container.uHidesy_hide
    {
        display: none;
    }
    
    .propertypane div.propertyItem .propertyItemheader.uHidesy_admin, .header ul li a.uHidesy_admin span, .header ul li.tabOn.uHidesy_admin a span, .tabpage.uHidesy_admin .propertypane div.propertyItem .propertyItemheader
    {
        color: #137;
        font-weight:normal;
    }
    
    .uHidesy_text
    {
        font-weight:normal;
    }
</style>
<script src="/usercontrols/uHidesy/JSLINQ.js" type="text/javascript"></script>
<script src="/usercontrols/uHidesy/json2.js" type="text/javascript"></script>
<script type="text/javascript">
    $(document).ready(function () {
        var uHidesy = new function () {
            //tabs: new Array(),
            var document;

            //constants
            this.TABNAME_SELECTOR = '#body_TabView1 > .header > ul > li nobr'; 
            this.TAB_SELECTOR = '.tabpage'; 

            this.PROPERTY_SELECTOR = '.tabpageContent .propertyItem'; 
            this.PROPERTYNAME_SELECTOR = '.propertyItemheader'; 

            // TODO: when toggling a tinyMCE control, when there are no more on the page, remove the menu.
            this.TINYMCE_SELECTOR = '.tinymceContainer'; 
            this.TINYMCE_MENU_SELECTOR = '.menubar .tinymceMenuBar'; 

            //--
            // Define Document class
            this.Document = function () {
                this.id = <%= Id %>; 
                this.documentType = '<%= DocumentType %>';
                this.tabs = new Array();
                this.applyToAll = false;
                this.applyToAdmin = false;
                this.saveDate;
            },


            //--
            // Define Tab class
            this.Tab = function (name, index) {
                this.name = name;
                this.index = index;
                this.properties = new Array();
                this.status = 'show';
            },


            //--
            // Define Property class
            this.Property = function (name, index) {
                this.name = name;
                this.index = index;
                this.status = 'show';
            },



            //--
            // Creates list of tabs and properties. Then binds click events.
            this.init = function () {
                // create list of tabs and properties, along with references
                this.createLinks();

                // bind click events to new dom objects
                this.bindClickForTabLinks();
                this.bindClickForPropertyLinks();

                // apply settings from umbracoValue to this content node
                this.loadSettings();

                // trigger click on first tab which is not hidden - use created link!!!
                if ('<%= IsAdmin %>' == 'False' || ('<%= IsAdmin %>' == 'True' && uHidesy.document.applyToAdmin)){
                    for(i = 0; i < uHidesy.document.tabs.length; i++){
                        var tab = uHidesy.document.tabs[i];
                        if(tab.status == 'show'){
                            $(uHidesy.TABNAME_SELECTOR).eq(i).parent().parent().trigger('click');
                            break;                        
                        }
                    }
                }
                // hide uhidesy for non-admin
                if ('<%= IsAdmin %>' == 'False'){
                    $('#uHidesy_container').parents('.propertypane').css('display','none');
                }

                // show the main propertypane after processing uHidesy
                $('#body_TabView1').show();

            },



            //--
            // creates uHidesy links for toggling tabs and properties
            this.createLinks = function () {
                uHidesy.document = new uHidesy.Document();
                // get table names
                var tabNames = $(uHidesy.TABNAME_SELECTOR);
                
                // list tab names
                $(tabNames).each(function (tabIndex) {
                    var tabName = $(this).text();

                    // create tab object
                    var tab = new uHidesy.Tab(tabName, tabIndex);

                    // create tab item link
                    var tabItem = $('<li><a class="uHidesy_tab_toggle ' + tabName.toLowerCase() + '" href="#">' + tabName + '</a><div class="uHidesy_tab_index" style="display:none;">' + tabIndex + '</div></li>');

                    // create properties under tab
                    var properties = $(uHidesy.TAB_SELECTOR).eq(tabIndex).find(uHidesy.PROPERTY_SELECTOR);

                    var propertyList = $('<ul class="uHidesy_properties"></ul>');
                    $(properties).each(function (propertyIndex) {
                        var propertyItemheader = $(this).find(uHidesy.PROPERTYNAME_SELECTOR);
                        var propertyName = propertyItemheader.length == 0 ? '-Property-name-not-displayed-' : $(propertyItemheader).html();
                        propertyName = propertyName.indexOf('<small>') == -1 ? propertyName : propertyName.substring(0, propertyName.indexOf('<small>'));
                        
                        var propertyItem = $('<li><a class="uHidesy_property_toggle ' + propertyName.toLowerCase() + '" href="#">' + propertyName + '</a><div class="uHidesy_tab_index" style="display:none;">' + tabIndex + '</div><div class="uHidesy_property_index" style="display:none;">' + propertyIndex + '</div></li>');
                        $(propertyList).append(propertyItem);
                        var property = new uHidesy.Property(propertyName, tabIndex);
                       
                        tab.properties.push(property);
                    });

                    // store tab in array
                    uHidesy.document.tabs.push(tab);

                    // add property list to tab parent
                    $(tabItem).append(propertyList);

                    // finally append to the list
                    $('#uHidesy_tabs').append(tabItem);
                });
            },

           

            //--
            // Parses json string from Umbraco Value.
            // Compares stored json with the page json, then toggles the relative tabs and properties.
            this.loadSettings = function () {
                var jsonText = $('input[id$=uHidesy_value]').val().toString().trim();
                if (jsonText == '' || jsonText == '""') {
                    return;
                }

                // get json object
                var storedDocument = JSON.parse(jsonText.toString()).document; 
                uHidesy.document.applyToAdmin = storedDocument.applyToAdmin;
                uHidesy.document.applyToAll = storedDocument.applyToAll;

                // compare tabs and properties
                for(i = 0; i < storedDocument.tabs.length; i++){
                    if (i > uHidesy.document.tabs.length-1){
                        // there was probably a tab removed from this doc type but is still in the uHidesy settings
                        break;
                    }

                    var settingsTab = storedDocument.tabs[i];
                    var pageTab = uHidesy.document.tabs[i];

                    // compare properties of this tab
                    for(j = 0; j < settingsTab.properties.length; j++){
                        if (j > pageTab.properties.length-1){
                            // there was probably a property removed from this doc type but is still in the uHidesy settings
                            break;
                        }
                        
                        var settingsProperty = settingsTab.properties[j];
                        var pageProperty = pageTab.properties[j];

                        pageProperty.status = settingsProperty.status; 
                        if (settingsProperty.status == 'hide'){
                            $('#uHidesy_tabs > li').eq(i).find('a.uHidesy_property_toggle').eq(j).trigger('click');
                        }
                    }

                    // do tab hiding last to allow for properties which are not hidden to show when tab is re-shown
                    pageTab.status = settingsTab.status;
                    if (settingsTab.status == 'hide'){
                        $('#uHidesy_tabs a.uHidesy_tab_toggle').eq(i).trigger('click');
                    }
                }

                // set check boxes
                $('input[id$=uHidesyApplyToAll]').attr('checked', uHidesy.document.applyToAll);
                $('input[id$=uHidesyApplyToAdmin]').attr('checked', uHidesy.document.applyToAdmin);
            },



            //--
            // Gets the property which this a.uHidesy_property_toggle refers to.
            this.getPropertyFromLink = function (uHidesy_property_toggle) {        
                // get index of this property's tab from hidden div
                var tabIndex = $(uHidesy_property_toggle).siblings('.uHidesy_tab_index').text();

                // get index of this property from hidden div
                var propertyIndex = $(uHidesy_property_toggle).siblings('.uHidesy_property_index').text();

                // get property
                var property = $(uHidesy.TAB_SELECTOR).eq(tabIndex).find(uHidesy.PROPERTY_SELECTOR).eq(propertyIndex);
                
                return property;
            },


            //--
            // Shows or hides a property
            this.toggleProperty = function(tabIndex, propertyIndex, status){
                 var property = $(uHidesy.TAB_SELECTOR).eq(tabIndex).find(uHidesy.PROPERTY_SELECTOR).eq(propertyIndex);
                uHidesy.toggleItem(property);
            },


            //--
            // Shows or hides a tab body
            this.toggleTabBody = function(tabIndex){
                 var tab = $(uHidesy.TAB_SELECTOR).eq(tabIndex);

                 if ('<%= IsAdmin %>' == 'True' && !uHidesy.document.applyToAdmin){
                    tab.toggleClass('uHidesy_admin');
                    
                    $(tab).find('.propertypane').each(function(){
                        $(this).find('.propertyItem').each(function(){
                        
                            // only toggle the property off when it is not already off, or, toggle on when .uHidesy_admin_tabToggled already exists
                            if ($(this).find('.uHidesy_admin').length == 0 || $(this).find('.uHidesy_admin_tabToggled').length > 0){
                                uHidesy.toggleItem(this);

                                // add this class so we know that the property was toggled by clicking the tab-link
                                $(this).find('.propertyItemheader').toggleClass('uHidesy_admin_tabToggled');
                            }
                        });

                    });
                 }
                 else{
                    this.toggleItem($(uHidesy.TABNAME_SELECTOR).eq(tabIndex));
                }
            },
            

           

            //--
            // Toggle was not working so this is a quick and hacky
            // Shows/hides an item.
            this.toggleItem = function (item) {
                // ensure that .propertyItem has a .propertyItemheader otherwise we have nothing to append text to
                var header = $(item).find('.propertyItemheader');
                if (header.length == 0){
                    if ($(item).find('nobr').length == 0){
                        // inject .propertyItemheader only when this is a property
                        $(item).prepend('<div class="propertyItemheader"></div>');
                    }
                }

                // when admin, only change the color
                if ('<%= IsAdmin %>' == 'True' && !uHidesy.document.applyToAdmin){
                    header = $(item).find('.propertyItemheader');
                    header.toggleClass('uHidesy_admin');
                    $(item).find('a').toggleClass('uHidesy_admin');

                    // determine if we should add or remove text
                    if ($(item).children().hasClass('uHidesy_admin')){
                        // add text to the tab/property
                        this.toggleuHidesyText($(item).find('nobr'));
                        this.toggleuHidesyText(header);
                        return 'hide';                        
                    }else{
                        // remove text from the tab/property
                        this.toggleuHidesyText(item);  

                        // hide .propertyItemheader if it is empty... it is empty because we injected it to add uhidesy text
                        if ($(header).html() == ''){
                            $(header).remove();
                        }

                        return 'show';
                    }
                }

                else{
                    if ($(item).css('display') != 'none') {
                        $(item).css('display', 'none');
                        return 'hide';
                    } else {
                        $(item).css('display', 'block');
                        return 'show';
                    }
                }
            },


            //--
            // Toggles text to indicate that a tab or property has been hidden
            this.toggleuHidesyText = function(item){
                if ($(item).html() == null){
                    return;
                }

                var uHidesyText = '<i class="uHidesy_text"> (hidden by uHidesy)</i>';

                if ($(item).html().indexOf(uHidesyText) == -1){
                    $(item).append(uHidesyText);
                }else{
                    $(item).find('.uHidesy_text').remove();
                }
            },


            //--
            // Binds click event for tab links 
            // Toggles 'uHidesy_off' class for tab link and child property links.
            // Toggles (shows/hides) tab.
            this.bindClickForTabLinks = function () {
                $('#uHidesy_tabs a.uHidesy_tab_toggle').click(function () {
                    $(this).toggleClass('uHidesy_off');

                    // toggle the property links
                    var propertyLinks = $(this).siblings('.uHidesy_properties').children();
                    $(propertyLinks).each(function(){
                        $(this).toggleClass('uHidesy_off');
                    });

                    // get tab index from hidden div
                    var tabIndex = $(this).siblings('.uHidesy_tab_index').text();
                    
                    // toggle tab and store status
                    var tab = $(uHidesy.TABNAME_SELECTOR).eq(tabIndex).parents('li');
                    uHidesy.document.tabs[tabIndex].status = uHidesy.toggleItem($(tab));

                    uHidesy.toggleTabBody(tabIndex);

                    // get property links from tab link
                    var propertyLinks = $(this).siblings('.uHidesy_properties').find('.uHidesy_property_toggle');

                    var tabLinkStatus =  $(this).hasClass('uHidesy_off');
                    
                    // toggle uHidesy_off class for property names
                    $(propertyLinks).each(function () {
                        if (tabLinkStatus == true) {
                            // tab is being turned uHidesy_off so turn off properties
                            $(this).addClass('uHidesy_off');
                        } else {
                            // tab is being turned on so check if the property was originally turned off
                            var property = uHidesy.getPropertyFromLink($(this));

                            if ('<%= IsAdmin %>' == 'True' && !uHidesy.document.applyToAdmin){
                                var propertyHeader = $(property).find('.propertyItemheader');
                                //var propertyHeader = $(property).children(); // to handle no name
                                if (!propertyHeader.hasClass('uHidesy_admin_tabToggled') && !propertyHeader.hasClass('uHidesy_admin')) {
                                    $(this).removeClass('uHidesy_off');
                                }
                            }else{
                                if ($(property).css('display') != 'none') {
                                    $(this).removeClass('uHidesy_off');
                                }
                            }
                        }
                    });

                    return false;
                });
            },


            //--
            // Binds click event for properties 
            // Toggles 'uHidesy_off' class for property link
            this.bindClickForPropertyLinks = function () {
                // bind click for property toggling
                $('#uHidesy_tabs a.uHidesy_property_toggle').click(function () {
                    
                    // when tab is uHidesy_off, you cant toggle the properties!
                    if ($(this).parent().parent().siblings('.uHidesy_tab_toggle').hasClass('uHidesy_off')){
                        return false;
                    }
                    
                    var tabIndex = $(this).siblings('.uHidesy_tab_index').text();
                    var property = uHidesy.getPropertyFromLink($(this));
                    var propertyIndex = $(this).siblings('.uHidesy_property_index').text();

                    // toggle item and store status
                    uHidesy.document.tabs[tabIndex].properties[propertyIndex].status = uHidesy.toggleItem($(property));

                    // this is hacky but i'm 1.5 hours away from london and it's 3am in sydney
                    var siblings = $(property).parent().children('.propertyItem');
                    var visibleSiblings = false;
                    for(var i = 0 ; i < siblings.length; i++){
                        var display = $(siblings[i]).css('display');
                        if (display == 'block' || display == 'inline'){
                            visibleSiblings = true;
                            break;
                        }
                    }
                    
                    // when all properties in propertypane are hidden, toggle property pane
                    if (visibleSiblings == false){
                        $(property).parents('.propertypane').hide();
                    }else{
                        $(property).parents('.propertypane').show();
                    }
                    
                    // toggle the color of the uHidesy property link 
                    $(this).toggleClass('uHidesy_off');
                    return false;
                });
            }
        };


        //--
        // Binds click event of save and publish buttons.
        // Constructs json string and saves to input for saving.
        $('input[id$=layer_save],input[id$=layer_publish],input[id$=UnPublishButton]').click(function () {
            // save umbracoValue
            var jsonForUmbracoValue = JSON.stringify({ "document" : uHidesy.document });
            $('input[id$=uHidesy_value]').val(jsonForUmbracoValue);

            // get value of checkbox and set "apply to all" value
            uHidesy.document.applyToAll = $('input[id$=uHidesyApplyToAll]:checked').val() !== undefined;
            uHidesy.document.applyToAdmin = $('input[id$=uHidesyApplyToAdmin]:checked').val() !== undefined;
            
            // create json string and save
            var jsonForSettings = JSON.stringify({ "document" : uHidesy.document });

            $('input[id$=uHidesy_value]').val(jsonForSettings);
        });


        // run uHidesy!
        uHidesy.init();
    });

</script>
<asp:HiddenField ID="uHidesy_value" runat="server" />
<asp:HiddenField ID="uHidesy_value_old" runat="server" />
<div id="uHidesy_container">
    <h3>
        Tabs</h3>
    <h4>
        Select the tabs or properties to disable</h4>
    <ul id="uHidesy_tabs">
    </ul>
    <label>
        Apply to all content nodes of type
        <%=DocumentType %></label>
    <asp:CheckBox ID="uHidesyApplyToAll" runat="server" /><br />
    <br />
    <label>
        Apply to administrators</label>
    <asp:CheckBox ID="uHidesyApplyToAdmin" runat="server" /><br />
    <br />

    <div>Special note: uHidesy relies on your document type to stay consistent with it's settings. So be careful if you want to add, remove, or reorder tabs or properties.</div>

</div>
