library(shiny)
library(leaflet) #javascript lbrary om de kaart te gebruiken

# iets simpel om te beginnen
# zie https://rstudio.github.io/leaflet/shiny.html 

adreslocaties <- read.csv("data/wel_en_niet_INTEGO_Antwerpen2.csv")

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10, selectInput("intego", "Intego", choices=c(0, 1) )
  )
)


server <- function(input, output, session) {
  adreslocaties_subset <- eventReactive(input$intego, {subset(adreslocaties, INTEGO == input$intego) })
  output$map <- renderLeaflet({
    leaflet() %>%
    #Indien je onderstaade in commentaar zet en addTiles()%>% uit commentaar, dan krijg je een kaart in kleur
     addProviderTiles(providers$Stamen.TonerLite ) %>%
      #addTiles()%>%
      addCircleMarkers(data = adreslocaties_subset(), radius = ~Aantal.artsen * 3, fillColor = "red" , color = "red", popup = ~paste(Praktijk)) 
  })
  
}

shinyApp(ui, server)