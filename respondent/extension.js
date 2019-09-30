// ユーザー ID が設定されていない場合に設定する。
shinyjs.init = function() {
   var user_id = Cookies.get('user_id');
   if (typeof user_id === 'undefined') {
      user_id = uuid.v4();
      Cookies.set('user_id', user_id);
   }
};

shinyjs.getUserId = function() {
   const user_id = Cookies.get('user_id');
   Shiny.onInputChange('user_id', user_id);
};
