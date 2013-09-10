
BlogShow
=========

* Cool Themes
  * Presentation
    * Cool Presentation Powered by Deck.js/Reveal.js
  * Magazine
    * Responsive
    * Page flips
  * Animation
    * Animation Page Transitions
    * Animation Text Effects
  * TOC Generation Automatically

* Template Engine
  * Jade/HTML Supported
  * Mustache/Handlebar Template Engine

* Page/Post Edition
  * Jade/HTML/Markdown Format Supported
  * Multi-languges Supported

* Site
  * RSS Supported
  * Sitemap Supported
  * Search Supported
  * Tag Cloud Supported


Specials:

* Render Markdown/Jade(Hogan) on Browser
* Normal Directories to write content
  * the folder name is the category's slug name
    * the index.md in this folder is the category page. u can override the category's slug name here.
    * Category1/Category2/my.md
    * Category1/Category2/my.cn.md
  * the file name is the page's slug name(u can override this in the markdown file).
* meta-data in the markdown file:
  * layout: specified the layout file in layouts for this category/document.
  * title: the category/page's title.
  * date:  the published time. the default is mtime. and u can changed to ctime.
  * name:  Defaults to the filename. The name of the document. Useful for listings
  * slug/url:  The url that you would like to use as the primary url for the document. 
    When a user accesses a document via a secondary url, the user will be redirected
    to the primary url automatically.
  * urls: Urls is the secondary urls for a document. It can be a comma seperated values
    list, or an array of values.
  * draft/ignored: Defaults to false. If set to true, the category/document will not be parsed.
    Useful for draft documents.


blogshow Source Folders:
  src/
    themes/theme/
      pages/: render, metadata supported
      assets/:     no render, no metadata, outputed to outDir.
      layouts/:   render, metadata supported, but do not get outputed to outDir .
      partials/:  render, metadata supported, but do not get outputed to outDir .

User's blog Folder:

* config.yml:
  * outPath     = public #the default value
  * docPath     = .      #the default value
  * layoutPath  = ./layouts  # the addtional layout path if any. the default is null.
  * assertPath  = ./asserts  # the addtional assert path if any. the default is null.
  * site:
    * title: the site's title
    * keywords: 
    * description:
    * url:
  * authors: = it can be in a single file(authors.yml).
    * riceball:
      * name: Riceball LEE
      * email: snowyu.lee@gamil.com
* documents/
  * index.md: override the site's frontpage
  * Category1/my.md
* public/ : the default outputed folder.
  * index.html: frontpage
  * index.json: the items list of this category
  * Category1/index.html
  * Category1/my.html
  * Category1/my.md
* layouts/: the addtional layout path if any.
* assets/ : the addtional assert path if any.
* index.html: the main application entry


CategoryPage(CollectionPage):

* FrontPage
  * Title
  * Author(if any)
  * Description(Summary)
* IndexComponent(List of Index)
  * Title
  * Date(If this is a category?)
  * Author
  * Summary
* Navbar()

ContentPage

* TOC
* NavBar
* Title
* Author
* Summary
* Content

Generation files:

* authors.json
* langs.json
* index.html
* [lang]/index.json: the subdirs and pages info in the current directory.
  * dirs:
    * name/slug:
    * title
    * summary:
    * date
    * count: integer
    * tags:
  * pages:
    * name/slug:
    * title
    * authors
    * date
    * summary:
    * tags:
* [lang]/xxx.html
  * the article content

### Workflow

* scan folders to generate infomation files:
  * item's list
  * sitemap
  * tag cloud

#### Specification

* Presentation Concept
  * Category: can contain sub-category and contents
    * index page to list the sub-category and contents
  * Content: post/page/partial
* Internal Concept
  * Folder: can be a category or content, check the meta info to determine. the default is category.
    * index.md: the meta info and content in it.
  * Template/Macro(handlebar.js/Hogan.js)
  * MetaInfo
    * id/slug/name: the default is the file name.
    * type: category, post, page, script, partial, layout, asset, macro, media/css(js/icon/img), the default is category if the file name is "index"
      * media/asset means this folder is a media/asset collection container.
    * index: the display order on list(sortByIndex).
    * created:  the default is the file created time.
    * modified: the default is the file modified time.
    * author: the default is the author in global configuration.
    * tags:
    * public: true/false
    * title: the default is the first level header.
    * summary: the default is the first section less than 1024 characters.



### Layout

* Navbar
* //breadcrumbs?
* Content
  * For Index
    * Picture/Thumnail?
    * Title
    * Url
    * IsFolder
    * Summary
  * For Markdown

* View
  * Control Bar
    * Navigator
  * Index Item
    * Bordered
    * Pictured
    * Summaried
  * Post/Page
    * PageFlipped

* http://vegas.jaysalvat.com/ :Vegas Background jQuery Plugin
  https://github.com/jaysalvat/vegas
  也可以参考用在IndexItem上，作为Picture和html的叠加.
* http://responsiveslides.com/
* http://alexdunphy.github.io/refineslide/ 3D slideshow
* https://github.com/passy/angular-masonry 把elements堆成砖块
* http://collageplus.edlea.com/ 这个对于图像的堆叠更好支持自适应。
* https://github.com/localmotors/quantum-angularity AngularJS image gallery 计划了很多功能
* http://benjaminmock.de/bezoom-jquery-plugin/ 放大镜
* https://github.com/HubSpot/executr

### Dev Misc

yo angular jsBlog --coffee
npm install xxx --save-dev
bower install xxx --save
bower install supports git://xxxx

### Dev Internal

I plan to use the yeoman as the blog generator(It is not necessary though).

the main programming language is the Literate CoffeeScript with markdown.

the source code is in the src folder:

- src\
  - README.md
  - model\
    - iCmsResource.md
    - iCmsConfig.md
    - icmsContent.md
  - iCmsFolderParser.md
  - iCmsFileReader.md
  - iCmsFileWriter.md
  - iCmsTemplateEngine.md
- bin\
  -icms

the 'README.md' is the main application entry.


    iFolderParser = require("./iCmsFolderParser")
    iFileReader   = require("./iCmsFileReader")
    iFileWriter   = require("./iCmsFileWriter")


* iCmsResource
  - iCmsConfiguration
  - iCmsContent: the category, post, page all are content.
* iCmsFolderParser
* iCmsFileReader
  * getMetaInfo()
  * getContent()
* iCmsFileWriter
* iCmsTemplateEngine(the default is handlebar)

#### Folder Structure

- RootFolder/
  - index.md: the global configuration here
      * type: config
      * outdir: the default output dir is 'public'
      * site:
        * title: the site's title
        * keywords: 
        * description:
        * url:
        * language: the default site language if any. the default language is English if no.
      * authors: = it can be in a single file(authors.md).
        * riceball: the author id can be referenced on other place.
          * name: Riceball LEE
          * email: snowyu.lee@gamil.com


#### Dev Toolkit chain

* Toolkits
  * Yeoman/Grunt/Bower/Karma/PhantomJS/karma-phantomjs-launcher/Sass/Compass/Coffee/LiveReload
* Library
  * JS
    * Angular
    * Docpad
    * https://github.com/paulmillr/chokidar watch folder
    * https://github.com/isaacs/node-glob
  * CSS
    * groundwork/Bootstrap?/Foundation?
    * http://css-tricks.com/triangle-breadcrumbs/
    * http://thecodeplayer.com/walkthrough/css3-breadcrumb-navigation
    * http://www.hongkiat.com/blog/breadcrumb-menu-css3/
    * https://techinterviewpuzzles.appspot.com/articles/CSS/6-graceful-css-breadcrumb-Navigation-designs
    * 智能响应的面包屑 Smart Responsive Breadcrumbs http://www.planetree.cn/article/details/11
    * http://bradfrost.github.io/this-is-responsive/patterns.html
    * http://www.w3cplus.com/demo/CSS3-Animation-Breadcrumbs.html
    * http://galleria.io/docs/  https://github.com/aino/galleria
    * http://blueimp.github.io/Gallery/
    * https://github.com/ed-lea/jquery-collagePlus/ : 还没有box to view.
    * https://github.com/fiestah/angular-gallery-directive
      可以参考他怎么去写angular指令的.

use foundation css framework: 

    [sudo] gem install compass zurb-foundation
    cd /path/to/your/project/ #IMPORTANT: Not inside the /app directory!
    compass create app -r "zurb-foundation" --using foundation --force

   //"bootstrap-sass": "http://github.com/jlong/sass-twitter-bootstrap.git",
   https://github.com/nu7hatch/angular-foundation-on-yeoman
   http://stackoverflow.com/questions/14602156/angularjs-with-reveal-js
   http://www.yearofmoo.com/2012/10/more-angularjs-magic-to-supercharge-your-webapp.html#how-to-make-sure-your-directives-are-run-after-your-scope-is-ready

      https://github.com/G33kLabs/Node.VaSH nodejs blog with redis and sso
      reveal.js git://github.com/hakimel/reveal.js/
      zurb-reveal git://github.com/zurb/reveal.git
      nucleus-angular-revealing-panel git://github.com/nucleus-angular/revealing-panel.git
      jquery-reveal git://github.com/VitalikL/reveal.git
      https://github.com/harvesthq/chosen
      https://github.com/kamens/jQuery-menu-aim
      inspector tool: angularjs-batarang
      https://github.com/daneroo/im-dash
      https://github.com/jogloran/angular-presentation
      http://worrydream.com/Tangle/
      https://github.com/okfn/timeliner
      https://github.com/danvk/dygraphs/
      http://www.simile-widgets.org/timeplot/
      http://worrydream.com/
      http://worrydream.com/Home2011/
      https://www.khanacademy.org/cs
      https://github.com/Khan/khan-exercises
      https://cmn.khanacademy.org/
      https://github.com/musicalglass/AKA/wiki/Processing-JS
      http://ink.sapo.pt/ resposive navbar
      https://github.com/sapo/ink
      http://badassjs.com/
      https://github.com/olton/Metro-UI-CSS
      http://www.w3cplus.com/MetroUICSS/ Metro UI CSS中文版
      http://jsfiddle.net/highcharts/AyUbx/
      http://rabidgadfly.com/ perfect for angularjs tut
      https://github.com/posativ/acrylamid static blog generator in python with incremental rendering
      rename ngMobile to ngTouch now in git 


#### CSS breadcrumbs

##### jsfiddle.net/nicooprat/WMMyu/

```html
<p id="breadcrumb">
    <a href="#">Home</a>
    <a href="#">Grandpa</a>
    <a href="#">Father</a>
    <a href="#">Son</a>
    Product
</p
```

```scss
$linkColorHover: #00b0ec;
$gray: #F0F0F0;
$gray2: #aaa;

body {
    padding: 40px;
    font-family: Helvetica, sans-serif;
    font-size: 13px;
}

#breadcrumb {
    margin-bottom: 20px;
    line-height: 30px;
    color: $gray2;
    padding: 1px;
    border: 1px solid $gray;
    
    a {
        display: block;
        float: left;
        background: $gray;
        padding-right: 10px;
        height: 30px;
        margin-right: 31px;
        position: relative;
        text-decoration: none;
        color: $gray2;
        
        &:last-of-type {
            margin-right: 25px;
        }
        
        &:before {
            content: "";
            display: block;
            width: 0;
            height: 0;
            position: absolute;
            top: 0;
            left: -30px;
            border: 15px solid transparent;
            border-color: $gray;
            border-left-color: transparent;
        }
        
        &:after {
            content: "";
            display: block;
            width: 0;
            height: 0;
            position: absolute;
            top: 0;
            right: -30px;
            border: 15px solid transparent;
            border-left-color: $gray;
        }
        
        &:first-of-type {
            padding-left: 15px;
            
            &:before {
                display: none;
            }
        }
        
        &:hover {
            background: $linkColorHover;
            color: #fff;
            text-decoration: none;
            
            &:before {
                border-color: $linkColorHover;
                border-left-color: transparent;
            }
            
            &:after {
                border-left-color: $linkColorHover;
            }
        }
    }
}
```

##### http://css-tricks.com/triangle-breadcrumbs/

```css
		.breadcrumb { 
			list-style: none; 
			overflow: hidden; 
			font: 18px Helvetica, Arial, Sans-Serif;
		}
		.breadcrumb li { 
			float: left; 
		}
		.breadcrumb li a {
			color: white;
			text-decoration: none; 
			padding: 10px 0 10px 55px;
			background: brown;                   /* fallback color */
			background: hsla(34,85%,35%,1); 
			position: relative; 
			display: block;
			float: left;
		}
		.breadcrumb li a:after { 
			content: " "; 
			display: block; 
			width: 0; 
			height: 0;
			border-top: 50px solid transparent;           /* Go big on the size, and let overflow hide */
			border-bottom: 50px solid transparent;
			border-left: 30px solid hsla(34,85%,35%,1);
			position: absolute;
			top: 50%;
			margin-top: -50px; 
			left: 100%;
			z-index: 2; 
		}	
		.breadcrumb li a:before { 
			content: " "; 
			display: block; 
			width: 0; 
			height: 0;
			border-top: 50px solid transparent;           /* Go big on the size, and let overflow hide */
			border-bottom: 50px solid transparent;
			border-left: 30px solid white;
			position: absolute;
			top: 50%;
			margin-top: -50px; 
			margin-left: 1px;
			left: 100%;
			z-index: 1; 
		}	
		.breadcrumb li:first-child a {
			padding-left: 10px;
		}
		.breadcrumb li:nth-child(2) a       { background:        hsla(34,85%,45%,1); }
		.breadcrumb li:nth-child(2) a:after { border-left-color: hsla(34,85%,45%,1); }
		.breadcrumb li:nth-child(3) a       { background:        hsla(34,85%,55%,1); }
		.breadcrumb li:nth-child(3) a:after { border-left-color: hsla(34,85%,55%,1); }
		.breadcrumb li:nth-child(4) a       { background:        hsla(34,85%,65%,1); }
		.breadcrumb li:nth-child(4) a:after { border-left-color: hsla(34,85%,65%,1); }
		.breadcrumb li:nth-child(5) a       { background:        hsla(34,85%,75%,1); }
		.breadcrumb li:nth-child(5) a:after { border-left-color: hsla(34,85%,75%,1); }
		.breadcrumb li:last-child a {
			background: transparent !important;
			color: black;
			pointer-events: none;
			cursor: default;
		}
		.breadcrumb li:last-child a:after { border: 0; }
		.breadcrumb li a:hover { background: hsla(34,85%,25%,1); }
		.breadcrumb li a:hover:after { border-left-color: hsla(34,85%,25%,1) !important; }

```
