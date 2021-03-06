// From https://gist.github.com/1343518
// Modified by Hakim to handle Markdown indented with tabs
// Modified by Riceball to slidifyMarkdown automatically.
(function(){

    if( typeof marked === 'undefined' ) {
        throw 'The reveal.js Markdown plugin requires marked to be loaded';
    }

    if (typeof hljs !== 'undefined') {
        console.log('highlight ok');
        marked.setOptions({
            highlight: function (lang, code) {
                return hljs.highlightAuto(lang, code).value;
            }
        });
    }

    var stripLeadingWhitespace = function(section) {

        var template = section.querySelector( 'script' );

        // strip leading whitespace so it isn't evaluated as code
        var text = ( template || section ).textContent;

        var leadingWs = text.match(/^\n?(\s*)/)[1].length,
            leadingTabs = text.match(/^\n?(\t*)/)[1].length;

        if( leadingTabs > 0 ) {
            text = text.replace( new RegExp('\\n?\\t{' + leadingTabs + '}','g'), '\n' );
        }
        else if( leadingWs > 1 ) {
            text = text.replace( new RegExp('\\n? {' + leadingWs + '}','g'), '\n' );
        }

        return text;

    };

    var twrap = function(el) {
      //return '<script type="text/template">' + marked(el) + '</script>';
      return marked(el);
    };

    var getForwardedAttributes = function(section) {
        var attributes = section.attributes;
        var result = [];

        for( var i = 0, len = attributes.length; i < len; i++ ) {
            var name = attributes[i].name,
                value = attributes[i].value;

            // disregard attributes that are used for markdown loading/parsing
            if( /data\-(markdown|separator|vertical)/gi.test( name ) ) continue;

            if( value ) {
                result.push( name + '=' + value );
            }
            else {
                result.push( name );
            }
        }

        return result;//result.join( ' ' );
    };


    var slidifyMarkdownManually = function(markdown, separator, vertical, attributes) {
      
        separator = separator || '^\n---\n$';
        attributes = attributes.join(' ');

        var reSeparator = new RegExp(separator + (vertical ? '|' + vertical : ''), 'mg'),
            reHorSeparator = new RegExp(separator),
            matches,
            lastIndex = 0,
            isHorizontal,
            wasHorizontal = true,
            content,
            sectionStack = [],
            markdownSections = '';

        // iterate until all blocks between separators are stacked up
        while(matches = reSeparator.exec(markdown)) {

            // determine direction (horizontal by default)
            isHorizontal = reHorSeparator.test(matches[0]);

            if( !isHorizontal && wasHorizontal ) {
                // create vertical stack
                sectionStack.push([]);
            }

            // pluck slide content from markdown input
            content = markdown.substring(lastIndex, matches.index);

            if( isHorizontal && wasHorizontal ) {
                // add to horizontal stack
                sectionStack.push(content);
            } else {
                // add to vertical stack
                sectionStack[sectionStack.length-1].push(content);
            }

            lastIndex = reSeparator.lastIndex;
            wasHorizontal = isHorizontal;
        }

        // add the remaining slide
        (wasHorizontal ? sectionStack : sectionStack[sectionStack.length-1]).push(markdown.substring(lastIndex));

        // flatten the hierarchical stack, and insert <section data-markdown> tags
        for( var k = 0, klen = sectionStack.length; k < klen; k++ ) {
            // horizontal
            if( typeof sectionStack[k] === 'string' ) {
                markdownSections += '<section '+ attributes +'>' +  marked( sectionStack[k] )  + '</section>';
            }
            // vertical
            else {
                markdownSections += '<section '+ attributes +'>' +
                                      '<section>' +  sectionStack[k].map(twrap).join('</section><section>') + '</section>' +
                                    '</section>';
            }
        }

        return markdownSections;
    };

    var slidifyMarkdown = function(markdown, separator, vertical, attributes, columnCount) {
        if (separator) {
          return slidifyMarkdownManually(markdown, separator, vertical, attributes);
        }
        else {
          var conf = Reveal.getConfig();
          var slideHeight = conf.height*(0.935-conf.margin);
          var slideWidth  = conf.width*(0.935-conf.margin);
          var markdownSections = "";
          var $cache = $("<div id='_smdcache' class='slides'></div>").css("visibility", "hidden");
          var $body = $("div.reveal");
          if ($.isNumeric(columnCount))
              columnCount = parseInt(columnCount, 0);
          else
              columnCount = 1;
          $cache.append(marked(markdown));
          $cache.find('table, thead, tbody, tfoot, colgroup, caption, label, legend, script, style, textarea, button, object, embed, tr, th, td, li, h1, h2, h3, h4, h5, h6, form, code').addClass('dontsplit');
          $cache.find('h1, h2, h3, h4, h5, h6').addClass('dontend');
          $cache.find('br').addClass('removeiflast').addClass('removeiffirst');
          var $sections=$("<div></div>").css("display", "block");
          $body.append($cache);
          $body.append($sections);
          function buildPage() {
              if ($cache.contents().length > 0) {
                  var $page = $("<section></section>");
                  $sections.append($page);
                  $('#_smdcache').columnize({
                      columns: columnCount,
                      target: $sections.find("section:last"),
                      overflow: {
                          height: slideHeight,
                          width: slideWidth,
                          id: '#_smdcache',
                          doneFunc: function(){
                              //console.log("done with a page");
                              buildPage();
                          }
                      }
                  });
              }
          }
          buildPage();
          var s = $sections.html();
          $sections.remove();
          $cache.remove();
          if (typeof(vertical) !== "undefined")
              s = '<section '+ attributes.join(' ') +'>'+s+'</section>';

          return s;
          
        }
    };

    var querySlidingMarkdown = function() {

        var sections = $('[data-markdown]');//document.querySelectorAll( '[data-markdown]'),

        $.each(sections, function(index, section){
            var $section = $(section);

            if( $section.attr('data-markdown').length ) {

                var xhr = new XMLHttpRequest(),
                    url = $section.attr('data-markdown');

                xhr.onreadystatechange = function () {
                    if( xhr.readyState === 4 ) {
                        if (xhr.status >= 200 && xhr.status < 300) {
                            $section.replaceWith(slidifyMarkdown( xhr.responseText, $section.data('separator'), $section.data('vertical'), getForwardedAttributes(section), $section.data('columns') ));
                        } else {
                            $section.replaceWith('<section data-state="alert">ERROR: The attempt to fetch ' + url + ' failed with the HTTP status ' + xhr.status +
                                '. Check your browser\'s JavaScript console for more details.' +
                                '<p>Remember that you need to serve the presentation HTML from a HTTP server and the Markdown file must be there too.</p></section>');
                        }
                    }
                };

                xhr.open('GET', url, false);
                try {
                    xhr.send();
                } catch (e) {
                    alert('Failed to get the Markdown file ' + url + '. Make sure that the presentation and the file are served by a HTTP server and the file can be found there. ' + e);
                }

            } else if( $section.data('separator') ) {

                var markdown = stripLeadingWhitespace(section);
                section.outerHTML = slidifyMarkdown( markdown, $section.data('separator'), $section.data('vertical'), getForwardedAttributes(section), $section.data('columns') );

            }
        });

    };

    var queryMarkdownSlides = function() {

        var sections = document.querySelectorAll( '[data-markdown]');

        for( var j = 0, jlen = sections.length; j < jlen; j++ ) {

            makeHtml(sections[j]);

        }

    };

    var makeHtml = function(section) {

        var notes = section.querySelector( 'aside.notes' );

        var markdown = stripLeadingWhitespace(section);

        section.innerHTML = marked(markdown);

        if( notes ) {
            section.appendChild( notes );
        }

    };

    querySlidingMarkdown();

    queryMarkdownSlides();

})();
