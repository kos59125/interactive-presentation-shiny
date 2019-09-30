library(magrittr)
library(shiny)
library(shinyjs)

table_presenter <- config::get('table_presenter') %>% aws.dynamodb::get_table()
table_respondent <- config::get('table_respondent') %>% aws.dynamodb::get_table()

#' 現在のスライドページを取得する。
get_current_page <- function(session_id) {
   key <- list(
      'SessionId' = list('S' = session_id)
   )
   request_body <- list(
      'TableName' = table_presenter$TableName,
      'Key' = key,
      'AttributesToGet' = list('PageId')
   )
   response <- aws.dynamodb::dynamoHTTP(verb = 'POST', body = request_body, target = 'DynamoDB_20120810.GetItem')
   if (length(response)) {
      response$Item$PageId$S
   }
}

#' ユーザーの回答を DynamoDB に登録する。
set_user_response <- function(user_id, session_id, question, answer) {
   key <- list(
      'SessionId' = list('S' = session_id),
      'UserId' = list('S' = user_id)
   )
   update_expr <- glue::glue('SET {question} = :val')
   values <- list(':val' = list('S' = as.character(answer)))
   request_body <- list(
      'TableName' = table_respondent$TableName,
      'Key' = key,
      'ReturnValues' = 'NONE', 
      'UpdateExpression' = update_expr,
      'ExpressionAttributeValues' = values
   )
   aws.dynamodb::dynamoHTTP(verb = 'POST', body = request_body, target = 'DynamoDB_20120810.UpdateItem')
   invisible()
}

increment_counter <- function(user_id, session_id, question, countup = 1L) {
   key <- list(
      'SessionId' = list('S' = session_id),
      'UserId' = list('S' = user_id)
   )
   update_expr <- glue::glue('ADD {question} :incr')
   values <- list(':incr' = list('N' = as.character(countup)))
   request_body <- list(
      'TableName' = table_respondent$TableName,
      'Key' = key,
      'ReturnValues' = 'NONE', 
      'UpdateExpression' = update_expr,
      'ExpressionAttributeValues' = values
   )
   aws.dynamodb::dynamoHTTP(verb = 'POST', body = request_body, target = 'DynamoDB_20120810.UpdateItem')
   invisible()
}

function(input, output, session) {
   js$getUserId()

   session_id <- reactive({
      query <- parseQueryString(session$clientData$url_search)
      if (length(query$session_id)) {
         query$session_id
      } else {
         '00000000-0000-0000-0000-000000000000'
      }
   })
   
   output$current_question <- renderText({
      invalidateLater(500)
      sid <- session_id()
      current_page <- get_current_page(sid)
      if (length(current_page)) {
         current_page
      }
   })
   
   observeEvent(input$shiny_experience, {
      uid <- input$user_id
      sid <- session_id()
      answer <- input$shiny_experience
      
      if (length(uid) && length(answer)) {
         set_user_response(uid, sid, 'ShinyExperience', answer)
      }
   })
   
   onclick("increment_button", {
      uid <- input$user_id
      sid <- session_id()
      
      if (length(uid)) {
         increment_counter(uid, sid, 'HitsCounter')
      }
   })
   
   observeEvent(input$difficulty, {
      uid <- input$user_id
      sid <- session_id()
      answer <- input$difficulty
      
      if (length(uid) && length(answer)) {
         set_user_response(uid, sid, 'Difficulty', answer)
      }
   })
   
   # for debugging
   output$user_id <- renderText({
      input$user_id
   })
   
   output$session_id <- renderText({
      session_id()
   })
}
