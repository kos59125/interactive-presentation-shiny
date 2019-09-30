library(shiny)
library(shinyWidgets)
library(shinyjs)

fluidPage(
  tags$meta(name = 'viewport', content = 'width=320, initial-scale=1'),
  tags$script(src = 'https://cdn.jsdelivr.net/npm/js-cookie@2/src/js.cookie.min.js'),
  tags$script(src = 'https://cdn.jsdelivr.net/npm/js-uuid@0.0.6/js-uuid.min.js'),
  useShinyjs(),
  extendShinyjs('extension.js'),

  conditionalPanel(
    'output.current_question === "shiny-experience"',
    radioGroupButtons('shiny_experience', 'Shiny の経験は？', choices = c('初心者', 'そこそこ', '得意'), selected = '', direction = 'vertical', justified = TRUE)
  ),

  conditionalPanel(
    'output.current_question === "hits-counter"',
    actionButton("increment_button", '連打！', width = '100%')
  ),

  conditionalPanel(
    'output.current_question === "last-questionnaire"',
    radioGroupButtons('difficulty', '今回の発表の難易度は？', choices = c('簡単', 'ちょうどよい', '難しい'), selected = '', direction = 'vertical', justified = TRUE)
  ),
  
  conditionalPanel(
    'output.current_question === "__undefined"',
    p('準備中')
  ),

  if (config::get('debug')) {
    tags$div(
      tags$div('current_page: ', textOutput('current_question', inline = TRUE)),
      tags$div('user_id: ', textOutput('user_id', inline = TRUE)),
      tags$div('session_id: ', textOutput('session_id', inline = TRUE))
    )
  } else {
    # hidden 状態にすると取得できなくなるので文字色でごまかす
    tags$div(style = 'color:white;', textOutput('current_question'))
  }
)
