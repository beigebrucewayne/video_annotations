library(shiny)
library(DT)
library(RoogleVideo)

CLIENT.ID  <- ""
CLIENT.SECRET  <- ""
PATH.JSON  <- ""

token  <- RoogleVideo::service_auth(CLIENT.ID, CLIENT.SECRET, PATH.JSON)


ui  <- fluidPage(
  
  titlePanel("Creative Recognition"),
  br(),
  br(),
  sidebarLayout(
    sidebarPanel(
      
      h4('Path To Video Asset:'),
      # download the kyrie asset to desktop
      textInput('b64', '', '~/Desktop/kyrie.mp4'),
      br(),
      img(src="https://www.xmedia.com/images/cognitive-solutions_v3.png", align = 'center')
    ),
    mainPanel(
      h4('Terms Identified'),
      br(),
      DT::dataTableOutput('video_data')
    )
  )
)


server  <- function(input, output) {

  base64_string  <- reactive({
    input$b64
  }) 

  output$video_data  <- DT::renderDataTable({
  
    data_endpoint  <- RoogleVideo::annotation_request(base64_string())
    Sys.sleep(5)
    data <- RoogleVideo::get_annotations(data_endpoint)
    terms  <- RoogleVideo::get_term_descriptions(data)

    DT::datatable(terms,
                  class = 'stripe hover compact order-column',
                  extensions = 'Buttons',
                  options = list(
                    dom = 'Bfrtip',
                    buttons = c('csv', 'excel', 'pdf'),
                    pageLength = 50)
                  )
  
  })

}


shinyApp(ui, server)
