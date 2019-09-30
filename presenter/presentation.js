$('slide').on('slideenter', function(e) {
   const $article = $(e.target).find('article');
   const page_id = $article.attr('id');
   if (typeof page_id === 'undefined') {
      Shiny.onInputChange('page_id', null);
   } else {
      Shiny.onInputChange('page_id', page_id);
   }
});
