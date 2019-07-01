// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require jquery-tablesorter
//= require jquery-tablesorter/jquery.metadata.min
//= require jquery-tablesorter/jquery.tablesorter
//= require jquery-tablesorter/jquery.tablesorter.widgets
//= require jquery-tablesorter/jquery.tablesorter.pager
//= require fusioncharts/fusioncharts
//= require fusioncharts/fusioncharts.charts
//= require fusioncharts/themes/fusioncharts.theme.fint
//= require select2-full
//= require select2_locale_pt-BR
//= require_tree .

$(document).on('page:load ready', function(){
    $('.datepicker').datepicker({format: 'yyyy-mm-dd',autoclose: true, minView: 2});
});

$(function() {
    $("table.time_tracks thead th:eq(6)").data("sorter", false);
    $("table.companies thead th:eq(3)").data("sorter", false);
    $("table.members thead th:eq(2)").data("sorter", false);
    $("table.clients thead th:eq(3)").data("sorter", false);
    $("table.projects thead th:eq(3)").data("sorter", false);

    $('table').tablesorter({
        theme: 'blue',
        widgets: ["zebra", "filter", "output"],
        widgetOptions : {
            // filter_anyMatch replaced! Instead use the filter_external option
            // Set to use a jQuery selector (or jQuery object) pointing to the
            // external filter (column specific or any match)
            filter_external : '.search',
            // add a default type search to the first name column
            filter_defaultFilter: { 1 : '~{query}' },
            // include column filters
            filter_columnFilters: true,
            filter_placeholder: { search : 'Search...' },
            filter_saveFilters : true,
            filter_filteredRow   : 'filtered',
            filter_reset         : '.group2 .reset',
            output_headerRows    : true,        // output all header rows (multiple rows)
            output_popupStyle    : 'width=580,height=310',
            output_saveFileName  : 'mytable.csv'
        }
    });
    // set up download buttons for two table groups
    var demos = ['.group2'];

    $.each(demos, function(groupIndex){
        var $this = $(demos[groupIndex]);
        $this.find('.dropdown-toggle').click(function(e){
            // this is needed because clicking inside the dropdown will close
            // the menu with only bootstrap controlling it.
            $this.find('.dropdown-menu').toggle();
            return false;
        });
        // make separator & replace quotes buttons update the value
        $this.find('.output-separator').click(function(){
            $this.find('.output-separator').removeClass('active');
            var txt = $(this).addClass('active').html()
            $this.find('.output-separator-input').val( txt );
            $this.find('.output-filename').val(function(i, v){
                // change filename extension based on separator
                var filetype = (txt === 'json' || txt === 'array') ? 'js' :
                    txt === ',' ? 'csv' : 'txt';
                return v.replace(/\.\w+$/, '.' + filetype);
            });
            return false;
        });
        $this.find('.output-quotes').click(function(){
            $this.find('.output-quotes').removeClass('active');
            $this.find('.output-replacequotes').val( $(this).addClass('active').text() );
            return false;
        });

        // clicking the download button; all you really need is to
        // trigger an "output" event on the table
        $this.find('.download').click(function(){
            var typ,
                $table = $this.find('table'),
                wo = $table[0].config.widgetOptions,
                saved = $this.find('.output-filter-all :checked').attr('class');
            wo.output_separator    = $this.find('.output-separator-input').val();
            wo.output_delivery     = $this.find('.output-download-popup :checked').attr('class') === 'output-download' ? 'd' : 'p';
            wo.output_saveRows     = saved === 'output-filter' ? 'f' :
                saved === 'output-visible' ? 'v' :
                    saved === 'output-selected' ? '.checked' : // checked class name, see table.config.checkboxClass
                        saved === 'output-sel-vis' ? '.checked:visible' :
                            'a';
            wo.output_replaceQuote = $this.find('.output-replacequotes').val();
            wo.output_trimSpaces   = $this.find('.output-trim').is(':checked');
            wo.output_includeHTML  = $this.find('.output-html').is(':checked');
            wo.output_wrapQuotes   = $this.find('.output-wrap').is(':checked');
            wo.output_headerRows   = $this.find('.output-headers').is(':checked');
            wo.output_saveFileName = $this.find('.output-filename').val();
            $table.trigger('outputTable');
            return false;
        });


    });

    $("#time_track_filter").change(function() {
        $('table.time_tracks tbody').html('Loading...');
        $.get( "/time_tracks?filter="+$(this).val(), function( data ) {
            $('table.time_tracks tbody').html(data);
            $('table.time_tracks').trigger('update');
        });
    });

});