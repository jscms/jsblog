
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
  * authors:
    * riceball:
      * name: Riceball LEE
      * email: snowyu.lee@gamil.com
* documents/
  * index.md: override the site's frontpage
  * Category1/my.md
* public/ : the default outputed folder.
  * index.html: frontpage
  * Category1/index.html
  * Category1/my.html
  * Category1/my.md
* layouts/: the addtional layout path if any.
* assets/ : the addtional assert path if any.

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
  


Generation files:

* index.json:
  * the subdirs and pages info in the current directory
* xxx.html
  * the article content

