library(shiny)
library(leaflet) #javascript lbrary om de kaart te gebruiken
library(RColorBrewer)

# iets simpel om te beginnen
# zie https://rstudio.github.io/leaflet/shiny.html 

adreslocaties <- read.csv("data/huisartsenlocaties.csv")

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
      setView(lng = 4.4695, lat = 51.21611, zoom = 12)  %>%
      #addTiles()%>%
      addCircleMarkers(data = adreslocaties_subset(), radius = ~Aantal.artsen , fillColor = "red" , color = "red",  popup = ~paste(Praktijk,"<br/>",Straat,Nummer,"<br/>",Postcode,Plaatsnaam,"<br/>",Aantal.artsen,"arts(en) in deze praktijk")) 
  })
  
}

shinyApp(ui, server)